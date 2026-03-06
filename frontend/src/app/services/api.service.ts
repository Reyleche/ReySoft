import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { tap, catchError } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private static readonly SERVER_BASE_KEY = 'reysoft_server_base';

  private normalizeServerBase(input: string): string {
    let value = String(input || '').trim();
    if (!value) return 'http://localhost:3000';
    if (!/^https?:\/\//i.test(value)) {
      value = `http://${value}`;
    }
    value = value.replace(/\/+$/, '');
    // Si no trae puerto, asumimos 3000 (backend)
    try {
      const u = new URL(value);
      if (!u.port) {
        u.port = '3000';
      }
      return u.toString().replace(/\/+$/, '');
    } catch {
      return 'http://localhost:3000';
    }
  }

  getServerBase(): string {
    const saved = typeof window !== 'undefined' ? window.localStorage.getItem(ApiService.SERVER_BASE_KEY) : null;
    return this.normalizeServerBase(saved || 'http://localhost:3000');
  }

  setServerBase(input: string): void {
    const normalized = this.normalizeServerBase(input);
    if (typeof window !== 'undefined') {
      window.localStorage.setItem(ApiService.SERVER_BASE_KEY, normalized);
    }
    // Si cambia servidor, invalidamos cachés
    this.usuariosCache = [];
  }

  private get apiUrl(): string {
    return `${this.getServerBase()}/api`;
  }
  
  // AQUÍ ESTÁ EL TRUCO: Una variable para recordar los usuarios
  private usuariosCache: any[] = [];

  constructor(private http: HttpClient) { }

  getUsuarios(): Observable<any> {
    // 1. Si ya tenemos usuarios en memoria, ¡devuélvelos ya! (Velocidad Luz)
    if (this.usuariosCache.length > 0) {
      console.log('⚡ Usando caché de memoria para usuarios');
      return of(this.usuariosCache);
    }

    // 2. Si no, búscalos en el servidor y guárdalos
    return this.http.get(`${this.apiUrl}/usuarios`).pipe(
      tap((data: any) => {
        console.log('📡 Datos traídos de internet y guardados en caché');
        this.usuariosCache = data;
      }),
      catchError(error => {
        console.error('Error obteniendo usuarios', error);
        return of([]); // Devuelve array vacío para que no explote la app
      })
    );
  }

  // Clientes
  getClientes(): Observable<any> {
    return this.http.get(`${this.apiUrl}/clientes`);
  }

  crearCliente(payload: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/clientes`, payload);
  }

  actualizarCliente(id: number, payload: any): Observable<any> {
    return this.http.put(`${this.apiUrl}/clientes/${id}`, payload);
  }

  eliminarCliente(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/clientes/${id}`);
  }

  // Login normal
  login(idUsuario: number | string, pin: string, nombre?: string): Observable<any> {
    return this.http.post(`${this.apiUrl}/login`, { id_usuario: idUsuario, pin, nombre });
  }

  // Inventario - Insumos
  getInsumos(): Observable<any> {
    return this.http.get(`${this.apiUrl}/insumos`);
  }

  crearInsumo(payload: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/insumos`, payload);
  }

  eliminarInsumo(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/insumos/${id}`);
  }

  actualizarInsumo(id: number, payload: any): Observable<any> {
    return this.http.put(`${this.apiUrl}/insumos/${id}`, payload);
  }

  // Catálogo
  getCategorias(): Observable<any> {
    return this.http.get(`${this.apiUrl}/categorias`);
  }

  // Productos
  getProductos(): Observable<any> {
    return this.http.get(`${this.apiUrl}/productos`);
  }

  crearProducto(payload: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/productos`, payload);
  }

  eliminarProducto(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/productos/${id}`);
  }

  actualizarProducto(id: number, payload: any): Observable<any> {
    return this.http.put(`${this.apiUrl}/productos/${id}`, payload);
  }

  subirImagenProducto(id: number, file: File): Observable<any> {
    const formData = new FormData();
    formData.append('imagen', file);
    return this.http.post(`${this.apiUrl}/productos/${id}/imagen`, formData);
  }

  // Movimientos de Inventario
  crearMovimientoInventario(payload: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/inventario/movimientos`, payload);
  }

  crearTransformacionInventario(payload: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/inventario/transformacion`, payload);
  }

  getMovimientosInventario(query: any = {}): Observable<any> {
    let params = new HttpParams();
    Object.entries(query).forEach(([key, value]) => {
      if (value !== undefined && value !== null && value !== '') {
        params = params.set(key, String(value));
      }
    });
    return this.http.get(`${this.apiUrl}/inventario/movimientos`, { params });
  }

  getKardexInventario(query: any = {}): Observable<any> {
    let params = new HttpParams();
    Object.entries(query).forEach(([key, value]) => {
      if (value !== undefined && value !== null && value !== '') {
        params = params.set(key, String(value));
      }
    });
    return this.http.get(`${this.apiUrl}/inventario/kardex`, { params });
  }

  getKardexProductos(query: any = {}): Observable<any> {
    let params = new HttpParams();
    Object.entries(query).forEach(([key, value]) => {
      if (value !== undefined && value !== null && value !== '') {
        params = params.set(key, String(value));
      }
    });
    return this.http.get(`${this.apiUrl}/productos/kardex`, { params });
  }

  // Ventas
  getVentas(query: any = {}): Observable<any> {
    let params = new HttpParams();
    Object.entries(query).forEach(([key, value]) => {
      if (value !== undefined && value !== null && value !== '') {
        params = params.set(key, String(value));
      }
    });
    return this.http.get(`${this.apiUrl}/ventas`, { params });
  }

  crearVenta(payload: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/ventas`, payload);
  }

  actualizarVenta(id: number, payload: any): Observable<any> {
    return this.http.put(`${this.apiUrl}/ventas/${id}`, payload);
  }

  cobrarCredito(id: number, payload: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/ventas/${id}/cobrar-credito`, payload);
  }

  // Caja
  getCajaEstado(): Observable<any> {
    return this.http.get(`${this.apiUrl}/caja/estado`);
  }

  getCajaHistorial(limit: number = 20): Observable<any> {
    let params = new HttpParams();
    if (limit) {
      params = params.set('limit', String(limit));
    }
    return this.http.get(`${this.apiUrl}/caja/historial`, { params });
  }

  getCajaHistorialMovimientos(query: any = {}): Observable<any> {
    let params = new HttpParams();
    Object.entries(query).forEach(([key, value]) => {
      if (value !== undefined && value !== null && value !== '') {
        params = params.set(key, String(value));
      }
    });
    return this.http.get(`${this.apiUrl}/caja/historial/movimientos`, { params });
  }

  getCajaCierres(query: any = {}): Observable<any> {
    let params = new HttpParams();
    Object.entries(query).forEach(([key, value]) => {
      if (value !== undefined && value !== null && value !== '') {
        params = params.set(key, String(value));
      }
    });
    return this.http.get(`${this.apiUrl}/caja/cierres`, { params });
  }

  getVentaById(id: number): Observable<any> {
    return this.http.get(`${this.apiUrl}/ventas/${id}`);
  }

  abrirCaja(payload: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/caja/abrir`, payload);
  }

  cerrarCaja(payload: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/caja/cerrar`, payload);
  }

  actualizarSaldoInicialCaja(payload: any): Observable<any> {
    return this.http.put(`${this.apiUrl}/caja/saldo-inicial`, payload);
  }

  crearMovimientoCaja(payload: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/caja/movimientos`, payload);
  }

  actualizarMovimientoCaja(id: number, payload: any): Observable<any> {
    return this.http.put(`${this.apiUrl}/caja/movimientos/${id}`, payload);
  }

  eliminarMovimientoCaja(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/caja/movimientos/${id}`);
  }

  // Bodega
  getBodegaInsumos(): Observable<any> {
    return this.http.get(`${this.apiUrl}/bodega/insumos`);
  }

  crearBodegaInsumo(payload: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/bodega/insumos`, payload);
  }

  actualizarBodegaInsumo(id: number, payload: any): Observable<any> {
    return this.http.put(`${this.apiUrl}/bodega/insumos/${id}`, payload);
  }

  eliminarBodegaInsumo(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/bodega/insumos/${id}`);
  }

  getBodegaProductos(): Observable<any> {
    return this.http.get(`${this.apiUrl}/bodega/productos`);
  }

  crearBodegaProducto(payload: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/bodega/productos`, payload);
  }

  actualizarBodegaProducto(id: number, payload: any): Observable<any> {
    return this.http.put(`${this.apiUrl}/bodega/productos/${id}`, payload);
  }

  eliminarBodegaProducto(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/bodega/productos/${id}`);
  }

  transferirBodega(payload: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/bodega/transferir`, payload);
  }

  getApiUrl(): string {
    return this.apiUrl;
  }

  getDashboardResumenMes(query: any = {}): Observable<any> {
    let params = new HttpParams();
    Object.entries(query).forEach(([key, value]) => {
      if (value !== undefined && value !== null && value !== '') {
        params = params.set(key, String(value));
      }
    });
    return this.http.get(`${this.apiUrl}/dashboard/resumen-mes`, { params });
  }

  getDashboardAnalyticsExtra(): Observable<any> {
    return this.http.get(`${this.apiUrl}/dashboard/analytics-extra`);
  }

  getGastos(query: any = {}): Observable<any> {
    let params = new HttpParams();
    Object.entries(query).forEach(([key, value]) => {
      if (value !== undefined && value !== null && value !== '') {
        params = params.set(key, String(value));
      }
    });
    return this.http.get(`${this.apiUrl}/gastos`, { params });
  }

  crearGasto(payload: any, facturaFile?: File | null): Observable<any> {
    const formData = new FormData();
    Object.entries(payload || {}).forEach(([key, value]) => {
      if (value !== undefined && value !== null && value !== '') {
        formData.append(key, String(value));
      }
    });
    if (facturaFile) {
      formData.append('factura', facturaFile);
    }
    return this.http.post(`${this.apiUrl}/gastos`, formData);
  }

  actualizarGasto(id: number, payload: any, facturaFile?: File | null): Observable<any> {
    const formData = new FormData();
    Object.entries(payload || {}).forEach(([key, value]) => {
      if (value !== undefined && value !== null && value !== '') {
        formData.append(key, String(value));
      }
    });
    if (facturaFile) {
      formData.append('factura', facturaFile);
    }
    return this.http.put(`${this.apiUrl}/gastos/${id}`, formData);
  }

  eliminarGasto(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/gastos/${id}`);
  }

  getCajaChicaAhorros(query: any = {}): Observable<any> {
    let params = new HttpParams();
    Object.entries(query).forEach(([key, value]) => {
      if (value !== undefined && value !== null && value !== '') {
        params = params.set(key, String(value));
      }
    });
    return this.http.get(`${this.apiUrl}/caja-chica/ahorros`, { params });
  }

  crearCajaChicaAhorro(payload: any, comprobanteFile?: File | null): Observable<any> {
    const formData = new FormData();
    Object.entries(payload || {}).forEach(([key, value]) => {
      if (value !== undefined && value !== null && value !== '') {
        formData.append(key, String(value));
      }
    });
    if (comprobanteFile) {
      formData.append('comprobante', comprobanteFile);
    }
    return this.http.post(`${this.apiUrl}/caja-chica/ahorros`, formData);
  }

  eliminarCajaChicaAhorro(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/caja-chica/ahorros/${id}`);
  }

  getGastosSugerencias(): Observable<any> {
    return this.http.get(`${this.apiUrl}/gastos/sugerencias`);
  }

  getReporteData(query: any = {}): Observable<any> {
    let params = new HttpParams();
    Object.entries(query).forEach(([key, value]) => {
      if (value !== undefined && value !== null && value !== '') {
        params = params.set(key, String(value));
      }
    });
    return this.http.get(`${this.apiUrl}/reportes/data`, { params });
  }

  enviarReporteCorreo(payload: {
    to: string;
    subject: string;
    body?: string;
    fileName: string;
    pdfBase64: string;
  }): Observable<any> {
    return this.http.post(`${this.apiUrl}/reportes/enviar-email`, payload);
  }

  // Facturas
  getFacturas(query: any = {}): Observable<any> {
    let params = new HttpParams();
    Object.entries(query).forEach(([key, value]) => {
      if (value !== undefined && value !== null && value !== '') {
        params = params.set(key, String(value));
      }
    });
    return this.http.get(`${this.apiUrl}/facturas`, { params });
  }

  getFactura(id: number): Observable<any> {
    return this.http.get(`${this.apiUrl}/facturas/${id}`);
  }

  crearFactura(payload: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/facturas`, payload);
  }

  actualizarFactura(id: number, payload: any): Observable<any> {
    return this.http.put(`${this.apiUrl}/facturas/${id}`, payload);
  }

  anularFactura(id: number, payload: { motivo: string; usuario?: string }): Observable<any> {
    return this.http.post(`${this.apiUrl}/facturas/${id}/anular`, payload);
  }

  marcarFacturaImpresa(id: number): Observable<any> {
    return this.http.post(`${this.apiUrl}/facturas/${id}/marcar-impresa`, {});
  }

  // Config impresora
  getConfigImpresora(): Observable<any> {
    return this.http.get(`${this.apiUrl}/config/impresora`);
  }

  guardarConfigImpresora(payload: any): Observable<any> {
    return this.http.put(`${this.apiUrl}/config/impresora`, payload);
  }

  getFacturaSecuencia(): Observable<any> {
    return this.http.get(`${this.apiUrl}/config/factura-secuencia`);
  }

  actualizarFacturaSecuencia(payload: any): Observable<any> {
    return this.http.put(`${this.apiUrl}/config/factura-secuencia`, payload);
  }

  // ========== SINCRONIZACIÓN ==========
  getSyncConfig(): Observable<any> {
    return this.http.get(`${this.apiUrl}/sync/config`);
  }

  guardarSyncConfig(payload: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/sync/config`, payload);
  }

  crearBackup(): Observable<any> {
    // Preferimos backup completo (ZIP con fotos). Si el backend es viejo, caemos al .sql.
    return this.http.post(`${this.apiUrl}/sync/backup-full`, {}).pipe(
      catchError(() => this.http.post(`${this.apiUrl}/sync/backup`, {}))
    );
  }

  listarBackups(): Observable<any> {
    return this.http.get(`${this.apiUrl}/sync/backups`);
  }

  restaurarBackupArchivo(file: File): Observable<any> {
    const fd = new FormData();
    fd.append('archivo', file);
    return this.http.post(`${this.apiUrl}/sync/restaurar`, fd);
  }

  restaurarBackupNombre(fileName: string): Observable<any> {
    return this.http.post(`${this.apiUrl}/sync/restaurar`, { fileName });
  }

  eliminarBackup(nombre: string): Observable<any> {
    return this.http.delete(`${this.apiUrl}/sync/backup/${encodeURIComponent(nombre)}`);
  }
}