export type TipoMovimientoInventario = 'INGRESO' | 'EGRESO' | 'PRODUCCION' | 'TRANSFORMACION_ENTRADA' | 'TRANSFORMACION_SALIDA';

export interface InsumoItem {
  id: number;
  nombre: string;
  unidad_medida: string;
  stock_actual: number;
  stock_minimo: number;
}

export interface MovimientoInventarioItem {
  id: number;
  insumo_id: number;
  insumo_nombre: string;
  tipo: TipoMovimientoInventario;
  cantidad: number;
  unidad_medida: string;
  motivo?: string;
  referencia?: string;
  usuario?: string;
  fecha: string;
  saldo?: number;
}

export class MovimientoInventarioForm {
  constructor(
    public insumoId: number | null = null,
    public cantidad: number | null = null,
    public motivo: string = '',
    public referencia: string = ''
  ) {}

  isValid(): boolean {
    return !!this.insumoId && this.cantidad !== null && this.cantidad > 0;
  }

  toPayload(tipo: TipoMovimientoInventario, usuario?: string): any {
    return {
      insumo_id: this.insumoId,
      tipo,
      cantidad: Number(this.cantidad),
      motivo: this.motivo?.trim() || null,
      referencia: this.referencia?.trim() || null,
      usuario: usuario?.trim() || null
    };
  }
}

export class ProduccionInventarioForm {
  constructor(
    public insumoId: number | null = null,
    public cantidad: number | null = null,
    public producto: string = '',
    public observacion: string = ''
  ) {}

  isValid(): boolean {
    return !!this.insumoId && this.cantidad !== null && this.cantidad > 0;
  }

  toPayload(usuario?: string): any {
    const referencia = this.producto?.trim();
    const motivo = this.observacion?.trim();
    return {
      insumo_id: this.insumoId,
      tipo: 'PRODUCCION',
      cantidad: Number(this.cantidad),
      motivo: motivo || null,
      referencia: referencia || null,
      usuario: usuario?.trim() || null
    };
  }
}

export class TransformacionInventarioForm {
  constructor(
    public insumoOrigenId: number | null = null,
    public insumoDestinoId: number | null = null,
    public cantidadOrigen: number | null = null,
    public cantidadDestino: number | null = null,
    public motivo: string = '',
    public referencia: string = ''
  ) {}

  isValid(): boolean {
    return !!this.insumoOrigenId && !!this.insumoDestinoId
      && this.insumoOrigenId !== this.insumoDestinoId
      && this.cantidadOrigen !== null && this.cantidadOrigen > 0
      && this.cantidadDestino !== null && this.cantidadDestino > 0;
  }

  toPayload(usuario?: string): any {
    return {
      insumo_origen_id: this.insumoOrigenId,
      insumo_destino_id: this.insumoDestinoId,
      cantidad_origen: Number(this.cantidadOrigen),
      cantidad_destino: Number(this.cantidadDestino),
      motivo: this.motivo?.trim() || null,
      referencia: this.referencia?.trim() || null,
      usuario: usuario?.trim() || null
    };
  }
}

export class KardexFiltro {
  constructor(
    public insumoId: number | null = null,
    public desde: string = '',
    public hasta: string = ''
  ) {}

  toQuery(): any {
    return {
      insumoId: this.insumoId || undefined,
      desde: this.desde || undefined,
      hasta: this.hasta || undefined
    };
  }
}

export class MovimientosFiltro {
  constructor(
    public insumoId: number | null = null,
    public tipo: string = '',
    public desde: string = '',
    public hasta: string = ''
  ) {}

  toQuery(): any {
    return {
      insumoId: this.insumoId || undefined,
      tipo: this.tipo || undefined,
      desde: this.desde || undefined,
      hasta: this.hasta || undefined
    };
  }
}
