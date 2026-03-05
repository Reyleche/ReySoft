import { Component, OnInit, OnDestroy, HostListener, ChangeDetectorRef, ViewChild, ElementRef, AfterViewInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Subscription } from 'rxjs';
import { Router } from '@angular/router';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import { AuthService } from '../../services/auth.service';
import { ApiService } from '../../services/api.service';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';
import { Chart, registerables } from 'chart.js';
import {
  MovimientoInventarioForm,
  ProduccionInventarioForm,
  TransformacionInventarioForm,
  KardexFiltro,
  MovimientosFiltro,
  MovimientoInventarioItem
} from '../../models/inventario.models';

type CanalVenta = 'LOCAL' | 'PEDIDOS_YA';
type TipoVenta = 'DIRECTA' | 'MESA' | 'PEDIDOS_YA';
type EstadoVenta = 'ABIERTA' | 'PAGADA';

interface VentaItem {
  producto_id: number | null;
  nombre: string;
  precio: number;
  cantidad: number;
  subtotal: number;
  image_url?: string | null;
}

interface Venta {
  id?: number;
  tipo: TipoVenta;
  canal: CanalVenta;
  mesa?: number | null;
  estado: EstadoVenta;
  metodo_pago: string;
  cliente_id?: number | null;
  credito_pagado?: boolean;
  credito_metodo_pago?: string | null;
  credito_fecha_pago?: string | null;
  notas: string;
  items: VentaItem[];
  subtotal: number;
  impuesto_pct: number;
  impuesto_monto: number;
  total: number;
}

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './dashboard.html',
  styleUrls: ['./dashboard.css']
})
export class DashboardComponent implements OnInit, OnDestroy, AfterViewInit {
  usuario: any = null;
  vistaActual: string = 'resumen'; // Opciones: 'resumen', 'ventas', 'mesas', 'inventario', 'gastos', 'reportes'
  fechaHoy: string = new Date().toLocaleDateString('es-ES', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });

  insumos: any[] = [];
  productos: any[] = [];
  categorias: any[] = [];
  cargandoInventario: boolean = false;
  errorInventario: string = '';
  inventarioVista: string = 'articulos';
  inventarioMenuAbierto: boolean = false;

  ingresoForm = new MovimientoInventarioForm();
  egresoForm = new MovimientoInventarioForm();
  produccionForm = new ProduccionInventarioForm();
  transformacionForm = new TransformacionInventarioForm();

  kardexFiltro = new KardexFiltro();
  movimientosFiltro = new MovimientosFiltro();
  kardexItems: MovimientoInventarioItem[] = [];
  movimientosItems: MovimientoInventarioItem[] = [];
  kardexTipo: 'insumos' | 'productos' = 'insumos';
  kardexProductosItems: any[] = [];
  kardexProductoId: number | null = null;

  nuevoInsumo = {
    nombre: '',
    stock_actual: 0,
    unidad_medida: 'UND',
    stock_minimo: 0
  };

  nuevoProducto = {
    nombre: '',
    precio: 0,
    id_categoria: '',
    es_preparado: true,
    stock_actual: 0,
    unidad_medida: 'UND',
    stock_minimo: 0
  };
  nuevoProductoImagen: File | null = null;

  editandoInsumo: any = null;
  editandoProducto: any = null;
  editandoProductoImagen: File | null = null;

  // Datos simulados para el resumen (luego vendrán de BD)
  resumen = {
    ventasHoy: 0.00,
    pedidos: 0,
    efectivo: 0.00,
    ventasTransferencia: 0.00,
    ventasCount: 0,
    ticketPromedio: 0.00,
    ventasMes: 0.00,
    gananciasMes: 0.00,
    gastosMes: 0.00,
    gananciasBaseMes: 0.00,
    gastosFacturasMes: 0.00
  };

  gastosItems: any[] = [];
  gastoForm = {
    fecha: this.getFechaLocalISO(),
    descripcion: '',
    monto: 0,
    categoria: '',
    proveedor: ''
  };
  gastoFacturaFile: File | null = null;
  editandoGasto: any = null;
  editandoGastoFacturaFile: File | null = null;
  editandoGastoMantenerFactura: boolean = true;
  errorGastos: string = '';
  ahorrosCajaChicaItems: any[] = [];
  ahorrosCajaChicaTotal: number = 0;
  ahorroCajaChicaForm = {
    fecha: this.getFechaLocalISO(),
    monto: 0,
    referencia: ''
  };
  ahorroComprobanteFile: File | null = null;
  ahorroComprobantePreview: string | null = null;
  gastoFacturaPreview: string | null = null;
  // Sugerencias para combobox
  sugerenciasCategorias: string[] = [];
  sugerenciasProveedores: string[] = [];
  categoriaFiltrada: string[] = [];
  proveedorFiltrado: string[] = [];
  mostrarSugCategorias: boolean = false;
  mostrarSugProveedores: boolean = false;

  // Modal imagen (ver factura/comprobante)
  imagenModalUrl: string | null = null;

  // Chart.js dashboard
  @ViewChild('chartMetodoPago') chartMetodoPagoRef!: ElementRef<HTMLCanvasElement>;
  @ViewChild('chartVentasDiarias') chartVentasDiariasRef!: ElementRef<HTMLCanvasElement>;
  @ViewChild('chartTopProductos') chartTopProductosRef!: ElementRef<HTMLCanvasElement>;
  @ViewChild('chartVentasHora') chartVentasHoraRef!: ElementRef<HTMLCanvasElement>;
  private chartMetodoPago: any = null;
  private chartVentasDiarias: any = null;
  private chartTopProductos: any = null;
  private chartVentasHora: any = null;
  analyticsExtra: any = { topProductos: [], ventasDiarias: [], productosHoy: 0, ventasPorHora: [] };

  reportesTipos = [
    { value: 'inventario', label: 'Inventario y existencias' },
    { value: 'stock', label: 'Stock bajo' },
    { value: 'caja', label: 'Caja' },
    { value: 'ganancias', label: 'Ganancias' },
    { value: 'gastos', label: 'Gastos' },
    { value: 'ventas', label: 'Ventas' }
  ];
  reporteForm = {
    tipo: 'ganancias',
    desde: this.getRangoMesActual().desdeMes,
    hasta: this.getRangoMesActual().hastaMes,
    email: '',
    asunto: 'Reporte ReySoft',
    mensaje: 'Adjunto reporte generado desde ReySoft.'
  };
  reporteData: any = null;
  reporteError: string = '';
  reporteCargando: boolean = false;
  reportePdfUrl: string = '';
  reportePdfSafeUrl: SafeResourceUrl | null = null;
  reportePdfNombre: string = '';
  enviandoReporte: boolean = false;
  private readonly reporteBrand = {
    nombre: 'Coco & Caña',
    slogan: 'Sistema contable y operativo empresarial',
    ruc: '0706533031001',
    direccion: 'Machala, Ecuador',
    telefono: '+593 98 983 7350',
    email: 'cocoycana98@gmail.com',
    representante: 'Gerencia General',
    logoPath: 'assets/coco.jpg',
    primary: [39, 174, 96] as [number, number, number],
    secondary: [109, 76, 65] as [number, number, number],
    soft: [245, 238, 227] as [number, number, number]
  };
  private reporteLogoDataUrl: string | null = null;

  cajaEstado: any = null;
  cajaVentas: any[] = [];
  cajaMovimientos: any[] = [];
  cajaResumen: any = null;
  cajaHistorial: any[] = [];
  cajaCargando: boolean = false;
  cajaSaldoInicial: number = 0;
  cajaSaldoReal: number = 0;
  cajaSaldoInicialEdit: number = 0;
  errorCaja: string = '';
  cajaEfectivoEsperado: number = 0;
  cajaVentasEfectivo: number = 0;
  cajaVentasTransferencia: number = 0;
  cajaMovIngresosEfectivo: number = 0;
  cajaMovEgresosEfectivo: number = 0;
  cajaMovTransferencias: number = 0;
  cajaVentasCount: number = 0;
  cajaTicketPromedio: number = 0;
  cajaEfectivoCaja: number = 0;

  cajaMovimientoForm = { tipo: 'INGRESO', metodo_pago: 'EFECTIVO', monto: 0, referencia: '' };
  editandoMovimientoCaja: any = null;

  ventasEdicion: any[] = [];
  ventasEdicionFiltro = { fecha: '', tipo: '', canal: '', estado: '' };

  historialCajaCierres: any[] = [];
  historialCajaFiltro = { desde: '', hasta: '', usuario: '', metodo_pago: '', tipo_movimiento: '' };
  ventaDetalle: any = null;

  bodegaInsumos: any[] = [];
  bodegaProductos: any[] = [];
  bodegaNuevoInsumo = { nombre: '', stock_actual: 0, unidad_medida: 'UND', stock_minimo: 0 };
  bodegaNuevoProducto = { nombre: '', precio: 0, id_categoria: '', es_preparado: true };
  bodegaTransfer = { insumoId: null as number | null, cantidad: 0 };

  editandoVenta: Venta | null = null;

  analiticas = {
    totalVentas: 0,
    porMetodo: [] as Array<{ label: string; value: number; color: string }>,
    porCanal: [] as Array<{ label: string; value: number; color: string }>,
    porUsuario: [] as Array<{ label: string; value: number; color: string }>
  };

  private autoRefreshId: any = null;

  errorVentas: string = '';
  busquedaProducto: string = '';
  errorPago: string = '';
  advertenciaStock: string = '';
  errorClientes: string = '';

  ventasTab: 'productos' | 'combos' | 'mayor' = 'productos';
  mesasTab: 'productos' | 'combos' | 'mayor' = 'productos';

  pagoModalAbierto: boolean = false;
  ventaEnPago: Venta | null = null;
  pagoMetodoSeleccionado: string = 'EFECTIVO';
  pagoEfectivoRecibido: number | null = null;
  pagoEsMesa: boolean = false;
  guardandoMesa: boolean = false;
  cobrandoMesa: boolean = false;
  private guardadoMesaSub: Subscription | null = null;
  pagoBancoSeleccionado: string = '';
  pagoClienteSeleccionado: number | null = null;
  pagoNotas: string = '';
  pagoComprobante: string = '';
  pagoClienteTab: 'cliente' | 'final' = 'cliente';
  pagoDividido: boolean = false;
  pagoPartes: Array<{ metodo: string; monto: number; banco?: string; comprobante?: string }> = [];

  cobroCreditoAbierto: boolean = false;
  cobroCreditoVenta: any = null;
  cobroCreditoMetodo: string = 'EFECTIVO';
  cobroCreditoEfectivo: number | null = null;
  cobroCreditoBanco: string = '';

  bancosEcuador = [
    { value: 'PICHINCHA', label: 'Banco Pichincha', logo: 'assets/banks/pichincha.svg' },
    { value: 'GUAYAQUIL', label: 'Banco Guayaquil', logo: 'assets/banks/guayaquil.svg' },
    { value: 'PRODUBANCO', label: 'Produbanco', logo: 'assets/banks/produbanco.svg' },
    { value: 'PACIFICO', label: 'Banco del Pacífico', logo: 'assets/banks/pacifico.svg' },
    { value: 'BOLIVARIANO', label: 'Banco Bolivariano', logo: 'assets/banks/bolivariano.svg' },
    { value: 'INTERNACIONAL', label: 'Banco Internacional', logo: 'assets/banks/internacional.svg' },
    { value: 'AUSTRO', label: 'Banco del Austro', logo: 'assets/banks/austro.svg' }
  ];

  comboModalAbierto: boolean = false;
  comboTipoSeleccionado: 'PERSONAL' | 'DUO' = 'PERSONAL';
  comboSmoothiesSeleccionados: any[] = [];
  comboVentaTarget: Venta | null = null;

  metodosPagoPrincipales = [
    { value: 'EFECTIVO', label: '💵 Efectivo', requiereEfectivo: true },
    { value: 'TARJETA_DEBITO', label: '💳 Débito' },
    { value: 'TARJETA_CREDITO', label: '💳 Crédito' },
    { value: 'CREDITO', label: '🧾 Crédito' },
    { value: 'TRANSFERENCIA', label: '🏦 Transferencia' },
    { value: 'DE_UNA', label: '⚡ De una' },
    { value: 'CORTESIA', label: '🎁 Cortesía' }
  ];

  metodosCobroCredito = [
    { value: 'EFECTIVO', label: '💵 Efectivo' },
    { value: 'TRANSFERENCIA', label: '🏦 Transferencia' },
    { value: 'TARJETA_DEBITO', label: '💳 Débito' },
    { value: 'TARJETA_CREDITO', label: '💳 Crédito' },
    { value: 'DE_UNA', label: '⚡ De una' }
  ];

  clientes: any[] = [];
  clienteForm: any = {
    id: null,
    nombre: '',
    identificacion: '',
    telefono: '',
    email: '',
    direccion: '',
    notas: ''
  };

  ventaDirecta: Venta = this.crearVentaBase('DIRECTA', null, 'LOCAL');

  mesas: Array<{ numero: number; venta: Venta | null }> = [
    { numero: 1, venta: null },
    { numero: 2, venta: null },
    { numero: 3, venta: null }
  ];
  mesaActiva: number | null = null;
  mesaVentaActiva: Venta | null = null;

  comboSmoothieId: number | null = null;
  comboPanId: number | null = null;
  comboPanCantidad: number = 1;

  // ========== FACTURACIÓN ==========
  facturas: any[] = [];
  facturasFiltro = { estado: '', buscar: '', desde: '', hasta: '' };
  facturaDetalle: any = null;
  facturaEditando: any = null;
  facturaEditForm = {
    cliente_nombre: '', cliente_identificacion: '', cliente_direccion: '',
    cliente_telefono: '', cliente_email: '', notas: '', tipo: 'RECIBO'
  };
  facturaAnulandoId: number | null = null;
  facturaAnularMotivo: string = '';
  errorFacturas: string = '';
  cargandoFacturas: boolean = false;

  // Config impresora
  configImpresora = { nombre_impresora: '', tipo: 'TERMICA', ancho_mm: 80, auto_imprimir: false };
  facturaSecuencia = { prefijo: 'REC', siguiente: 1 };
  configImpresoraAbierto: boolean = false;
  errorConfigImpresora: string = '';
  imprimiendoFactura: boolean = false;

  // Checkbox imprimir al pagar
  pagoImprimirRecibo: boolean = true;

  // Datos empresa para factura
  readonly empresaInfo = {
    nombre: 'COCO & CAÑA',
    razonSocial: 'Coco & Caña – Smoothie Bar',
    ruc: '0706533031001',
    direccion: 'Machala, Ecuador',
    telefono: '+593 98 983 7350',
    email: 'cocoycana98@gmail.com',
    lema: 'Energía De La Naturaleza'
  };
  private logoBase64: string = '';

  // ========== SINCRONIZACIÓN ==========
  syncConfig: any = { backupFolder: '', autoBackup: true, oneDriveDetected: '', backupFolderResolved: '' };
  syncBackups: any[] = [];
  syncCargando: boolean = false;
  syncMensaje: string = '';
  syncError: string = '';
  syncRestaurando: boolean = false;
  syncBackupFolder: string = '';

  constructor(
    private router: Router,
    private auth: AuthService,
    private api: ApiService,
    private cdr: ChangeDetectorRef,
    private sanitizer: DomSanitizer
  ) {}

  ngOnInit() {
    Chart.register(...registerables);
    this.usuario = this.auth.getUsuario();
    if (!this.usuario || !this.auth.isLoggedIn()) {
      this.auth.clearSession();
      this.router.navigate(['/login'], { queryParams: { reason: 'expired' } });
    }
    const vistaGuardada = localStorage.getItem('dashboard:vista');
    const inventarioVista = localStorage.getItem('dashboard:inventarioVista');
    if (vistaGuardada) {
      this.vistaActual = vistaGuardada;
    }
    if (inventarioVista) {
      this.inventarioVista = inventarioVista;
    }
    this.refrescarVista(this.vistaActual);
    setTimeout(() => this.refrescarVista(this.vistaActual), 200);
    setTimeout(() => this.refrescarVista(this.vistaActual), 800);
    this.iniciarAutoRefresh();
    this.cargarLogoBase64();
  }

  ngAfterViewInit() {
    if (this.vistaActual === 'resumen') {
      setTimeout(() => this.inicializarCharts(), 500);
    }
  }

  ngOnDestroy() {
    this.destroyCharts();
    this.detenerAutoRefresh();
    this.limpiarReportePdf();
  }

  cambiarVista(vista: string) {
    this.vistaActual = vista;
    localStorage.setItem('dashboard:vista', vista);
    if (vista === 'inventario') {
      this.inventarioMenuAbierto = true;
    } else {
      this.inventarioMenuAbierto = false;
    }
    this.refrescarVista(vista);
    this.iniciarAutoRefresh();
    if (vista === 'resumen') {
      setTimeout(() => this.inicializarCharts(), 300);
    }
  }

  toggleInventarioMenu() {
    if (this.vistaActual !== 'inventario') {
      this.cambiarVista('inventario');
      this.inventarioMenuAbierto = true;
      return;
    }
    this.inventarioMenuAbierto = !this.inventarioMenuAbierto;
  }

  abrirInventarioSub(vista: string) {
    this.vistaActual = 'inventario';
    this.inventarioMenuAbierto = true;
    this.cambiarInventarioVista(vista);
    localStorage.setItem('dashboard:vista', 'inventario');
    localStorage.setItem('dashboard:inventarioVista', vista);
    this.refrescarVista('inventario');
  }

  private refrescarVista(vista: string) {
    if (vista === 'inventario') {
      this.cargarInventario();
      this.cambiarInventarioVista(this.inventarioVista || 'articulos');
    }
    if (vista === 'ventas') {
      this.cargarProductosVenta();
    }
    if (vista === 'mesas') {
      this.cargarProductosVenta();
      this.cargarMesas();
    }
    if (vista === 'arqueo') {
      this.cargarCajaEstado();
      this.cargarCajaHistorial();
    }
    if (vista === 'historial-caja') {
      this.cargarHistorialCaja();
    }
    if (vista === 'historial-caja') {
      this.cargarHistorialCaja();
    }
    if (vista === 'ventas-edicion') {
      this.cargarVentasEdicion();
    }
    if (vista === 'bodega') {
      this.cargarBodega();
    }
    if (vista === 'resumen') {
      this.cargarResumenVentas();
    }
    if (vista === 'clientes') {
      this.cargarClientes();
    }
    if (vista === 'gastos') {
      this.cargarGastosMes();
      this.cargarAhorrosCajaChicaMes();
      this.cargarResumenVentas();
      this.cargarSugerenciasGastos();
    }
    if (vista === 'reportes') {
      this.cargarReporte();
    }
    if (vista === 'facturacion') {
      this.cargarFacturas();
      this.cargarConfigImpresora();
    }
    if (vista === 'sincronizacion') {
      this.cargarSyncConfig();
      this.cargarSyncBackups();
    }
  }

  private postActionRefresh() {
    this.refrescarVista(this.vistaActual);
    this.cargarResumenVentas();
  }

  cambiarInventarioVista(vista: string) {
    this.inventarioVista = vista;
    localStorage.setItem('dashboard:inventarioVista', vista);
    if (vista === 'kardex') {
      this.cargarKardex();
    }
    if (vista === 'movimientos') {
      this.cargarMovimientos();
    }
  }

  cargarInventario() {
    this.cargandoInventario = true;
    this.errorInventario = '';
    this.api.getInsumos().subscribe({
      next: (data: any) => {
        this.insumos = Array.isArray(data) ? data : [];
      },
      error: () => {
        this.errorInventario = 'No se pudo cargar el inventario.';
      }
    });

    this.api.getCategorias().subscribe({
      next: (data: any) => {
        this.categorias = Array.isArray(data) ? data : [];
      },
      error: () => {
        this.errorInventario = 'No se pudieron cargar categorías.';
      }
    });

    this.api.getProductos().subscribe({
      next: (data: any) => {
        this.productos = Array.isArray(data) ? data : [];
        this.cargandoInventario = false;
      },
      error: () => {
        this.errorInventario = 'No se pudieron cargar productos.';
        this.cargandoInventario = false;
      }
    });
  }

  cargarProductosVenta() {
    this.api.getProductos().subscribe({
      next: (data: any) => {
        this.productos = Array.isArray(data) ? data : [];
      },
      error: () => {
        this.errorVentas = 'No se pudieron cargar los productos para venta.';
      }
    });
  }

  productosFiltrados(): any[] {
    const term = this.normalizarTexto(this.busquedaProducto);
    const base = this.productos.filter((prod) => !this.esComboProducto(prod));
    if (!term) return base;
    return base.filter((prod) =>
      this.normalizarTexto(prod?.nombre).includes(term)
    );
  }

  productosPorMayor(): Array<{ producto: any; precio: number; label: string }> {
    const lookup = [
      { nombre: 'agua de coco', precio: 1, label: 'Agua de coco (por mayor)' },
      { nombre: 'agua de coco', precio: 0.9, label: 'Agua de coco (por mayor) $0.90' },
      { nombre: 'jugo de cana', precio: 0.75, label: 'Jugo de caña (por mayor)' }
    ];
    const normalizados = new Map(this.productos.map((p) => [this.normalizarTexto(p?.nombre), p]));
    return lookup
      .map((item) => ({
        producto: normalizados.get(this.normalizarTexto(item.nombre)) || null,
        precio: item.precio,
        label: item.label
      }))
      .filter((item) => item.producto);
  }

  smoothiesDisponibles(): any[] {
    return this.productos.filter((prod) => this.esSmoothieProducto(prod));
  }

  panesYucaDisponibles(): any[] {
    return this.productos.filter((prod) => this.esPanYucaProducto(prod));
  }

  abrirComboModal(tipo: 'PERSONAL' | 'DUO', venta: Venta) {
    this.errorVentas = '';
    this.comboTipoSeleccionado = tipo;
    this.comboSmoothiesSeleccionados = [];
    this.comboVentaTarget = venta;
    this.comboModalAbierto = true;
  }

  cerrarComboModal() {
    this.comboModalAbierto = false;
    this.comboSmoothiesSeleccionados = [];
    this.comboVentaTarget = null;
  }

  seleccionarSmoothieCombo(prod: any) {
    if (!prod) return;
    const existe = this.comboSmoothiesSeleccionados.find((p) => p.id === prod.id);
    if (existe) {
      this.comboSmoothiesSeleccionados = this.comboSmoothiesSeleccionados.filter((p) => p.id !== prod.id);
      return;
    }
    const limite = this.comboTipoSeleccionado === 'DUO' ? 2 : 1;
    if (this.comboSmoothiesSeleccionados.length >= limite) {
      this.comboSmoothiesSeleccionados = this.comboSmoothiesSeleccionados.slice(0, limite - 1);
    }
    this.comboSmoothiesSeleccionados = [...this.comboSmoothiesSeleccionados, prod];
  }

  confirmarCombo() {
    const requeridos = this.comboTipoSeleccionado === 'DUO' ? 2 : 1;
    if (this.comboSmoothiesSeleccionados.length !== requeridos) {
      this.errorVentas = this.comboTipoSeleccionado === 'DUO'
        ? 'Selecciona 2 smoothies para el combo dúo.'
        : 'Selecciona 1 smoothie para el combo personal.';
      return;
    }
    const comboNombre = this.comboTipoSeleccionado === 'PERSONAL'
      ? 'Combo Personal'
      : 'Combo Dúo';
    const precioCombo = this.obtenerPrecioCombo(this.comboTipoSeleccionado);
    const nombres = this.comboSmoothiesSeleccionados.map((p) => p.nombre).join(' + ');
    const nombre = `${comboNombre} + ${nombres}`;

    const target = this.comboVentaTarget || this.ventaDirecta;
    target.items.push({
      producto_id: null,
      nombre,
      precio: precioCombo,
      cantidad: 1,
      subtotal: precioCombo,
      image_url: this.comboSmoothiesSeleccionados[0]?.image_url || null
    });
    this.recalcularVenta(target);
    this.cerrarComboModal();
  }

  agregarCombo(venta: Venta) {
    this.errorVentas = '';
    const smoothie = this.obtenerProductoPorId(this.comboSmoothieId);
    const pan = this.obtenerProductoPorId(this.comboPanId);
    if (!smoothie || !pan) {
      this.errorVentas = 'Selecciona un smoothie y panes de yuca para el combo.';
      return;
    }
    const cantidadPanes = Number(this.comboPanCantidad || 1);
    const precioSmoothie = Number(smoothie.precio || 0);
    const precioPan = Number(pan.precio || 0);
    const subtotal = precioSmoothie + (precioPan * cantidadPanes);
    const nombreCombo = `Combo: ${smoothie.nombre} + ${cantidadPanes} Pan(es) de Yuca`;

    venta.items.push({
      producto_id: null,
      nombre: nombreCombo,
      precio: subtotal,
      cantidad: 1,
      subtotal,
      image_url: smoothie.image_url || null
    });
    this.recalcularVenta(venta);
  }

  seleccionarMesa(numero: number) {
    this.mesaActiva = numero;
    const mesa = this.mesas.find((m) => m.numero === numero);
    if (mesa) {
      if (!mesa.venta) {
        mesa.venta = this.crearVentaBase('MESA', numero, 'LOCAL');
      }
      this.mesaVentaActiva = mesa.venta;
    }
  }

  cerrarMesa() {
    this.mesaActiva = null;
    this.mesaVentaActiva = null;
  }

  cargarMesas() {
    this.api.getVentas({ estado: 'ABIERTA', tipo: 'MESA' }).subscribe({
      next: (data: any) => {
        const ventas = Array.isArray(data) ? data : [];
        this.mesas = this.mesas.map((mesa) => {
          const ventaData = ventas.find((v: any) => Number(v.mesa) === mesa.numero);
          if (!ventaData && mesa.venta && !mesa.venta.id && mesa.venta.items?.length) {
            return mesa;
          }
          return {
            ...mesa,
            venta: ventaData ? this.mapVentaFromApi(ventaData) : null
          };
        });
        if (this.mesaActiva) {
          const mesa = this.mesas.find((m) => m.numero === this.mesaActiva);
          this.mesaVentaActiva = mesa?.venta || null;
        }
      },
      error: () => {
        this.errorVentas = 'No se pudieron cargar las mesas.';
      }
    });
  }

  cambiarCanalVentaDirecta(canal: CanalVenta) {
    this.ventaDirecta.canal = canal;
    this.ventaDirecta.tipo = canal === 'PEDIDOS_YA' ? 'PEDIDOS_YA' : 'DIRECTA';
  }

  agregarProductoVenta(venta: Venta, prod: any) {
    this.agregarProductoVentaConPrecio(venta, prod, null);
  }

  agregarProductoVentaConPrecio(venta: Venta, prod: any, precioOverride: number | null) {
    if (!prod) return;
    const productoId = Number(prod.id);
    const precio = Number(precioOverride ?? prod.precio ?? 0);
    const existente = venta.items.find((i) => i.producto_id === productoId && Number(i.precio) === precio);
    if (existente) {
      existente.cantidad += 1;
      existente.subtotal = existente.cantidad * existente.precio;
    } else {
      venta.items.push({
        producto_id: productoId,
        nombre: String(prod.nombre || ''),
        precio,
        cantidad: 1,
        subtotal: precio,
        image_url: prod.image_url || null
      });
    }
    this.recalcularVenta(venta);
  }

  actualizarCantidadItem(venta: Venta, item: VentaItem, value: any) {
    const cantidad = Number(value);
    item.cantidad = Number.isFinite(cantidad) && cantidad > 0 ? cantidad : 1;
    item.subtotal = item.cantidad * item.precio;
    this.recalcularVenta(venta);
  }

  quitarItem(venta: Venta, item: VentaItem) {
    venta.items = venta.items.filter((i) => i !== item);
    this.recalcularVenta(venta);
  }

  recalcularVenta(venta: Venta) {
    const subtotal = venta.items.reduce((acc, i) => acc + Number(i.subtotal || 0), 0);
    const impuestoPct = Number(venta.impuesto_pct || 0);
    const impuestoMonto = subtotal * (impuestoPct / 100);
    venta.subtotal = subtotal;
    venta.impuesto_pct = impuestoPct;
    venta.impuesto_monto = impuestoMonto;
    venta.total = subtotal + impuestoMonto;
  }

  cobrarVentaDirecta() {
    this.abrirPagoModal(this.ventaDirecta, false);
  }

  guardarMesaActiva() {
    if (!this.mesaVentaActiva) return;
    if (this.cobrandoMesa || this.guardandoMesa) return;
    this.errorVentas = '';
    if (!this.mesaVentaActiva.items.length) {
      this.errorVentas = 'La mesa no tiene productos.';
      return;
    }
    this.guardandoMesa = true;
    const payload = this.buildVentaPayload({
      ...this.mesaVentaActiva,
      estado: 'ABIERTA'
    });
    const request = this.mesaVentaActiva.id
      ? this.api.actualizarVenta(this.mesaVentaActiva.id, payload)
      : this.api.crearVenta(payload);
    this.guardadoMesaSub?.unsubscribe();
    this.guardadoMesaSub = request.subscribe({
      next: (data: any) => {
        this.guardandoMesa = false;
        if (!this.mesaVentaActiva) return;
        this.mesaVentaActiva.id = data?.id || this.mesaVentaActiva.id;
        this.cargarMesas();
        this.postActionRefresh();
      },
      error: (err) => {
        this.guardandoMesa = false;
        this.errorVentas = this.getErrorMessage(err, 'No se pudo guardar la cuenta.');
      }
    });
  }

  cobrarMesaActiva() {
    if (!this.mesaVentaActiva) return;
    // Cancelar guardado pendiente antes de cobrar para evitar race condition
    if (this.guardandoMesa) {
      this.guardadoMesaSub?.unsubscribe();
      this.guardadoMesaSub = null;
      this.guardandoMesa = false;
    }
    this.abrirPagoModal(this.mesaVentaActiva, true);
  }

  abrirPagoModal(venta: Venta, esMesa: boolean) {
    this.errorVentas = '';
    this.errorPago = '';
    if (!venta.items.length) {
      this.errorVentas = 'Agrega productos antes de cobrar.';
      return;
    }
    this.ventaEnPago = venta;
    this.pagoMetodoSeleccionado = 'EFECTIVO';
    this.pagoEfectivoRecibido = null;
    this.pagoBancoSeleccionado = '';
    this.pagoClienteSeleccionado = null;
    this.pagoNotas = venta.notas || '';
    this.pagoComprobante = '';
    this.pagoClienteTab = 'final';
    this.pagoDividido = false;
    this.pagoPartes = [
      { metodo: 'EFECTIVO', monto: Number(venta.total || 0), banco: '', comprobante: '' }
    ];
    this.pagoEsMesa = esMesa;
    this.cargarClientes();
    this.pagoModalAbierto = true;
    this.focusPagoEfectivoInput();
  }

  cerrarPagoModal() {
    this.pagoModalAbierto = false;
    this.ventaEnPago = null;
    this.errorPago = '';
    this.pagoBancoSeleccionado = '';
    this.pagoClienteSeleccionado = null;
    this.pagoNotas = '';
    this.pagoComprobante = '';
    this.pagoClienteTab = 'final';
    this.pagoDividido = false;
    this.pagoPartes = [];
  }

  cerrarAdvertenciaStock() {
    this.advertenciaStock = '';
  }

  seleccionarMetodoPago(metodo: string) {
    this.pagoMetodoSeleccionado = metodo;
    if (metodo !== 'EFECTIVO') {
      this.pagoEfectivoRecibido = null;
    } else {
      this.focusPagoEfectivoInput();
    }
    if (metodo !== 'TRANSFERENCIA') {
      this.pagoBancoSeleccionado = '';
      this.pagoComprobante = '';
    } else if (!this.pagoBancoSeleccionado && this.bancosEcuador.length) {
      this.pagoBancoSeleccionado = this.bancosEcuador[0].value;
    }
    if (metodo !== 'CREDITO') {
      this.pagoClienteSeleccionado = null;
    }
    if (metodo === 'CREDITO') {
      this.pagoClienteTab = 'cliente';
    }
  }

  private focusPagoEfectivoInput() {
    setTimeout(() => {
      const input = document.getElementById('pago-efectivo-recibido') as HTMLInputElement | null;
      if (input) {
        input.focus();
        input.select();
      }
    }, 0);
  }

  togglePagoDividido() {
    if (this.pagoMetodoSeleccionado === 'CREDITO') {
      this.errorPago = 'No se puede dividir un pago a crédito.';
      return;
    }
    this.errorPago = '';
    this.pagoDividido = !this.pagoDividido;
    if (this.pagoDividido) {
      const total = Number(this.ventaEnPago?.total || 0);
      const mitad = Number((total / 2).toFixed(2));
      this.pagoPartes = [
        { metodo: 'EFECTIVO', monto: mitad, banco: '', comprobante: '' },
        { metodo: 'EFECTIVO', monto: Number((total - mitad).toFixed(2)), banco: '', comprobante: '' }
      ];
    } else {
      this.pagoPartes = [
        { metodo: this.pagoMetodoSeleccionado, monto: Number(this.ventaEnPago?.total || 0), banco: this.pagoBancoSeleccionado, comprobante: this.pagoComprobante }
      ];
    }
  }

  setPagoClienteTab(tab: 'cliente' | 'final') {
    this.pagoClienteTab = tab;
    if (tab === 'final') {
      this.pagoClienteSeleccionado = null;
    }
  }

  agregarPartePago() {
    const total = Number(this.ventaEnPago?.total || 0);
    const partes = this.pagoPartes.length + 1;
    const montoBase = Number((total / partes).toFixed(2));
    this.pagoPartes = Array.from({ length: partes }, (_, idx) => ({
      metodo: 'EFECTIVO',
      monto: idx === partes - 1 ? Number((total - montoBase * (partes - 1)).toFixed(2)) : montoBase,
      banco: '',
      comprobante: ''
    }));
  }

  quitarPartePago(index: number) {
    if (this.pagoPartes.length <= 2) return;
    this.pagoPartes = this.pagoPartes.filter((_, i) => i !== index);
  }

  getCambio(): number {
    if (!this.ventaEnPago || this.pagoMetodoSeleccionado !== 'EFECTIVO') return 0;
    const recibido = Number(this.pagoEfectivoRecibido || 0);
    const total = Number(this.ventaEnPago.total || 0);
    return recibido > total ? recibido - total : 0;
  }

  confirmarPago() {
    if (!this.ventaEnPago) return;
    const total = Number(this.ventaEnPago.total || 0);
    if (this.pagoMetodoSeleccionado === 'EFECTIVO' && !this.pagoDividido) {
      const recibido = Number(this.pagoEfectivoRecibido || 0);
      if (!recibido || recibido < total) {
        this.errorPago = 'El efectivo recibido debe ser mayor o igual al total.';
        return;
      }
    }
    if (this.pagoMetodoSeleccionado === 'TRANSFERENCIA' && !this.pagoDividido) {
      if (!this.pagoBancoSeleccionado) {
        this.errorPago = 'Selecciona el banco para la transferencia.';
        return;
      }
      if (!this.pagoComprobante) {
        this.errorPago = 'Ingresa el número de comprobante.';
        return;
      }
    }
    if (this.pagoMetodoSeleccionado === 'CREDITO') {
      if (!this.pagoClienteSeleccionado) {
        this.errorPago = 'Selecciona un cliente para crédito.';
        return;
      }
    }
    if (this.pagoMetodoSeleccionado === 'CREDITO' && this.pagoClienteTab === 'final') {
      this.errorPago = 'Crédito requiere un cliente.';
      return;
    }
    if (this.pagoDividido) {
      const suma = this.pagoPartes.reduce((acc, p) => acc + Number(p.monto || 0), 0);
      if (Math.abs(total - suma) > 0.01) {
        this.errorPago = 'La suma de pagos divididos no coincide con el total.';
        return;
      }
      for (const parte of this.pagoPartes) {
        if (String(parte.metodo || '').toUpperCase() === 'TRANSFERENCIA') {
          if (!parte.banco || !parte.comprobante) {
            this.errorPago = 'Completa banco y comprobante en transferencias.';
            return;
          }
        }
      }
    }
    this.errorPago = '';
    const bancoLabel = this.bancosEcuador.find((b) => b.value === this.pagoBancoSeleccionado)?.label || '';
    const notas = this.aplicarBancoEnNotas(this.pagoNotas || this.ventaEnPago.notas || '', bancoLabel);
    const notasConComprobante = this.pagoMetodoSeleccionado === 'TRANSFERENCIA' && this.pagoComprobante
      ? `${notas}${notas ? ' | ' : ''}Comprobante: ${this.pagoComprobante}`
      : notas;
    const venta = {
      ...this.ventaEnPago,
      metodo_pago: this.pagoDividido ? 'DIVIDIDO' : this.pagoMetodoSeleccionado,
      cliente_id: this.pagoClienteTab === 'cliente' && this.pagoMetodoSeleccionado === 'CREDITO'
        ? this.pagoClienteSeleccionado
        : null,
      notas: notasConComprobante
    };
    const pagosDivididos = this.pagoDividido
      ? this.pagoPartes.map((p, idx) => {
          const banco = this.bancosEcuador.find((b) => b.value === p.banco)?.label || '';
          const refBase = `Parte ${idx + 1}`;
          const refBanco = banco ? ` | Banco: ${banco}` : '';
          const refComp = p.comprobante ? ` | Comprobante: ${p.comprobante}` : '';
          return {
            metodo_pago: p.metodo,
            monto: Number(p.monto || 0),
            referencia: `${refBase}${refBanco}${refComp}`
          };
        })
      : undefined;
    this.ejecutarCobro(venta, this.pagoEsMesa, pagosDivididos);
  }

  private ejecutarCobro(venta: Venta, esMesa: boolean, pagosDivididos?: Array<{ metodo_pago: string; monto: number; referencia?: string }>) {
    // Cancelar cualquier request de guardado pendiente para evitar race condition
    if (esMesa) {
      this.guardadoMesaSub?.unsubscribe();
      this.guardadoMesaSub = null;
      this.guardandoMesa = false;
      this.cobrandoMesa = true;
    }

    const payload = this.buildVentaPayload({
      ...venta,
      estado: 'PAGADA'
    });
    if (pagosDivididos?.length) {
      (payload as any).pagos_divididos = pagosDivididos;
    }
    const request = esMesa && venta.id
      ? this.api.actualizarVenta(venta.id, payload)
      : esMesa
        ? this.api.crearVenta(payload)
        : this.api.crearVenta(payload);

    const quiereImprimir = this.pagoImprimirRecibo;
    request.subscribe({
      next: (res: any) => {
        this.cobrandoMesa = false;
        // Imprimir recibo si el checkbox está activo
        if (quiereImprimir) {
          const ventaId = res?.id || res?.venta?.id;
          if (ventaId) {
            setTimeout(() => this.imprimirDesdeVenta(ventaId), 600);
          }
        }
        if (esMesa) {
          const mesa = this.mesas.find((m) => m.numero === this.mesaActiva);
          if (mesa) mesa.venta = null;
          this.mesaVentaActiva = null;
          this.mesaActiva = null;
          this.cargarMesas();
        } else {
          this.ventaDirecta = this.crearVentaBase('DIRECTA', null, this.ventaDirecta.canal);
          this.ventaDirecta.tipo = this.ventaDirecta.canal === 'PEDIDOS_YA' ? 'PEDIDOS_YA' : 'DIRECTA';
        }
        this.postActionRefresh();
        this.cargarCajaEstado();
        this.cargarCajaHistorial();
        this.cargarResumenVentas();
        this.cargarProductosVenta();
        this.cargarInventario();
        this.cargarMesas();
        this.cdr.detectChanges();
        this.cerrarPagoModal();
        this.refrescarVista(this.vistaActual);
        this.cargarCajaEstado();
        this.cargarResumenVentas();
      },
      error: (err) => {
        this.cobrandoMesa = false;
        this.errorPago = this.getErrorMessage(err, 'No se pudo registrar el pago.');
      }
    });
  }

  private crearVentaBase(tipo: TipoVenta, mesa: number | null, canal: CanalVenta): Venta {
    return {
      tipo,
      canal,
      mesa,
      estado: 'ABIERTA',
      metodo_pago: this.metodosPagoPrincipales[0].value,
      cliente_id: null,
      notas: '',
      items: [],
      subtotal: 0,
      impuesto_pct: 0,
      impuesto_monto: 0,
      total: 0
    };
  }

  private buildVentaPayload(venta: Venta) {
    this.recalcularVenta(venta);
    const tipo = venta.tipo === 'DIRECTA' && venta.canal === 'PEDIDOS_YA' ? 'PEDIDOS_YA' : venta.tipo;
    return {
      tipo,
      canal: venta.canal,
      mesa: venta.mesa ?? null,
      estado: venta.estado,
      metodo_pago: venta.metodo_pago,
      cliente_id: venta.cliente_id ?? null,
      subtotal: Number(venta.subtotal || 0),
      impuesto_pct: Number(venta.impuesto_pct || 0),
      impuesto_monto: Number(venta.impuesto_monto || 0),
      total: Number(venta.total || 0),
      notas: venta.notas || '',
      usuario: this.usuario?.nombre || '',
      items: venta.items.map((i) => ({
        producto_id: i.producto_id,
        nombre: i.nombre,
        precio: Number(i.precio || 0),
        cantidad: Number(i.cantidad || 0),
        subtotal: Number(i.subtotal || 0),
        image_url: i.image_url || null
      }))
    };
  }

  private mapVentaFromApi(data: any): Venta {
    const items = Array.isArray(data.items) ? data.items : [];
    const mappedItems: VentaItem[] = items.map((item: any) => ({
      producto_id: item.producto_id ?? null,
      nombre: item.nombre || '',
      precio: Number(item.precio || 0),
      cantidad: Number(item.cantidad || 0),
      subtotal: Number(item.subtotal || 0),
      image_url: item.image_url || null
    }));
    const venta: Venta = {
      id: data.id,
      tipo: data.tipo,
      canal: data.canal || 'LOCAL',
      mesa: data.mesa ?? null,
      estado: data.estado || 'ABIERTA',
      metodo_pago: data.metodo_pago || this.metodosPagoPrincipales[0].value,
      cliente_id: data.cliente_id ?? null,
      credito_pagado: data.credito_pagado ?? true,
      credito_metodo_pago: data.credito_metodo_pago ?? null,
      credito_fecha_pago: data.credito_fecha_pago ?? null,
      notas: data.notas || '',
      items: mappedItems,
      subtotal: Number(data.subtotal || 0),
      impuesto_pct: Number(data.impuesto_pct || 0),
      impuesto_monto: Number(data.impuesto_monto || 0),
      total: Number(data.total || 0)
    };
    this.recalcularVenta(venta);
    return venta;
  }

  abrirCobroCredito(venta: any) {
    if (!venta?.id) return;
    this.cobroCreditoVenta = venta;
    this.cobroCreditoMetodo = 'EFECTIVO';
    this.cobroCreditoEfectivo = null;
    this.cobroCreditoBanco = '';
    this.cobroCreditoAbierto = true;
  }

  cerrarCobroCredito() {
    this.cobroCreditoAbierto = false;
    this.cobroCreditoVenta = null;
    this.cobroCreditoEfectivo = null;
    this.cobroCreditoBanco = '';
  }

  confirmarCobroCredito() {
    if (!this.cobroCreditoVenta?.id) return;
    const total = Number(this.cobroCreditoVenta.total || 0);
    if (this.cobroCreditoMetodo === 'EFECTIVO') {
      const recibido = Number(this.cobroCreditoEfectivo || 0);
      if (!recibido || recibido < total) {
        this.errorPago = 'El efectivo recibido debe ser mayor o igual al total.';
        return;
      }
    }
    if (this.cobroCreditoMetodo === 'TRANSFERENCIA' && !this.cobroCreditoBanco) {
      this.errorPago = 'Selecciona el banco para la transferencia.';
      return;
    }
    const bancoLabel = this.bancosEcuador.find((b) => b.value === this.cobroCreditoBanco)?.label || '';
    const referencia = bancoLabel ? `Cobro crédito ${bancoLabel}` : undefined;
    this.api.cobrarCredito(this.cobroCreditoVenta.id, {
      metodo_pago: this.cobroCreditoMetodo,
      usuario: this.usuario?.nombre || '',
      referencia
    }).subscribe({
      next: () => {
        this.cargarVentasEdicion();
        this.cargarCajaEstado();
        this.postActionRefresh();
        this.cerrarCobroCredito();
      },
      error: () => {
        this.errorPago = 'No se pudo cobrar el crédito.';
      }
    });
  }

  cargarClientes() {
    this.errorClientes = '';
    this.api.getClientes().subscribe({
      next: (data: any) => {
        this.clientes = Array.isArray(data) ? data : [];
      },
      error: () => {
        this.errorClientes = 'No se pudieron cargar los clientes.';
        this.clientes = [];
      }
    });
  }

  editarCliente(cliente: any) {
    this.clienteForm = {
      id: cliente?.id || null,
      nombre: cliente?.nombre || '',
      identificacion: cliente?.identificacion || '',
      telefono: cliente?.telefono || '',
      email: cliente?.email || '',
      direccion: cliente?.direccion || '',
      notas: cliente?.notas || ''
    };
  }

  cancelarEdicionCliente() {
    this.clienteForm = { id: null, nombre: '', identificacion: '', telefono: '', email: '', direccion: '', notas: '' };
  }

  guardarCliente() {
    if (!this.clienteForm.nombre) {
      this.errorClientes = 'El nombre es obligatorio.';
      return;
    }
    this.errorClientes = '';
    const payload = {
      nombre: this.clienteForm.nombre,
      identificacion: this.clienteForm.identificacion,
      telefono: this.clienteForm.telefono,
      email: this.clienteForm.email,
      direccion: this.clienteForm.direccion,
      notas: this.clienteForm.notas
    };
    const request = this.clienteForm.id
      ? this.api.actualizarCliente(this.clienteForm.id, payload)
      : this.api.crearCliente(payload);
    request.subscribe({
      next: () => {
        this.cancelarEdicionCliente();
        this.cargarClientes();
      },
      error: () => {
        this.errorClientes = 'No se pudo guardar el cliente.';
      }
    });
  }

  eliminarCliente(id: number) {
    if (!id) return;
    if (!confirm('¿Eliminar cliente?')) return;
    this.api.eliminarCliente(id).subscribe({
      next: () => this.cargarClientes(),
      error: () => {
        this.errorClientes = 'No se pudo eliminar el cliente.';
      }
    });
  }

  cargarCajaEstado() {
    this.errorCaja = '';
    this.cajaCargando = true;
    this.api.getCajaEstado().subscribe({
      next: (data: any) => {
        this.cajaEstado = data?.turno || null;
        this.cajaSaldoInicialEdit = Number(this.cajaEstado?.saldo_inicial || 0);
        this.cajaVentas = Array.isArray(data?.ventas) ? data.ventas : [];
        this.cajaMovimientos = Array.isArray(data?.movimientos) ? data.movimientos : [];
        this.cajaResumen = data?.resumen || null;
        this.calcularEfectivoEsperado();
        this.cajaCargando = false;
        this.cdr.detectChanges();
      },
      error: (err) => {
        this.errorCaja = this.getErrorMessage(err, 'No se pudo cargar el estado de caja.');
        this.cajaCargando = false;
        this.cdr.detectChanges();
      }
    });
  }

  cargarCajaHistorial() {
    this.api.getCajaHistorial(20).subscribe({
      next: (data: any) => {
        this.cajaHistorial = Array.isArray(data) ? data : [];
      },
      error: () => {
        this.cajaHistorial = [];
      }
    });
  }

  calcularEfectivoEsperado() {
    const ventasMov = this.cajaMovimientos
      .filter(m => String(m?.tipo || '').trim().toUpperCase() === 'VENTA');

    this.cajaVentasEfectivo = ventasMov
      .filter(m => String(m?.tipo || '').trim().toUpperCase() === 'VENTA' && String(m?.metodo_pago || '').toUpperCase() === 'EFECTIVO')
      .reduce((acc, m) => acc + Number(m.monto || 0), 0);
    this.cajaVentasTransferencia = ventasMov
      .filter(m => String(m?.tipo || '').trim().toUpperCase() === 'VENTA' && String(m?.metodo_pago || '').toUpperCase() === 'TRANSFERENCIA')
      .reduce((acc, m) => acc + Number(m.monto || 0), 0);
    this.cajaMovIngresosEfectivo = this.cajaMovimientos
      .filter(m => String(m?.metodo_pago || '').toUpperCase() === 'EFECTIVO' && String(m?.tipo || '').trim().toUpperCase() === 'INGRESO')
      .reduce((acc, m) => acc + Number(m.monto || 0), 0);
    this.cajaMovEgresosEfectivo = this.cajaMovimientos
      .filter(m => String(m?.metodo_pago || '').toUpperCase() === 'EFECTIVO' && String(m?.tipo || '').trim().toUpperCase() === 'EGRESO')
      .reduce((acc, m) => acc + Number(m.monto || 0), 0);
    this.cajaMovTransferencias = this.cajaMovimientos
      .filter(m => {
        const tipo = String(m?.tipo || '').trim().toUpperCase();
        const metodo = String(m?.metodo_pago || '').toUpperCase();
        return metodo === 'TRANSFERENCIA' && (tipo === 'VENTA' || tipo === 'INGRESO');
      })
      .reduce((acc, m) => acc + Number(m.monto || 0), 0);
    const totalVentas = ventasMov.reduce((acc, m) => acc + Number(m.monto || 0), 0);
    this.cajaVentasCount = ventasMov.length;
    this.cajaTicketPromedio = this.cajaVentasCount ? totalVentas / this.cajaVentasCount : 0;
    this.cajaEfectivoEsperado = Math.max(0, this.cajaVentasEfectivo + this.cajaMovIngresosEfectivo - this.cajaMovEgresosEfectivo);
    const saldoInicial = Number(this.cajaEstado?.saldo_inicial || 0);
    this.cajaEfectivoCaja = Math.max(0, this.cajaVentasEfectivo - this.cajaMovEgresosEfectivo + this.cajaMovIngresosEfectivo - saldoInicial);
  }

  crearMovimientoCaja() {
    if (!this.cajaEstado?.id) return;
    if (!this.cajaMovimientoForm.monto || this.cajaMovimientoForm.monto <= 0) return;
    this.api.crearMovimientoCaja({
      turno_id: this.cajaEstado.id,
      tipo: this.cajaMovimientoForm.tipo,
      metodo_pago: this.cajaMovimientoForm.metodo_pago,
      monto: this.cajaMovimientoForm.monto,
      referencia: this.cajaMovimientoForm.referencia,
      usuario: this.usuario?.nombre
    }).subscribe({
      next: () => {
        this.cajaMovimientoForm = { tipo: 'INGRESO', metodo_pago: 'EFECTIVO', monto: 0, referencia: '' };
        this.cargarCajaEstado();
        this.postActionRefresh();
      },
      error: (err) => {
        this.errorCaja = this.getErrorMessage(err, 'No se pudo registrar el movimiento.');
      }
    });
  }

  abrirEditarMovimientoCaja(mov: any) {
    this.editandoMovimientoCaja = { ...mov };
  }

  cancelarEditarMovimientoCaja() {
    this.editandoMovimientoCaja = null;
  }

  guardarEditarMovimientoCaja() {
    if (!this.editandoMovimientoCaja?.id) return;
    this.api.actualizarMovimientoCaja(this.editandoMovimientoCaja.id, this.editandoMovimientoCaja).subscribe({
      next: () => {
        this.editandoMovimientoCaja = null;
        this.cargarCajaEstado();
        this.postActionRefresh();
      },
      error: (err) => {
        this.errorCaja = this.getErrorMessage(err, 'No se pudo actualizar el movimiento.');
      }
    });
  }

  eliminarMovimientoCaja(id: number) {
    this.api.eliminarMovimientoCaja(id).subscribe({
      next: () => {
        this.cargarCajaEstado();
        this.postActionRefresh();
      },
      error: (err) => {
        this.errorCaja = this.getErrorMessage(err, 'No se pudo eliminar el movimiento.');
      }
    });
  }

  cargarResumenVentas() {
    const fecha = this.getFechaLocalISO();
    this.api.getVentas({ fecha, estado: 'PAGADA' }).subscribe({
      next: (data: any) => {
        const ventas = Array.isArray(data) ? data : [];
        const total = ventas.reduce((acc, v) => acc + Number(v.total || 0), 0);
        const pedidos = ventas.length;
        const ventasTransferencia = ventas
          .filter(v => String(v?.metodo_pago || '').toUpperCase() === 'TRANSFERENCIA')
          .reduce((acc, v) => acc + Number(v.total || 0), 0);
        const ticketPromedio = pedidos ? total / pedidos : 0;

        const porMetodo = this.agruparPor(ventas, 'metodo_pago', {
          EFECTIVO: '#2ecc71',
          TARJETA_DEBITO: '#3498db',
          TARJETA_CREDITO: '#9b59b6',
          TRANSFERENCIA: '#f39c12',
          DE_UNA: '#e67e22',
          CORTESIA: '#95a5a6',
          OTRO: '#7f8c8d'
        });
        const porCanal = this.agruparPor(ventas, 'canal', {
          LOCAL: '#2ecc71',
          PEDIDOS_YA: '#e74c3c'
        });

        this.analiticas = { totalVentas: total, porMetodo, porCanal, porUsuario: this.analiticas.porUsuario };

        const { desdeMes, hastaMes } = this.getRangoMesActual();
        this.api.getDashboardResumenMes({ desde: desdeMes, hasta: hastaMes }).subscribe({
          next: (mesData: any) => {
            const totalMes = Number(mesData?.totalVentas || 0);
            const gastosMes = Number(mesData?.totalGastos || 0);
            const gananciasBaseMes = Number(mesData?.totalGanancias || 0);
            const gastosFacturasMes = Number(mesData?.totalGastosFacturas || 0);
            const gananciasMes = Number(mesData?.totalGananciaReal ?? gananciasBaseMes);
            const porUsuario = Array.isArray(mesData?.ventasPorUsuario) ? mesData.ventasPorUsuario : [];
            this.analiticas.porUsuario = porUsuario.map((u: any, idx: number) => ({
              label: u.usuario,
              value: Number(u.total || 0),
              color: ['#2ecc71', '#27ae60', '#16a085', '#1abc9c', '#2c3e50', '#3498db'][idx % 6]
            }));

            this.api.getCajaEstado().subscribe({
              next: (caja: any) => {
                const movs = Array.isArray(caja?.movimientos) ? caja.movimientos : [];
                const ventasMov = movs.filter((m: any) => String(m?.tipo || '').trim().toUpperCase() === 'VENTA');
                const totalCaja = ventasMov.reduce((acc: number, m: any) => acc + Number(m.monto || 0), 0);
                const ventasTransferenciaCaja = ventasMov
                  .filter((m: any) => String(m?.metodo_pago || '').toUpperCase() === 'TRANSFERENCIA')
                  .reduce((acc: number, m: any) => acc + Number(m.monto || 0), 0);
                const ventasCountCaja = ventasMov.length;
                const ticketPromedioCaja = ventasCountCaja ? totalCaja / ventasCountCaja : 0;
                const ventasEfectivo = movs
                  .filter((m: any) => String(m?.tipo || '').trim().toUpperCase() === 'VENTA' && String(m?.metodo_pago || '').toUpperCase() === 'EFECTIVO')
                  .reduce((acc: number, m: any) => acc + Number(m.monto || 0), 0);
                const ingresos = movs
                  .filter((m: any) => String(m?.tipo || '').trim().toUpperCase() === 'INGRESO' && String(m?.metodo_pago || '').toUpperCase() === 'EFECTIVO')
                  .reduce((acc: number, m: any) => acc + Number(m.monto || 0), 0);
                const egresos = movs
                  .filter((m: any) => String(m?.tipo || '').trim().toUpperCase() === 'EGRESO' && String(m?.metodo_pago || '').toUpperCase() === 'EFECTIVO')
                  .reduce((acc: number, m: any) => acc + Number(m.monto || 0), 0);
                const saldoInicial = Number(caja?.turno?.saldo_inicial || 0);
                const efectivoCaja = Math.max(0, saldoInicial + ventasEfectivo - egresos + ingresos);

                this.resumen = {
                  ventasHoy: totalCaja,
                  pedidos: ventasCountCaja,
                  efectivo: efectivoCaja,
                  ventasTransferencia: ventasTransferenciaCaja,
                  ventasCount: ventasCountCaja,
                  ticketPromedio: ticketPromedioCaja,
                  ventasMes: totalMes,
                  gananciasMes,
                  gastosMes,
                  gananciasBaseMes,
                  gastosFacturasMes
                };
                this.cargarAnalyticsExtra();
              },
              error: () => {
                this.resumen = {
                  ventasHoy: total,
                  pedidos,
                  efectivo: Math.max(0, porMetodo.find((p) => p.label === 'EFECTIVO')?.value || 0),
                  ventasTransferencia,
                  ventasCount: pedidos,
                  ticketPromedio,
                  ventasMes: totalMes,
                  gananciasMes,
                  gastosMes,
                  gananciasBaseMes,
                  gastosFacturasMes
                };
              }
            });
          },
          error: () => {
            this.api.getCajaEstado().subscribe({
              next: (caja: any) => {
                const movs = Array.isArray(caja?.movimientos) ? caja.movimientos : [];
                const ventasEfectivo = movs
                  .filter((m: any) => String(m?.tipo || '').trim().toUpperCase() === 'VENTA' && String(m?.metodo_pago || '').toUpperCase() === 'EFECTIVO')
                  .reduce((acc: number, m: any) => acc + Number(m.monto || 0), 0);
                const ingresos = movs
                  .filter((m: any) => String(m?.tipo || '').trim().toUpperCase() === 'INGRESO' && String(m?.metodo_pago || '').toUpperCase() === 'EFECTIVO')
                  .reduce((acc: number, m: any) => acc + Number(m.monto || 0), 0);
                const egresos = movs
                  .filter((m: any) => String(m?.tipo || '').trim().toUpperCase() === 'EGRESO' && String(m?.metodo_pago || '').toUpperCase() === 'EFECTIVO')
                  .reduce((acc: number, m: any) => acc + Number(m.monto || 0), 0);
                const saldoInicial = Number(caja?.turno?.saldo_inicial || 0);
                const efectivoCaja = Math.max(0, saldoInicial + ventasEfectivo - egresos + ingresos);
                this.resumen = {
                  ventasHoy: total,
                  pedidos,
                  efectivo: efectivoCaja,
                  ventasTransferencia,
                  ventasCount: pedidos,
                  ticketPromedio,
                  ventasMes: 0,
                  gananciasMes: 0,
                  gastosMes: 0,
                  gananciasBaseMes: 0,
                  gastosFacturasMes: 0
                };
              },
              error: () => {
                this.resumen = {
                  ventasHoy: total,
                  pedidos,
                  efectivo: Math.max(0, porMetodo.find((p) => p.label === 'EFECTIVO')?.value || 0),
                  ventasTransferencia,
                  ventasCount: pedidos,
                  ticketPromedio,
                  ventasMes: 0,
                  gananciasMes: 0,
                  gastosMes: 0,
                  gananciasBaseMes: 0,
                  gastosFacturasMes: 0
                };
              }
            });
          }
        });
      },
      error: () => {}
    });
  }

  cargarGastosMes() {
    this.errorGastos = '';
    const { desdeMes, hastaMes } = this.getRangoMesActual();
    this.api.getGastos({ desde: desdeMes, hasta: hastaMes }).subscribe({
      next: (data: any) => {
        this.gastosItems = Array.isArray(data) ? data : [];
      },
      error: (err) => {
        this.errorGastos = this.getErrorMessage(err, 'No se pudieron cargar los gastos del mes.');
        this.gastosItems = [];
      }
    });
  }

  cargarAhorrosCajaChicaMes() {
    const { desdeMes, hastaMes } = this.getRangoMesActual();
    this.api.getCajaChicaAhorros({ desde: desdeMes, hasta: hastaMes }).subscribe({
      next: (data: any) => {
        this.ahorrosCajaChicaItems = Array.isArray(data) ? data : [];
        this.ahorrosCajaChicaTotal = this.ahorrosCajaChicaItems.reduce((acc, item) => acc + Number(item?.monto || 0), 0);
      },
      error: () => {
        this.ahorrosCajaChicaItems = [];
        this.ahorrosCajaChicaTotal = 0;
      }
    });
  }

  onGastoFacturaSeleccionada(event: Event) {
    const input = event.target as HTMLInputElement;
    this.gastoFacturaFile = input.files && input.files.length ? input.files[0] : null;
    this.gastoFacturaPreview = null;
    if (this.gastoFacturaFile && this.gastoFacturaFile.type.startsWith('image/')) {
      const reader = new FileReader();
      reader.onload = (e: any) => { this.gastoFacturaPreview = e.target.result; this.cdr.detectChanges(); };
      reader.readAsDataURL(this.gastoFacturaFile);
    }
  }

  onAhorroComprobanteSeleccionado(event: Event) {
    const input = event.target as HTMLInputElement;
    this.ahorroComprobanteFile = input.files && input.files.length ? input.files[0] : null;
    this.ahorroComprobantePreview = null;
    if (this.ahorroComprobanteFile && this.ahorroComprobanteFile.type.startsWith('image/')) {
      const reader = new FileReader();
      reader.onload = (e: any) => { this.ahorroComprobantePreview = e.target.result; this.cdr.detectChanges(); };
      reader.readAsDataURL(this.ahorroComprobanteFile);
    }
  }

  quitarGastoFactura() {
    this.gastoFacturaFile = null;
    this.gastoFacturaPreview = null;
  }

  quitarAhorroComprobante() {
    this.ahorroComprobanteFile = null;
    this.ahorroComprobantePreview = null;
  }

  // Sugerencias combobox
  cargarSugerenciasGastos() {
    this.api.getGastosSugerencias().subscribe({
      next: (data: any) => {
        this.sugerenciasCategorias = Array.isArray(data?.categorias) ? data.categorias : [];
        this.sugerenciasProveedores = Array.isArray(data?.proveedores) ? data.proveedores : [];
      }
    });
  }

  filtrarCategorias(valor: string) {
    const v = (valor || '').toLowerCase();
    this.categoriaFiltrada = v ? this.sugerenciasCategorias.filter(c => c.toLowerCase().includes(v)) : [...this.sugerenciasCategorias];
    this.mostrarSugCategorias = this.categoriaFiltrada.length > 0;
  }

  seleccionarCategoria(cat: string) {
    this.gastoForm.categoria = cat;
    this.mostrarSugCategorias = false;
  }

  filtrarProveedores(valor: string) {
    const v = (valor || '').toLowerCase();
    this.proveedorFiltrado = v ? this.sugerenciasProveedores.filter(p => p.toLowerCase().includes(v)) : [...this.sugerenciasProveedores];
    this.mostrarSugProveedores = this.proveedorFiltrado.length > 0;
  }

  seleccionarProveedor(prov: string) {
    this.gastoForm.proveedor = prov;
    this.mostrarSugProveedores = false;
  }

  cerrarSugerencias() {
    setTimeout(() => {
      this.mostrarSugCategorias = false;
      this.mostrarSugProveedores = false;
    }, 200);
  }

  registrarGastoMes() {
    if (!this.gastoForm.fecha || !this.gastoForm.descripcion || !this.gastoForm.monto || this.gastoForm.monto <= 0) {
      this.errorGastos = 'Fecha, descripción y monto son obligatorios.';
      return;
    }

    const payload = {
      fecha: this.gastoForm.fecha,
      descripcion: this.gastoForm.descripcion,
      monto: this.gastoForm.monto,
      categoria: this.gastoForm.categoria,
      caja_origen: 'CAJA_LOCAL',
      proveedor: this.gastoForm.proveedor,
      usuario: this.usuario?.nombre
    };

    this.api.crearGasto(payload, this.gastoFacturaFile).subscribe({
      next: () => {
        this.resetGastoForm();
        this.cargarGastosMes();
        this.cargarResumenVentas();
        this.cargarSugerenciasGastos();
      },
      error: (err) => {
        this.errorGastos = this.getErrorMessage(err, 'No se pudo registrar el gasto.');
      }
    });
  }

  registrarAhorroCajaChica() {
    if (!this.ahorroCajaChicaForm.fecha || !this.ahorroCajaChicaForm.monto || this.ahorroCajaChicaForm.monto <= 0) {
      this.errorGastos = 'Para ahorro en caja chica debes indicar fecha y monto mayor a 0.';
      return;
    }

    this.api.crearCajaChicaAhorro({
      fecha: this.ahorroCajaChicaForm.fecha,
      monto: this.ahorroCajaChicaForm.monto,
      referencia: this.ahorroCajaChicaForm.referencia,
      usuario: this.usuario?.nombre
    }, this.ahorroComprobanteFile).subscribe({
      next: () => {
        this.ahorroCajaChicaForm = { fecha: this.getFechaLocalISO(), monto: 0, referencia: '' };
        this.ahorroComprobanteFile = null;
        this.ahorroComprobantePreview = null;
        this.cargarAhorrosCajaChicaMes();
      },
      error: (err) => {
        this.errorGastos = this.getErrorMessage(err, 'No se pudo registrar el ahorro en caja chica.');
      }
    });
  }

  eliminarAhorroCajaChica(id: number) {
    if (!id) return;
    if (!confirm('¿Eliminar este movimiento de ahorro?')) return;
    this.api.eliminarCajaChicaAhorro(id).subscribe({
      next: () => {
        this.cargarAhorrosCajaChicaMes();
      },
      error: (err) => {
        this.errorGastos = this.getErrorMessage(err, 'No se pudo eliminar el ahorro.');
      }
    });
  }

  eliminarGastoMes(id: number) {
    if (!id) return;
    if (!confirm('¿Eliminar este gasto?')) return;
    this.api.eliminarGasto(id).subscribe({
      next: () => {
        this.cargarGastosMes();
        this.cargarResumenVentas();
      },
      error: (err) => {
        this.errorGastos = this.getErrorMessage(err, 'No se pudo eliminar el gasto.');
      }
    });
  }

  abrirEditarGasto(gasto: any) {
    if (!gasto) return;
    this.editandoGasto = {
      ...gasto,
      fecha: String(gasto.fecha_iso || gasto.fecha || '').slice(0, 10)
    };
    this.editandoGastoFacturaFile = null;
    this.editandoGastoMantenerFactura = true;
  }

  onEditarGastoFacturaSeleccionada(event: Event) {
    const input = event.target as HTMLInputElement;
    this.editandoGastoFacturaFile = input.files && input.files.length ? input.files[0] : null;
    if (this.editandoGastoFacturaFile) {
      this.editandoGastoMantenerFactura = true;
    }
  }

  cancelarEditarGasto() {
    this.editandoGasto = null;
    this.editandoGastoFacturaFile = null;
    this.editandoGastoMantenerFactura = true;
  }

  guardarEditarGasto() {
    if (!this.editandoGasto?.id) return;
    const monto = Number(this.editandoGasto?.monto || 0);
    if (!this.editandoGasto?.fecha || !this.editandoGasto?.descripcion || monto <= 0) {
      this.errorGastos = 'Fecha, descripción y monto son obligatorios.';
      return;
    }

    const payload = {
      fecha: this.editandoGasto.fecha,
      descripcion: this.editandoGasto.descripcion,
      monto,
      categoria: this.editandoGasto.categoria,
      caja_origen: 'CAJA_LOCAL',
      proveedor: this.editandoGasto.proveedor,
      usuario: this.usuario?.nombre,
      mantener_factura: this.editandoGastoMantenerFactura
    };

    this.api.actualizarGasto(this.editandoGasto.id, payload, this.editandoGastoFacturaFile).subscribe({
      next: () => {
        this.cancelarEditarGasto();
        this.cargarGastosMes();
        this.cargarResumenVentas();
      },
      error: (err) => {
        this.errorGastos = this.getErrorMessage(err, 'No se pudo actualizar el gasto.');
      }
    });
  }

  private resetGastoForm() {
    this.gastoForm = {
      fecha: this.getFechaLocalISO(),
      descripcion: '',
      monto: 0,
      categoria: '',
      proveedor: ''
    };
    this.gastoFacturaFile = null;
    this.gastoFacturaPreview = null;
    this.errorGastos = '';
  }

  cargarReporte() {
    if (!this.reporteForm.tipo || !this.reporteForm.desde || !this.reporteForm.hasta) {
      this.reporteError = 'Selecciona tipo y rango de fechas.';
      return;
    }
    this.reporteCargando = true;
    this.reporteError = '';
    this.api.getReporteData({
      tipo: this.reporteForm.tipo,
      desde: this.reporteForm.desde,
      hasta: this.reporteForm.hasta
    }).subscribe({
      next: async (data: any) => {
        try {
          this.reporteData = data || null;
          await this.generarPdfReporte();
        } catch (e) {
          this.reporteError = this.getErrorMessage(e, 'No se pudo generar el PDF del reporte.');
          this.limpiarReportePdf();
        } finally {
          this.reporteCargando = false;
        }
      },
      error: async (err) => {
        try {
          const status = Number(err?.status || 0);
          if (status === 404) {
            await this.generarReporteFallback();
            await this.generarPdfReporte();
            this.reporteError = 'Backend sin módulo de reportes nuevo: se generó usando modo compatibilidad.';
            return;
          }
          this.reporteError = this.getErrorMessage(err, 'No se pudo generar el reporte.');
          this.reporteData = null;
          this.limpiarReportePdf();
        } catch (fallbackErr) {
          this.reporteError = this.getErrorMessage(fallbackErr, 'No se pudo generar el reporte en modo compatibilidad.');
          this.reporteData = null;
          this.limpiarReportePdf();
        } finally {
          this.reporteCargando = false;
        }
      }
    });
  }

  private async generarReporteFallback() {
    const tipo = String(this.reporteForm.tipo || '').toLowerCase();
    const desde = this.reporteForm.desde;
    const hasta = this.reporteForm.hasta;

    if (tipo === 'inventario' || tipo === 'stock') {
      const insumosRaw: any = await this.toPromise<any>(this.api.getInsumos());
      const productosRaw: any = await this.toPromise<any>(this.api.getProductos());
      const insumos: any[] = Array.isArray(insumosRaw) ? insumosRaw : [];
      const productos: any[] = Array.isArray(productosRaw) ? productosRaw : [];

      if (tipo === 'inventario') {
        this.reporteData = {
          tipo,
          titulo: 'Reporte de Inventario y Existencias',
          desde,
          hasta,
          resumen: {
            totalInsumos: insumos.length,
            totalProductos: productos.length,
            stockBajoInsumos: insumos.filter((i: any) => Number(i?.stock_actual || 0) <= Number(i?.stock_minimo || 0)).length,
            stockBajoProductos: productos.filter((p: any) => Number(p?.stock_actual || 0) <= Number(p?.stock_minimo || 0)).length
          },
          secciones: [
            { titulo: 'Insumos', items: insumos },
            { titulo: 'Productos', items: productos }
          ]
        };
        return;
      }

      const criticosInsumos = insumos
        .filter((i: any) => Number(i?.stock_actual || 0) <= Number(i?.stock_minimo || 0))
        .map((i: any) => ({ tipo: 'INSUMO', ...i }));
      const criticosProductos = productos
        .filter((p: any) => Number(p?.stock_actual || 0) <= Number(p?.stock_minimo || 0))
        .map((p: any) => ({ tipo: 'PRODUCTO', ...p }));
      const items = [...criticosInsumos, ...criticosProductos];

      this.reporteData = {
        tipo,
        titulo: 'Reporte de Stock Bajo',
        desde,
        hasta,
        resumen: { totalItems: items.length },
        secciones: [{ titulo: 'Items con stock crítico', items }]
      };
      return;
    }

    if (tipo === 'ventas') {
      const ventasRaw: any = await this.toPromise<any>(this.api.getVentas({ desde, hasta, estado: 'PAGADA' }));
      const ventas: any[] = Array.isArray(ventasRaw) ? ventasRaw : [];
      const totalVentas = ventas.reduce((acc: number, v: any) => acc + Number(v?.total || 0), 0);
      this.reporteData = {
        tipo,
        titulo: 'Reporte de Ventas',
        desde,
        hasta,
        resumen: {
          totalVentas,
          cantidad: ventas.length,
          ticketPromedio: ventas.length ? totalVentas / ventas.length : 0
        },
        secciones: [{ titulo: 'Ventas pagadas', items: ventas }]
      };
      return;
    }

    if (tipo === 'caja') {
      const ventasRaw: any = await this.toPromise<any>(this.api.getVentas({ desde, hasta, estado: 'PAGADA' }));
      const movRaw: any = await this.toPromise<any>(this.api.getCajaHistorialMovimientos({ desde, hasta }));
      const ventas: any[] = Array.isArray(ventasRaw) ? ventasRaw : [];
      const movimientos: any[] = Array.isArray(movRaw) ? movRaw : [];
      const totalVentas = ventas.reduce((acc: number, v: any) => acc + Number(v?.total || 0), 0);
      const totalIngresos = movimientos
        .filter((m: any) => String(m?.tipo || '').toUpperCase() === 'INGRESO')
        .reduce((acc: number, m: any) => acc + Number(m?.monto || 0), 0);
      const totalEgresos = movimientos
        .filter((m: any) => String(m?.tipo || '').toUpperCase() === 'EGRESO')
        .reduce((acc: number, m: any) => acc + Number(m?.monto || 0), 0);

      this.reporteData = {
        tipo,
        titulo: 'Reporte de Caja',
        desde,
        hasta,
        resumen: {
          totalVentas,
          totalIngresos,
          totalEgresos,
          neto: totalVentas + totalIngresos - totalEgresos
        },
        secciones: [
          { titulo: 'Ventas', items: ventas },
          { titulo: 'Movimientos de Caja', items: movimientos }
        ]
      };
      return;
    }

    if (tipo === 'ganancias' || tipo === 'gastos') {
      const resumenMes: any = await this.toPromise<any>(this.api.getDashboardResumenMes({ desde, hasta }));
      let gastos: any[] = [];
      try {
        const maybeGastos = await this.toPromise(this.api.getGastos({ desde, hasta }));
        gastos = Array.isArray(maybeGastos) ? maybeGastos : [];
      } catch {
        gastos = [];
      }

      if (tipo === 'ganancias') {
        this.reporteData = {
          tipo,
          titulo: 'Reporte de Ganancias',
          desde,
          hasta,
          resumen: {
            totalVentas: Number(resumenMes?.totalVentas || 0),
            totalIngresos: Number(resumenMes?.totalIngresos || 0),
            totalEgresosCaja: Number(resumenMes?.totalGastos || 0),
            totalGananciasBase: Number(resumenMes?.totalGanancias || 0),
            totalGastosFacturas: Number(resumenMes?.totalGastosFacturas || 0),
            totalGananciaReal: Number((resumenMes?.totalGananciaReal ?? resumenMes?.totalGanancias) || 0)
          },
          secciones: [{ titulo: 'Gastos Facturados', items: gastos }]
        };
      } else {
        const totalGastos = gastos.reduce((acc: number, g: any) => acc + Number(g?.monto || 0), 0);
        this.reporteData = {
          tipo,
          titulo: 'Reporte de Gastos',
          desde,
          hasta,
          resumen: {
            totalGastos,
            cantidad: gastos.length,
            cajaLocal: gastos
              .filter((g: any) => String(g?.caja_origen || '').toUpperCase() === 'CAJA_LOCAL')
              .reduce((acc: number, g: any) => acc + Number(g?.monto || 0), 0),
            cajaChica: gastos
              .filter((g: any) => String(g?.caja_origen || '').toUpperCase() === 'CAJA_CHICA')
              .reduce((acc: number, g: any) => acc + Number(g?.monto || 0), 0)
          },
          secciones: [{ titulo: 'Detalle de gastos', items: gastos }]
        };
      }
      return;
    }

    throw new Error('Tipo de reporte no soportado en modo compatibilidad.');
  }

  async generarPdfReporte() {
    if (!this.reporteData) return;
    const titulo = String(this.reporteData?.titulo || 'Reporte');
    const desde = String(this.reporteData?.desde || this.reporteForm.desde || '');
    const hasta = String(this.reporteData?.hasta || this.reporteForm.hasta || '');
    const doc = new jsPDF({ orientation: 'portrait', unit: 'pt', format: 'a4' });

    const logoDataUrl = await this.getReporteLogoDataUrl();

    this.pintarEncabezadoReporte(doc, titulo, logoDataUrl, false);
    this.pintarPortadaEjecutiva(doc, desde, hasta);

    doc.setTextColor(this.reporteBrand.secondary[0], this.reporteBrand.secondary[1], this.reporteBrand.secondary[2]);
    doc.setFont('helvetica', 'normal');
    doc.setFontSize(10);
    doc.text(`Rango: ${desde} a ${hasta}`, 40, 208);
    doc.text(`Generado: ${new Date().toLocaleString('es-EC')}`, 40, 222);

    const resumenObj = this.reporteData?.resumen || {};
    const resumenRows = Object.entries(resumenObj).map(([key, value]) => [this.humanizarKey(key), this.formatearValor(value)]);
    let y = 238;
    if (resumenRows.length) {
      autoTable(doc, {
        startY: y,
        head: [['Resumen', 'Valor']],
        body: resumenRows,
        styles: { fontSize: 9 },
        headStyles: { fillColor: this.reporteBrand.primary },
        alternateRowStyles: { fillColor: [248, 252, 249] }
      });
      y = (doc as any).lastAutoTable.finalY + 16;
    }

    const secciones = Array.isArray(this.reporteData?.secciones) ? this.reporteData.secciones : [];
    secciones.forEach((seccion: any, idx: number) => {
      const items = Array.isArray(seccion?.items) ? seccion.items : [];
      if (!items.length) return;
      if (y > 700) {
        doc.addPage();
        this.pintarEncabezadoReporte(doc, titulo, logoDataUrl, true);
        y = 86;
      }
      doc.setFont('helvetica', 'bold');
      doc.setFontSize(12);
      doc.text(String(seccion?.titulo || `Sección ${idx + 1}`), 40, y);
      y += 10;

      const keys = Object.keys(items[0]).slice(0, 8);
      const head = [keys.map((key) => this.humanizarKey(key))];
      const body = items.map((item: any) => keys.map((key) => this.formatearValor(item?.[key])));

      autoTable(doc, {
        startY: y,
        head,
        body,
        styles: { fontSize: 8, cellPadding: 4 },
        headStyles: { fillColor: this.reporteBrand.secondary },
        alternateRowStyles: { fillColor: [252, 248, 244] },
        margin: { left: 32, right: 32 }
      });

      y = (doc as any).lastAutoTable.finalY + 18;
    });

    y = this.pintarBloqueFirma(doc, y);

    const totalPages = doc.getNumberOfPages();
    for (let i = 1; i <= totalPages; i++) {
      doc.setPage(i);
      this.pintarPieLegal(doc, i, totalPages);
    }

    const pdfBlob = doc.output('blob');
    this.limpiarReportePdf();
    this.reportePdfUrl = URL.createObjectURL(pdfBlob);
    this.reportePdfSafeUrl = this.sanitizer.bypassSecurityTrustResourceUrl(this.reportePdfUrl);
    this.reportePdfNombre = `${String(this.reporteForm.tipo || 'reporte')}_${this.reporteForm.desde}_${this.reporteForm.hasta}.pdf`;
  }

  private pintarEncabezadoReporte(doc: jsPDF, titulo: string, logoDataUrl: string | null, compact: boolean) {
    const h = compact ? 64 : 88;
    doc.setFillColor(this.reporteBrand.primary[0], this.reporteBrand.primary[1], this.reporteBrand.primary[2]);
    doc.rect(0, 0, 595, h, 'F');
    doc.setFillColor(this.reporteBrand.soft[0], this.reporteBrand.soft[1], this.reporteBrand.soft[2]);
    doc.rect(0, h, 595, 10, 'F');

    if (logoDataUrl) {
      doc.addImage(logoDataUrl, 'JPEG', 40, compact ? 12 : 18, compact ? 40 : 52, compact ? 40 : 52, undefined, 'FAST');
    }

    doc.setTextColor(255, 255, 255);
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(compact ? 14 : 18);
    doc.text(titulo, logoDataUrl ? 94 : 40, compact ? 30 : 40);
    doc.setFontSize(compact ? 9 : 11);
    doc.text(this.reporteBrand.nombre, logoDataUrl ? 94 : 40, compact ? 44 : 58);
  }

  private pintarPortadaEjecutiva(doc: jsPDF, desde: string, hasta: string) {
    doc.setTextColor(this.reporteBrand.secondary[0], this.reporteBrand.secondary[1], this.reporteBrand.secondary[2]);
    doc.setFont('helvetica', 'bold');
    doc.setFontSize(12);
    doc.text('Resumen Ejecutivo', 40, 132);

    doc.setFont('helvetica', 'normal');
    doc.setFontSize(10);
    doc.text(this.reporteBrand.slogan, 40, 148);
    doc.text(`RUC: ${this.reporteBrand.ruc}`, 40, 164);
    doc.text(`Dirección: ${this.reporteBrand.direccion}`, 40, 178);
    doc.text(`Tel: ${this.reporteBrand.telefono} · Email: ${this.reporteBrand.email}`, 40, 192);
    doc.text(`Periodo analizado: ${desde} a ${hasta}`, 320, 148);
  }

  private pintarBloqueFirma(doc: jsPDF, y: number): number {
    let top = y;
    if (top > 690) {
      doc.addPage();
      this.pintarEncabezadoReporte(doc, String(this.reporteData?.titulo || 'Reporte'), this.reporteLogoDataUrl, true);
      top = 110;
    }

    doc.setDrawColor(this.reporteBrand.secondary[0], this.reporteBrand.secondary[1], this.reporteBrand.secondary[2]);
    doc.line(60, top + 40, 250, top + 40);
    doc.line(340, top + 40, 530, top + 40);

    doc.setFont('helvetica', 'bold');
    doc.setFontSize(10);
    doc.setTextColor(this.reporteBrand.secondary[0], this.reporteBrand.secondary[1], this.reporteBrand.secondary[2]);
    doc.text('Firma responsable', 60, top + 54);
    doc.text('Aprobación gerencial', 340, top + 54);
    doc.setFont('helvetica', 'normal');
    doc.text(String(this.usuario?.nombre || 'Usuario del sistema'), 60, top + 68);
    doc.text(this.reporteBrand.representante, 340, top + 68);

    return top + 86;
  }

  private pintarPieLegal(doc: jsPDF, page: number, totalPages: number) {
    const y = 818;
    doc.setDrawColor(210, 220, 214);
    doc.line(32, y - 18, 563, y - 18);
    doc.setTextColor(110, 120, 124);
    doc.setFont('helvetica', 'normal');
    doc.setFontSize(8);
    doc.text(`${this.reporteBrand.nombre} · RUC ${this.reporteBrand.ruc} · ${this.reporteBrand.direccion}`, 32, y - 4);
    doc.text(`Documento confidencial · Emitido por ReySoft`, 32, y + 8);
    doc.text(`Página ${page} de ${totalPages}`, 500, y + 8);
  }

  private async getReporteLogoDataUrl(): Promise<string | null> {
    if (this.reporteLogoDataUrl) return this.reporteLogoDataUrl;
    try {
      const response = await fetch(this.reporteBrand.logoPath);
      if (!response.ok) return null;
      const blob = await response.blob();
      this.reporteLogoDataUrl = await this.blobToDataUrl(blob);
      return this.reporteLogoDataUrl;
    } catch {
      return null;
    }
  }

  private toPromise<T>(observable: any): Promise<T> {
    return new Promise<T>((resolve, reject) => {
      observable.subscribe({
        next: (data: T) => resolve(data),
        error: (err: any) => reject(err)
      });
    });
  }

  private blobToDataUrl(blob: Blob): Promise<string> {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onloadend = () => resolve(String(reader.result || ''));
      reader.onerror = reject;
      reader.readAsDataURL(blob);
    });
  }

  descargarReportePdf() {
    if (!this.reportePdfUrl) return;
    const a = document.createElement('a');
    a.href = this.reportePdfUrl;
    a.download = this.reportePdfNombre || 'reporte.pdf';
    a.click();
  }

  imprimirReportePdf() {
    if (!this.reportePdfUrl) return;
    const win = window.open(this.reportePdfUrl, '_blank');
    if (!win) return;
    setTimeout(() => win.print(), 500);
  }

  async enviarReportePorCorreo() {
    if (!this.reportePdfUrl || !this.reporteForm.email) {
      this.reporteError = 'Debes generar un reporte y escribir un correo destino.';
      return;
    }
    this.enviandoReporte = true;
    this.reporteError = '';
    try {
      const response = await fetch(this.reportePdfUrl);
      const blob = await response.blob();
      const base64 = await this.blobToBase64(blob);
      await new Promise<void>((resolve, reject) => {
        this.api.enviarReporteCorreo({
          to: this.reporteForm.email,
          subject: this.reporteForm.asunto || 'Reporte ReySoft',
          body: this.reporteForm.mensaje || '',
          fileName: this.reportePdfNombre || 'reporte.pdf',
          pdfBase64: base64
        }).subscribe({
          next: () => resolve(),
          error: (err) => reject(err)
        });
      });
    } catch (err: any) {
      this.reporteError = this.getErrorMessage(err, 'No se pudo enviar el correo del reporte.');
    } finally {
      this.enviandoReporte = false;
    }
  }

  private blobToBase64(blob: Blob): Promise<string> {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onloadend = () => {
        const raw = String(reader.result || '');
        const base64 = raw.includes(',') ? raw.split(',')[1] : raw;
        resolve(base64);
      };
      reader.onerror = reject;
      reader.readAsDataURL(blob);
    });
  }

  private humanizarKey(key: string): string {
    return String(key || '')
      .replace(/_/g, ' ')
      .replace(/\b\w/g, (l) => l.toUpperCase());
  }

  private formatearValor(value: any): string {
    if (value === null || value === undefined) return '-';
    if (typeof value === 'number') return Number(value).toLocaleString('es-EC', { maximumFractionDigits: 2 });
    return String(value);
  }

  private limpiarReportePdf() {
    if (this.reportePdfUrl) {
      URL.revokeObjectURL(this.reportePdfUrl);
      this.reportePdfUrl = '';
    }
    this.reportePdfSafeUrl = null;
  }

  getPieDash(value: number, total: number): string {
    if (!total) return '0 100';
    const pct = (value / total) * 100;
    return `${pct} ${100 - pct}`;
  }

  getPieOffset(index: number, items: Array<{ value: number }>, total: number): number {
    if (!total) return 0;
    const prev = items.slice(0, index).reduce((acc, item) => acc + (item.value / total) * 100, 0);
    return -25 - prev;
  }

  private agruparPor(ventas: any[], key: string, colors: Record<string, string>) {
    const map = new Map<string, number>();
    ventas.forEach((v) => {
      const raw = String(v?.[key] || 'OTRO').toUpperCase();
      map.set(raw, (map.get(raw) || 0) + Number(v.total || 0));
    });
    return Array.from(map.entries()).map(([label, value]) => ({
      label,
      value,
      color: colors[label] || '#95a5a6'
    }));
  }

  // ===================== IMAGEN MODAL =====================
  abrirImagenModal(url: string) {
    this.imagenModalUrl = url;
  }
  cerrarImagenModal() {
    this.imagenModalUrl = null;
  }

  // ===================== CHART.JS DASHBOARD =====================
  private destroyCharts() {
    this.chartMetodoPago?.destroy(); this.chartMetodoPago = null;
    this.chartVentasDiarias?.destroy(); this.chartVentasDiarias = null;
    this.chartTopProductos?.destroy(); this.chartTopProductos = null;
    this.chartVentasHora?.destroy(); this.chartVentasHora = null;
  }

  inicializarCharts() {
    this.destroyCharts();
    this.renderChartMetodoPago();
    this.renderChartTopProductos();
    this.renderChartVentasDiarias();
    this.renderChartVentasHora();
  }

  cargarAnalyticsExtra() {
    this.api.getDashboardAnalyticsExtra().subscribe({
      next: (data: any) => {
        this.analyticsExtra = data || { topProductos: [], ventasDiarias: [], productosHoy: 0, ventasPorHora: [] };
        setTimeout(() => this.inicializarCharts(), 100);
      },
      error: () => {}
    });
  }

  private renderChartMetodoPago() {
    if (!this.chartMetodoPagoRef?.nativeElement) return;
    const ctx = this.chartMetodoPagoRef.nativeElement.getContext('2d');
    if (!ctx) return;
    const data = this.analiticas.porMetodo;
    this.chartMetodoPago = new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: data.map(d => d.label),
        datasets: [{
          data: data.map(d => d.value),
          backgroundColor: data.map(d => d.color),
          borderWidth: 2,
          borderColor: '#fff'
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        cutout: '65%',
        plugins: {
          legend: { position: 'bottom', labels: { padding: 15, usePointStyle: true, pointStyle: 'circle', font: { size: 12 } } }
        }
      }
    });
  }

  private renderChartTopProductos() {
    if (!this.chartTopProductosRef?.nativeElement) return;
    const ctx = this.chartTopProductosRef.nativeElement.getContext('2d');
    if (!ctx) return;
    const items = this.analyticsExtra.topProductos || [];
    const colors = ['#2ecc71', '#27ae60', '#16a085', '#1abc9c', '#3498db'];
    this.chartTopProductos = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: items.map((p: any) => p.nombre?.length > 15 ? p.nombre.substring(0, 15) + '...' : p.nombre),
        datasets: [{
          label: 'Unidades vendidas',
          data: items.map((p: any) => Number(p.cantidad)),
          backgroundColor: items.map((_: any, i: number) => colors[i % colors.length]),
          borderRadius: 8,
          borderSkipped: false
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        indexAxis: 'y',
        plugins: { legend: { display: false } },
        scales: {
          x: { grid: { display: false }, ticks: { font: { size: 11 } } },
          y: { grid: { display: false }, ticks: { font: { size: 11 } } }
        }
      }
    });
  }

  private renderChartVentasDiarias() {
    if (!this.chartVentasDiariasRef?.nativeElement) return;
    const ctx = this.chartVentasDiariasRef.nativeElement.getContext('2d');
    if (!ctx) return;
    const items = this.analyticsExtra.ventasDiarias || [];
    this.chartVentasDiarias = new Chart(ctx, {
      type: 'line',
      data: {
        labels: items.map((d: any) => {
          const date = new Date(d.dia);
          return `${date.getDate()}/${date.getMonth() + 1}`;
        }),
        datasets: [{
          label: 'Ventas ($)',
          data: items.map((d: any) => Number(d.total)),
          borderColor: '#2ecc71',
          backgroundColor: 'rgba(46,204,113,0.1)',
          fill: true,
          tension: 0.4,
          pointRadius: 4,
          pointBackgroundColor: '#27ae60',
          borderWidth: 2.5
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: {
          x: { grid: { display: false }, ticks: { font: { size: 10 } } },
          y: { grid: { color: 'rgba(0,0,0,0.05)' }, ticks: { font: { size: 10 }, callback: (v) => '$' + v } }
        }
      }
    });
  }

  private renderChartVentasHora() {
    if (!this.chartVentasHoraRef?.nativeElement) return;
    const ctx = this.chartVentasHoraRef.nativeElement.getContext('2d');
    if (!ctx) return;
    const items = this.analyticsExtra.ventasPorHora || [];
    const allHours = [];
    for (let h = 7; h <= 22; h++) allHours.push(h);
    const dataMap = new Map(items.map((i: any) => [Number(i.hora), Number(i.total)]));
    this.chartVentasHora = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: allHours.map(h => `${h}:00`),
        datasets: [{
          label: 'Ventas ($)',
          data: allHours.map(h => dataMap.get(h) || 0),
          backgroundColor: 'rgba(46,204,113,0.6)',
          borderColor: '#27ae60',
          borderWidth: 1,
          borderRadius: 4
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: {
          x: { grid: { display: false }, ticks: { font: { size: 9 } } },
          y: { grid: { color: 'rgba(0,0,0,0.05)' }, ticks: { font: { size: 10 }, callback: (v) => '$' + v } }
        }
      }
    });
  }

  private iniciarAutoRefresh() {
    this.detenerAutoRefresh();
    this.refrescarVista(this.vistaActual);
  }

  private detenerAutoRefresh() {
    if (this.autoRefreshId) {
      clearInterval(this.autoRefreshId);
      this.autoRefreshId = null;
    }
  }

  @HostListener('window:focus')
  onWindowFocus() {
    this.refrescarVista(this.vistaActual);
  }

  @HostListener('document:visibilitychange')
  onVisibilityChange() {
    if (!document.hidden) {
      this.refrescarVista(this.vistaActual);
    }
  }

  cargarVentasEdicion() {
    this.errorCaja = '';
    this.api.getVentas(this.ventasEdicionFiltro).subscribe({
      next: (data: any) => {
        this.ventasEdicion = Array.isArray(data) ? data : [];
      },
      error: (err) => {
        this.errorCaja = this.getErrorMessage(err, 'No se pudieron cargar las ventas.');
      }
    });
  }

  cargarHistorialCaja() {
    this.errorCaja = '';
    this.api.getCajaCierres(this.historialCajaFiltro).subscribe({
      next: (data: any) => {
        const cierres = Array.isArray(data) ? data : [];
        this.historialCajaCierres = cierres.map((c: any) => this.mapCierreCaja(c));
      },
      error: (err) => {
        this.errorCaja = this.getErrorMessage(err, 'No se pudo cargar el historial de caja.');
      }
    });
  }

  abrirVentaDetalle(ventaId: number) {
    if (!ventaId) return;
    this.api.getVentaById(ventaId).subscribe({
      next: (data: any) => {
        this.ventaDetalle = data;
      },
      error: () => {
        this.ventaDetalle = { id: ventaId, items: [] };
      }
    });
  }

  cerrarVentaDetalle() {
    this.ventaDetalle = null;
  }

  private mapCierreCaja(cierre: any) {
    const movimientos = Array.isArray(cierre?.movimientos) ? cierre.movimientos : [];
    const ventas = Array.isArray(cierre?.ventas) ? cierre.ventas : [];
    const resumen = cierre?.resumen || {};
    const ventasEfectivo = movimientos
      .filter((m: any) => String(m?.tipo || '').trim().toUpperCase() === 'VENTA' && String(m?.metodo_pago || '').toUpperCase() === 'EFECTIVO')
      .reduce((acc: number, m: any) => acc + Number(m.monto || 0), 0);
    const ingresosEfectivo = movimientos
      .filter((m: any) => String(m?.tipo || '').trim().toUpperCase() === 'INGRESO' && String(m?.metodo_pago || '').toUpperCase() === 'EFECTIVO')
      .reduce((acc: number, m: any) => acc + Number(m.monto || 0), 0);
    const egresosEfectivo = movimientos
      .filter((m: any) => String(m?.tipo || '').trim().toUpperCase() === 'EGRESO' && String(m?.metodo_pago || '').toUpperCase() === 'EFECTIVO')
      .reduce((acc: number, m: any) => acc + Number(m.monto || 0), 0);
    const transferencias = movimientos
      .filter((m: any) => {
        const tipo = String(m?.tipo || '').trim().toUpperCase();
        const metodo = String(m?.metodo_pago || '').toUpperCase();
        return metodo === 'TRANSFERENCIA' && (tipo === 'VENTA' || tipo === 'INGRESO');
      })
      .reduce((acc: number, m: any) => acc + Number(m.monto || 0), 0);
    const saldoInicial = Number(cierre?.saldo_inicial || 0);
    const efectivoEsperado = ventasEfectivo + ingresosEfectivo - egresosEfectivo;

    return {
      ...cierre,
      ventas,
      movimientos,
      resumenCalc: {
        saldoInicial,
        totalVentas: Number(resumen.totalVentas || 0),
        ventasEfectivo,
        totalIngresos: Number(resumen.totalIngresos || 0),
        totalEgresos: Number(resumen.totalEgresos || 0),
        totalNeto: Number(resumen.totalNeto || 0),
        transferencias,
        efectivoEsperado
      }
    };
  }

  cargarBodega() {
    this.errorInventario = '';
    this.api.getBodegaInsumos().subscribe({
      next: (data: any) => {
        this.bodegaInsumos = Array.isArray(data) ? data : [];
      },
      error: () => {
        this.errorInventario = 'No se pudieron cargar los insumos de bodega.';
      }
    });
    this.api.getBodegaProductos().subscribe({
      next: (data: any) => {
        this.bodegaProductos = Array.isArray(data) ? data : [];
      },
      error: () => {
        this.errorInventario = 'No se pudieron cargar los productos de bodega.';
      }
    });
  }

  crearBodegaInsumo() {
    if (!this.bodegaNuevoInsumo.nombre || !this.bodegaNuevoInsumo.unidad_medida) return;
    this.api.crearBodegaInsumo(this.bodegaNuevoInsumo).subscribe({
      next: () => {
        this.bodegaNuevoInsumo = { nombre: '', stock_actual: 0, unidad_medida: 'UND', stock_minimo: 0 };
        this.cargarBodega();
        this.postActionRefresh();
      },
      error: () => {
        this.errorInventario = 'No se pudo crear el insumo de bodega.';
      }
    });
  }

  crearBodegaProducto() {
    if (!this.bodegaNuevoProducto.nombre) return;
    const payload = {
      ...this.bodegaNuevoProducto,
      id_categoria: this.bodegaNuevoProducto.id_categoria ? Number(this.bodegaNuevoProducto.id_categoria) : null,
      precio: Number(this.bodegaNuevoProducto.precio || 0)
    };
    this.api.crearBodegaProducto(payload).subscribe({
      next: () => {
        this.bodegaNuevoProducto = { nombre: '', precio: 0, id_categoria: '', es_preparado: true };
        this.cargarBodega();
        this.postActionRefresh();
      },
      error: () => {
        this.errorInventario = 'No se pudo crear el producto de bodega.';
      }
    });
  }

  transferirBodega() {
    if (!this.bodegaTransfer.insumoId || !this.bodegaTransfer.cantidad) return;
    this.api.transferirBodega({
      bodega_insumo_id: this.bodegaTransfer.insumoId,
      cantidad: this.bodegaTransfer.cantidad,
      usuario: this.usuario?.nombre
    }).subscribe({
      next: () => {
        this.bodegaTransfer = { insumoId: null, cantidad: 0 };
        this.cargarBodega();
        this.postActionRefresh();
      },
      error: (err) => {
        this.errorInventario = this.getErrorMessage(err, 'No se pudo transferir a local.');
      }
    });
  }

  abrirCaja() {
    this.errorCaja = '';
    this.api.abrirCaja({ saldo_inicial: this.cajaSaldoInicial, usuario: this.usuario?.nombre }).subscribe({
      next: () => {
        this.cajaSaldoInicial = 0;
        this.cargarCajaEstado();
        this.postActionRefresh();
      },
      error: (err) => {
        this.errorCaja = this.getErrorMessage(err, 'No se pudo abrir la caja.');
      }
    });
  }

  actualizarSaldoInicialCaja() {
    if (!this.cajaEstado?.id) return;
    this.errorCaja = '';
    this.api.actualizarSaldoInicialCaja({
      turno_id: this.cajaEstado.id,
      saldo_inicial: this.cajaSaldoInicialEdit,
      usuario: this.usuario?.nombre
    }).subscribe({
      next: () => {
        this.cargarCajaEstado();
        this.postActionRefresh();
      },
      error: (err) => {
        this.errorCaja = this.getErrorMessage(err, 'No se pudo actualizar el saldo inicial.');
      }
    });
  }

  cerrarCaja() {
    if (!this.cajaEstado?.id) return;
    this.errorCaja = '';
    this.api.cerrarCaja({ turno_id: this.cajaEstado.id, saldo_real: this.cajaSaldoReal, usuario: this.usuario?.nombre }).subscribe({
      next: () => {
        this.cajaSaldoReal = 0;
        this.cargarCajaEstado();
        this.cargarCajaHistorial();
        this.cargarHistorialCaja();
        this.postActionRefresh();
      },
      error: (err) => {
        this.errorCaja = this.getErrorMessage(err, 'No se pudo cerrar la caja.');
      }
    });
  }

  abrirEditarVenta(venta: any) {
    this.editandoVenta = this.mapVentaFromApi(venta);
  }

  cancelarEditarVenta() {
    this.editandoVenta = null;
  }

  guardarEditarVenta() {
    if (!this.editandoVenta?.id) return;
    const payload = this.buildVentaPayload({
      ...this.editandoVenta,
      estado: 'PAGADA'
    });
    this.api.actualizarVenta(this.editandoVenta.id, payload).subscribe({
      next: () => {
        this.editandoVenta = null;
        this.cargarCajaEstado();
        this.postActionRefresh();
      },
      error: (err) => {
        this.errorCaja = this.getErrorMessage(err, 'No se pudo actualizar la venta.');
      }
    });
  }

  private normalizarTexto(texto: string | null | undefined): string {
    return String(texto || '')
      .toLowerCase()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .trim();
  }

  private aplicarBancoEnNotas(notas: string, bancoLabel: string): string {
    if (!bancoLabel) return notas || '';
    const base = notas || '';
    if (/banco\s*:/i.test(base)) return base;
    const separador = base ? ' | ' : '';
    return `${base}${separador}Banco: ${bancoLabel}`;
  }

  private getFechaLocalISO(): string {
    const hoy = new Date();
    const yyyy = hoy.getFullYear();
    const mm = String(hoy.getMonth() + 1).padStart(2, '0');
    const dd = String(hoy.getDate()).padStart(2, '0');
    return `${yyyy}-${mm}-${dd}`;
  }

  private getRangoMesActual(): { desdeMes: string; hastaMes: string } {
    const hoy = new Date();
    const yyyy = hoy.getFullYear();
    const mesIndex = hoy.getMonth();
    const mm = String(mesIndex + 1).padStart(2, '0');
    const desdeMes = `${yyyy}-${mm}-01`;
    const ultimoDia = new Date(yyyy, mesIndex + 1, 0).getDate();
    const hastaMes = `${yyyy}-${mm}-${String(ultimoDia).padStart(2, '0')}`;
    return { desdeMes, hastaMes };
  }

  private esComboProducto(prod: any): boolean {
    const nombre = this.normalizarTexto(prod?.nombre);
    const categoria = this.normalizarTexto(prod?.categoria_nombre);
    return nombre.includes('combo') || categoria.includes('combo');
  }

  esSmoothieProducto(prod: any): boolean {
    const nombre = this.normalizarTexto(prod?.nombre);
    const categoria = this.normalizarTexto(prod?.categoria_nombre);
    return nombre.includes('smoothie') || categoria.includes('smoothie');
  }

  private esPanYucaProducto(prod: any): boolean {
    const nombre = this.normalizarTexto(prod?.nombre);
    const categoria = this.normalizarTexto(prod?.categoria_nombre);
    return nombre.includes('pan de yuca') || nombre.includes('panes de yuca') || categoria.includes('pan de yuca') || categoria.includes('panes de yuca');
  }

  private obtenerProductoPorId(id: number | null): any | null {
    if (!id) return null;
    return this.productos.find((p) => Number(p.id) === Number(id)) || null;
  }

  private obtenerPrecioCombo(tipo: 'PERSONAL' | 'DUO'): number {
    const nombre = tipo === 'PERSONAL' ? 'combo personal' : 'combo dúo';
    const encontrado = this.productos.find((p) => this.normalizarTexto(p?.nombre).includes(nombre));
    return Number(encontrado?.precio || 0);
  }

  getSeleccionIndex(prod: any): number {
    return this.comboSmoothiesSeleccionados.findIndex((p) => p.id === prod?.id);
  }

  crearInsumo() {
    if (!this.nuevoInsumo.nombre || !this.nuevoInsumo.unidad_medida) return;
    this.api.crearInsumo(this.nuevoInsumo).subscribe({
      next: () => {
        this.nuevoInsumo = { nombre: '', stock_actual: 0, unidad_medida: 'UND', stock_minimo: 0 };
        this.cargarInventario();
        this.postActionRefresh();
      },
      error: () => {
        this.errorInventario = 'No se pudo crear el insumo.';
      }
    });
  }

  eliminarInsumo(id: number) {
    this.api.eliminarInsumo(id).subscribe({
      next: () => {
        if (this.editandoInsumo?.id === id) {
          this.editandoInsumo = null;
        }
        this.cargarInventario();
        this.postActionRefresh();
      },
      error: () => {
        this.errorInventario = 'No se pudo eliminar el insumo.';
      }
    });
  }

  abrirEditarInsumo(insumo: any) {
    this.editandoInsumo = { ...insumo };
  }

  cancelarEditarInsumo() {
    this.editandoInsumo = null;
  }

  guardarEditarInsumo() {
    if (!this.editandoInsumo?.nombre || !this.editandoInsumo?.unidad_medida) return;
    const payload = {
      nombre: this.editandoInsumo.nombre,
      stock_actual: Number(this.editandoInsumo.stock_actual ?? 0),
      unidad_medida: this.editandoInsumo.unidad_medida,
      stock_minimo: Number(this.editandoInsumo.stock_minimo ?? 0)
    };
    this.api.actualizarInsumo(this.editandoInsumo.id, payload).subscribe({
      next: () => {
        this.editandoInsumo = null;
        this.cargarInventario();
        this.postActionRefresh();
      },
      error: () => {
        this.errorInventario = 'No se pudo actualizar el insumo.';
      }
    });
  }

  crearProducto() {
    if (!this.nuevoProducto.nombre || this.nuevoProducto.precio === undefined || this.nuevoProducto.precio === null) return;
    const payload = {
      ...this.nuevoProducto,
      id_categoria: this.nuevoProducto.id_categoria ? Number(this.nuevoProducto.id_categoria) : null,
      precio: Number(this.nuevoProducto.precio)
    };
    if (Number.isNaN(payload.precio)) {
      this.errorInventario = 'Precio inválido.';
      return;
    }
    this.api.crearProducto(payload).subscribe({
      next: (prod: any) => {
        if (this.nuevoProductoImagen && prod?.id) {
          this.api.subirImagenProducto(prod.id, this.nuevoProductoImagen).subscribe({
            next: () => this.cargarInventario(),
            error: (err) => { this.errorInventario = this.getErrorMessage(err, 'No se pudo subir la imagen.'); }
          });
        }
        this.nuevoProducto = { nombre: '', precio: 0, id_categoria: '', es_preparado: true, stock_actual: 0, unidad_medida: 'UND', stock_minimo: 0 };
        this.nuevoProductoImagen = null;
        this.cargarInventario();
        this.postActionRefresh();
      },
      error: (err) => {
        this.errorInventario = this.getErrorMessage(err, 'No se pudo crear el producto.');
      }
    });
  }

  eliminarProducto(id: number) {
    this.api.eliminarProducto(id).subscribe({
      next: () => {
        if (this.editandoProducto?.id === id) {
          this.editandoProducto = null;
          this.editandoProductoImagen = null;
        }
        this.cargarInventario();
        this.postActionRefresh();
      },
      error: () => {
        this.errorInventario = 'No se pudo eliminar el producto.';
      }
    });
  }

  abrirEditarProducto(prod: any) {
    this.editandoProducto = { ...prod, id_categoria: prod.id_categoria ?? '', unidad_medida: prod.unidad_medida || 'UND' };
    this.editandoProductoImagen = null;
  }

  cancelarEditarProducto() {
    this.editandoProducto = null;
    this.editandoProductoImagen = null;
  }

  guardarEditarProducto() {
    if (!this.editandoProducto?.nombre || this.editandoProducto?.precio === undefined) return;
    const payload = {
      nombre: this.editandoProducto.nombre,
      precio: Number(this.editandoProducto.precio),
      id_categoria: this.editandoProducto.id_categoria ? Number(this.editandoProducto.id_categoria) : null,
      es_preparado: this.editandoProducto.es_preparado === undefined ? true : Boolean(this.editandoProducto.es_preparado),
      stock_actual: Number(this.editandoProducto.stock_actual ?? 0),
      unidad_medida: String(this.editandoProducto.unidad_medida || 'UND'),
      stock_minimo: Number(this.editandoProducto.stock_minimo ?? 0)
    };
    if (Number.isNaN(payload.precio)) {
      this.errorInventario = 'Precio inválido.';
      return;
    }
    this.api.actualizarProducto(this.editandoProducto.id, payload).subscribe({
      next: () => {
        const id = this.editandoProducto.id;
        this.editandoProducto = null;
        if (this.editandoProductoImagen && id) {
          this.api.subirImagenProducto(id, this.editandoProductoImagen).subscribe({
            next: () => this.cargarInventario(),
            error: (err) => { this.errorInventario = this.getErrorMessage(err, 'No se pudo subir la imagen.'); }
          });
        } else {
          this.cargarInventario();
        }
        this.postActionRefresh();
      },
      error: (err) => {
        this.errorInventario = this.getErrorMessage(err, 'No se pudo actualizar el producto.');
      }
    });
  }

  onNuevoProductoImagen(event: Event) {
    const input = event.target as HTMLInputElement;
    this.nuevoProductoImagen = input.files && input.files.length ? input.files[0] : null;
  }

  onEditarProductoImagen(event: Event) {
    const input = event.target as HTMLInputElement;
    this.editandoProductoImagen = input.files && input.files.length ? input.files[0] : null;
  }

  descargarInventarioExcel() {
    const fecha = new Date().toISOString().slice(0, 10);
    window.open(`${this.api.getApiUrl()}/reportes/inventario?fecha=${fecha}`, '_blank');
  }

  descargarCajaExcel() {
    const fecha = new Date().toISOString().slice(0, 10);
    window.open(`${this.api.getApiUrl()}/reportes/caja?fecha=${fecha}`, '_blank');
  }

  registrarIngreso() {
    if (!this.ingresoForm.isValid()) return;
    this.api.crearMovimientoInventario(this.ingresoForm.toPayload('INGRESO', this.usuario?.nombre)).subscribe({
      next: () => {
        this.ingresoForm = new MovimientoInventarioForm();
        this.cargarInventario();
        this.cargarMovimientos();
        this.postActionRefresh();
      },
      error: (err) => {
        this.errorInventario = this.getErrorMessage(err, 'No se pudo registrar el ingreso.');
      }
    });
  }

  registrarEgreso() {
    if (!this.egresoForm.isValid()) return;
    this.api.crearMovimientoInventario(this.egresoForm.toPayload('EGRESO', this.usuario?.nombre)).subscribe({
      next: () => {
        this.egresoForm = new MovimientoInventarioForm();
        this.cargarInventario();
        this.cargarMovimientos();
        this.postActionRefresh();
      },
      error: (err) => {
        this.errorInventario = this.getErrorMessage(err, 'No se pudo registrar el egreso.');
      }
    });
  }

  registrarProduccion() {
    if (!this.produccionForm.isValid()) return;
    this.api.crearMovimientoInventario(this.produccionForm.toPayload(this.usuario?.nombre)).subscribe({
      next: () => {
        this.produccionForm = new ProduccionInventarioForm();
        this.cargarInventario();
        this.cargarMovimientos();
        this.postActionRefresh();
      },
      error: (err) => {
        this.errorInventario = this.getErrorMessage(err, 'No se pudo registrar la producción.');
      }
    });
  }

  registrarTransformacion() {
    if (!this.transformacionForm.isValid()) return;
    this.api.crearTransformacionInventario(this.transformacionForm.toPayload(this.usuario?.nombre)).subscribe({
      next: () => {
        this.transformacionForm = new TransformacionInventarioForm();
        this.cargarInventario();
        this.cargarMovimientos();
        this.postActionRefresh();
      },
      error: (err) => {
        this.errorInventario = this.getErrorMessage(err, 'No se pudo registrar la transformación.');
      }
    });
  }

  cargarMovimientos() {
    this.api.getMovimientosInventario(this.movimientosFiltro.toQuery()).subscribe({
      next: (data: any) => {
        this.movimientosItems = Array.isArray(data) ? data : [];
      },
      error: () => {
        this.errorInventario = 'No se pudieron cargar los movimientos.';
      }
    });
  }

  cargarKardex() {
    if (this.kardexTipo === 'productos') {
      const query = {
        productoId: this.kardexProductoId,
        desde: this.kardexFiltro.desde,
        hasta: this.kardexFiltro.hasta
      };
      this.api.getKardexProductos(query).subscribe({
        next: (data: any) => {
          this.kardexProductosItems = Array.isArray(data) ? data : [];
        },
        error: () => {
          this.errorInventario = 'No se pudo cargar el kardex de productos.';
        }
      });
      return;
    }

    this.api.getKardexInventario(this.kardexFiltro.toQuery()).subscribe({
      next: (data: any) => {
        this.kardexItems = Array.isArray(data) ? data : [];
      },
      error: () => {
        this.errorInventario = 'No se pudo cargar el kardex.';
      }
    });
  }

  private getErrorMessage(err: any, fallback: string): string {
    const message = err?.error?.error || err?.message || fallback;
    const lower = String(message || '').toLowerCase();
    if (lower.includes('stock insuficiente') || lower.includes('insumo faltante') || lower.includes('no se encontró crema')) {
      this.advertenciaStock = String(message || 'Stock insuficiente');
    }
    return message;
  }

  getUploadUrl(path: string | null | undefined): string {
    if (!path) return '';
    const base = this.api.getApiUrl().replace('/api', '');
    return `${base}${path}`;
  }

  logout() {
    this.auth.clearSession();
    this.router.navigate(['/login']);
  }

  // ===================== FACTURACIÓN =====================

  cargarFacturas() {
    this.cargandoFacturas = true;
    this.errorFacturas = '';
    this.api.getFacturas(this.facturasFiltro).subscribe({
      next: (data: any) => {
        this.facturas = Array.isArray(data) ? data : [];
        this.cargandoFacturas = false;
      },
      error: () => {
        this.errorFacturas = 'No se pudieron cargar las facturas.';
        this.cargandoFacturas = false;
      }
    });
  }

  buscarFacturas() {
    this.cargarFacturas();
  }

  limpiarFiltroFacturas() {
    this.facturasFiltro = { estado: '', buscar: '', desde: '', hasta: '' };
    this.cargarFacturas();
  }

  verFacturaDetalle(factura: any) {
    this.facturaDetalle = factura;
  }

  cerrarFacturaDetalle() {
    this.facturaDetalle = null;
  }

  abrirEditarFactura(factura: any) {
    this.facturaEditando = factura;
    this.facturaEditForm = {
      cliente_nombre: factura.cliente_nombre || '',
      cliente_identificacion: factura.cliente_identificacion || '',
      cliente_direccion: factura.cliente_direccion || '',
      cliente_telefono: factura.cliente_telefono || '',
      cliente_email: factura.cliente_email || '',
      notas: factura.notas || '',
      tipo: factura.tipo || 'RECIBO'
    };
  }

  cerrarEditarFactura() {
    this.facturaEditando = null;
    this.errorFacturas = '';
  }

  guardarFactura() {
    if (!this.facturaEditando?.id) return;
    this.errorFacturas = '';
    this.api.actualizarFactura(this.facturaEditando.id, this.facturaEditForm).subscribe({
      next: () => {
        this.cerrarEditarFactura();
        this.cargarFacturas();
      },
      error: () => {
        this.errorFacturas = 'No se pudo actualizar la factura.';
      }
    });
  }

  abrirAnularFactura(factura: any) {
    this.facturaAnulandoId = factura.id;
    this.facturaAnularMotivo = '';
  }

  cerrarAnularFactura() {
    this.facturaAnulandoId = null;
    this.facturaAnularMotivo = '';
  }

  confirmarAnularFactura() {
    if (!this.facturaAnulandoId || !this.facturaAnularMotivo.trim()) {
      this.errorFacturas = 'Ingresa el motivo de anulación.';
      return;
    }
    this.api.anularFactura(this.facturaAnulandoId, {
      motivo: this.facturaAnularMotivo,
      usuario: this.usuario?.nombre || ''
    }).subscribe({
      next: () => {
        this.cerrarAnularFactura();
        this.cargarFacturas();
      },
      error: () => {
        this.errorFacturas = 'No se pudo anular la factura.';
      }
    });
  }

  // ===================== IMPRESIÓN DE FACTURAS =====================

  cargarConfigImpresora() {
    this.api.getConfigImpresora().subscribe({
      next: (data: any) => {
        if (data) {
          this.configImpresora = {
            nombre_impresora: data.nombre_impresora || '',
            tipo: data.tipo || 'TERMICA',
            ancho_mm: data.ancho_mm || 80,
            auto_imprimir: Boolean(data.auto_imprimir)
          };
        }
      }
    });
    this.api.getFacturaSecuencia().subscribe({
      next: (data: any) => {
        if (data) {
          this.facturaSecuencia = { prefijo: data.prefijo || 'REC', siguiente: data.siguiente || 1 };
        }
      }
    });
  }

  abrirConfigImpresora() {
    this.configImpresoraAbierto = true;
    this.errorConfigImpresora = '';
    this.cargarConfigImpresora();
  }

  cerrarConfigImpresora() {
    this.configImpresoraAbierto = false;
    this.errorConfigImpresora = '';
  }

  guardarConfigImpresora() {
    this.errorConfigImpresora = '';
    this.api.guardarConfigImpresora(this.configImpresora).subscribe({
      next: () => {
        this.api.actualizarFacturaSecuencia(this.facturaSecuencia).subscribe({
          next: () => {
            this.cerrarConfigImpresora();
          },
          error: () => {
            this.errorConfigImpresora = 'Error guardando secuencia.';
          }
        });
      },
      error: () => {
        this.errorConfigImpresora = 'Error guardando configuración impresora.';
      }
    });
  }

  private async cargarLogoBase64() {
    try {
      const w = window as any;
      if (w.reysoft?.getLogoBase64) {
        this.logoBase64 = await w.reysoft.getLogoBase64();
      } else {
        // Fallback: cargar desde assets vía fetch
        const resp = await fetch('assets/coco.jpg');
        const blob = await resp.blob();
        this.logoBase64 = await new Promise<string>((resolve) => {
          const reader = new FileReader();
          reader.onloadend = () => resolve(reader.result as string);
          reader.readAsDataURL(blob);
        });
      }
    } catch {
      this.logoBase64 = '';
    }
  }

  imprimirFactura(factura: any) {
    if (!factura) return;
    this.imprimiendoFactura = true;
    const html = this.generarHtmlFactura(factura);
    const w = window as any;

    if (w.reysoft?.printSilent) {
      // Electron: impresión silenciosa sin diálogo
      w.reysoft.printSilent(html).then((result: any) => {
        if (result?.success) {
          this.api.marcarFacturaImpresa(factura.id).subscribe();
        }
        this.imprimiendoFactura = false;
        this.cdr.detectChanges();
      }).catch(() => {
        this.imprimiendoFactura = false;
        this.cdr.detectChanges();
      });
    } else {
      // Navegador: fallback con ventana emergente
      const ventana = window.open('', '_blank', 'width=400,height=700');
      if (ventana) {
        ventana.document.write(html);
        ventana.document.close();
        ventana.focus();
        setTimeout(() => {
          ventana.print();
          this.api.marcarFacturaImpresa(factura.id).subscribe();
          this.imprimiendoFactura = false;
        }, 400);
      } else {
        this.imprimiendoFactura = false;
        this.errorFacturas = 'No se pudo abrir ventana de impresión.';
      }
    }
  }

  imprimirDesdeVenta(ventaId: number) {
    this.api.getFacturas({ buscar: '' }).subscribe({
      next: (facturas: any[]) => {
        const factura = facturas.find((f: any) => f.venta_id === ventaId && f.estado !== 'ANULADA');
        if (factura) {
          this.imprimirFactura(factura);
        } else {
          this.errorPago = 'No se encontró factura para esta venta.';
        }
      }
    });
  }

  private generarHtmlFactura(factura: any): string {
    const items = Array.isArray(factura.items) ? factura.items : [];
    const fecha = new Date(factura.fecha);
    const fechaStr = fecha.toLocaleDateString('es-EC', {
      year: 'numeric', month: '2-digit', day: '2-digit'
    });
    const horaStr = fecha.toLocaleTimeString('es-EC', {
      hour: '2-digit', minute: '2-digit'
    });

    const itemsHtml = items.map((i: any) =>
      `<tr>
        <td style="text-align:left;padding:3px 0">${i.nombre}</td>
        <td style="text-align:center">${Number(i.cantidad || 0)}</td>
        <td style="text-align:right">$${Number(i.precio_unitario || 0).toFixed(2)}</td>
        <td style="text-align:right">$${Number(i.subtotal || 0).toFixed(2)}</td>
      </tr>`
    ).join('');

    const esAnulada = factura.estado === 'ANULADA';
    const anuladaHtml = esAnulada
      ? `<div style="color:#dc2626;font-weight:bold;text-align:center;border:2px solid #dc2626;padding:6px;margin:8px 0;border-radius:6px">*** ANULADA ***</div>`
      : '';

    const logoHtml = this.logoBase64
      ? `<div class="center" style="margin-bottom:6px"><img src="${this.logoBase64}" style="width:60px;height:60px;border-radius:50%;object-fit:cover" /></div>`
      : '';

    return `<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Factura ${factura.numero}</title>
<style>
  @page { margin: 5mm; }
  body { font-family: 'Courier New', monospace; font-size: 12px; width: 72mm; margin: 0 auto; color: #111; }
  .center { text-align: center; }
  .bold { font-weight: bold; }
  .divider { border-top: 1px dashed #999; margin: 6px 0; }
  table { width: 100%; border-collapse: collapse; }
  th { text-align: left; border-bottom: 1px solid #333; padding: 3px 0; font-size: 11px; }
  .total-row td { font-weight: bold; padding-top: 4px; }
</style>
</head>
<body>
  ${logoHtml}
  <div class="center bold" style="font-size:16px;margin-bottom:2px">${this.empresaInfo.nombre}</div>
  <div class="center" style="font-size:10px;margin-bottom:4px">${this.empresaInfo.lema}</div>
  <div class="center" style="font-size:10px">RUC: ${this.empresaInfo.ruc}</div>
  <div class="center" style="font-size:10px">${this.empresaInfo.direccion}</div>
  <div class="center" style="font-size:10px">Tel: ${this.empresaInfo.telefono}</div>
  <div class="center" style="font-size:10px">${this.empresaInfo.email}</div>
  <div class="divider"></div>
  <div class="center bold" style="font-size:13px">${factura.tipo === 'FACTURA' ? 'FACTURA ELECTRÓNICA' : 'RECIBO DE VENTA'}</div>
  <div class="center bold" style="margin-bottom:4px">${factura.numero}</div>
  ${anuladaHtml}
  <div class="divider"></div>
  <div><strong>Fecha:</strong> ${fechaStr} ${horaStr}</div>
  <div><strong>Cliente:</strong> ${factura.cliente_nombre || 'Consumidor Final'}</div>
  <div><strong>RUC/CI:</strong> ${factura.cliente_identificacion || '9999999999999'}</div>
  ${factura.cliente_direccion ? `<div><strong>Dir:</strong> ${factura.cliente_direccion}</div>` : ''}
  ${factura.cliente_telefono ? `<div><strong>Tel:</strong> ${factura.cliente_telefono}</div>` : ''}
  <div class="divider"></div>
  <table>
    <thead><tr><th>Desc.</th><th style="text-align:center">Cant</th><th style="text-align:right">P.U.</th><th style="text-align:right">Total</th></tr></thead>
    <tbody>
      ${itemsHtml}
    </tbody>
  </table>
  <div class="divider"></div>
  <table>
    <tr><td>Subtotal</td><td style="text-align:right">$${Number(factura.subtotal || 0).toFixed(2)}</td></tr>
    <tr><td>IVA (${Number(factura.impuesto_pct || 0)}%)</td><td style="text-align:right">$${Number(factura.impuesto_monto || 0).toFixed(2)}</td></tr>
    <tr class="total-row"><td style="font-size:14px">TOTAL</td><td style="text-align:right;font-size:14px">$${Number(factura.total || 0).toFixed(2)}</td></tr>
  </table>
  <div class="divider"></div>
  <div><strong>Pago:</strong> ${factura.metodo_pago || '-'}</div>
  ${factura.notas ? `<div style="font-size:10px;margin-top:4px"><strong>Notas:</strong> ${factura.notas}</div>` : ''}
  <div class="divider"></div>
  <div class="center" style="font-size:10px;margin-top:6px">¡Gracias por su compra!</div>
  <div class="center" style="font-size:9px;color:#888">Documento generado por sistema Coco & Caña</div>
  ${factura.usuario ? `<div class="center" style="font-size:9px;color:#999;margin-top:2px">Atendido por: ${factura.usuario}</div>` : ''}
</body>
</html>`;
  }

  // ========== SINCRONIZACIÓN ==========
  cargarSyncConfig() {
    this.api.getSyncConfig().subscribe({
      next: (cfg: any) => {
        this.syncConfig = cfg;
        this.syncBackupFolder = cfg.backupFolderResolved || '';
      },
      error: () => this.syncError = 'Error al cargar configuración de sync'
    });
  }

  cargarSyncBackups() {
    this.api.listarBackups().subscribe({
      next: (data: any) => {
        this.syncBackups = data.backups || [];
        this.syncBackupFolder = data.folder || this.syncBackupFolder;
      },
      error: () => this.syncError = 'Error al cargar backups'
    });
  }

  crearBackupManual() {
    this.syncCargando = true;
    this.syncMensaje = '';
    this.syncError = '';
    this.api.crearBackup().subscribe({
      next: (res: any) => {
        this.syncCargando = false;
        this.syncMensaje = `✅ Backup creado: ${res.fileName} (${this.formatBytes(res.size)})`;
        this.cargarSyncBackups();
      },
      error: (err: any) => {
        this.syncCargando = false;
        this.syncError = err?.error?.error || 'Error al crear backup';
      }
    });
  }

  restaurarDesdeArchivo(event: any) {
    const file = event?.target?.files?.[0];
    if (!file) return;
    if (!file.name.endsWith('.sql')) {
      this.syncError = 'Solo se permiten archivos .sql';
      return;
    }
    if (!confirm('⚠️ ADVERTENCIA: Esto reemplazará TODOS los datos actuales con los del backup. ¿Estás seguro?')) return;
    this.syncRestaurando = true;
    this.syncMensaje = '';
    this.syncError = '';
    this.api.restaurarBackupArchivo(file).subscribe({
      next: (res: any) => {
        this.syncRestaurando = false;
        this.syncMensaje = '✅ ' + (res.message || 'Restauración completada');
        alert('Base de datos restaurada. La app se recargará.');
        window.location.reload();
      },
      error: (err: any) => {
        this.syncRestaurando = false;
        this.syncError = err?.error?.error || 'Error al restaurar';
      }
    });
    event.target.value = '';
  }

  restaurarDesdeNombre(nombre: string) {
    if (!confirm('⚠️ ADVERTENCIA: Esto reemplazará TODOS los datos actuales con los del backup seleccionado. ¿Continuar?')) return;
    this.syncRestaurando = true;
    this.syncMensaje = '';
    this.syncError = '';
    this.api.restaurarBackupNombre(nombre).subscribe({
      next: (res: any) => {
        this.syncRestaurando = false;
        this.syncMensaje = '✅ ' + (res.message || 'Restauración completada');
        alert('Base de datos restaurada. La app se recargará.');
        window.location.reload();
      },
      error: (err: any) => {
        this.syncRestaurando = false;
        this.syncError = err?.error?.error || 'Error al restaurar';
      }
    });
  }

  eliminarBackupSync(nombre: string) {
    if (!confirm(`¿Eliminar el backup "${nombre}"?`)) return;
    this.api.eliminarBackup(nombre).subscribe({
      next: () => this.cargarSyncBackups(),
      error: () => this.syncError = 'Error al eliminar backup'
    });
  }

  toggleAutoBackup() {
    this.syncConfig.autoBackup = !this.syncConfig.autoBackup;
    this.api.guardarSyncConfig({ autoBackup: this.syncConfig.autoBackup }).subscribe({
      next: () => this.syncMensaje = this.syncConfig.autoBackup ? 'Auto-backup activado' : 'Auto-backup desactivado',
      error: () => this.syncError = 'Error al guardar configuración'
    });
  }

  guardarSyncFolder() {
    if (!this.syncBackupFolder) return;
    this.api.guardarSyncConfig({ backupFolder: this.syncBackupFolder }).subscribe({
      next: () => {
        this.syncMensaje = 'Carpeta de backup actualizada';
        this.cargarSyncConfig();
        this.cargarSyncBackups();
      },
      error: () => this.syncError = 'Error al guardar carpeta'
    });
  }

  formatBytes(bytes: number): string {
    if (!bytes) return '0 B';
    if (bytes < 1024) return bytes + ' B';
    if (bytes < 1048576) return (bytes / 1024).toFixed(1) + ' KB';
    return (bytes / 1048576).toFixed(1) + ' MB';
  }

  formatFechaBackup(fecha: string): string {
    return new Date(fecha).toLocaleString('es-ES', {
      day: '2-digit', month: '2-digit', year: 'numeric',
      hour: '2-digit', minute: '2-digit'
    });
  }
}