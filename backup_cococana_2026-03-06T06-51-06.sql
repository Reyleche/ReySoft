--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bodega_insumos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bodega_insumos (
    id integer NOT NULL,
    nombre character varying(120) NOT NULL,
    stock_actual numeric(12,3) DEFAULT 0 NOT NULL,
    unidad_medida character varying(20) NOT NULL,
    stock_minimo numeric(12,3) DEFAULT 0 NOT NULL
);


ALTER TABLE public.bodega_insumos OWNER TO postgres;

--
-- Name: bodega_insumos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bodega_insumos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bodega_insumos_id_seq OWNER TO postgres;

--
-- Name: bodega_insumos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bodega_insumos_id_seq OWNED BY public.bodega_insumos.id;


--
-- Name: bodega_movimientos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bodega_movimientos (
    id integer NOT NULL,
    insumo_id integer,
    tipo character varying(20) NOT NULL,
    cantidad numeric(12,3) NOT NULL,
    unidad_medida text NOT NULL,
    motivo text,
    referencia text,
    usuario text,
    fecha timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.bodega_movimientos OWNER TO postgres;

--
-- Name: bodega_movimientos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bodega_movimientos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bodega_movimientos_id_seq OWNER TO postgres;

--
-- Name: bodega_movimientos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bodega_movimientos_id_seq OWNED BY public.bodega_movimientos.id;


--
-- Name: bodega_productos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bodega_productos (
    id integer NOT NULL,
    nombre character varying(120) NOT NULL,
    precio numeric(12,2) DEFAULT 0 NOT NULL,
    id_categoria integer,
    es_preparado boolean DEFAULT true NOT NULL,
    image_url text
);


ALTER TABLE public.bodega_productos OWNER TO postgres;

--
-- Name: bodega_productos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bodega_productos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bodega_productos_id_seq OWNER TO postgres;

--
-- Name: bodega_productos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bodega_productos_id_seq OWNED BY public.bodega_productos.id;


--
-- Name: caja_chica_ahorros; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.caja_chica_ahorros (
    id integer NOT NULL,
    fecha date NOT NULL,
    monto numeric(12,2) NOT NULL,
    referencia text,
    usuario text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    comprobante_url text
);


ALTER TABLE public.caja_chica_ahorros OWNER TO postgres;

--
-- Name: caja_chica_ahorros_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.caja_chica_ahorros_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.caja_chica_ahorros_id_seq OWNER TO postgres;

--
-- Name: caja_chica_ahorros_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.caja_chica_ahorros_id_seq OWNED BY public.caja_chica_ahorros.id;


--
-- Name: caja_cierres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.caja_cierres (
    id integer NOT NULL,
    turno_id integer NOT NULL,
    resumen jsonb NOT NULL,
    ventas jsonb NOT NULL,
    movimientos jsonb NOT NULL,
    fecha_cierre timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.caja_cierres OWNER TO postgres;

--
-- Name: caja_cierres_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.caja_cierres_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.caja_cierres_id_seq OWNER TO postgres;

--
-- Name: caja_cierres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.caja_cierres_id_seq OWNED BY public.caja_cierres.id;


--
-- Name: caja_movimientos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.caja_movimientos (
    id integer NOT NULL,
    turno_id integer NOT NULL,
    tipo character varying(20) NOT NULL,
    metodo_pago character varying(30),
    monto numeric(12,2) NOT NULL,
    referencia text,
    usuario text,
    venta_id integer,
    fecha timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.caja_movimientos OWNER TO postgres;

--
-- Name: caja_movimientos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.caja_movimientos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.caja_movimientos_id_seq OWNER TO postgres;

--
-- Name: caja_movimientos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.caja_movimientos_id_seq OWNED BY public.caja_movimientos.id;


--
-- Name: caja_turnos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.caja_turnos (
    id integer NOT NULL,
    fecha_apertura timestamp without time zone DEFAULT now() NOT NULL,
    fecha_cierre timestamp without time zone,
    saldo_inicial numeric(12,2) DEFAULT 0 NOT NULL,
    saldo_final numeric(12,2),
    usuario_apertura text,
    usuario_cierre text,
    estado character varying(20) DEFAULT 'ABIERTA'::character varying NOT NULL
);


ALTER TABLE public.caja_turnos OWNER TO postgres;

--
-- Name: caja_turnos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.caja_turnos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.caja_turnos_id_seq OWNER TO postgres;

--
-- Name: caja_turnos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.caja_turnos_id_seq OWNED BY public.caja_turnos.id;


--
-- Name: categorias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categorias (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    icono character varying(50)
);


ALTER TABLE public.categorias OWNER TO postgres;

--
-- Name: categorias_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categorias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categorias_id_seq OWNER TO postgres;

--
-- Name: categorias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categorias_id_seq OWNED BY public.categorias.id;


--
-- Name: clientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientes (
    id integer NOT NULL,
    nombre character varying(120) NOT NULL,
    identificacion character varying(50),
    telefono character varying(50),
    email character varying(120),
    direccion text,
    notas text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.clientes OWNER TO postgres;

--
-- Name: clientes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clientes_id_seq OWNER TO postgres;

--
-- Name: clientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clientes_id_seq OWNED BY public.clientes.id;


--
-- Name: config_impresora; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.config_impresora (
    id integer NOT NULL,
    nombre_impresora text DEFAULT ''::text NOT NULL,
    tipo character varying(20) DEFAULT 'TERMICA'::character varying NOT NULL,
    ancho_mm integer DEFAULT 80 NOT NULL,
    auto_imprimir boolean DEFAULT false NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.config_impresora OWNER TO postgres;

--
-- Name: config_impresora_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.config_impresora_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.config_impresora_id_seq OWNER TO postgres;

--
-- Name: config_impresora_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.config_impresora_id_seq OWNED BY public.config_impresora.id;


--
-- Name: detalle_ventas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detalle_ventas (
    id integer NOT NULL,
    id_venta integer,
    id_producto integer,
    cantidad integer NOT NULL,
    precio_unitario numeric(10,2) NOT NULL,
    subtotal numeric(10,2) NOT NULL
);


ALTER TABLE public.detalle_ventas OWNER TO postgres;

--
-- Name: detalle_ventas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detalle_ventas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.detalle_ventas_id_seq OWNER TO postgres;

--
-- Name: detalle_ventas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detalle_ventas_id_seq OWNED BY public.detalle_ventas.id;


--
-- Name: facturas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.facturas (
    id integer NOT NULL,
    numero character varying(30) NOT NULL,
    venta_id integer,
    tipo character varying(20) DEFAULT 'RECIBO'::character varying NOT NULL,
    fecha timestamp without time zone DEFAULT now() NOT NULL,
    cliente_nombre character varying(200) DEFAULT 'Consumidor Final'::character varying NOT NULL,
    cliente_identificacion character varying(50) DEFAULT '9999999999999'::character varying,
    cliente_direccion text,
    cliente_telefono character varying(50),
    cliente_email character varying(120),
    subtotal numeric(12,2) DEFAULT 0 NOT NULL,
    impuesto_pct numeric(5,2) DEFAULT 0 NOT NULL,
    impuesto_monto numeric(12,2) DEFAULT 0 NOT NULL,
    total numeric(12,2) DEFAULT 0 NOT NULL,
    metodo_pago character varying(30),
    estado character varying(20) DEFAULT 'EMITIDA'::character varying NOT NULL,
    notas text,
    usuario text,
    anulada_motivo text,
    anulada_fecha timestamp without time zone,
    impresa boolean DEFAULT false NOT NULL
);


ALTER TABLE public.facturas OWNER TO postgres;

--
-- Name: facturas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.facturas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.facturas_id_seq OWNER TO postgres;

--
-- Name: facturas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.facturas_id_seq OWNED BY public.facturas.id;


--
-- Name: facturas_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.facturas_items (
    id integer NOT NULL,
    factura_id integer NOT NULL,
    producto_id integer,
    nombre text NOT NULL,
    cantidad numeric(12,2) NOT NULL,
    precio_unitario numeric(12,2) NOT NULL,
    subtotal numeric(12,2) NOT NULL
);


ALTER TABLE public.facturas_items OWNER TO postgres;

--
-- Name: facturas_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.facturas_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.facturas_items_id_seq OWNER TO postgres;

--
-- Name: facturas_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.facturas_items_id_seq OWNED BY public.facturas_items.id;


--
-- Name: facturas_secuencia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.facturas_secuencia (
    id integer NOT NULL,
    prefijo character varying(10) DEFAULT 'REC'::character varying NOT NULL,
    siguiente integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.facturas_secuencia OWNER TO postgres;

--
-- Name: facturas_secuencia_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.facturas_secuencia_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.facturas_secuencia_id_seq OWNER TO postgres;

--
-- Name: facturas_secuencia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.facturas_secuencia_id_seq OWNED BY public.facturas_secuencia.id;


--
-- Name: gastos_mensuales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gastos_mensuales (
    id integer NOT NULL,
    fecha date NOT NULL,
    descripcion text NOT NULL,
    monto numeric(12,2) NOT NULL,
    categoria character varying(80),
    caja_origen character varying(20) DEFAULT 'CAJA_LOCAL'::character varying NOT NULL,
    proveedor text,
    factura_url text,
    usuario text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.gastos_mensuales OWNER TO postgres;

--
-- Name: gastos_mensuales_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gastos_mensuales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.gastos_mensuales_id_seq OWNER TO postgres;

--
-- Name: gastos_mensuales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gastos_mensuales_id_seq OWNED BY public.gastos_mensuales.id;


--
-- Name: insumos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insumos (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    stock_actual numeric(10,3) DEFAULT 0,
    unidad_medida character varying(20) NOT NULL,
    stock_minimo numeric(10,3) DEFAULT 5
);


ALTER TABLE public.insumos OWNER TO postgres;

--
-- Name: insumos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.insumos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.insumos_id_seq OWNER TO postgres;

--
-- Name: insumos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.insumos_id_seq OWNED BY public.insumos.id;


--
-- Name: mesas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mesas (
    id integer NOT NULL,
    nombre character varying(20) NOT NULL,
    estado character varying(20) DEFAULT 'LIBRE'::character varying
);


ALTER TABLE public.mesas OWNER TO postgres;

--
-- Name: mesas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mesas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mesas_id_seq OWNER TO postgres;

--
-- Name: mesas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mesas_id_seq OWNED BY public.mesas.id;


--
-- Name: movimientos_inventario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movimientos_inventario (
    id integer NOT NULL,
    insumo_id integer NOT NULL,
    tipo character varying(30) NOT NULL,
    cantidad numeric(12,3) NOT NULL,
    unidad_medida text NOT NULL,
    motivo text,
    referencia text,
    usuario text,
    fecha timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.movimientos_inventario OWNER TO postgres;

--
-- Name: movimientos_inventario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movimientos_inventario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.movimientos_inventario_id_seq OWNER TO postgres;

--
-- Name: movimientos_inventario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movimientos_inventario_id_seq OWNED BY public.movimientos_inventario.id;


--
-- Name: productos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productos (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    precio numeric(10,2) NOT NULL,
    id_categoria integer,
    es_preparado boolean DEFAULT true,
    image_url text,
    stock_actual numeric(12,3) DEFAULT 0,
    unidad_medida character varying(20) DEFAULT 'UND'::character varying,
    stock_minimo numeric(12,3) DEFAULT 0
);


ALTER TABLE public.productos OWNER TO postgres;

--
-- Name: productos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.productos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.productos_id_seq OWNER TO postgres;

--
-- Name: productos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.productos_id_seq OWNED BY public.productos.id;


--
-- Name: recetas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recetas (
    id integer NOT NULL,
    id_producto integer,
    id_insumo integer,
    cantidad_requerida numeric(10,3) NOT NULL
);


ALTER TABLE public.recetas OWNER TO postgres;

--
-- Name: recetas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recetas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recetas_id_seq OWNER TO postgres;

--
-- Name: recetas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recetas_id_seq OWNED BY public.recetas.id;


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    pin_acceso character varying(4) NOT NULL,
    rol character varying(20) NOT NULL,
    activo boolean DEFAULT true
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_seq OWNER TO postgres;

--
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- Name: ventas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ventas (
    id integer NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    id_usuario integer,
    cliente_nombre character varying(100) DEFAULT 'Consumidor Final'::character varying,
    total numeric(10,2) NOT NULL,
    metodo_pago character varying(20) DEFAULT 'EFECTIVO'::character varying,
    tipo character varying(20),
    canal character varying(20) DEFAULT 'LOCAL'::character varying,
    mesa integer,
    estado character varying(20) DEFAULT 'ABIERTA'::character varying,
    notas text,
    usuario text,
    subtotal numeric(12,2) DEFAULT 0,
    impuesto_pct numeric(5,2) DEFAULT 0,
    impuesto_monto numeric(12,2) DEFAULT 0,
    cliente_id integer,
    credito_pagado boolean DEFAULT true,
    credito_metodo_pago character varying(30),
    credito_fecha_pago timestamp without time zone
);


ALTER TABLE public.ventas OWNER TO postgres;

--
-- Name: ventas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ventas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ventas_id_seq OWNER TO postgres;

--
-- Name: ventas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ventas_id_seq OWNED BY public.ventas.id;


--
-- Name: ventas_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ventas_items (
    id integer NOT NULL,
    venta_id integer NOT NULL,
    producto_id integer,
    nombre text NOT NULL,
    precio numeric(12,2) NOT NULL,
    cantidad numeric(12,2) NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    image_url text
);


ALTER TABLE public.ventas_items OWNER TO postgres;

--
-- Name: ventas_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ventas_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ventas_items_id_seq OWNER TO postgres;

--
-- Name: ventas_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ventas_items_id_seq OWNED BY public.ventas_items.id;


--
-- Name: bodega_insumos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bodega_insumos ALTER COLUMN id SET DEFAULT nextval('public.bodega_insumos_id_seq'::regclass);


--
-- Name: bodega_movimientos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bodega_movimientos ALTER COLUMN id SET DEFAULT nextval('public.bodega_movimientos_id_seq'::regclass);


--
-- Name: bodega_productos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bodega_productos ALTER COLUMN id SET DEFAULT nextval('public.bodega_productos_id_seq'::regclass);


--
-- Name: caja_chica_ahorros id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_chica_ahorros ALTER COLUMN id SET DEFAULT nextval('public.caja_chica_ahorros_id_seq'::regclass);


--
-- Name: caja_cierres id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_cierres ALTER COLUMN id SET DEFAULT nextval('public.caja_cierres_id_seq'::regclass);


--
-- Name: caja_movimientos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos ALTER COLUMN id SET DEFAULT nextval('public.caja_movimientos_id_seq'::regclass);


--
-- Name: caja_turnos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_turnos ALTER COLUMN id SET DEFAULT nextval('public.caja_turnos_id_seq'::regclass);


--
-- Name: categorias id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias ALTER COLUMN id SET DEFAULT nextval('public.categorias_id_seq'::regclass);


--
-- Name: clientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id SET DEFAULT nextval('public.clientes_id_seq'::regclass);


--
-- Name: config_impresora id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.config_impresora ALTER COLUMN id SET DEFAULT nextval('public.config_impresora_id_seq'::regclass);


--
-- Name: detalle_ventas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_ventas ALTER COLUMN id SET DEFAULT nextval('public.detalle_ventas_id_seq'::regclass);


--
-- Name: facturas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas ALTER COLUMN id SET DEFAULT nextval('public.facturas_id_seq'::regclass);


--
-- Name: facturas_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas_items ALTER COLUMN id SET DEFAULT nextval('public.facturas_items_id_seq'::regclass);


--
-- Name: facturas_secuencia id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas_secuencia ALTER COLUMN id SET DEFAULT nextval('public.facturas_secuencia_id_seq'::regclass);


--
-- Name: gastos_mensuales id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gastos_mensuales ALTER COLUMN id SET DEFAULT nextval('public.gastos_mensuales_id_seq'::regclass);


--
-- Name: insumos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insumos ALTER COLUMN id SET DEFAULT nextval('public.insumos_id_seq'::regclass);


--
-- Name: mesas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mesas ALTER COLUMN id SET DEFAULT nextval('public.mesas_id_seq'::regclass);


--
-- Name: movimientos_inventario id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimientos_inventario ALTER COLUMN id SET DEFAULT nextval('public.movimientos_inventario_id_seq'::regclass);


--
-- Name: productos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos ALTER COLUMN id SET DEFAULT nextval('public.productos_id_seq'::regclass);


--
-- Name: recetas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recetas ALTER COLUMN id SET DEFAULT nextval('public.recetas_id_seq'::regclass);


--
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- Name: ventas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas ALTER COLUMN id SET DEFAULT nextval('public.ventas_id_seq'::regclass);


--
-- Name: ventas_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas_items ALTER COLUMN id SET DEFAULT nextval('public.ventas_items_id_seq'::regclass);


--
-- Data for Name: bodega_insumos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bodega_insumos (id, nombre, stock_actual, unidad_medida, stock_minimo) FROM stdin;
\.


--
-- Data for Name: bodega_movimientos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bodega_movimientos (id, insumo_id, tipo, cantidad, unidad_medida, motivo, referencia, usuario, fecha) FROM stdin;
\.


--
-- Data for Name: bodega_productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bodega_productos (id, nombre, precio, id_categoria, es_preparado, image_url) FROM stdin;
\.


--
-- Data for Name: caja_chica_ahorros; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caja_chica_ahorros (id, fecha, monto, referencia, usuario, created_at, comprobante_url) FROM stdin;
1	2026-03-02	100.00	cuenta gye alex comprobante: 178677981	Rey	2026-03-04 20:23:37.593663	\N
\.


--
-- Data for Name: caja_cierres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caja_cierres (id, turno_id, resumen, ventas, movimientos, fecha_cierre) FROM stdin;
\.


--
-- Data for Name: caja_movimientos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caja_movimientos (id, turno_id, tipo, metodo_pago, monto, referencia, usuario, venta_id, fecha) FROM stdin;
1	2	VENTA	EFECTIVO	5.00	Venta 4	Rey	4	2026-02-23 13:39:57.802652
2	2	VENTA	EFECTIVO	8.00	Venta 5	Rey	5	2026-02-23 13:40:43.930691
3	2	VENTA	EFECTIVO	5.00	Venta 6	Rey	6	2026-02-23 13:45:23.582408
13	2	VENTA	EFECTIVO	8.50	Venta 16	Rey	16	2026-02-23 14:00:30.935623
14	2	VENTA	EFECTIVO	4.00	Venta 17	Rey	17	2026-02-23 14:04:11.869448
15	2	VENTA	EFECTIVO	3.00	Venta 18	Rey	18	2026-02-23 14:05:45.444656
16	2	VENTA	EFECTIVO	1.50	Venta 19	Rey	19	2026-02-23 14:35:48.96949
17	3	VENTA	EFECTIVO	13.50	Venta 21	Rey	21	2026-02-23 18:03:21.894925
19	3	EGRESO	EFECTIVO	2.00	taxi gasto	Rey	\N	2026-02-23 18:17:11.449855
20	3	VENTA	EFECTIVO	5.00	Venta 23	Rey	23	2026-02-23 18:34:48.276024
34	3	EGRESO	EFECTIVO	3.00	Compra hielo	Rey	\N	2026-02-23 18:54:35.50934
39	3	VENTA	EFECTIVO	8.50	Venta 20	Rey	20	2026-02-23 20:19:58.802213
40	3	VENTA	TRANSFERENCIA	6.00	Venta 28	Rey	28	2026-02-23 20:28:13.536023
41	3	VENTA	TRANSFERENCIA	1.50	Venta 29	Rey	29	2026-02-23 20:30:54.702897
42	3	INGRESO	EFECTIVO	3.00	alex puso	Rey	\N	2026-02-23 20:50:38.900965
44	3	VENTA	TRANSFERENCIA	2.50	Venta 31	Rey	31	2026-02-23 21:01:58.403278
45	3	VENTA	TRANSFERENCIA	1.50	Venta 32	Rey	32	2026-02-23 21:02:26.750843
51	3	VENTA	EFECTIVO	11.75	Venta 38	Rey	38	2026-02-23 21:09:05.511735
52	3	VENTA	EFECTIVO	4.00	Venta 39	Rey	39	2026-02-23 21:20:21.034891
53	3	VENTA	TRANSFERENCIA	3.50	Venta 40	Rey	40	2026-02-23 21:22:49.15548
57	3	VENTA	EFECTIVO	9.75	Venta 43	Rey	43	2026-02-23 21:29:13.561407
58	3	VENTA	EFECTIVO	3.25	Venta 44	Rey	44	2026-02-23 21:41:07.360208
59	3	VENTA	TRANSFERENCIA	4.25	Venta 30	Rey	30	2026-02-23 21:46:48.630693
60	3	VENTA	EFECTIVO	12.00	Venta 22	Rey	22	2026-02-23 21:47:40.305757
61	3	VENTA	EFECTIVO	6.75	Venta 46	Rey	46	2026-02-23 22:08:08.502655
62	3	VENTA	EFECTIVO	8.50	Venta 45	Rey	45	2026-02-23 22:09:21.377046
63	3	VENTA	EFECTIVO	17.00	Venta 47	Rey	47	2026-02-23 22:15:14.497914
64	3	VENTA	TRANSFERENCIA	1.75	Venta 48	Rey	48	2026-02-23 22:34:22.149147
65	3	VENTA	EFECTIVO	3.50	Venta 49	Rey	49	2026-02-23 22:40:58.48011
66	3	VENTA	EFECTIVO	1.50	Venta 50	Rey	50	2026-02-23 23:04:41.086451
67	3	EGRESO	EFECTIVO	2.50	comida rey	Rey	\N	2026-02-23 23:25:42.472117
68	4	EGRESO	EFECTIVO	3.00	moto llaves alex	Rey	\N	2026-02-24 16:10:08.86051
69	4	EGRESO	EFECTIVO	0.50	alex	Rey	\N	2026-02-24 16:18:53.247157
70	4	VENTA	EFECTIVO	2.75	Venta 52	Rey	52	2026-02-24 16:30:31.564755
72	4	VENTA	TRANSFERENCIA	1.75	Venta 53	Rey	53	2026-02-24 16:38:59.604662
71	4	VENTA	EFECTIVO	9.00	Venta 51	Rey	51	2026-02-24 16:35:30.78649
73	4	VENTA	EFECTIVO	3.25	Venta 54	Rey	54	2026-02-24 16:42:54.669729
74	4	VENTA	EFECTIVO	4.00	Venta 56	Rey	56	2026-02-24 17:31:49.24857
77	4	VENTA	EFECTIVO	7.50	Venta 55	Rey	55	2026-02-24 17:41:54.733429
78	4	VENTA	EFECTIVO	2.25	Venta 58	Rey	58	2026-02-24 17:51:08.247721
79	4	VENTA	EFECTIVO	1.00	Venta 59	Rey	59	2026-02-24 17:51:19.145846
84	4	VENTA	EFECTIVO	5.00	Venta 64	Rey	64	2026-02-24 18:15:02.304594
87	4	VENTA	TRANSFERENCIA	6.00	Venta 67	Rey	67	2026-02-24 18:32:05.811226
88	4	VENTA	EFECTIVO	3.25	Venta 68	Rey	68	2026-02-24 18:34:52.0494
89	4	VENTA	EFECTIVO	1.50	Venta 69	Rey	69	2026-02-24 18:36:58.889658
90	4	INGRESO	TRANSFERENCIA	20.00	60432960	Rey	\N	2026-02-24 18:39:14.14614
91	4	EGRESO	EFECTIVO	20.00	SeÃ±ora transfiriÃ³ 20	Rey	\N	2026-02-24 18:39:48.597761
95	4	VENTA	EFECTIVO	4.00	Venta 73	Rey	73	2026-02-24 19:05:00.615265
96	4	VENTA	EFECTIVO	1.50	Venta 74	Rey	74	2026-02-24 19:08:06.687712
97	4	VENTA	EFECTIVO	4.00	Venta 75	Rey	75	2026-02-24 19:35:38.922849
98	4	VENTA	EFECTIVO	1.00	Venta 76	Rey	76	2026-02-24 19:39:56.415695
100	4	VENTA	TRANSFERENCIA	1.75	Venta 78	Rey	78	2026-02-24 19:52:07.944925
102	4	VENTA	EFECTIVO	4.75	Venta 80	Rey	80	2026-02-24 20:04:24.33906
107	4	VENTA	EFECTIVO	5.00	Venta 85	Rey	85	2026-02-24 20:07:44.441477
108	4	VENTA	EFECTIVO	1.75	Venta 86	Rey	86	2026-02-24 20:23:47.590546
110	4	VENTA	EFECTIVO	1.75	Venta 88	Rey	88	2026-02-24 21:27:21.407507
111	4	VENTA	EFECTIVO	1.75	Venta 89	Rey	89	2026-02-24 21:27:31.245705
112	4	EGRESO	EFECTIVO	10.00	Anticipo de arriendo Don miguel	Rey	\N	2026-02-24 21:29:39.711092
113	4	VENTA	TRANSFERENCIA	0.00	Venta 87	Rey	87	2026-02-24 21:40:02.667113
114	4	VENTA	TRANSFERENCIA	11.75	Venta 90	Rey	90	2026-02-24 21:40:37.464351
115	4	VENTA	EFECTIVO	0.75	Venta 91	Rey	91	2026-02-24 21:41:58.437266
116	4	VENTA	TRANSFERENCIA	3.50	Venta 92	Rey	92	2026-02-24 21:57:41.07567
117	4	VENTA	EFECTIVO	3.00	Venta 93	Rey	93	2026-02-24 22:01:45.069288
118	4	VENTA	TRANSFERENCIA	6.00	Venta 94	Rey	94	2026-02-24 22:05:36.804663
119	4	VENTA	EFECTIVO	2.75	Venta 95	Rey	95	2026-02-24 22:11:37.229491
120	4	VENTA	EFECTIVO	0.75	Venta 96	Rey	96	2026-02-24 23:07:00.901747
121	4	INGRESO	EFECTIVO	1.00	hielo	Rey	\N	2026-02-24 23:33:38.537202
122	4	EGRESO	EFECTIVO	2.50	comida rey	Rey	\N	2026-02-25 10:03:13.13295
123	5	VENTA	EFECTIVO	3.50	Venta 97	Rey	97	2026-02-25 16:13:04.522899
124	5	EGRESO	EFECTIVO	2.50	comida rey	Rey	\N	2026-02-25 16:13:47.825257
125	5	VENTA	TRANSFERENCIA	14.00	Venta 98	Rey	98	2026-02-25 17:11:17.837718
126	5	VENTA	EFECTIVO	5.00	Venta 99	Rey	99	2026-02-25 17:40:09.226436
127	5	VENTA	EFECTIVO	1.75	Venta 100	Rey	100	2026-02-25 18:12:14.971106
128	5	EGRESO	EFECTIVO	4.50	compra hielo	Rey	\N	2026-02-25 18:12:56.80705
129	5	VENTA	EFECTIVO	1.75	Venta 101	Rey	101	2026-02-25 18:17:54.103782
130	5	VENTA	TRANSFERENCIA	1.00	Venta 102	Rey	102	2026-02-25 18:22:25.727658
131	5	VENTA	EFECTIVO	3.50	Venta 103	Rey	103	2026-02-25 18:53:45.612011
132	5	VENTA	EFECTIVO	20.00	Venta 104	Rey	104	2026-02-25 18:54:28.245325
133	5	VENTA	EFECTIVO	5.00	Venta 105	Rey	105	2026-02-25 19:06:26.557225
134	5	VENTA	EFECTIVO	1.75	Venta 106	Rey	106	2026-02-25 19:24:52.722124
135	5	VENTA	EFECTIVO	1.75	Venta 107	Rey	107	2026-02-25 20:39:52.284585
136	5	VENTA	EFECTIVO	2.50	Venta 108	Rey	108	2026-02-25 20:40:02.331884
137	5	VENTA	EFECTIVO	5.00	Venta 109	Rey	109	2026-02-25 20:46:05.493535
138	5	VENTA	EFECTIVO	4.50	Venta 110	Rey	110	2026-02-25 20:48:22.654839
139	5	VENTA	TRANSFERENCIA	3.00	Venta 111	Rey	111	2026-02-25 20:52:04.099202
143	5	VENTA	EFECTIVO	1.75	Venta 112	Rey	112	2026-02-25 21:00:51.117264
144	5	VENTA	EFECTIVO	3.50	Venta 114	Rey	114	2026-02-25 21:06:46.628949
145	5	VENTA	EFECTIVO	1.75	Venta 115	Rey	115	2026-02-25 21:06:52.347883
146	5	VENTA	EFECTIVO	3.50	Venta 116	Rey	116	2026-02-25 21:16:44.396752
147	5	VENTA	EFECTIVO	3.75	Venta 117	Rey	117	2026-02-25 21:16:52.260495
148	5	VENTA	EFECTIVO	2.50	Venta 118	Rey	118	2026-02-25 21:16:59.723785
149	5	EGRESO	EFECTIVO	2.50	comida rey 2502	Rey	\N	2026-02-25 21:20:43.550896
267	8	VENTA	EFECTIVO	8.50	Venta 235	Rey	235	2026-03-01 17:42:30.407103
151	5	VENTA	EFECTIVO	2.50	Venta 120	Rey	120	2026-02-25 21:31:09.600036
152	5	VENTA	TRANSFERENCIA	2.00	Venta 121	Rey	121	2026-02-25 21:43:06.488332
153	5	VENTA	EFECTIVO	3.25	Venta 122	Rey	122	2026-02-25 21:59:06.277754
154	5	VENTA	EFECTIVO	3.00	Venta 123	Rey	123	2026-02-25 22:02:01.163321
155	5	VENTA	TRANSFERENCIA	3.75	Venta 124	Rey	124	2026-02-25 22:02:48.317937
156	5	VENTA	TRANSFERENCIA	1.75	Venta 125	Rey	125	2026-02-25 22:03:17.389335
157	5	VENTA	EFECTIVO	3.50	Venta 126	Rey	126	2026-02-25 22:07:44.531029
158	5	VENTA	EFECTIVO	1.75	Venta 127	Rey	127	2026-02-25 22:16:16.4175
159	5	VENTA	EFECTIVO	13.00	Venta 129	Rey	129	2026-02-25 22:39:44.89953
160	5	VENTA	EFECTIVO	1.50	Venta 130	Rey	130	2026-02-25 22:40:36.226837
161	5	VENTA	TRANSFERENCIA	3.25	Venta 128	Rey	128	2026-02-25 22:52:52.856223
268	8	VENTA	EFECTIVO	3.50	Venta 236	Rey	236	2026-03-01 17:42:43.65379
269	8	VENTA	EFECTIVO	2.50	Venta 237	Rey	237	2026-03-01 17:42:51.806377
164	5	EGRESO	EFECTIVO	2.00	taxi 	Rey	\N	2026-02-25 23:26:13.534694
165	5	VENTA	EFECTIVO	3.75	Venta 132	Rey	132	2026-02-25 23:35:42.031916
270	8	VENTA	EFECTIVO	8.50	Venta 238	Rey	238	2026-03-01 17:48:22.582492
167	6	EGRESO	EFECTIVO	2.00	taxi	Rey	\N	2026-02-26 16:27:56.066963
168	6	VENTA	TRANSFERENCIA	3.75	Venta 134	Rey	134	2026-02-26 16:32:54.312281
169	6	VENTA	EFECTIVO	0.75	Venta 135	Rey	135	2026-02-26 16:55:18.883896
170	6	VENTA	EFECTIVO	30.00	Venta 137	Rey	137	2026-02-26 17:33:39.432224
171	6	VENTA	EFECTIVO	3.50	Venta 138	Rey	138	2026-02-26 17:50:41.394133
173	6	VENTA	EFECTIVO	5.00	Venta 139	Rey	139	2026-02-26 18:42:06.565682
174	6	VENTA	EFECTIVO	3.50	Venta 133	Rey	133	2026-02-26 18:42:32.11905
176	6	VENTA	TRANSFERENCIA	2.70	Venta 140	Rey	140	2026-02-26 19:09:15.336341
177	6	VENTA	EFECTIVO	4.25	Venta 141	Rey	141	2026-02-26 19:16:11.969646
178	6	VENTA	EFECTIVO	1.75	Venta 142	Rey	142	2026-02-26 19:19:30.328816
180	6	VENTA	EFECTIVO	1.50	Venta 152	Rey	152	2026-02-26 19:58:19.368293
181	6	VENTA	EFECTIVO	1.50	Venta 153	Rey	153	2026-02-26 19:58:54.110438
182	6	VENTA	EFECTIVO	13.00	Venta 154	Rey	154	2026-02-26 20:16:45.99235
183	6	VENTA	TRANSFERENCIA	2.50	Venta 155	Rey	155	2026-02-26 20:35:46.313593
184	6	VENTA	EFECTIVO	5.00	Venta 156	Rey	156	2026-02-26 20:39:02.973911
185	6	VENTA	EFECTIVO	1.75	Venta 157	Rey	157	2026-02-26 20:40:08.77052
186	6	EGRESO	EFECTIVO	2.00	LIMONES	Rey	\N	2026-02-26 21:02:11.471218
187	6	VENTA	EFECTIVO	2.25	Venta 158	Rey	158	2026-02-26 21:05:09.933437
188	6	VENTA	EFECTIVO	5.00	Venta 159	Rey	159	2026-02-26 21:05:32.870947
189	6	VENTA	EFECTIVO	0.75	Venta 160	Rey	160	2026-02-26 21:20:04.636601
190	6	VENTA	TRANSFERENCIA	3.50	Venta 161	Rey	161	2026-02-26 21:41:56.030148
191	6	VENTA	TRANSFERENCIA	20.00	Venta 162	Rey	162	2026-02-26 21:43:51.095846
192	6	VENTA	EFECTIVO	0.75	Venta 163	Rey	163	2026-02-26 21:44:00.977422
193	6	VENTA	EFECTIVO	3.75	Venta 143	Rey	143	2026-02-26 22:03:06.794017
194	6	VENTA	EFECTIVO	8.50	Venta 164	Rey	164	2026-02-26 22:09:16.366438
195	6	VENTA	EFECTIVO	1.50	Venta 165	Rey	165	2026-02-26 22:13:32.723177
196	6	VENTA	EFECTIVO	1.50	Venta 166	Rey	166	2026-02-26 22:36:45.019071
197	6	VENTA	EFECTIVO	1.50	Venta 167	Rey	167	2026-02-26 23:09:22.357502
198	6	VENTA	TRANSFERENCIA	10.50	Venta 168	Rey	168	2026-02-26 23:26:02.639138
199	6	EGRESO	EFECTIVO	2.50	COMIDA REY	Rey	\N	2026-02-26 23:50:27.370188
200	6	VENTA	EFECTIVO	0.75	Venta 170	Rey	170	2026-02-26 23:54:32.04546
201	7	VENTA	EFECTIVO	7.50	Venta 171	Rey	171	2026-02-28 16:54:18.291396
202	7	VENTA	EFECTIVO	2.75	Venta 172	Rey	172	2026-02-28 16:54:51.023618
203	7	EGRESO	EFECTIVO	12.00	COMPRA HIELO	Rey	\N	2026-02-28 17:06:30.020149
204	7	VENTA	EFECTIVO	4.25	Venta 174	Rey	174	2026-02-28 17:11:34.121971
205	7	VENTA	EFECTIVO	12.25	Venta 175	Rey	175	2026-02-28 17:34:32.894542
206	7	VENTA	EFECTIVO	1.50	Venta 176	Rey	176	2026-02-28 17:34:46.628934
207	7	EGRESO	EFECTIVO	2.00	TIZA PARA PIZARRA	Rey	\N	2026-02-28 17:43:47.90343
208	7	VENTA	EFECTIVO	1.50	Venta 177	Rey	177	2026-02-28 17:53:07.78519
209	7	VENTA	EFECTIVO	3.50	Venta 178	Rey	178	2026-02-28 18:22:29.926135
210	7	VENTA	EFECTIVO	8.75	Venta 179	Rey	179	2026-02-28 18:33:11.470906
211	7	VENTA	EFECTIVO	7.50	Venta 180	Rey	180	2026-02-28 19:17:04.979049
212	7	VENTA	EFECTIVO	0.75	Venta 181	Rey	181	2026-02-28 19:17:10.539556
213	7	VENTA	EFECTIVO	15.00	Venta 182	Rey	182	2026-02-28 19:43:55.511468
214	7	VENTA	EFECTIVO	2.00	Venta 183	Rey	183	2026-02-28 19:44:01.837154
215	7	VENTA	EFECTIVO	2.25	Venta 184	Rey	184	2026-02-28 20:37:56.113211
216	7	VENTA	EFECTIVO	4.50	Venta 185	Rey	185	2026-02-28 20:41:29.460527
217	7	VENTA	EFECTIVO	3.50	Venta 186	Rey	186	2026-02-28 20:46:35.432792
218	7	VENTA	EFECTIVO	4.25	Venta 187	Rey	187	2026-02-28 21:04:39.464543
219	7	VENTA	EFECTIVO	5.00	Venta 188	Rey	188	2026-02-28 21:04:44.771562
220	7	VENTA	EFECTIVO	3.50	Venta 189	Rey	189	2026-02-28 21:04:49.08029
221	7	VENTA	EFECTIVO	4.25	Venta 190	Rey	190	2026-02-28 21:09:05.417206
222	7	VENTA	DE_UNA	1.50	Venta 191	Rey	191	2026-02-28 21:16:19.623815
223	7	VENTA	EFECTIVO	2.50	Venta 192	Rey	192	2026-02-28 21:27:35.399724
224	7	VENTA	EFECTIVO	1.50	Venta 193	Rey	193	2026-02-28 21:29:08.215708
225	7	VENTA	EFECTIVO	5.00	Venta 194	Rey	194	2026-02-28 21:45:00.336961
226	7	VENTA	EFECTIVO	7.00	Venta 195	Rey	195	2026-02-28 21:50:16.821203
227	7	VENTA	TRANSFERENCIA	5.00	Venta 196	Rey	196	2026-02-28 21:51:11.884117
228	7	VENTA	EFECTIVO	1.50	Venta 197	Rey	197	2026-02-28 22:00:25.98113
229	7	VENTA	EFECTIVO	3.50	Venta 198	Rey	198	2026-02-28 22:28:02.782855
230	7	EGRESO	EFECTIVO	2.50	rey comida	Rey	\N	2026-02-28 22:28:26.094691
231	7	VENTA	EFECTIVO	2.00	Venta 200	Rey	200	2026-02-28 22:34:04.288083
232	7	VENTA	TRANSFERENCIA	1.75	Venta 201	Rey	201	2026-02-28 22:36:07.392629
233	7	VENTA	EFECTIVO	3.50	Venta 202	Rey	202	2026-02-28 22:38:09.031223
234	7	VENTA	EFECTIVO	1.50	Venta 203	Rey	203	2026-02-28 22:40:22.871838
235	7	VENTA	EFECTIVO	5.00	Venta 204	Rey	204	2026-02-28 22:47:23.003873
236	7	VENTA	EFECTIVO	1.00	Venta 205	Rey	205	2026-02-28 22:47:33.967914
237	7	VENTA	EFECTIVO	1.00	Venta 206	Rey	206	2026-02-28 22:48:54.820519
238	7	VENTA	EFECTIVO	5.00	Venta 207	Rey	207	2026-02-28 23:24:58.612734
239	7	VENTA	EFECTIVO	3.50	Venta 208	Rey	208	2026-02-28 23:30:07.133542
240	7	EGRESO	EFECTIVO	3.00	taxi rey	Rey	\N	2026-03-01 00:11:06.893107
241	8	VENTA	EFECTIVO	4.75	Venta 209	Rey	209	2026-03-01 16:40:37.958776
242	8	VENTA	TRANSFERENCIA	5.00	Venta 210	Rey	210	2026-03-01 16:41:19.284929
243	8	VENTA	TRANSFERENCIA	3.50	Venta 211	Rey	211	2026-03-01 16:41:45.373568
244	8	VENTA	TRANSFERENCIA	2.50	Venta 212	Rey	212	2026-03-01 16:42:06.48609
245	8	VENTA	EFECTIVO	3.00	Venta 213	Rey	213	2026-03-01 16:57:56.439683
271	8	VENTA	EFECTIVO	2.25	Venta 239	Rey	239	2026-03-01 17:59:31.44892
272	8	VENTA	TRANSFERENCIA	5.25	Venta 240	Rey	240	2026-03-01 18:00:00.643627
273	8	EGRESO	EFECTIVO	1.00	DESINFECTANTE	Rey	\N	2026-03-01 18:00:27.567037
274	8	VENTA	EFECTIVO	1.50	Venta 241	Rey	241	2026-03-01 18:08:02.431863
275	8	VENTA	EFECTIVO	3.75	Venta 242	Rey	242	2026-03-01 18:13:26.28313
276	8	VENTA	EFECTIVO	3.50	Venta 243	Rey	243	2026-03-01 18:20:02.26705
280	8	VENTA	EFECTIVO	3.50	Venta 247	Rey	247	2026-03-01 18:20:32.650307
281	8	VENTA	EFECTIVO	4.50	Venta 249	Rey	249	2026-03-01 18:31:56.477133
282	8	VENTA	EFECTIVO	11.50	Venta 248	Rey	248	2026-03-01 18:48:16.464022
283	8	VENTA	TRANSFERENCIA	3.50	Venta 251	Rey	251	2026-03-01 19:09:49.971425
284	8	VENTA	EFECTIVO	4.25	Venta 252	Rey	252	2026-03-01 19:18:04.366678
285	8	VENTA	EFECTIVO	9.00	Venta 250	Rey	250	2026-03-01 19:28:17.099252
286	8	VENTA	EFECTIVO	3.50	Venta 253	Rey	253	2026-03-01 19:28:39.374842
291	8	VENTA	TRANSFERENCIA	5.00	Venta 258	Rey	258	2026-03-01 19:46:27.334455
292	8	VENTA	EFECTIVO	2.25	Venta 259	Rey	259	2026-03-01 19:51:39.394571
293	8	VENTA	EFECTIVO	3.75	Venta 260	Rey	260	2026-03-01 19:55:30.640598
294	8	VENTA	EFECTIVO	3.25	Venta 261	Rey	261	2026-03-01 20:13:15.285202
297	8	VENTA	TRANSFERENCIA	7.50	Venta 264	Rey	264	2026-03-01 20:36:35.476167
298	8	EGRESO	EFECTIVO	2.50	comida rey	Rey	\N	2026-03-01 20:50:56.215683
305	8	VENTA	EFECTIVO	2.50	Venta 271	Rey	271	2026-03-01 20:58:47.211378
306	8	VENTA	TRANSFERENCIA	3.50	Venta 272	Rey	272	2026-03-01 21:10:39.005921
307	8	VENTA	EFECTIVO	1.75	Venta 273	Rey	273	2026-03-01 21:11:35.878886
308	8	VENTA	TRANSFERENCIA	2.25	Venta 274	Rey	274	2026-03-01 21:19:50.935486
309	8	VENTA	EFECTIVO	2.00	Venta 275	Rey	275	2026-03-01 21:21:20.725122
310	8	VENTA	EFECTIVO	3.50	Venta 276	Rey	276	2026-03-01 21:26:39.347891
311	8	VENTA	EFECTIVO	6.00	Venta 277	Rey	277	2026-03-01 21:36:41.060707
312	8	VENTA	EFECTIVO	1.50	Venta 278	Rey	278	2026-03-01 21:36:56.08171
313	8	VENTA	TRANSFERENCIA	5.00	Venta 279	Rey	279	2026-03-01 21:37:17.943377
315	8	VENTA	EFECTIVO	5.00	Venta 280	Rey	280	2026-03-01 21:51:58.39288
316	8	VENTA	EFECTIVO	1.75	Venta 281	Rey	281	2026-03-01 21:52:10.715077
317	8	VENTA	EFECTIVO	2.50	Venta 282	Rey	282	2026-03-01 22:21:21.877873
318	8	VENTA	TRANSFERENCIA	2.50	Venta 283	Rey	283	2026-03-01 22:25:28.481477
319	8	VENTA	EFECTIVO	1.50	Venta 284	Rey	284	2026-03-01 22:27:20.833803
320	8	VENTA	EFECTIVO	1.50	Venta 285	Rey	285	2026-03-01 22:30:38.471812
321	8	VENTA	EFECTIVO	3.00	Venta 286	Rey	286	2026-03-01 22:31:24.994721
322	8	VENTA	TRANSFERENCIA	3.50	Venta 287	Rey	287	2026-03-01 22:43:12.540864
323	8	VENTA	EFECTIVO	3.00	Venta 288	Rey	288	2026-03-01 23:13:57.590856
324	9	VENTA	TRANSFERENCIA	25.00	Venta 289	Rey	289	2026-03-02 15:13:56.91021
325	9	VENTA	TRANSFERENCIA	13.50	Venta 290	Rey	290	2026-03-02 15:15:25.09292
329	9	EGRESO	EFECTIVO	2.00	DON MIGUEL PENDIENTE DE PAGO	Rey	\N	2026-03-02 15:35:19.383679
330	9	VENTA	EFECTIVO	1.50	Venta 294	Rey	294	2026-03-02 15:38:12.466397
331	9	VENTA	EFECTIVO	2.50	Venta 295	Rey	295	2026-03-02 15:52:37.672104
332	9	EGRESO	EFECTIVO	1.00	AYUDA HUMANITARIA	Rey	\N	2026-03-02 16:19:53.513518
333	9	VENTA	EFECTIVO	3.50	Venta 296	Rey	296	2026-03-02 17:22:39.236397
334	9	VENTA	EFECTIVO	1.75	Venta 297	Rey	297	2026-03-02 17:51:04.262517
335	9	VENTA	EFECTIVO	1.00	Venta 298	Rey	298	2026-03-02 17:59:22.286585
336	9	VENTA	EFECTIVO	3.50	Venta 299	Rey	299	2026-03-02 18:47:49.249054
337	9	VENTA	EFECTIVO	1.50	Venta 300	Rey	300	2026-03-02 18:53:21.114371
338	9	VENTA	EFECTIVO	5.00	Venta 301	Rey	301	2026-03-02 19:12:11.397491
339	9	VENTA	EFECTIVO	5.25	Venta 302	Rey	302	2026-03-02 19:15:56.637231
340	9	VENTA	EFECTIVO	1.50	Venta 303	Rey	303	2026-03-02 19:16:01.126569
341	9	VENTA	TRANSFERENCIA	1.50	Venta 304	Rey	304	2026-03-02 19:16:34.228756
342	9	EGRESO	EFECTIVO	0.25	VUELTO POR TRANSFERECNIA	Rey	\N	2026-03-02 19:16:55.544516
343	9	VENTA	EFECTIVO	0.75	Venta 305	Rey	305	2026-03-02 20:41:53.696978
345	9	EGRESO	EFECTIVO	2.00	taxi desde bodega	Rey	\N	2026-03-02 21:07:42.678764
346	9	EGRESO	EFECTIVO	2.50	comida rey	Rey	\N	2026-03-02 21:08:05.754909
347	9	VENTA	EFECTIVO	1.50	Venta 306	Rey	306	2026-03-02 21:10:49.885965
344	9	EGRESO	EFECTIVO	2.40	envases alex	Rey	\N	2026-03-02 21:07:19.695389
348	9	VENTA	EFECTIVO	3.00	Venta 307	Rey	307	2026-03-02 21:22:33.415194
349	9	VENTA	TRANSFERENCIA	7.00	Venta 308	Rey	308	2026-03-02 21:22:56.574605
350	9	VENTA	TRANSFERENCIA	18.75	Venta 293	Rey	293	2026-03-02 21:29:15.209233
351	9	VENTA	EFECTIVO	60.00	Venta 309	Rey	309	2026-03-02 21:50:30.255663
352	9	VENTA	EFECTIVO	3.50	Venta 310	Rey	310	2026-03-02 21:51:24.692544
353	9	VENTA	EFECTIVO	7.50	Venta 311	Rey	311	2026-03-02 21:52:02.421316
354	9	EGRESO	EFECTIVO	1.00	PAGO 1 DOLAR POR TRANSFERENCIA VENTA 311	Rey	\N	2026-03-02 21:52:28.659353
355	9	VENTA	TRANSFERENCIA	3.50	Venta 312	Rey	312	2026-03-02 21:53:10.91289
356	9	VENTA	TRANSFERENCIA	2.00	Venta 313	Rey	313	2026-03-02 21:55:56.233887
357	9	INGRESO	TRANSFERENCIA	1.00	207463012	Rey	\N	2026-03-02 22:08:00.544051
358	9	EGRESO	EFECTIVO	5.00	MOTO Y COMIDA ALEX	Rey	\N	2026-03-02 22:13:03.194501
359	9	VENTA	EFECTIVO	3.00	Venta 314	Rey	314	2026-03-02 22:24:49.458929
360	9	VENTA	TRANSFERENCIA	4.50	Venta 315	Rey	315	2026-03-02 22:25:09.732934
361	9	VENTA	TRANSFERENCIA	2.50	Venta 316	Rey	316	2026-03-02 22:25:38.814018
362	9	VENTA	EFECTIVO	3.00	Venta 317	Rey	317	2026-03-02 22:27:19.809604
363	9	VENTA	EFECTIVO	3.50	Venta 318	Rey	318	2026-03-02 22:35:11.481806
364	9	VENTA	EFECTIVO	1.50	Venta 319	Rey	319	2026-03-02 22:44:44.06269
365	10	EGRESO	TRANSFERENCIA	5.00	GASTO PERSONAL, 18692103	Rey	\N	2026-03-03 17:40:41.647413
366	10	VENTA	EFECTIVO	3.00	Venta 321	Rey	321	2026-03-03 17:43:51.511292
367	10	VENTA	EFECTIVO	1.50	Venta 322	Rey	322	2026-03-03 17:43:59.29886
368	10	VENTA	TRANSFERENCIA	1.75	Venta 323	Rey	323	2026-03-03 18:31:40.857412
369	10	VENTA	EFECTIVO	3.00	Venta 324	Rey	324	2026-03-03 19:20:02.176831
370	10	VENTA	TRANSFERENCIA	14.50	Venta 325	Rey	325	2026-03-03 19:23:27.488104
371	10	VENTA	TRANSFERENCIA	4.25	Venta 326	Rey	326	2026-03-03 19:24:35.162818
372	10	VENTA	EFECTIVO	4.25	Venta 327	Rey	327	2026-03-03 19:31:55.208868
373	10	VENTA	EFECTIVO	9.00	Parte 1	Rey	328	2026-03-03 20:47:29.288078
374	10	VENTA	EFECTIVO	7.00	Parte 2	Rey	328	2026-03-03 20:47:29.288078
375	10	VENTA	EFECTIVO	10.25	Venta 329	Rey	329	2026-03-03 21:05:06.360765
378	10	VENTA	EFECTIVO	2.50	Venta 332	Rey	332	2026-03-03 21:30:32.532835
379	10	VENTA	EFECTIVO	1.00	Venta 333	Rey	333	2026-03-03 22:14:35.330673
380	10	VENTA	EFECTIVO	2.50	Venta 334	Rey	334	2026-03-03 22:34:59.379783
381	10	EGRESO	EFECTIVO	2.00	taxi	Rey	\N	2026-03-03 22:35:30.290921
382	10	VENTA	TRANSFERENCIA	1.00	Venta 335	Rey	335	2026-03-03 22:36:43.831112
383	10	VENTA	EFECTIVO	1.75	Venta 336	Rey	336	2026-03-03 22:52:31.632046
384	11	VENTA	EFECTIVO	5.00	Venta 337	Rey	337	2026-03-04 15:47:15.175922
385	11	EGRESO	EFECTIVO	2.00	taxi	Rey	\N	2026-03-04 15:48:04.910454
386	11	EGRESO	EFECTIVO	10.00	ALEX ANTICIPO	Rey	\N	2026-03-04 15:48:19.795076
387	11	VENTA	EFECTIVO	3.25	Venta 338	Rey	338	2026-03-04 16:03:48.208848
388	11	VENTA	EFECTIVO	0.75	Venta 339	Rey	339	2026-03-04 16:03:53.131458
389	11	VENTA	EFECTIVO	3.50	Venta 341	Rey	341	2026-03-04 18:57:02.04808
390	11	VENTA	EFECTIVO	1.75	Venta 342	Rey	342	2026-03-04 19:18:47.864179
391	11	VENTA	TRANSFERENCIA	1.50	Venta 343	Rey	343	2026-03-04 19:43:11.300973
392	11	EGRESO	EFECTIVO	1.50	CAMBIO DE TRANSFERENCIA A EFECTIVO	Rey	\N	2026-03-04 19:48:53.056072
393	11	INGRESO	TRANSFERENCIA	1.50	BANCO PICHINCHA: 66949512	Rey	\N	2026-03-04 19:49:35.99661
394	11	VENTA	EFECTIVO	3.00	Venta 344	Rey	344	2026-03-04 19:56:20.279169
395	11	VENTA	EFECTIVO	1.50	Venta 345	Rey	345	2026-03-04 19:56:33.265719
396	11	VENTA	EFECTIVO	3.00	Venta 346	Rey	346	2026-03-04 19:56:48.578589
397	11	VENTA	EFECTIVO	1.75	Venta 347	Rey	347	2026-03-04 20:07:58.164246
398	11	EGRESO	EFECTIVO	1.00	DON MIGUEL PIDIO QUEDA PENDIENTE	Rey	\N	2026-03-04 20:27:43.04102
399	11	VENTA	TRANSFERENCIA	1.75	Venta 348	Rey	348	2026-03-04 22:30:54.662668
400	11	VENTA	EFECTIVO	17.00	Venta 349	Rey	349	2026-03-04 23:01:13.183772
401	11	VENTA	EFECTIVO	2.50	Venta 350	Rey	350	2026-03-04 23:01:24.595828
402	11	VENTA	TRANSFERENCIA	8.75	Venta 351	Rey	351	2026-03-04 23:40:06.679679
403	11	VENTA	EFECTIVO	3.50	Venta 352	Rey	352	2026-03-04 23:43:14.846003
404	11	VENTA	EFECTIVO	0.75	Venta 353	Rey	353	2026-03-04 23:47:46.058783
405	11	EGRESO	EFECTIVO	2.50	rey comida	Rey	\N	2026-03-04 23:49:07.889518
406	11	VENTA	EFECTIVO	2.50	Venta 354	Rey	354	2026-03-04 23:50:02.873551
407	12	VENTA	EFECTIVO	2.25	Venta 355	Administrador	355	2026-03-05 22:59:08.467459
408	12	VENTA	TRANSFERENCIA	2.00	Venta 356	Administrador	356	2026-03-05 22:59:53.517925
409	12	VENTA	TRANSFERENCIA	3.50	Venta 357	Administrador	357	2026-03-05 23:00:35.099712
410	12	VENTA	EFECTIVO	1.50	Venta 358	Administrador	358	2026-03-05 23:00:49.716357
412	12	VENTA	EFECTIVO	6.00	Venta 359	Administrador	359	2026-03-05 23:05:39.863328
413	12	VENTA	EFECTIVO	2.25	Venta 360	Administrador	360	2026-03-05 23:06:24.063577
414	12	VENTA	EFECTIVO	14.75	Venta 361	Administrador	361	2026-03-05 23:08:04.75606
415	12	EGRESO	EFECTIVO	1.00	PAGO MOTORIZADO CUCHILLO	Administrador	\N	2026-03-05 23:08:43.875742
416	12	EGRESO	EFECTIVO	25.00	PAGO ARRIENDO	Administrador	\N	2026-03-05 23:09:12.297267
417	12	VENTA	EFECTIVO	10.25	Venta 362	Administrador	362	2026-03-05 23:10:08.623793
418	12	VENTA	TRANSFERENCIA	3.50	Venta 363	Administrador	363	2026-03-05 23:11:19.547228
419	12	VENTA	TRANSFERENCIA	2.50	Venta 364	Administrador	364	2026-03-05 23:11:46.899934
420	12	VENTA	EFECTIVO	20.25	Venta 365	Administrador	365	2026-03-05 23:14:29.571713
421	12	VENTA	EFECTIVO	5.00	Venta 366	Administrador	366	2026-03-05 23:16:43.033659
422	12	VENTA	EFECTIVO	1.00	Parte 1	Administrador	367	2026-03-05 23:17:55.407164
423	12	VENTA	TRANSFERENCIA	2.00	Parte 2 | Banco: Banco Pichincha | Comprobante: 900102532	Administrador	367	2026-03-05 23:17:55.407164
424	12	VENTA	EFECTIVO	6.00	Venta 368	Administrador	368	2026-03-05 23:18:29.427062
425	12	VENTA	TRANSFERENCIA	2.50	Venta 369	Administrador	369	2026-03-05 23:19:09.292136
426	12	VENTA	TRANSFERENCIA	2.50	Venta 370	Administrador	370	2026-03-05 23:19:09.292644
427	12	VENTA	EFECTIVO	1.75	Venta 371	Administrador	371	2026-03-05 23:19:19.94581
428	12	VENTA	EFECTIVO	3.50	Venta 372	Administrador	372	2026-03-05 23:19:54.074525
429	12	EGRESO	EFECTIVO	2.50	comida rey	Administrador	\N	2026-03-05 23:30:45.17039
430	12	VENTA	EFECTIVO	3.00	Venta 373	Administrador	373	2026-03-05 23:34:37.831685
431	12	VENTA	EFECTIVO	2.75	Venta 374	Administrador	374	2026-03-05 23:39:45.198371
432	12	INGRESO	EFECTIVO	0.50	SOBRANTE	Administrador	\N	2026-03-05 23:40:16.855626
\.


--
-- Data for Name: caja_turnos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caja_turnos (id, fecha_apertura, fecha_cierre, saldo_inicial, saldo_final, usuario_apertura, usuario_cierre, estado) FROM stdin;
1	2026-02-23 13:35:51.702532	2026-02-23 13:36:01.436104	30.00	0.00	Rey	Rey	CERRADA
2	2026-02-23 13:39:46.729692	2026-02-23 14:36:10.392662	30.00	0.00	Rey	Rey	CERRADA
3	2026-02-23 17:28:35.182508	2026-02-24 02:30:20.418413	25.70	0.00	Rey	Rey	CERRADA
4	2026-02-24 16:01:39.891989	2026-02-25 10:52:24.111985	25.70	0.00	Rey	Rey	CERRADA
5	2026-02-25 16:12:40.107004	2026-02-25 23:43:05.265583	25.95	0.00	Rey	Rey	CERRADA
6	2026-02-26 16:27:23.666502	2026-02-26 23:54:41.301292	25.95	0.00	Rey	Rey	CERRADA
7	2026-02-28 16:53:45.164805	2026-03-01 16:38:22.159542	31.65	0.00	Rey	Rey	CERRADA
8	2026-03-01 16:40:18.8294	2026-03-02 15:06:08.708646	31.50	0.00	Rey	Rey	CERRADA
9	2026-03-02 15:06:16.876276	2026-03-03 17:28:19.559374	31.50	0.00	Rey	Rey	CERRADA
10	2026-03-03 17:39:58.635517	2026-03-04 14:02:24.82972	27.00	0.00	Rey	Rey	CERRADA
11	2026-03-04 15:46:56.94423	2026-03-04 23:52:28.294229	27.00	0.00	Rey	Rey	CERRADA
12	2026-03-05 22:58:38.566814	\N	27.00	\N	Administrador	\N	ABIERTA
\.


--
-- Data for Name: categorias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categorias (id, nombre, icono) FROM stdin;
1	Smoothies	blender
2	Cocos/Bebidas	coconut
3	Paletas	icecream
4	Combos/Piqueos	restaurant
5	General	\N
\.


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientes (id, nombre, identificacion, telefono, email, direccion, notas, created_at) FROM stdin;
1	MECHE	\N	\N	\N	machala	\N	2026-02-25 21:30:13.28815
2	Xavier quiteÃ±o	\N	\N	\N	\N	\N	2026-02-26 17:37:31.904303
3	Velur Plaza	\N	\N	\N	\N	\N	2026-02-26 18:55:11.622089
4	Juan Diego	\N	\N	\N	\N	\N	2026-02-26 19:20:21.704434
5	GABRIEL NAGUA	\N	\N	\N	\N	\N	2026-02-26 23:48:32.396391
6	jhon	\N	\N	\N	\N	\N	2026-02-28 17:04:44.998798
7	DON JUNIOR	\N	\N	\N	\N	\N	2026-02-28 22:30:35.550681
\.


--
-- Data for Name: config_impresora; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.config_impresora (id, nombre_impresora, tipo, ancho_mm, auto_imprimir, updated_at) FROM stdin;
1		TERMICA	80	f	2026-03-04 19:08:44.278761
\.


--
-- Data for Name: detalle_ventas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.detalle_ventas (id, id_venta, id_producto, cantidad, precio_unitario, subtotal) FROM stdin;
\.


--
-- Data for Name: facturas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.facturas (id, numero, venta_id, tipo, fecha, cliente_nombre, cliente_identificacion, cliente_direccion, cliente_telefono, cliente_email, subtotal, impuesto_pct, impuesto_monto, total, metodo_pago, estado, notas, usuario, anulada_motivo, anulada_fecha, impresa) FROM stdin;
2	REC-000000002	343	RECIBO	2026-03-04 19:43:11.300973	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 66516388	Rey	\N	\N	t
1	REC-000000001	342	RECIBO	2026-03-04 19:18:47.864179	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	t
3	REC-000000003	344	RECIBO	2026-03-04 19:56:20.279169	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	t
4	REC-000000004	345	RECIBO	2026-03-04 19:56:33.265719	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	t
5	REC-000000005	346	RECIBO	2026-03-04 19:56:48.578589	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	t
6	REC-000000006	347	RECIBO	2026-03-04 20:07:58.164246	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	t
7	REC-000000007	348	RECIBO	2026-03-04 22:30:54.662668	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 74970135	Rey	\N	\N	t
9	REC-000000009	350	RECIBO	2026-03-04 23:01:24.595828	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	t
10	REC-000000010	351	RECIBO	2026-03-04 23:40:06.679679	Consumidor Final	9999999999999				8.75	0.00	0.00	8.75	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 900088781	Rey	\N	\N	t
11	REC-000000011	352	RECIBO	2026-03-04 23:43:14.846003	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	t
12	REC-000000012	353	RECIBO	2026-03-04 23:47:46.058783	Consumidor Final	9999999999999				0.75	0.00	0.00	0.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	t
13	REC-000000013	354	RECIBO	2026-03-04 23:50:02.873551	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	t
8	REC-000000008	349	RECIBO	2026-03-04 23:01:13.183772	Consumidor Final	9999999999999				17.00	0.00	0.00	17.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	t
14	REC-000000014	355	RECIBO	2026-03-05 22:59:08.467459	Consumidor Final	9999999999999				2.25	0.00	0.00	2.25	EFECTIVO	EMITIDA	\N	Administrador	\N	\N	t
15	REC-000000015	356	RECIBO	2026-03-05 22:59:53.517925	Consumidor Final	9999999999999				2.00	0.00	0.00	2.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 48414194	Administrador	\N	\N	t
16	REC-000000016	357	RECIBO	2026-03-05 23:00:35.099712	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 54113983	Administrador	\N	\N	t
17	REC-000000017	358	RECIBO	2026-03-05 23:00:49.716357	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Administrador	\N	\N	t
18	REC-000000018	359	RECIBO	2026-03-05 23:01:26.927696	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Administrador	\N	\N	t
19	REC-000000019	360	RECIBO	2026-03-05 23:06:24.063577	Consumidor Final	9999999999999				2.25	0.00	0.00	2.25	EFECTIVO	EMITIDA	\N	Administrador	\N	\N	t
20	REC-000000020	361	RECIBO	2026-03-05 23:08:04.75606	Consumidor Final	9999999999999				14.75	0.00	0.00	14.75	EFECTIVO	EMITIDA	\N	Administrador	\N	\N	t
21	REC-000000021	362	RECIBO	2026-03-05 23:10:08.623793	Consumidor Final	9999999999999				10.25	0.00	0.00	10.25	EFECTIVO	EMITIDA	\N	Administrador	\N	\N	t
22	REC-000000022	363	RECIBO	2026-03-05 23:11:19.547228	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 69486411	Administrador	\N	\N	t
23	REC-000000023	364	RECIBO	2026-03-05 23:11:46.899934	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 71996534	Administrador	\N	\N	t
24	REC-000000024	365	RECIBO	2026-03-05 23:14:29.571713	Consumidor Final	9999999999999				20.25	0.00	0.00	20.25	EFECTIVO	EMITIDA	\N	Administrador	\N	\N	t
25	REC-000000025	366	RECIBO	2026-03-05 23:16:43.033659	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Administrador	\N	\N	t
26	REC-000000026	367	RECIBO	2026-03-05 23:17:55.407164	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	DIVIDIDO	EMITIDA	Banco: Banco Pichincha	Administrador	\N	\N	t
27	REC-000000027	368	RECIBO	2026-03-05 23:18:29.427062	Consumidor Final	9999999999999				6.00	0.00	0.00	6.00	EFECTIVO	EMITIDA	\N	Administrador	\N	\N	t
29	REC-000000029	370	RECIBO	2026-03-05 23:19:09.292644	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 74869728	Administrador	\N	\N	f
28	REC-000000028	369	RECIBO	2026-03-05 23:19:09.292136	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 74869728	Administrador	\N	\N	t
30	REC-000000030	371	RECIBO	2026-03-05 23:19:19.94581	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Administrador	\N	\N	t
31	REC-000000031	372	RECIBO	2026-03-05 23:19:54.074525	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Administrador	\N	\N	t
32	REC-000000032	373	RECIBO	2026-03-05 23:34:37.831685	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	EFECTIVO	EMITIDA	\N	Administrador	\N	\N	t
33	REC-000000033	374	RECIBO	2026-03-05 23:39:45.198371	Consumidor Final	9999999999999				2.75	0.00	0.00	2.75	EFECTIVO	EMITIDA	\N	Administrador	\N	\N	t
\.


--
-- Data for Name: facturas_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.facturas_items (id, factura_id, producto_id, nombre, cantidad, precio_unitario, subtotal) FROM stdin;
1	1	17	Pipa de Coco (Entera)	1.00	1.75	1.75
2	2	10	Paleta Coco	2.00	0.75	1.50
3	3	10	Paleta Coco	4.00	0.75	3.00
4	4	19	Agua de Coco	1.00	1.50	1.50
5	5	16	Jugo de CaÃ±a	3.00	1.00	3.00
6	6	17	Pipa de Coco (Entera)	1.00	1.75	1.75
7	7	17	Pipa de Coco (Entera)	1.00	1.75	1.75
8	8	15	Coco Relleno	4.00	3.50	14.00
9	8	19	Agua de Coco	2.00	1.50	3.00
10	9	19	Agua de Coco	1.00	1.50	1.50
11	9	16	Jugo de CaÃ±a	1.00	1.00	1.00
12	10	17	Pipa de Coco (Entera)	5.00	1.75	8.75
13	11	17	Pipa de Coco (Entera)	2.00	1.75	3.50
14	12	10	Paleta Coco	1.00	0.75	0.75
15	13	17	Pipa de Coco (Entera)	1.00	1.75	1.75
16	13	10	Paleta Coco	1.00	0.75	0.75
17	14	10	Paleta Coco	3.00	0.75	2.25
18	15	16	Jugo de CaÃ±a	2.00	1.00	2.00
19	16	15	Coco Relleno	1.00	3.50	3.50
20	17	19	Agua de Coco	1.00	1.50	1.50
21	18	19	Agua de Coco	5.00	1.00	5.00
22	19	10	Paleta Coco	1.00	0.75	0.75
23	19	9	Paleta Frutos Rojos	2.00	0.75	1.50
24	20	10	Paleta Coco	8.00	0.75	6.00
25	20	15	Coco Relleno	2.00	3.50	7.00
26	20	17	Pipa de Coco (Entera)	1.00	1.75	1.75
27	21	1	PiÃ±a-Coco	1.00	2.50	2.50
28	21	2	Aranda-Coco	1.00	2.50	2.50
29	21	9	Paleta Frutos Rojos	2.00	0.75	1.50
30	21	10	Paleta Coco	3.00	0.75	2.25
31	21	19	Agua de Coco	1.00	1.50	1.50
32	22	17	Pipa de Coco (Entera)	2.00	1.75	3.50
33	23	2	Aranda-Coco	1.00	2.50	2.50
34	24	2	Aranda-Coco	1.00	2.50	2.50
35	24	1	PiÃ±a-Coco	1.00	2.50	2.50
36	24	19	Agua de Coco	1.00	1.50	1.50
37	24	17	Pipa de Coco (Entera)	1.00	1.75	1.75
38	24	9	Paleta Frutos Rojos	8.00	0.75	6.00
39	24	21	WhiskyCoco	1.00	6.00	6.00
40	25	27	Paloma	1.00	5.00	5.00
41	26	19	Agua de Coco	2.00	1.50	3.00
42	27	19	Agua de Coco	4.00	1.50	6.00
43	28	2	Aranda-Coco	1.00	2.50	2.50
44	29	2	Aranda-Coco	1.00	2.50	2.50
45	30	17	Pipa de Coco (Entera)	1.00	1.75	1.75
46	31	16	Jugo de CaÃ±a	1.00	1.00	1.00
47	31	1	PiÃ±a-Coco	1.00	2.50	2.50
48	32	19	Agua de Coco	2.00	1.50	3.00
49	33	16	Jugo de CaÃ±a	2.00	1.00	2.00
50	33	9	Paleta Frutos Rojos	1.00	0.75	0.75
\.


--
-- Data for Name: facturas_secuencia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.facturas_secuencia (id, prefijo, siguiente) FROM stdin;
1	REC	34
\.


--
-- Data for Name: gastos_mensuales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gastos_mensuales (id, fecha, descripcion, monto, categoria, caja_origen, proveedor, factura_url, usuario, created_at) FROM stdin;
1	2026-03-04	Pago de frutas	6.00	Gastos	CAJA_LOCAL	Freddy Coronel Vargas	/uploads/1772673134602-520412874.jpeg	Rey	2026-03-04 20:12:14.609581
2	2026-03-04	Pago de Cocos	150.00	Gastos	CAJA_LOCAL	Doris Margoth Cely Olaya	/uploads/1772673232562-986890902.jpeg	Rey	2026-03-04 20:13:52.565684
3	2026-03-02	Pago cocos	125.00	gastos	CAJA_LOCAL	Doris Margoth Cely Olaya	/uploads/1772673579142-698111152.jpg	Rey	2026-03-04 20:19:39.160418
4	2026-03-02	Pago etiquetas	50.00	gastos	CAJA_LOCAL	Cristhian Morocho Jaramillo	/uploads/1772673733823-205151615.jpg	Rey	2026-03-04 20:22:13.825451
5	2026-03-02	Pago cocos	25.00	gastos	CAJA_LOCAL	Doris Margoth Cely Olaya	/uploads/1772674143662-306223963.jpg	Rey	2026-03-04 20:29:03.665288
6	2026-03-03	Pago de fundas	4.05	gastos	CAJA_LOCAL	PLASTIQUIMIA	/uploads/1772674286720-621643054.jpg	Rey	2026-03-04 20:31:26.723085
7	2026-03-03	Compras para merienda	3.35	gastos	CAJA_LOCAL	idk	\N	Rey	2026-03-04 20:32:11.883435
8	2026-03-03	Compra fundas Basura y tipo camiseta	3.00	gastos	CAJA_LOCAL	idk	\N	Rey	2026-03-04 20:32:44.100048
\.


--
-- Data for Name: insumos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insumos (id, nombre, stock_actual, unidad_medida, stock_minimo) FROM stdin;
8	CaÃ±a Manabita	11231.610	ML	5.000
6	CafÃ© Soluble Manuelito	50.000	GR	5.000
10	Pan de Yuca (Crudo/Congelado)	0.000	UND	5.000
3	Crema de ArÃ¡ndanos (PorciÃ³n)	21.000	UND	5.000
7	Zumo de LimÃ³n	4978.000	ML	5.000
18	Whisky	174.730	ML	0.000
11	Pipa de Coco (Entera)	18.000	UND	5.000
2	Crema de PiÃ±a (PorciÃ³n)	19.000	UND	5.000
1	Crema de Coco (PorciÃ³n)	31.000	UND	5.000
5	Hielo	1942.000	ML	5.000
4	Agua Purificada	6045.380	ML	4.000
9	Jugo de CaÃ±a	12.000	UND	5.000
16	Agua de Coco	0.000	UND	0.000
17	Agua sin gas	10.000	UND	0.000
19	Ron	499.000	ML	0.000
\.


--
-- Data for Name: mesas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mesas (id, nombre, estado) FROM stdin;
\.


--
-- Data for Name: movimientos_inventario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movimientos_inventario (id, insumo_id, tipo, cantidad, unidad_medida, motivo, referencia, usuario, fecha) FROM stdin;
1	1	EGRESO	1.000	UND	perdida	1	Admin	2026-02-12 11:18:01.75927
2	1	INGRESO	5.000	UND	nuevo ingreso	alex	Rey	2026-02-12 11:20:20.749783
3	11	INGRESO	30.000	UND	inreso	1202	Alex	2026-02-12 13:14:24.737002
4	11	EGRESO	65.000	UND	perdida	1202	Alex	2026-02-12 13:14:59.058285
5	1	TRANSFORMACION_SALIDA	2.000	UND	smoothie	2	Rey	2026-02-12 13:22:44.988097
6	2	TRANSFORMACION_ENTRADA	4.000	UND	smoothie	2	Rey	2026-02-12 13:22:44.988097
7	10	EGRESO	5.000	UND	VENTA	VENTA:6	Rey	2026-02-23 13:45:23.582408
8	1	EGRESO	1.000	UND	VENTA	VENTA:6	Rey	2026-02-23 13:45:23.582408
9	2	EGRESO	1.000	UND	VENTA	VENTA:6	Rey	2026-02-23 13:45:23.582408
10	5	EGRESO	1.000	KG	VENTA	VENTA:6	Rey	2026-02-23 13:45:23.582408
11	4	EGRESO	1.000	ML	VENTA	VENTA:6	Rey	2026-02-23 13:45:23.582408
98	16	EGRESO	4.000	UND	VENTA	VENTA:38	Rey	2026-02-23 21:09:05.511735
99	1	EGRESO	2.000	UND	VENTA	VENTA:38	Rey	2026-02-23 21:09:05.511735
100	2	EGRESO	1.000	UND	VENTA	VENTA:38	Rey	2026-02-23 21:09:05.511735
101	5	EGRESO	2.000	KG	VENTA	VENTA:38	Rey	2026-02-23 21:09:05.511735
102	4	EGRESO	59.140	ML	VENTA	VENTA:38	Rey	2026-02-23 21:09:05.511735
103	3	EGRESO	1.000	UND	VENTA	VENTA:38	Rey	2026-02-23 21:09:05.511735
104	11	EGRESO	1.000	UND	VENTA	VENTA:39	Rey	2026-02-23 21:20:21.034891
105	11	EGRESO	2.000	UND	VENTA	VENTA:40	Rey	2026-02-23 21:22:49.15548
106	16	INGRESO	12.000	UND	ingreso alex	2302	Rey	2026-02-23 21:25:23.424774
111	1	EGRESO	1.000	UND	VENTA	VENTA:43	Rey	2026-02-23 21:29:13.561407
112	5	EGRESO	1.000	KG	VENTA	VENTA:43	Rey	2026-02-23 21:29:13.561407
113	4	EGRESO	29.570	ML	VENTA	VENTA:43	Rey	2026-02-23 21:29:13.561407
114	11	EGRESO	1.000	UND	VENTA	VENTA:44	Rey	2026-02-23 21:41:07.360208
115	16	EGRESO	1.000	UND	VENTA	VENTA:44	Rey	2026-02-23 21:41:07.360208
116	9	EGRESO	1.000	UND	VENTA	VENTA:30	Rey	2026-02-23 21:46:48.630693
117	17	EGRESO	1.000	UND	VENTA	VENTA:30	Rey	2026-02-23 21:46:48.630693
118	11	EGRESO	1.000	UND	VENTA	VENTA:22	Rey	2026-02-23 21:47:40.305757
119	9	EGRESO	3.000	UND	VENTA	VENTA:22	Rey	2026-02-23 21:47:40.305757
39	1	EGRESO	2.000	UND	VENTA	VENTA:16	Rey	2026-02-23 14:00:30.935623
40	5	EGRESO	3.000	KG	VENTA	VENTA:16	Rey	2026-02-23 14:00:30.935623
41	4	EGRESO	3.000	ML	VENTA	VENTA:16	Rey	2026-02-23 14:00:30.935623
42	3	EGRESO	1.000	UND	VENTA	VENTA:16	Rey	2026-02-23 14:00:30.935623
43	9	EGRESO	4.000	UND	VENTA	VENTA:17	Rey	2026-02-23 14:04:11.869448
44	1	EGRESO	4.000	UND	VENTA	VENTA:18	Rey	2026-02-23 14:05:45.444656
45	5	EGRESO	4.000	KG	VENTA	VENTA:18	Rey	2026-02-23 14:05:45.444656
46	4	EGRESO	118.280	ML	VENTA	VENTA:18	Rey	2026-02-23 14:05:45.444656
120	16	EGRESO	2.000	UND	VENTA	VENTA:22	Rey	2026-02-23 21:47:40.305757
121	11	EGRESO	3.000	UND	VENTA	VENTA:46	Rey	2026-02-23 22:08:08.502655
49	1	EGRESO	3.000	UND	VENTA	VENTA:21	Rey	2026-02-23 18:03:21.894925
50	5	EGRESO	3.000	KG	VENTA	VENTA:21	Rey	2026-02-23 18:03:21.894925
51	4	EGRESO	88.710	ML	VENTA	VENTA:21	Rey	2026-02-23 18:03:21.894925
122	16	EGRESO	1.000	UND	VENTA	VENTA:45	Rey	2026-02-23 22:09:21.377046
123	2	EGRESO	1.000	UND	VENTA	VENTA:47	Rey	2026-02-23 22:15:14.497914
124	1	EGRESO	1.000	UND	VENTA	VENTA:47	Rey	2026-02-23 22:15:14.497914
125	5	EGRESO	1.000	KG	VENTA	VENTA:47	Rey	2026-02-23 22:15:14.497914
61	11	INGRESO	25.000	UND	Ingreso inventario	23/02	Rey	2026-02-23 18:14:25.765594
62	1	EGRESO	1.000	UND	VENTA	VENTA:23	Rey	2026-02-23 18:34:48.276024
63	5	EGRESO	1.000	KG	VENTA	VENTA:23	Rey	2026-02-23 18:34:48.276024
64	4	EGRESO	29.570	ML	VENTA	VENTA:23	Rey	2026-02-23 18:34:48.276024
126	4	EGRESO	29.570	ML	VENTA	VENTA:47	Rey	2026-02-23 22:15:14.497914
127	11	EGRESO	1.000	UND	VENTA	VENTA:48	Rey	2026-02-23 22:34:22.149147
128	16	EGRESO	1.000	UND	VENTA	VENTA:50	Rey	2026-02-23 23:04:41.086451
129	3	INGRESO	3.000	UND	ingreso	2302	Rey	2026-02-23 23:06:37.316627
130	1	INGRESO	3.000	UND	ingreso venta	2402	Rey	2026-02-24 15:58:02.478535
131	11	EGRESO	1.000	UND	VENTA	VENTA:52	Rey	2026-02-24 16:30:31.564755
132	9	EGRESO	1.000	UND	VENTA	VENTA:52	Rey	2026-02-24 16:30:31.564755
133	3	EGRESO	1.000	UND	VENTA	VENTA:51	Rey	2026-02-24 16:35:30.78649
134	1	EGRESO	2.000	UND	VENTA	VENTA:51	Rey	2026-02-24 16:35:30.78649
135	5	EGRESO	2.000	UND	VENTA	VENTA:51	Rey	2026-02-24 16:35:30.78649
136	4	EGRESO	59.140	ML	VENTA	VENTA:51	Rey	2026-02-24 16:35:30.78649
137	2	EGRESO	1.000	UND	VENTA	VENTA:51	Rey	2026-02-24 16:35:30.78649
138	8	EGRESO	1.000	ML	VENTA	VENTA:51	Rey	2026-02-24 16:35:30.78649
139	11	EGRESO	1.000	UND	VENTA	VENTA:53	Rey	2026-02-24 16:38:59.604662
79	17	EGRESO	2.000	UND	VENTA	VENTA:20	Rey	2026-02-23 20:19:58.802213
80	1	EGRESO	1.000	UND	VENTA	VENTA:28	Rey	2026-02-23 20:28:13.536023
81	5	EGRESO	1.000	KG	VENTA	VENTA:28	Rey	2026-02-23 20:28:13.536023
82	4	EGRESO	29.570	ML	VENTA	VENTA:28	Rey	2026-02-23 20:28:13.536023
83	16	EGRESO	1.000	UND	VENTA	VENTA:29	Rey	2026-02-23 20:30:54.702897
140	3	EGRESO	1.000	UND	VENTA	VENTA:54	Rey	2026-02-24 16:42:54.669729
141	1	EGRESO	1.000	UND	VENTA	VENTA:54	Rey	2026-02-24 16:42:54.669729
142	5	EGRESO	1.000	UND	VENTA	VENTA:54	Rey	2026-02-24 16:42:54.669729
143	4	EGRESO	29.570	ML	VENTA	VENTA:54	Rey	2026-02-24 16:42:54.669729
144	17	EGRESO	1.000	UND	VENTA	VENTA:54	Rey	2026-02-24 16:42:54.669729
89	1	EGRESO	1.000	UND	VENTA	VENTA:31	Rey	2026-02-23 21:01:58.403278
90	2	EGRESO	1.000	UND	VENTA	VENTA:31	Rey	2026-02-23 21:01:58.403278
91	5	EGRESO	1.000	KG	VENTA	VENTA:31	Rey	2026-02-23 21:01:58.403278
92	4	EGRESO	29.570	ML	VENTA	VENTA:31	Rey	2026-02-23 21:01:58.403278
145	11	EGRESO	1.000	UND	VENTA	VENTA:56	Rey	2026-02-24 17:31:49.24857
148	1	INGRESO	3.000	UND	ingreso venta	2402	Rey	2026-02-24 17:34:29.312672
149	16	EGRESO	1.000	UND	VENTA	VENTA:58	Rey	2026-02-24 17:51:08.247721
150	9	EGRESO	1.000	UND	VENTA	VENTA:59	Rey	2026-02-24 17:51:19.145846
157	3	EGRESO	3.000	UND	VENTA	VENTA:63	Rey	2026-02-24 18:09:32.559115
158	1	EGRESO	3.000	UND	VENTA	VENTA:63	Rey	2026-02-24 18:09:32.559115
159	5	EGRESO	3.000	ML	VENTA	VENTA:63	Rey	2026-02-24 18:09:32.559115
160	4	EGRESO	88.710	ML	VENTA	VENTA:63	Rey	2026-02-24 18:09:32.559115
161	16	EGRESO	2.000	UND	VENTA	VENTA:64	Rey	2026-02-24 18:15:02.304594
162	9	EGRESO	2.000	UND	VENTA	VENTA:64	Rey	2026-02-24 18:15:02.304594
163	1	INGRESO	3.000	UND	PRUEBA	\N	Rey	2026-02-24 18:20:29.080405
165	3	EGRESO	3.000	UND	VENTA	VENTA:66	Rey	2026-02-24 18:21:28.239586
166	1	EGRESO	3.000	UND	VENTA	VENTA:66	Rey	2026-02-24 18:21:28.239586
167	5	EGRESO	3.000	ML	VENTA	VENTA:66	Rey	2026-02-24 18:21:28.239586
168	4	EGRESO	88.710	ML	VENTA	VENTA:66	Rey	2026-02-24 18:21:28.239586
169	16	EGRESO	4.000	UND	VENTA	VENTA:67	Rey	2026-02-24 18:32:05.811226
170	11	EGRESO	1.000	UND	VENTA	VENTA:68	Rey	2026-02-24 18:34:52.0494
461	1	EGRESO	2.000	UND	VENTA	VENTA:235	Rey	2026-03-01 17:42:30.407103
462	9	EGRESO	1.000	UND	VENTA	VENTA:235	Rey	2026-03-01 17:42:30.407103
463	5	EGRESO	1.000	ML	VENTA	VENTA:235	Rey	2026-03-01 17:42:30.407103
174	1	INGRESO	1.000	UND	ingreso venta	\N	Rey	2026-02-24 19:04:52.215279
175	2	EGRESO	1.000	UND	VENTA	VENTA:73	Rey	2026-02-24 19:05:00.615265
176	1	EGRESO	1.000	UND	VENTA	VENTA:73	Rey	2026-02-24 19:05:00.615265
177	5	EGRESO	1.000	ML	VENTA	VENTA:73	Rey	2026-02-24 19:05:00.615265
178	4	EGRESO	29.570	ML	VENTA	VENTA:73	Rey	2026-02-24 19:05:00.615265
179	16	EGRESO	1.000	UND	VENTA	VENTA:73	Rey	2026-02-24 19:05:00.615265
180	11	EGRESO	1.000	UND	VENTA	VENTA:75	Rey	2026-02-24 19:35:38.922849
181	9	EGRESO	1.000	UND	VENTA	VENTA:76	Rey	2026-02-24 19:39:56.415695
182	1	INGRESO	2.000	UND	ingreso por venta	2402	Rey	2026-02-24 19:49:30.852954
183	11	EGRESO	1.000	UND	VENTA	VENTA:78	Rey	2026-02-24 19:52:07.944925
184	16	INGRESO	17.000	UND	ingreso desde bodega	2402	Rey	2026-02-24 20:04:13.044782
185	11	EGRESO	1.000	UND	VENTA	VENTA:80	Rey	2026-02-24 20:04:24.33906
186	16	EGRESO	2.000	UND	VENTA	VENTA:80	Rey	2026-02-24 20:04:24.33906
187	1	EGRESO	2.000	UND	VENTA	VENTA:85	Rey	2026-02-24 20:07:44.441477
188	7	EGRESO	2.000	ML	VENTA	VENTA:85	Rey	2026-02-24 20:07:44.441477
189	11	EGRESO	1.000	UND	VENTA	VENTA:86	Rey	2026-02-24 20:23:47.590546
190	1	INGRESO	4.000	UND	venta	\N	Rey	2026-02-24 21:12:31.800614
466	16	INGRESO	44.000	UND	ingreso desde bodega	\N	Rey	2026-03-01 17:47:01.593731
469	11	EGRESO	3.000	UND	VENTA	VENTA:240	Rey	2026-03-01 18:00:00.643627
472	1	EGRESO	4.000	UND	VENTA	VENTA:248	Rey	2026-03-01 18:48:16.464022
473	7	EGRESO	3.000	ML	VENTA	VENTA:248	Rey	2026-03-01 18:48:16.464022
474	3	EGRESO	1.000	UND	VENTA	VENTA:248	Rey	2026-03-01 18:48:16.464022
475	5	EGRESO	1.000	ML	VENTA	VENTA:248	Rey	2026-03-01 18:48:16.464022
198	11	EGRESO	1.000	UND	VENTA	VENTA:88	Rey	2026-02-24 21:27:21.407507
199	11	EGRESO	1.000	UND	VENTA	VENTA:89	Rey	2026-02-24 21:27:31.245705
200	1	EGRESO	2.000	UND	VENTA	VENTA:90	Rey	2026-02-24 21:40:37.464351
201	2	EGRESO	1.000	UND	VENTA	VENTA:90	Rey	2026-02-24 21:40:37.464351
202	5	EGRESO	1.000	ML	VENTA	VENTA:90	Rey	2026-02-24 21:40:37.464351
203	4	EGRESO	29.570	ML	VENTA	VENTA:90	Rey	2026-02-24 21:40:37.464351
204	16	EGRESO	2.000	UND	VENTA	VENTA:90	Rey	2026-02-24 21:40:37.464351
205	7	EGRESO	1.000	ML	VENTA	VENTA:90	Rey	2026-02-24 21:40:37.464351
206	11	EGRESO	1.000	UND	VENTA	VENTA:90	Rey	2026-02-24 21:40:37.464351
207	11	EGRESO	2.000	UND	VENTA	VENTA:92	Rey	2026-02-24 21:57:41.07567
208	16	EGRESO	1.000	UND	VENTA	VENTA:93	Rey	2026-02-24 22:01:45.069288
209	11	EGRESO	2.000	UND	VENTA	VENTA:94	Rey	2026-02-24 22:05:36.804663
210	16	EGRESO	1.000	UND	VENTA	VENTA:94	Rey	2026-02-24 22:05:36.804663
211	9	EGRESO	1.000	UND	VENTA	VENTA:94	Rey	2026-02-24 22:05:36.804663
212	11	EGRESO	1.000	UND	VENTA	VENTA:95	Rey	2026-02-24 22:11:37.229491
213	9	EGRESO	1.000	UND	VENTA	VENTA:95	Rey	2026-02-24 22:11:37.229491
214	11	EGRESO	2.000	UND	VENTA	VENTA:97	Rey	2026-02-25 16:13:04.522899
215	16	EGRESO	14.000	UND	VENTA	VENTA:98	Rey	2026-02-25 17:11:17.837718
216	1	INGRESO	2.000	UND	ingreso venta	2502	Rey	2026-02-25 17:39:49.001299
217	1	EGRESO	2.000	UND	VENTA	VENTA:99	Rey	2026-02-25 17:40:09.226436
218	5	EGRESO	1.000	ML	VENTA	VENTA:99	Rey	2026-02-25 17:40:09.226436
219	7	EGRESO	1.000	ML	VENTA	VENTA:99	Rey	2026-02-25 17:40:09.226436
220	11	EGRESO	1.000	UND	VENTA	VENTA:100	Rey	2026-02-25 18:12:14.971106
221	11	INGRESO	21.000	UND	ingreso desde bodega	2502	Rey	2026-02-25 18:15:33.949842
222	11	EGRESO	1.000	UND	VENTA	VENTA:101	Rey	2026-02-25 18:17:54.103782
223	9	EGRESO	1.000	UND	VENTA	VENTA:102	Rey	2026-02-25 18:22:25.727658
224	9	INGRESO	17.000	UND	ingreso desde bodega	2502	Rey	2026-02-25 18:23:27.823017
225	16	INGRESO	92.000	UND	ingreso desde bodega	2502	Rey	2026-02-25 18:36:26.987332
226	11	EGRESO	2.000	UND	VENTA	VENTA:103	Rey	2026-02-25 18:53:45.612011
227	16	EGRESO	20.000	UND	VENTA	VENTA:104	Rey	2026-02-25 18:54:28.245325
228	16	EGRESO	5.000	UND	VENTA	VENTA:105	Rey	2026-02-25 19:06:26.557225
229	11	EGRESO	1.000	UND	VENTA	VENTA:106	Rey	2026-02-25 19:24:52.722124
230	1	INGRESO	9.000	UND	ingreso crema	2502	Rey	2026-02-25 19:47:16.932419
231	2	INGRESO	4.000	UND	ingreso	2502	Rey	2026-02-25 20:28:11.710128
232	11	EGRESO	1.000	UND	VENTA	VENTA:107	Rey	2026-02-25 20:39:52.284585
233	1	EGRESO	1.000	UND	VENTA	VENTA:108	Rey	2026-02-25 20:40:02.331884
234	7	EGRESO	1.000	ML	VENTA	VENTA:108	Rey	2026-02-25 20:40:02.331884
235	2	EGRESO	1.000	UND	VENTA	VENTA:109	Rey	2026-02-25 20:46:05.493535
236	1	EGRESO	1.000	UND	VENTA	VENTA:109	Rey	2026-02-25 20:46:05.493535
237	5	EGRESO	1.000	ML	VENTA	VENTA:109	Rey	2026-02-25 20:46:05.493535
238	4	EGRESO	29.570	ML	VENTA	VENTA:109	Rey	2026-02-25 20:46:05.493535
239	19	EGRESO	1.000	ML	VENTA	VENTA:109	Rey	2026-02-25 20:46:05.493535
240	16	EGRESO	3.000	UND	VENTA	VENTA:110	Rey	2026-02-25 20:48:22.654839
243	11	EGRESO	1.000	UND	pipa daÃ±ada	2502	Rey	2026-02-25 20:58:42.288099
244	11	EGRESO	1.000	UND	VENTA	VENTA:112	Rey	2026-02-25 21:00:51.117264
245	11	EGRESO	2.000	UND	VENTA	VENTA:114	Rey	2026-02-25 21:06:46.628949
246	11	EGRESO	1.000	UND	VENTA	VENTA:115	Rey	2026-02-25 21:06:52.347883
247	11	EGRESO	2.000	UND	VENTA	VENTA:116	Rey	2026-02-25 21:16:44.396752
248	3	EGRESO	1.000	UND	VENTA	VENTA:118	Rey	2026-02-25 21:16:59.723785
249	1	EGRESO	1.000	UND	VENTA	VENTA:118	Rey	2026-02-25 21:16:59.723785
250	5	EGRESO	1.000	ML	VENTA	VENTA:118	Rey	2026-02-25 21:16:59.723785
251	4	EGRESO	29.570	ML	VENTA	VENTA:118	Rey	2026-02-25 21:16:59.723785
253	11	EGRESO	1.000	UND	VENTA	VENTA:120	Rey	2026-02-25 21:31:09.600036
254	9	EGRESO	2.000	UND	VENTA	VENTA:121	Rey	2026-02-25 21:43:06.488332
255	11	EGRESO	1.000	UND	VENTA	VENTA:122	Rey	2026-02-25 21:59:06.277754
256	16	EGRESO	2.000	UND	VENTA	VENTA:124	Rey	2026-02-25 22:02:48.317937
257	11	EGRESO	1.000	UND	VENTA	VENTA:125	Rey	2026-02-25 22:03:17.389335
258	11	EGRESO	2.000	UND	VENTA	VENTA:126	Rey	2026-02-25 22:07:44.531029
259	11	EGRESO	1.000	UND	VENTA	VENTA:127	Rey	2026-02-25 22:16:16.4175
260	16	EGRESO	4.000	UND	VENTA	VENTA:129	Rey	2026-02-25 22:39:44.89953
261	16	EGRESO	1.000	UND	VENTA	VENTA:130	Rey	2026-02-25 22:40:36.226837
262	11	EGRESO	1.000	UND	VENTA	VENTA:128	Rey	2026-02-25 22:52:52.856223
263	16	EGRESO	1.000	UND	VENTA	VENTA:128	Rey	2026-02-25 22:52:52.856223
265	16	EGRESO	2.000	UND	VENTA	VENTA:132	Rey	2026-02-25 23:35:42.031916
269	16	EGRESO	1.000	UND	VENTA	VENTA:134	Rey	2026-02-26 16:32:54.312281
270	2	INGRESO	16.000	UND	ingreso desde bodega	2602	Rey	2026-02-26 16:33:39.511053
271	11	INGRESO	26.000	UND	ingreso desde bodega	2602	Rey	2026-02-26 16:45:45.58545
272	1	INGRESO	30.000	UND	ingreso desde bodega	2602	Rey	2026-02-26 17:24:12.390715
273	16	EGRESO	30.000	UND	VENTA	VENTA:137	Rey	2026-02-26 17:33:39.432224
464	11	EGRESO	2.000	UND	VENTA	VENTA:236	Rey	2026-03-01 17:42:43.65379
467	9	INGRESO	12.000	UND	ingreso desde bodega	\N	Rey	2026-03-01 17:47:28.835891
470	16	EGRESO	1.000	UND	VENTA	VENTA:242	Rey	2026-03-01 18:13:26.28313
283	2	EGRESO	1.000	UND	VENTA	VENTA:139	Rey	2026-02-26 18:42:06.565682
284	1	EGRESO	2.000	UND	VENTA	VENTA:139	Rey	2026-02-26 18:42:06.565682
285	5	EGRESO	2.000	ML	VENTA	VENTA:139	Rey	2026-02-26 18:42:06.565682
286	4	EGRESO	59.140	ML	VENTA	VENTA:139	Rey	2026-02-26 18:42:06.565682
287	3	EGRESO	1.000	UND	VENTA	VENTA:139	Rey	2026-02-26 18:42:06.565682
476	4	EGRESO	29.570	ML	VENTA	VENTA:248	Rey	2026-03-01 18:48:16.464022
478	1	INGRESO	1.000	UND	imgreso venta	0103	Rey	2026-03-01 19:17:56.264142
480	1	EGRESO	1.000	UND	VENTA	VENTA:252	Rey	2026-03-01 19:18:04.366678
481	5	EGRESO	1.000	ML	VENTA	VENTA:252	Rey	2026-03-01 19:18:04.366678
292	1	EGRESO	1.000	UND	VENTA	VENTA:133	Rey	2026-02-26 18:42:32.11905
293	5	EGRESO	1.000	ML	VENTA	VENTA:133	Rey	2026-02-26 18:42:32.11905
294	9	EGRESO	1.000	UND	VENTA	VENTA:133	Rey	2026-02-26 18:42:32.11905
482	11	EGRESO	1.000	UND	VENTA	VENTA:252	Rey	2026-03-01 19:18:04.366678
296	16	EGRESO	3.000	UND	VENTA	VENTA:140	Rey	2026-02-26 19:09:15.336341
297	11	EGRESO	2.000	UND	VENTA	VENTA:141	Rey	2026-02-26 19:16:11.969646
298	11	EGRESO	1.000	UND	VENTA	VENTA:142	Rey	2026-02-26 19:19:30.328816
484	11	EGRESO	2.000	UND	VENTA	VENTA:253	Rey	2026-03-01 19:28:39.374842
302	16	EGRESO	7.000	UND	Reposicion venta Velur plaza (estaban daÃ±adas)	2602	Rey	2026-02-26 19:21:32.189798
491	16	EGRESO	2.000	UND	VENTA	VENTA:260	Rey	2026-03-01 19:55:30.640598
304	11	EGRESO	4.000	UND	VENTA	VENTA:119	Rey	2026-02-26 19:23:22.717935
305	17	EGRESO	1.000	UND	VENTA	VENTA:144	Rey	2026-02-26 19:42:39.29008
306	16	EGRESO	1.000	UND	VENTA	VENTA:144	Rey	2026-02-26 19:42:39.29008
494	11	INGRESO	10.000	UND	INGRESO DESDE BIDEGA ALEX	\N	Rey	2026-03-01 20:21:23.153526
496	1	EGRESO	3.000	UND	VENTA	VENTA:264	Rey	2026-03-01 20:36:35.476167
497	5	EGRESO	1.000	ML	VENTA	VENTA:264	Rey	2026-03-01 20:36:35.476167
498	7	EGRESO	2.000	ML	VENTA	VENTA:264	Rey	2026-03-01 20:36:35.476167
311	16	EGRESO	1.000	UND	VENTA	VENTA:153	Rey	2026-02-26 19:58:54.110438
312	11	EGRESO	2.000	UND	VENTA	VENTA:154	Rey	2026-02-26 20:16:45.99235
313	8	EGRESO	325.270	ML	VENTA	VENTA:154	Rey	2026-02-26 20:16:45.99235
314	16	EGRESO	2.000	UND	VENTA	VENTA:154	Rey	2026-02-26 20:16:45.99235
315	9	EGRESO	1.000	UND	VENTA	VENTA:155	Rey	2026-02-26 20:35:46.313593
316	16	EGRESO	1.000	UND	VENTA	VENTA:155	Rey	2026-02-26 20:35:46.313593
317	11	EGRESO	1.000	UND	VENTA	VENTA:156	Rey	2026-02-26 20:39:02.973911
318	8	EGRESO	162.635	ML	VENTA	VENTA:156	Rey	2026-02-26 20:39:02.973911
319	11	EGRESO	1.000	UND	VENTA	VENTA:157	Rey	2026-02-26 20:40:08.77052
320	1	EGRESO	2.000	UND	VENTA	VENTA:159	Rey	2026-02-26 21:05:32.870947
321	2	EGRESO	1.000	UND	VENTA	VENTA:159	Rey	2026-02-26 21:05:32.870947
322	5	EGRESO	2.000	ML	VENTA	VENTA:159	Rey	2026-02-26 21:05:32.870947
323	4	EGRESO	29.570	ML	VENTA	VENTA:159	Rey	2026-02-26 21:05:32.870947
324	11	EGRESO	2.000	UND	VENTA	VENTA:161	Rey	2026-02-26 21:41:56.030148
325	11	EGRESO	4.000	UND	VENTA	VENTA:162	Rey	2026-02-26 21:43:51.095846
326	8	EGRESO	650.540	ML	VENTA	VENTA:162	Rey	2026-02-26 21:43:51.095846
327	9	EGRESO	2.000	UND	VENTA	VENTA:143	Rey	2026-02-26 22:03:06.794017
328	1	EGRESO	1.000	UND	VENTA	VENTA:136	Rey	2026-02-26 22:03:15.444769
329	2	EGRESO	1.000	UND	VENTA	VENTA:136	Rey	2026-02-26 22:03:15.444769
330	5	EGRESO	1.000	ML	VENTA	VENTA:136	Rey	2026-02-26 22:03:15.444769
331	4	EGRESO	29.570	ML	VENTA	VENTA:136	Rey	2026-02-26 22:03:15.444769
332	1	EGRESO	1.000	UND	VENTA	VENTA:164	Rey	2026-02-26 22:09:16.366438
333	7	EGRESO	1.000	ML	VENTA	VENTA:164	Rey	2026-02-26 22:09:16.366438
334	16	EGRESO	4.000	UND	VENTA	VENTA:164	Rey	2026-02-26 22:09:16.366438
335	16	EGRESO	1.000	UND	VENTA	VENTA:165	Rey	2026-02-26 22:13:32.723177
336	16	EGRESO	1.000	UND	VENTA	VENTA:167	Rey	2026-02-26 23:09:22.357502
337	9	EGRESO	5.000	UND	VENTA	VENTA:169	Rey	2026-02-26 23:48:40.754916
338	1	EGRESO	3.000	UND	VENTA	VENTA:171	Rey	2026-02-28 16:54:18.291396
339	5	EGRESO	2.000	ML	VENTA	VENTA:171	Rey	2026-02-28 16:54:18.291396
340	4	EGRESO	59.140	ML	VENTA	VENTA:171	Rey	2026-02-28 16:54:18.291396
341	7	EGRESO	1.000	ML	VENTA	VENTA:171	Rey	2026-02-28 16:54:18.291396
342	9	EGRESO	2.000	UND	VENTA	VENTA:172	Rey	2026-02-28 16:54:51.023618
343	11	INGRESO	32.000	UND	ingreso desde bodega	2802	Rey	2026-02-28 16:57:30.598829
344	9	EGRESO	1.000	UND	VENTA	VENTA:173	Rey	2026-02-28 17:05:07.616667
345	8	EGRESO	118.280	ML	VENTA	VENTA:173	Rey	2026-02-28 17:05:07.616667
346	2	EGRESO	1.000	UND	VENTA	VENTA:174	Rey	2026-02-28 17:11:34.121971
347	1	EGRESO	1.000	UND	VENTA	VENTA:174	Rey	2026-02-28 17:11:34.121971
348	5	EGRESO	1.000	ML	VENTA	VENTA:174	Rey	2026-02-28 17:11:34.121971
349	4	EGRESO	29.570	ML	VENTA	VENTA:174	Rey	2026-02-28 17:11:34.121971
350	11	EGRESO	1.000	UND	VENTA	VENTA:174	Rey	2026-02-28 17:11:34.121971
351	2	EGRESO	2.000	UND	VENTA	VENTA:175	Rey	2026-02-28 17:34:32.894542
352	1	EGRESO	4.000	UND	VENTA	VENTA:175	Rey	2026-02-28 17:34:32.894542
353	5	EGRESO	4.000	ML	VENTA	VENTA:175	Rey	2026-02-28 17:34:32.894542
354	4	EGRESO	118.280	ML	VENTA	VENTA:175	Rey	2026-02-28 17:34:32.894542
355	3	EGRESO	2.000	UND	VENTA	VENTA:175	Rey	2026-02-28 17:34:32.894542
356	16	EGRESO	1.000	UND	VENTA	VENTA:175	Rey	2026-02-28 17:34:32.894542
357	11	EGRESO	2.000	UND	VENTA	VENTA:178	Rey	2026-02-28 18:22:29.926135
358	2	EGRESO	2.000	UND	VENTA	VENTA:179	Rey	2026-02-28 18:33:11.470906
359	1	EGRESO	2.000	UND	VENTA	VENTA:179	Rey	2026-02-28 18:33:11.470906
360	5	EGRESO	2.000	ML	VENTA	VENTA:179	Rey	2026-02-28 18:33:11.470906
361	4	EGRESO	59.140	ML	VENTA	VENTA:179	Rey	2026-02-28 18:33:11.470906
362	16	EGRESO	1.000	UND	VENTA	VENTA:179	Rey	2026-02-28 18:33:11.470906
363	1	EGRESO	3.000	UND	VENTA	VENTA:180	Rey	2026-02-28 19:17:04.979049
364	5	EGRESO	3.000	ML	VENTA	VENTA:180	Rey	2026-02-28 19:17:04.979049
365	11	EGRESO	3.000	UND	VENTA	VENTA:182	Rey	2026-02-28 19:43:55.511468
366	8	EGRESO	487.905	ML	VENTA	VENTA:182	Rey	2026-02-28 19:43:55.511468
367	9	EGRESO	2.000	UND	VENTA	VENTA:183	Rey	2026-02-28 19:44:01.837154
368	16	EGRESO	2.000	UND	VENTA	VENTA:185	Rey	2026-02-28 20:41:29.460527
369	1	EGRESO	1.000	UND	VENTA	VENTA:186	Rey	2026-02-28 20:46:35.432792
370	7	EGRESO	1.000	ML	VENTA	VENTA:186	Rey	2026-02-28 20:46:35.432792
371	9	EGRESO	1.000	UND	VENTA	VENTA:186	Rey	2026-02-28 20:46:35.432792
372	11	EGRESO	1.000	UND	VENTA	VENTA:187	Rey	2026-02-28 21:04:39.464543
373	1	EGRESO	1.000	UND	VENTA	VENTA:187	Rey	2026-02-28 21:04:39.464543
374	2	EGRESO	1.000	UND	VENTA	VENTA:187	Rey	2026-02-28 21:04:39.464543
375	5	EGRESO	1.000	ML	VENTA	VENTA:187	Rey	2026-02-28 21:04:39.464543
376	4	EGRESO	29.570	ML	VENTA	VENTA:187	Rey	2026-02-28 21:04:39.464543
377	11	EGRESO	1.000	UND	VENTA	VENTA:188	Rey	2026-02-28 21:04:44.771562
378	8	EGRESO	162.635	ML	VENTA	VENTA:188	Rey	2026-02-28 21:04:44.771562
379	11	EGRESO	2.000	UND	VENTA	VENTA:189	Rey	2026-02-28 21:04:49.08029
380	1	EGRESO	1.000	UND	VENTA	VENTA:190	Rey	2026-02-28 21:09:05.417206
381	5	EGRESO	1.000	ML	VENTA	VENTA:190	Rey	2026-02-28 21:09:05.417206
382	4	EGRESO	29.570	ML	VENTA	VENTA:190	Rey	2026-02-28 21:09:05.417206
383	11	EGRESO	1.000	UND	VENTA	VENTA:190	Rey	2026-02-28 21:09:05.417206
384	1	EGRESO	1.000	UND	VENTA	VENTA:192	Rey	2026-02-28 21:27:35.399724
385	7	EGRESO	1.000	ML	VENTA	VENTA:192	Rey	2026-02-28 21:27:35.399724
386	16	EGRESO	1.000	UND	VENTA	VENTA:193	Rey	2026-02-28 21:29:08.215708
387	9	EGRESO	1.000	UND	VENTA	VENTA:194	Rey	2026-02-28 21:45:00.336961
388	8	EGRESO	118.280	ML	VENTA	VENTA:194	Rey	2026-02-28 21:45:00.336961
389	16	EGRESO	1.000	UND	VENTA	VENTA:194	Rey	2026-02-28 21:45:00.336961
390	9	EGRESO	2.000	UND	VENTA	VENTA:195	Rey	2026-02-28 21:50:16.821203
391	8	EGRESO	236.560	ML	VENTA	VENTA:195	Rey	2026-02-28 21:50:16.821203
392	11	EGRESO	1.000	UND	VENTA	VENTA:196	Rey	2026-02-28 21:51:11.884117
393	8	EGRESO	162.635	ML	VENTA	VENTA:196	Rey	2026-02-28 21:51:11.884117
394	16	EGRESO	1.000	UND	VENTA	VENTA:197	Rey	2026-02-28 22:00:25.98113
395	9	EGRESO	1.000	UND	VENTA	VENTA:198	Rey	2026-02-28 22:28:02.782855
396	8	EGRESO	118.280	ML	VENTA	VENTA:198	Rey	2026-02-28 22:28:02.782855
397	9	EGRESO	2.000	UND	VENTA	VENTA:199	Rey	2026-02-28 22:30:49.416301
398	16	EGRESO	2.000	UND	VENTA	VENTA:199	Rey	2026-02-28 22:30:49.416301
399	9	EGRESO	2.000	UND	VENTA	VENTA:200	Rey	2026-02-28 22:34:04.288083
400	11	EGRESO	1.000	UND	VENTA	VENTA:201	Rey	2026-02-28 22:36:07.392629
401	16	EGRESO	1.000	UND	VENTA	VENTA:203	Rey	2026-02-28 22:40:22.871838
402	11	EGRESO	1.000	UND	VENTA	VENTA:204	Rey	2026-02-28 22:47:23.003873
403	8	EGRESO	162.635	ML	VENTA	VENTA:204	Rey	2026-02-28 22:47:23.003873
404	9	EGRESO	1.000	UND	VENTA	VENTA:205	Rey	2026-02-28 22:47:33.967914
405	9	EGRESO	1.000	UND	VENTA	VENTA:206	Rey	2026-02-28 22:48:54.820519
406	11	EGRESO	1.000	UND	VENTA	VENTA:207	Rey	2026-02-28 23:24:58.612734
407	8	EGRESO	162.635	ML	VENTA	VENTA:207	Rey	2026-02-28 23:24:58.612734
408	9	EGRESO	1.000	UND	VENTA	VENTA:208	Rey	2026-02-28 23:30:07.133542
409	8	EGRESO	118.280	ML	VENTA	VENTA:208	Rey	2026-02-28 23:30:07.133542
410	1	INGRESO	2.000	UND	ingreso truco jjaa	2802	Rey	2026-03-01 16:38:47.952104
411	11	EGRESO	1.000	UND	VENTA	VENTA:209	Rey	2026-03-01 16:40:37.958776
412	1	EGRESO	2.000	UND	VENTA	VENTA:210	Rey	2026-03-01 16:41:19.284929
413	5	EGRESO	2.000	ML	VENTA	VENTA:210	Rey	2026-03-01 16:41:19.284929
414	4	EGRESO	59.140	ML	VENTA	VENTA:210	Rey	2026-03-01 16:41:19.284929
415	2	EGRESO	1.000	UND	VENTA	VENTA:210	Rey	2026-03-01 16:41:19.284929
416	1	EGRESO	1.000	UND	VENTA	VENTA:212	Rey	2026-03-01 16:42:06.48609
417	5	EGRESO	1.000	ML	VENTA	VENTA:212	Rey	2026-03-01 16:42:06.48609
418	16	EGRESO	2.000	UND	VENTA	VENTA:213	Rey	2026-03-01 16:57:56.439683
465	11	EGRESO	1.000	UND	VENTA	VENTA:237	Rey	2026-03-01 17:42:51.806377
468	16	EGRESO	7.000	UND	VENTA	VENTA:238	Rey	2026-03-01 17:48:22.582492
471	1	INGRESO	4.000	UND	ingreso x venta	0103	Rey	2026-03-01 18:40:27.268961
477	11	EGRESO	2.000	UND	VENTA	VENTA:251	Rey	2026-03-01 19:09:49.971425
479	1	INGRESO	1.000	UND	imgreso venta	0103	Rey	2026-03-01 19:17:56.940289
483	16	EGRESO	4.000	UND	VENTA	VENTA:250	Rey	2026-03-01 19:28:17.099252
489	11	EGRESO	1.000	UND	VENTA	VENTA:258	Rey	2026-03-01 19:46:27.334455
490	8	EGRESO	162.635	ML	VENTA	VENTA:258	Rey	2026-03-01 19:46:27.334455
492	9	EGRESO	1.000	UND	VENTA	VENTA:261	Rey	2026-03-01 20:13:15.285202
493	16	EGRESO	1.000	UND	VENTA	VENTA:261	Rey	2026-03-01 20:13:15.285202
495	1	INGRESO	1.000	UND	ingreso venta	\N	Rey	2026-03-01 20:27:22.618155
499	1	INGRESO	1.000	UND	ingreso venta	\N	Rey	2026-03-01 20:58:43.336948
500	1	EGRESO	1.000	UND	VENTA	VENTA:271	Rey	2026-03-01 20:58:47.211378
501	2	EGRESO	1.000	UND	VENTA	VENTA:271	Rey	2026-03-01 20:58:47.211378
502	5	EGRESO	1.000	ML	VENTA	VENTA:271	Rey	2026-03-01 20:58:47.211378
503	4	EGRESO	29.570	ML	VENTA	VENTA:271	Rey	2026-03-01 20:58:47.211378
504	11	EGRESO	1.000	UND	VENTA	VENTA:273	Rey	2026-03-01 21:11:35.878886
505	16	EGRESO	1.000	UND	VENTA	VENTA:274	Rey	2026-03-01 21:19:50.935486
506	9	EGRESO	2.000	UND	VENTA	VENTA:275	Rey	2026-03-01 21:21:20.725122
507	1	INGRESO	1.000	UND	ingreso venta	\N	Rey	2026-03-01 21:26:32.264687
508	1	EGRESO	1.000	UND	VENTA	VENTA:277	Rey	2026-03-01 21:36:41.060707
509	7	EGRESO	1.000	ML	VENTA	VENTA:277	Rey	2026-03-01 21:36:41.060707
510	16	EGRESO	1.000	UND	VENTA	VENTA:278	Rey	2026-03-01 21:36:56.08171
511	11	EGRESO	1.000	UND	VENTA	VENTA:279	Rey	2026-03-01 21:37:17.943377
512	8	EGRESO	162.635	ML	VENTA	VENTA:279	Rey	2026-03-01 21:37:17.943377
513	1	INGRESO	3.000	UND	ingresoi venta	\N	Rey	2026-03-01 21:43:10.772485
520	1	EGRESO	2.000	UND	VENTA	VENTA:280	Rey	2026-03-01 21:51:58.39288
521	2	EGRESO	1.000	UND	VENTA	VENTA:280	Rey	2026-03-01 21:51:58.39288
522	5	EGRESO	2.000	ML	VENTA	VENTA:280	Rey	2026-03-01 21:51:58.39288
523	4	EGRESO	59.140	ML	VENTA	VENTA:280	Rey	2026-03-01 21:51:58.39288
524	3	EGRESO	1.000	UND	VENTA	VENTA:280	Rey	2026-03-01 21:51:58.39288
525	11	EGRESO	1.000	UND	VENTA	VENTA:281	Rey	2026-03-01 21:52:10.715077
526	1	EGRESO	1.000	UND	VENTA	VENTA:282	Rey	2026-03-01 22:21:21.877873
527	3	EGRESO	1.000	UND	VENTA	VENTA:282	Rey	2026-03-01 22:21:21.877873
528	5	EGRESO	1.000	ML	VENTA	VENTA:282	Rey	2026-03-01 22:21:21.877873
529	4	EGRESO	29.570	ML	VENTA	VENTA:282	Rey	2026-03-01 22:21:21.877873
530	1	INGRESO	1.000	UND	VENTA	\N	Rey	2026-03-01 22:21:33.866947
531	3	EGRESO	1.000	UND	VENTA	VENTA:283	Rey	2026-03-01 22:25:28.481477
532	1	EGRESO	1.000	UND	VENTA	VENTA:283	Rey	2026-03-01 22:25:28.481477
533	5	EGRESO	1.000	ML	VENTA	VENTA:283	Rey	2026-03-01 22:25:28.481477
534	4	EGRESO	29.570	ML	VENTA	VENTA:283	Rey	2026-03-01 22:25:28.481477
535	1	INGRESO	21.000	UND	INGRESO DESDE BODEGA	\N	Rey	2026-03-01 22:25:54.071764
536	16	EGRESO	1.000	UND	VENTA	VENTA:285	Rey	2026-03-01 22:30:38.471812
537	16	EGRESO	2.000	UND	VENTA	VENTA:286	Rey	2026-03-01 22:31:24.994721
538	16	EGRESO	2.000	UND	VENTA	VENTA:288	Rey	2026-03-01 23:13:57.590856
539	16	INGRESO	41.000	UND	ingreso desde bodega	0203	Rey	2026-03-02 15:12:16.950044
540	16	EGRESO	25.000	UND	VENTA	VENTA:289	Rey	2026-03-02 15:13:56.91021
541	16	EGRESO	15.000	UND	VENTA	VENTA:290	Rey	2026-03-02 15:15:25.09292
542	9	INGRESO	25.000	UND	ingreso desde bodega	0203	Rey	2026-03-02 15:16:15.941741
544	2	EGRESO	1.000	UND	VENTA	VENTA:295	Rey	2026-03-02 15:52:37.672104
545	1	EGRESO	1.000	UND	VENTA	VENTA:295	Rey	2026-03-02 15:52:37.672104
546	5	EGRESO	1.000	ML	VENTA	VENTA:295	Rey	2026-03-02 15:52:37.672104
547	4	EGRESO	29.570	ML	VENTA	VENTA:295	Rey	2026-03-02 15:52:37.672104
548	11	EGRESO	2.000	UND	VENTA	VENTA:296	Rey	2026-03-02 17:22:39.236397
549	11	INGRESO	21.000	UND	ingreso desde bodega	0203	Rey	2026-03-02 17:34:50.639531
550	11	EGRESO	1.000	UND	VENTA	VENTA:297	Rey	2026-03-02 17:51:04.262517
551	9	EGRESO	1.000	UND	VENTA	VENTA:298	Rey	2026-03-02 17:59:22.286585
552	11	EGRESO	2.000	UND	VENTA	VENTA:299	Rey	2026-03-02 18:47:49.249054
553	16	EGRESO	5.000	UND	VENTA	VENTA:301	Rey	2026-03-02 19:12:11.397491
554	11	EGRESO	3.000	UND	VENTA	VENTA:302	Rey	2026-03-02 19:15:56.637231
555	16	EGRESO	1.000	UND	VENTA	VENTA:304	Rey	2026-03-02 19:16:34.228756
556	16	INGRESO	55.000	UND	ingreso desde bodega	0203	Rey	2026-03-02 19:37:54.250173
557	16	EGRESO	1.000	UND	VENTA	VENTA:306	Rey	2026-03-02 21:10:49.885965
558	16	EGRESO	2.000	UND	VENTA	VENTA:307	Rey	2026-03-02 21:22:33.415194
559	11	EGRESO	4.000	UND	VENTA	VENTA:308	Rey	2026-03-02 21:22:56.574605
560	9	EGRESO	25.000	UND	VENTA	VENTA:293	Rey	2026-03-02 21:29:15.209233
561	16	EGRESO	60.000	UND	VENTA	VENTA:309	Rey	2026-03-02 21:50:30.255663
562	1	EGRESO	3.000	UND	VENTA	VENTA:311	Rey	2026-03-02 21:52:02.421316
563	5	EGRESO	2.000	ML	VENTA	VENTA:311	Rey	2026-03-02 21:52:02.421316
564	4	EGRESO	59.140	ML	VENTA	VENTA:311	Rey	2026-03-02 21:52:02.421316
565	7	EGRESO	1.000	ML	VENTA	VENTA:311	Rey	2026-03-02 21:52:02.421316
566	9	EGRESO	1.000	UND	VENTA	VENTA:312	Rey	2026-03-02 21:53:10.91289
567	8	EGRESO	118.280	ML	VENTA	VENTA:312	Rey	2026-03-02 21:53:10.91289
568	9	EGRESO	2.000	UND	VENTA	VENTA:313	Rey	2026-03-02 21:55:56.233887
569	9	EGRESO	3.000	UND	VENTA	VENTA:314	Rey	2026-03-02 22:24:49.458929
570	16	EGRESO	3.000	UND	VENTA	VENTA:315	Rey	2026-03-02 22:25:09.732934
571	1	EGRESO	1.000	UND	VENTA	VENTA:316	Rey	2026-03-02 22:25:38.814018
572	2	EGRESO	1.000	UND	VENTA	VENTA:316	Rey	2026-03-02 22:25:38.814018
573	5	EGRESO	1.000	ML	VENTA	VENTA:316	Rey	2026-03-02 22:25:38.814018
574	4	EGRESO	29.570	ML	VENTA	VENTA:316	Rey	2026-03-02 22:25:38.814018
575	16	EGRESO	2.000	UND	VENTA	VENTA:317	Rey	2026-03-02 22:27:19.809604
576	11	EGRESO	2.000	UND	VENTA	VENTA:318	Rey	2026-03-02 22:35:11.481806
577	16	EGRESO	1.000	UND	VENTA	VENTA:319	Rey	2026-03-02 22:44:44.06269
578	16	EGRESO	2.000	UND	VENTA	VENTA:321	Rey	2026-03-03 17:43:51.511292
579	16	EGRESO	1.000	UND	VENTA	VENTA:322	Rey	2026-03-03 17:43:59.29886
580	11	EGRESO	1.000	UND	VENTA	VENTA:323	Rey	2026-03-03 18:31:40.857412
581	16	INGRESO	25.000	UND	ingreso desde bodega	0303	Rey	2026-03-03 18:41:45.625867
582	9	INGRESO	20.000	UND	ingreso desde bodega	0303	Rey	2026-03-03 18:42:13.235478
583	16	EGRESO	2.000	UND	VENTA	VENTA:324	Rey	2026-03-03 19:20:02.176831
584	1	EGRESO	3.000	UND	VENTA	VENTA:325	Rey	2026-03-03 19:23:27.488104
585	3	EGRESO	2.000	UND	VENTA	VENTA:325	Rey	2026-03-03 19:23:27.488104
586	5	EGRESO	3.000	ML	VENTA	VENTA:325	Rey	2026-03-03 19:23:27.488104
587	4	EGRESO	88.710	ML	VENTA	VENTA:325	Rey	2026-03-03 19:23:27.488104
588	2	EGRESO	1.000	UND	VENTA	VENTA:325	Rey	2026-03-03 19:23:27.488104
589	11	EGRESO	1.000	UND	VENTA	VENTA:325	Rey	2026-03-03 19:23:27.488104
590	16	EGRESO	3.000	UND	VENTA	VENTA:325	Rey	2026-03-03 19:23:27.488104
591	1	EGRESO	1.000	UND	VENTA	VENTA:326	Rey	2026-03-03 19:24:35.162818
592	7	EGRESO	1.000	ML	VENTA	VENTA:326	Rey	2026-03-03 19:24:35.162818
593	11	EGRESO	1.000	UND	VENTA	VENTA:326	Rey	2026-03-03 19:24:35.162818
594	1	EGRESO	4.000	UND	VENTA	VENTA:328	Rey	2026-03-03 20:47:29.288078
595	7	EGRESO	4.000	ML	VENTA	VENTA:328	Rey	2026-03-03 20:47:29.288078
596	11	EGRESO	1.000	UND	VENTA	VENTA:328	Rey	2026-03-03 20:47:29.288078
597	18	EGRESO	162.635	ML	VENTA	VENTA:328	Rey	2026-03-03 20:47:29.288078
598	17	EGRESO	1.000	UND	VENTA	VENTA:329	Rey	2026-03-03 21:05:06.360765
599	16	EGRESO	1.000	UND	VENTA	VENTA:329	Rey	2026-03-03 21:05:06.360765
600	11	EGRESO	1.000	UND	VENTA	VENTA:329	Rey	2026-03-03 21:05:06.360765
601	8	EGRESO	162.635	ML	VENTA	VENTA:329	Rey	2026-03-03 21:05:06.360765
602	1	INGRESO	5.000	UND	ingreso desde bodega	0303	Rey	2026-03-03 21:10:47.87394
603	3	INGRESO	6.000	UND	ingreso desde bodega	\N	Rey	2026-03-03 21:30:23.656593
604	1	EGRESO	1.000	UND	VENTA	VENTA:332	Rey	2026-03-03 21:30:32.532835
605	3	EGRESO	1.000	UND	VENTA	VENTA:332	Rey	2026-03-03 21:30:32.532835
606	5	EGRESO	1.000	ML	VENTA	VENTA:332	Rey	2026-03-03 21:30:32.532835
607	4	EGRESO	29.570	ML	VENTA	VENTA:332	Rey	2026-03-03 21:30:32.532835
608	5	EGRESO	1.000	ML	VENTA	VENTA:333	Rey	2026-03-03 22:14:35.330673
609	1	EGRESO	1.000	UND	VENTA	VENTA:334	Rey	2026-03-03 22:34:59.379783
610	7	EGRESO	1.000	ML	VENTA	VENTA:334	Rey	2026-03-03 22:34:59.379783
611	9	EGRESO	1.000	UND	VENTA	VENTA:335	Rey	2026-03-03 22:36:43.831112
612	11	EGRESO	1.000	UND	VENTA	VENTA:336	Rey	2026-03-03 22:52:31.632046
613	11	EGRESO	1.000	UND	VENTA	VENTA:337	Rey	2026-03-04 15:47:15.175922
614	8	EGRESO	162.635	ML	VENTA	VENTA:337	Rey	2026-03-04 15:47:15.175922
615	11	INGRESO	20.000	UND	ingreso desde bodega	0403	Rey	2026-03-04 15:47:39.11128
616	2	INGRESO	18.000	UND	ingreso desde bodega	0403	Rey	2026-03-04 15:56:48.035414
617	1	EGRESO	1.000	UND	VENTA	VENTA:338	Rey	2026-03-04 16:03:48.208848
618	5	EGRESO	1.000	ML	VENTA	VENTA:338	Rey	2026-03-04 16:03:48.208848
619	1	INGRESO	26.000	UND	ingreso desde bodega	0403	Rey	2026-03-04 18:24:21.642929
620	11	EGRESO	2.000	UND	VENTA	VENTA:341	Rey	2026-03-04 18:57:02.04808
621	11	EGRESO	1.000	UND	VENTA	VENTA:342	Rey	2026-03-04 19:18:47.864179
622	16	EGRESO	1.000	UND	VENTA	VENTA:345	Rey	2026-03-04 19:56:33.265719
623	9	EGRESO	3.000	UND	VENTA	VENTA:346	Rey	2026-03-04 19:56:48.578589
624	11	EGRESO	1.000	UND	VENTA	VENTA:347	Rey	2026-03-04 20:07:58.164246
625	11	EGRESO	1.000	UND	VENTA	VENTA:348	Rey	2026-03-04 22:30:54.662668
626	16	EGRESO	2.000	UND	VENTA	VENTA:349	Rey	2026-03-04 23:01:13.183772
627	16	EGRESO	1.000	UND	VENTA	VENTA:350	Rey	2026-03-04 23:01:24.595828
628	9	EGRESO	1.000	UND	VENTA	VENTA:350	Rey	2026-03-04 23:01:24.595828
629	11	EGRESO	5.000	UND	VENTA	VENTA:351	Rey	2026-03-04 23:40:06.679679
630	11	EGRESO	2.000	UND	VENTA	VENTA:352	Rey	2026-03-04 23:43:14.846003
631	3	INGRESO	16.000	UND	ingreso desde bodega	0403	Rey	2026-03-04 23:46:29.830044
632	11	EGRESO	1.000	UND	VENTA	VENTA:354	Rey	2026-03-04 23:50:02.873551
633	9	EGRESO	2.000	UND	VENTA	VENTA:356	Administrador	2026-03-05 22:59:53.517925
634	16	EGRESO	1.000	UND	VENTA	VENTA:358	Administrador	2026-03-05 23:00:49.716357
636	16	EGRESO	6.000	UND	VENTA	VENTA:359	Administrador	2026-03-05 23:05:39.863328
637	11	EGRESO	1.000	UND	VENTA	VENTA:361	Administrador	2026-03-05 23:08:04.75606
638	2	EGRESO	1.000	UND	VENTA	VENTA:362	Administrador	2026-03-05 23:10:08.623793
639	1	EGRESO	2.000	UND	VENTA	VENTA:362	Administrador	2026-03-05 23:10:08.623793
640	5	EGRESO	2.000	ML	VENTA	VENTA:362	Administrador	2026-03-05 23:10:08.623793
641	4	EGRESO	59.140	ML	VENTA	VENTA:362	Administrador	2026-03-05 23:10:08.623793
642	16	EGRESO	1.000	UND	VENTA	VENTA:362	Administrador	2026-03-05 23:10:08.623793
643	11	EGRESO	2.000	UND	VENTA	VENTA:363	Administrador	2026-03-05 23:11:19.547228
644	1	EGRESO	1.000	UND	VENTA	VENTA:364	Administrador	2026-03-05 23:11:46.899934
645	5	EGRESO	1.000	ML	VENTA	VENTA:364	Administrador	2026-03-05 23:11:46.899934
646	4	EGRESO	29.570	ML	VENTA	VENTA:364	Administrador	2026-03-05 23:11:46.899934
647	1	EGRESO	2.000	UND	VENTA	VENTA:365	Administrador	2026-03-05 23:14:29.571713
648	5	EGRESO	2.000	ML	VENTA	VENTA:365	Administrador	2026-03-05 23:14:29.571713
649	4	EGRESO	59.140	ML	VENTA	VENTA:365	Administrador	2026-03-05 23:14:29.571713
650	2	EGRESO	1.000	UND	VENTA	VENTA:365	Administrador	2026-03-05 23:14:29.571713
651	16	EGRESO	1.000	UND	VENTA	VENTA:365	Administrador	2026-03-05 23:14:29.571713
652	11	EGRESO	2.000	UND	VENTA	VENTA:365	Administrador	2026-03-05 23:14:29.571713
653	18	EGRESO	162.635	ML	VENTA	VENTA:365	Administrador	2026-03-05 23:14:29.571713
654	16	EGRESO	2.000	UND	VENTA	VENTA:367	Administrador	2026-03-05 23:17:55.407164
655	16	EGRESO	4.000	UND	VENTA	VENTA:368	Administrador	2026-03-05 23:18:29.427062
656	1	EGRESO	1.000	UND	VENTA	VENTA:369	Administrador	2026-03-05 23:19:09.292136
657	5	EGRESO	1.000	ML	VENTA	VENTA:369	Administrador	2026-03-05 23:19:09.292136
658	4	EGRESO	29.570	ML	VENTA	VENTA:369	Administrador	2026-03-05 23:19:09.292136
659	1	EGRESO	1.000	UND	VENTA	VENTA:370	Administrador	2026-03-05 23:19:09.292644
660	5	EGRESO	1.000	ML	VENTA	VENTA:370	Administrador	2026-03-05 23:19:09.292644
661	4	EGRESO	29.570	ML	VENTA	VENTA:370	Administrador	2026-03-05 23:19:09.292644
662	11	EGRESO	1.000	UND	VENTA	VENTA:371	Administrador	2026-03-05 23:19:19.94581
663	9	EGRESO	1.000	UND	VENTA	VENTA:372	Administrador	2026-03-05 23:19:54.074525
664	2	EGRESO	1.000	UND	VENTA	VENTA:372	Administrador	2026-03-05 23:19:54.074525
665	1	EGRESO	1.000	UND	VENTA	VENTA:372	Administrador	2026-03-05 23:19:54.074525
666	5	EGRESO	1.000	ML	VENTA	VENTA:372	Administrador	2026-03-05 23:19:54.074525
667	4	EGRESO	29.570	ML	VENTA	VENTA:372	Administrador	2026-03-05 23:19:54.074525
668	16	EGRESO	2.000	UND	VENTA	VENTA:373	Administrador	2026-03-05 23:34:37.831685
669	9	EGRESO	2.000	UND	VENTA	VENTA:374	Administrador	2026-03-05 23:39:45.198371
\.


--
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.productos (id, nombre, precio, id_categoria, es_preparado, image_url, stock_actual, unidad_medida, stock_minimo) FROM stdin;
13	PorciÃ³n Pan de Yuca (Unitario)	0.50	4	t	\N	0.000	UND	0.000
21	WhiskyCoco	6.00	\N	t	/uploads/1772153958722-630179910.png	0.000	UND	0.000
1	PiÃ±a-Coco	2.50	1	t	/uploads/1770091190187-729842799.jpeg	0.000	UND	0.000
2	Aranda-Coco	2.50	1	t	/uploads/1770091502229-810802818.jpeg	0.000	UND	0.000
3	Coco & CaÃ±a	2.50	1	t	/uploads/1770091527798-395873077.jpeg	0.000	UND	0.000
4	Coco-Coffe	2.50	1	t	/uploads/1770091539173-351007575.jpeg	0.000	UND	0.000
5	Jugo de Coco	2.50	1	t	/uploads/1770091554071-9703308.jpeg	0.000	UND	0.000
6	Limonada de Coco	2.50	1	t	/uploads/1770091614274-113135252.jpeg	0.000	UND	0.000
16	Jugo de CaÃ±a	1.00	2	f	/uploads/1772074012217-453295926.jpeg	17.000	UND	5.000
18	CaÃ±a Manabita	1.50	\N	f	/uploads/1772153991048-60347243.jpeg	11231.610	ML	5.000
26	Hielo	1.00	\N	t	\N	3.000	UND	0.000
25	Helado + Topping	3.50	\N	f	\N	3.000	UND	0.000
23	Vaso con Pulpa	1.75	2	t	/uploads/1772144018286-603382465.jpeg	3.000	UND	0.000
24	Sprite	0.65	2	f	/uploads/1772155376162-699313250.jpeg	8.000	UND	0.000
10	Paleta Coco	0.75	3	t	/uploads/1770091625649-935062879.jpeg	87.000	UND	0.000
15	Coco Relleno	3.50	3	t	/uploads/1770091958846-900674604.jpeg	3.000	UND	0.000
17	Pipa de Coco (Entera)	1.75	2	f	/uploads/1771869920122-501966668.jpeg	18.000	UND	5.000
20	Agua sin gas	0.75	\N	f	/uploads/1772074039133-796578609.jpeg	10.000	UND	0.000
19	Agua de Coco	1.50	\N	f	/uploads/1772154137183-309473636.jpeg	0.000	UND	0.000
11	Combo Personal (5 Panes)	5.00	4	t	\N	0.000	UND	0.000
12	Combo DÃºo (8 Panes)	8.00	4	t	\N	0.000	UND	0.000
8	Guarapo	3.50	2	t	/uploads/1772074074837-724919799.jpeg	0.000	UND	0.000
7	Coco Loco	5.00	2	t	/uploads/1772154002579-269043330.png	0.000	UND	0.000
27	Paloma	5.00	2	t	/uploads/1772770582626-841215985.jpg	0.000	UND	1.000
9	Paleta Frutos Rojos	0.75	3	t	/uploads/1770091634345-225726818.jpeg	1.000	UND	0.000
22	Ron	2.50	\N	f	/uploads/1772153980717-263725156.jpeg	499.000	ML	0.000
\.


--
-- Data for Name: recetas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recetas (id, id_producto, id_insumo, cantidad_requerida) FROM stdin;
1	1	2	1.000
2	1	1	1.000
3	1	4	120.000
4	1	5	0.200
5	2	3	1.000
6	2	1	1.000
7	2	4	120.000
8	2	5	0.200
9	3	1	1.000
10	3	8	60.000
11	3	5	0.200
12	4	1	1.000
13	4	6	28.000
14	4	4	120.000
15	4	5	0.200
16	5	1	1.000
17	5	4	120.000
18	5	5	0.200
19	6	7	30.000
20	6	1	1.000
21	6	4	120.000
22	6	5	0.200
23	7	11	1.000
24	7	8	150.000
25	8	9	300.000
26	8	8	135.000
27	11	10	5.000
28	12	10	8.000
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id, nombre, pin_acceso, rol, activo) FROM stdin;
1	Admin	0000	ADMIN	t
2	Rey	3333	ADMIN	t
3	Alex	2222	ADMIN	t
\.


--
-- Data for Name: ventas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ventas (id, fecha, id_usuario, cliente_nombre, total, metodo_pago, tipo, canal, mesa, estado, notas, usuario, subtotal, impuesto_pct, impuesto_monto, cliente_id, credito_pagado, credito_metodo_pago, credito_fecha_pago) FROM stdin;
48	2026-02-23 22:34:22.149147	\N	Consumidor Final	1.75	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	neira febres cordero 	Rey	1.75	0.00	0.00	\N	t	\N	\N
49	2026-02-23 22:40:58.48011	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
50	2026-02-23 23:04:41.086451	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
52	2026-02-24 16:30:31.564755	\N	Consumidor Final	2.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.75	0.00	0.00	\N	t	\N	\N
51	2026-02-24 15:58:37.790931	\N	Consumidor Final	9.00	EFECTIVO	MESA	LOCAL	3	PAGADA	\N	Rey	9.00	0.00	0.00	\N	t	\N	\N
53	2026-02-24 16:38:59.604662	\N	Consumidor Final	1.75	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	0010241613	Rey	1.75	0.00	0.00	\N	t	\N	\N
54	2026-02-24 16:42:54.669729	\N	Consumidor Final	3.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.25	0.00	0.00	\N	t	\N	\N
56	2026-02-24 17:31:49.24857	\N	Consumidor Final	4.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.00	0.00	0.00	\N	t	\N	\N
57	2026-02-24 17:32:24.403699	\N	Consumidor Final	0.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.00	0.00	0.00	\N	t	\N	\N
55	2026-02-24 17:41:54.733429	\N	Consumidor Final	7.50	EFECTIVO	MESA	LOCAL	2	PAGADA	\N	Rey	7.50	0.00	0.00	\N	t	\N	\N
58	2026-02-24 17:51:08.247721	\N	Consumidor Final	2.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.25	0.00	0.00	\N	t	\N	\N
59	2026-02-24 17:51:19.145846	\N	Consumidor Final	1.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.00	0.00	0.00	\N	t	\N	\N
63	2026-02-24 18:09:32.559115	\N	Consumidor Final	7.50	EFECTIVO	MESA	LOCAL	1	PAGADA	\N	Rey	7.50	0.00	0.00	\N	t	\N	\N
40	2026-02-23 21:22:49.15548	\N	Consumidor Final	3.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	172528949	Rey	3.50	0.00	0.00	\N	t	\N	\N
64	2026-02-24 18:15:02.304594	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
21	2026-02-23 17:48:36.57715	\N	Consumidor Final	13.50	EFECTIVO	MESA	LOCAL	3	PAGADA	Pago efectivo	Rey	13.50	0.00	0.00	\N	t	\N	\N
23	2026-02-23 18:34:48.276024	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
66	2026-02-24 18:21:28.239586	\N	Consumidor Final	7.50	EFECTIVO	MESA	LOCAL	2	PAGADA	\N	Rey	7.50	0.00	0.00	\N	t	\N	\N
67	2026-02-24 18:32:05.811226	\N	Consumidor Final	6.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	60432960 | Banco: Banco Pichincha	Rey	6.00	0.00	0.00	\N	t	\N	\N
68	2026-02-24 18:34:52.0494	\N	Consumidor Final	3.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.25	0.00	0.00	\N	t	\N	\N
69	2026-02-24 18:36:58.889658	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
73	2026-02-24 19:05:00.615265	\N	Consumidor Final	4.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.00	0.00	0.00	\N	t	\N	\N
74	2026-02-24 19:08:06.687712	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
75	2026-02-24 19:35:38.922849	\N	Consumidor Final	4.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.00	0.00	0.00	\N	t	\N	\N
76	2026-02-24 19:39:56.415695	\N	Consumidor Final	1.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.00	0.00	0.00	\N	t	\N	\N
77	2026-02-24 19:49:50.820151	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
78	2026-02-24 19:52:07.944925	\N	Consumidor Final	1.75	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	66295330 | Banco: Banco Pichincha	Rey	1.75	0.00	0.00	\N	t	\N	\N
79	2026-02-24 19:56:50.502028	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
80	2026-02-24 20:04:24.33906	\N	Consumidor Final	4.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.75	0.00	0.00	\N	t	\N	\N
20	2026-02-23 17:48:13.765198	\N	Consumidor Final	8.50	EFECTIVO	MESA	LOCAL	2	PAGADA	\N	Rey	8.50	0.00	0.00	\N	t	\N	\N
28	2026-02-23 20:28:13.536023	\N	Consumidor Final	6.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	6.00	0.00	0.00	\N	t	\N	\N
29	2026-02-23 20:30:54.702897	\N	Consumidor Final	1.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	2208219489	Rey	1.50	0.00	0.00	\N	t	\N	\N
85	2026-02-24 20:07:44.441477	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
31	2026-02-23 20:59:44.473585	\N	Consumidor Final	2.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	bryan joel sansen ortega	Rey	2.50	0.00	0.00	\N	t	\N	\N
32	2026-02-23 21:02:26.750843	\N	Consumidor Final	1.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	bryan joel sansen ortega	Rey	1.50	0.00	0.00	\N	t	\N	\N
86	2026-02-24 20:23:47.590546	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
88	2026-02-24 21:27:21.407507	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
89	2026-02-24 21:27:31.245705	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
87	2026-02-24 21:24:29.950975	\N	Consumidor Final	0.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	71943898 | Banco: Banco Pichincha	Rey	0.00	0.00	0.00	\N	t	\N	\N
38	2026-02-23 21:09:05.511735	\N	Consumidor Final	11.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	11.75	0.00	0.00	\N	t	\N	\N
39	2026-02-23 21:20:21.034891	\N	Consumidor Final	4.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.00	0.00	0.00	\N	t	\N	\N
90	2026-02-24 21:40:37.464351	\N	Consumidor Final	11.75	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	71943898  | Banco: Banco Pichincha	Rey	11.75	0.00	0.00	\N	t	\N	\N
43	2026-02-23 21:26:02.997372	\N	Consumidor Final	9.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	9.75	0.00	0.00	\N	t	\N	\N
44	2026-02-23 21:41:07.360208	\N	Consumidor Final	3.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.25	0.00	0.00	\N	t	\N	\N
30	2026-02-23 20:54:35.30405	\N	Consumidor Final	4.25	TRANSFERENCIA	MESA	LOCAL	1	PAGADA	\N	Rey	4.25	0.00	0.00	\N	t	\N	\N
91	2026-02-24 21:41:58.437266	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
92	2026-02-24 21:57:41.07567	\N	Consumidor Final	3.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	trasnferencia desde banco guayaquil | Banco: Banco Guayaquil	Rey	3.50	0.00	0.00	\N	t	\N	\N
22	2026-02-23 18:06:25.38763	\N	Consumidor Final	12.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	ventas hasta ahora 1806	Rey	12.00	0.00	0.00	\N	t	\N	\N
46	2026-02-23 22:08:08.502655	\N	Consumidor Final	6.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	6.75	0.00	0.00	\N	t	\N	\N
45	2026-02-23 21:47:00.158621	\N	Consumidor Final	8.50	EFECTIVO	MESA	LOCAL	2	PAGADA	\N	Rey	8.50	0.00	0.00	\N	t	\N	\N
93	2026-02-24 22:01:45.069288	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
47	2026-02-23 22:10:58.778438	\N	Consumidor Final	17.00	EFECTIVO	MESA	LOCAL	1	PAGADA	\N	Rey	17.00	0.00	0.00	\N	t	\N	\N
94	2026-02-24 22:05:36.804663	\N	Consumidor Final	6.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	73811475 | Banco: Banco Pichincha	Rey	6.00	0.00	0.00	\N	t	\N	\N
95	2026-02-24 22:11:37.229491	\N	Consumidor Final	2.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.75	0.00	0.00	\N	t	\N	\N
96	2026-02-24 23:07:00.901747	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
97	2026-02-25 16:13:04.522899	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
98	2026-02-25 17:11:17.837718	\N	Consumidor Final	14.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	14.00	0.00	0.00	\N	t	\N	\N
99	2026-02-25 17:40:09.226436	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
100	2026-02-25 18:12:14.971106	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
101	2026-02-25 18:17:54.103782	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
102	2026-02-25 18:22:25.727658	\N	Consumidor Final	1.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	58122635 | Banco: Banco Pichincha	Rey	1.00	0.00	0.00	\N	t	\N	\N
103	2026-02-25 18:53:45.612011	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
104	2026-02-25 18:54:28.245325	\N	Consumidor Final	20.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	20.00	0.00	0.00	\N	t	\N	\N
105	2026-02-25 19:06:26.557225	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
106	2026-02-25 19:24:52.722124	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
107	2026-02-25 20:39:52.284585	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
108	2026-02-25 20:40:02.331884	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
109	2026-02-25 20:46:05.493535	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
110	2026-02-25 20:48:22.654839	\N	Consumidor Final	4.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.50	0.00	0.00	\N	t	\N	\N
111	2026-02-25 20:52:04.099202	\N	Consumidor Final	3.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	69133687 | Banco: Banco Pichincha	Rey	3.00	0.00	0.00	\N	t	\N	\N
113	2026-02-25 20:58:19.49684	\N	Consumidor Final	0.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.00	0.00	0.00	\N	t	\N	\N
112	2026-02-25 20:55:17.755006	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
114	2026-02-25 21:06:46.628949	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
115	2026-02-25 21:06:52.347883	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
116	2026-02-25 21:16:44.396752	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
117	2026-02-25 21:16:52.260495	\N	Consumidor Final	3.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.75	0.00	0.00	\N	t	\N	\N
118	2026-02-25 21:16:59.723785	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
120	2026-02-25 21:31:09.600036	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
121	2026-02-25 21:43:06.488332	\N	Consumidor Final	2.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	74323718 | Banco: Banco Pichincha	Rey	2.00	0.00	0.00	\N	t	\N	\N
153	2026-02-26 19:58:54.110438	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
122	2026-02-25 21:59:06.277754	\N	Consumidor Final	3.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.25	0.00	0.00	\N	t	\N	\N
123	2026-02-25 22:02:01.163321	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
124	2026-02-25 22:02:48.317937	\N	Consumidor Final	3.75	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	74651676 | Banco: Banco Pichincha	Rey	3.75	0.00	0.00	\N	t	\N	\N
125	2026-02-25 22:03:17.389335	\N	Consumidor Final	1.75	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	75036189 | Banco: Banco Pichincha	Rey	1.75	0.00	0.00	\N	t	\N	\N
126	2026-02-25 22:07:44.531029	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
127	2026-02-25 22:16:16.4175	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
141	2026-02-26 19:16:11.969646	\N	Consumidor Final	4.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.25	0.00	0.00	\N	t	\N	\N
129	2026-02-25 22:39:44.89953	\N	Consumidor Final	13.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	13.00	0.00	0.00	\N	t	\N	\N
130	2026-02-25 22:40:36.226837	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
128	2026-02-25 22:52:52.856223	\N	Consumidor Final	3.25	TRANSFERENCIA	MESA	LOCAL	1	PAGADA	900443730 | Banco: Banco Pichincha	Rey	3.25	0.00	0.00	\N	t	\N	\N
131	2026-02-25 23:09:08.325776	\N	Consumidor Final	0.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.00	0.00	0.00	\N	t	\N	\N
132	2026-02-25 23:35:42.031916	\N	Consumidor Final	3.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.75	0.00	0.00	\N	t	\N	\N
134	2026-02-26 16:32:54.312281	\N	Consumidor Final	3.75	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	41229167 | Banco: Banco Pichincha	Rey	3.75	0.00	0.00	\N	t	\N	\N
135	2026-02-26 16:55:18.883896	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
137	2026-02-26 17:33:39.432224	\N	Consumidor Final	30.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	30.00	0.00	0.00	\N	t	\N	\N
138	2026-02-26 17:50:41.394133	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
142	2026-02-26 19:19:30.328816	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
154	2026-02-26 20:16:45.99235	\N	Consumidor Final	13.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	13.00	0.00	0.00	\N	t	\N	\N
119	2026-02-25 21:30:43.772408	\N	Consumidor Final	7.00	CREDITO	DIRECTA	LOCAL	\N	PAGADA	meche	Rey	7.00	0.00	0.00	1	t	\N	\N
144	2026-02-26 19:20:46.356713	\N	Consumidor Final	13.50	CREDITO	DIRECTA	LOCAL	\N	PAGADA	Pagara a alex, Â¿Cuando? nose	Rey	13.50	0.00	0.00	4	f	\N	\N
139	2026-02-26 18:21:25.623012	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
155	2026-02-26 20:35:46.313593	\N	Consumidor Final	2.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 65624911	Rey	2.50	0.00	0.00	\N	t	\N	\N
133	2026-02-26 16:27:39.476872	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
140	2026-02-26 18:57:27.793084	\N	Consumidor Final	2.70	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	por pagar | Banco: Banco Pichincha | Comprobante: null	Rey	2.70	0.00	0.00	\N	t	\N	\N
164	2026-02-26 22:09:16.366438	\N	Consumidor Final	8.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	8.50	0.00	0.00	\N	t	\N	\N
152	2026-02-26 19:58:19.368293	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
156	2026-02-26 20:39:02.973911	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
157	2026-02-26 20:40:08.77052	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
158	2026-02-26 21:05:09.933437	\N	Consumidor Final	2.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.25	0.00	0.00	\N	t	\N	\N
159	2026-02-26 21:05:32.870947	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
160	2026-02-26 21:20:04.636601	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
161	2026-02-26 21:41:56.030148	\N	Consumidor Final	3.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 60232513	Rey	3.50	0.00	0.00	\N	t	\N	\N
162	2026-02-26 21:43:51.095846	\N	Consumidor Final	20.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 69176111	Rey	20.00	0.00	0.00	\N	t	\N	\N
163	2026-02-26 21:44:00.977422	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
143	2026-02-26 19:19:50.415082	\N	Consumidor Final	3.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.75	0.00	0.00	\N	t	\N	\N
136	2026-02-26 18:19:21.198805	\N	Consumidor Final	10.25	CREDITO	MESA	LOCAL	1	PAGADA	Anoto en hoja los consumos	Rey	10.25	0.00	0.00	2	f	\N	\N
165	2026-02-26 22:13:32.723177	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
166	2026-02-26 22:36:45.019071	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
167	2026-02-26 23:09:22.357502	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
168	2026-02-26 23:26:02.639138	\N	Consumidor Final	10.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 900883865	Rey	10.50	0.00	0.00	\N	t	\N	\N
169	2026-02-26 23:48:40.754916	\N	Consumidor Final	17.50	CREDITO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	17.50	0.00	0.00	5	f	\N	\N
170	2026-02-26 23:54:32.04546	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
171	2026-02-28 16:54:18.291396	\N	Consumidor Final	7.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	7.50	0.00	0.00	\N	t	\N	\N
172	2026-02-28 16:54:51.023618	\N	Consumidor Final	2.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.75	0.00	0.00	\N	t	\N	\N
173	2026-02-28 17:05:07.616667	\N	Consumidor Final	3.50	CREDITO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	6	f	\N	\N
174	2026-02-28 17:11:34.121971	\N	Consumidor Final	4.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.25	0.00	0.00	\N	t	\N	\N
175	2026-02-28 17:34:32.894542	\N	Consumidor Final	12.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	12.25	0.00	0.00	\N	t	\N	\N
176	2026-02-28 17:34:46.628934	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
177	2026-02-28 17:53:07.78519	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
178	2026-02-28 18:22:29.926135	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
179	2026-02-28 18:33:11.470906	\N	Consumidor Final	8.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	8.75	0.00	0.00	\N	t	\N	\N
180	2026-02-28 19:17:04.979049	\N	Consumidor Final	7.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	7.50	0.00	0.00	\N	t	\N	\N
181	2026-02-28 19:17:10.539556	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
182	2026-02-28 19:43:55.511468	\N	Consumidor Final	15.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	15.00	0.00	0.00	\N	t	\N	\N
183	2026-02-28 19:44:01.837154	\N	Consumidor Final	2.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.00	0.00	0.00	\N	t	\N	\N
184	2026-02-28 20:37:56.113211	\N	Consumidor Final	2.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.25	0.00	0.00	\N	t	\N	\N
185	2026-02-28 20:41:29.460527	\N	Consumidor Final	4.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.50	0.00	0.00	\N	t	\N	\N
186	2026-02-28 20:46:35.432792	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
187	2026-02-28 21:04:39.464543	\N	Consumidor Final	4.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.25	0.00	0.00	\N	t	\N	\N
188	2026-02-28 21:04:44.771562	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
189	2026-02-28 21:04:49.08029	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
190	2026-02-28 21:09:05.417206	\N	Consumidor Final	4.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.25	0.00	0.00	\N	t	\N	\N
191	2026-02-28 21:16:19.623815	\N	Consumidor Final	1.50	DE_UNA	DIRECTA	LOCAL	\N	PAGADA	58398908\n	Rey	1.50	0.00	0.00	\N	t	\N	\N
192	2026-02-28 21:27:35.399724	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
193	2026-02-28 21:29:08.215708	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
194	2026-02-28 21:45:00.336961	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
195	2026-02-28 21:50:16.821203	\N	Consumidor Final	7.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	7.00	0.00	0.00	\N	t	\N	\N
196	2026-02-28 21:51:11.884117	\N	Consumidor Final	5.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 61524202	Rey	5.00	0.00	0.00	\N	t	\N	\N
197	2026-02-28 22:00:25.98113	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
198	2026-02-28 22:28:02.782855	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
199	2026-02-28 22:30:49.416301	\N	Consumidor Final	5.00	CREDITO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	7	f	\N	\N
200	2026-02-28 22:34:04.288083	\N	Consumidor Final	2.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.00	0.00	0.00	\N	t	\N	\N
201	2026-02-28 22:36:07.392629	\N	Consumidor Final	1.75	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Guayaquil | Comprobante: 245334340	Rey	1.75	0.00	0.00	\N	t	\N	\N
202	2026-02-28 22:38:09.031223	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
203	2026-02-28 22:40:22.871838	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
204	2026-02-28 22:47:23.003873	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
205	2026-02-28 22:47:33.967914	\N	Consumidor Final	1.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.00	0.00	0.00	\N	t	\N	\N
206	2026-02-28 22:48:54.820519	\N	Consumidor Final	1.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.00	0.00	0.00	\N	t	\N	\N
207	2026-02-28 23:24:58.612734	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
208	2026-02-28 23:30:07.133542	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
209	2026-03-01 16:40:37.958776	\N	Consumidor Final	4.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.75	0.00	0.00	\N	t	\N	\N
210	2026-03-01 16:41:19.284929	\N	Consumidor Final	5.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 97516350	Rey	5.00	0.00	0.00	\N	t	\N	\N
211	2026-03-01 16:41:45.373568	\N	Consumidor Final	3.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 99472418	Rey	3.50	0.00	0.00	\N	t	\N	\N
212	2026-03-01 16:42:06.48609	\N	Consumidor Final	2.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 99901904	Rey	2.50	0.00	0.00	\N	t	\N	\N
213	2026-03-01 16:57:56.439683	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
235	2026-03-01 17:42:30.407103	\N	Consumidor Final	8.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	8.50	0.00	0.00	\N	t	\N	\N
236	2026-03-01 17:42:43.65379	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
237	2026-03-01 17:42:51.806377	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
238	2026-03-01 17:48:22.582492	\N	Consumidor Final	8.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	8.50	0.00	0.00	\N	t	\N	\N
239	2026-03-01 17:59:31.44892	\N	Consumidor Final	2.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.25	0.00	0.00	\N	t	\N	\N
240	2026-03-01 18:00:00.643627	\N	Consumidor Final	5.25	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 104249910	Rey	5.25	0.00	0.00	\N	t	\N	\N
241	2026-03-01 18:08:02.431863	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
242	2026-03-01 18:13:26.28313	\N	Consumidor Final	3.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.75	0.00	0.00	\N	t	\N	\N
243	2026-03-01 18:20:02.26705	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
247	2026-03-01 18:20:32.650307	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
249	2026-03-01 18:31:56.477133	\N	Consumidor Final	4.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.50	0.00	0.00	\N	t	\N	\N
248	2026-03-01 18:48:16.464022	\N	Consumidor Final	11.50	EFECTIVO	MESA	LOCAL	2	PAGADA	\N	Rey	11.50	0.00	0.00	\N	t	\N	\N
251	2026-03-01 19:09:49.971425	\N	Consumidor Final	3.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 31513515	Rey	3.50	0.00	0.00	\N	t	\N	\N
252	2026-03-01 19:18:04.366678	\N	Consumidor Final	4.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.25	0.00	0.00	\N	t	\N	\N
250	2026-03-01 19:28:17.099252	\N	Consumidor Final	9.00	EFECTIVO	MESA	LOCAL	1	PAGADA	\N	Rey	9.00	0.00	0.00	\N	t	\N	\N
253	2026-03-01 19:28:39.374842	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
258	2026-03-01 19:46:27.334455	\N	Consumidor Final	5.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 0103	Rey	5.00	0.00	0.00	\N	t	\N	\N
259	2026-03-01 19:51:39.394571	\N	Consumidor Final	2.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.25	0.00	0.00	\N	t	\N	\N
260	2026-03-01 19:55:30.640598	\N	Consumidor Final	3.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.75	0.00	0.00	\N	t	\N	\N
261	2026-03-01 20:13:15.285202	\N	Consumidor Final	3.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.25	0.00	0.00	\N	t	\N	\N
264	2026-03-01 20:36:35.476167	\N	Consumidor Final	7.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 112737716	Rey	7.50	0.00	0.00	\N	t	\N	\N
271	2026-03-01 20:58:47.211378	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
272	2026-03-01 21:10:39.005921	\N	Consumidor Final	3.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 114310524	Rey	3.50	0.00	0.00	\N	t	\N	\N
273	2026-03-01 21:11:35.878886	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
274	2026-03-01 21:19:50.935486	\N	Consumidor Final	2.25	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 104986011	Rey	2.25	0.00	0.00	\N	t	\N	\N
275	2026-03-01 21:21:20.725122	\N	Consumidor Final	2.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.00	0.00	0.00	\N	t	\N	\N
276	2026-03-01 21:26:39.347891	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
277	2026-03-01 21:36:41.060707	\N	Consumidor Final	6.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	6.00	0.00	0.00	\N	t	\N	\N
278	2026-03-01 21:36:56.08171	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
279	2026-03-01 21:37:17.943377	\N	Consumidor Final	5.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 115205116	Rey	5.00	0.00	0.00	\N	t	\N	\N
280	2026-03-01 21:44:31.87522	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
281	2026-03-01 21:52:10.715077	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
282	2026-03-01 22:21:21.877873	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
283	2026-03-01 22:25:28.481477	\N	Consumidor Final	2.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 116107136	Rey	2.50	0.00	0.00	\N	t	\N	\N
284	2026-03-01 22:27:20.833803	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
285	2026-03-01 22:30:38.471812	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
286	2026-03-01 22:31:24.994721	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
287	2026-03-01 22:43:12.540864	\N	Consumidor Final	3.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 117322269	Rey	3.50	0.00	0.00	\N	t	\N	\N
288	2026-03-01 23:13:57.590856	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
289	2026-03-02 15:13:56.91021	\N	Consumidor Final	25.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 164581872	Rey	25.00	0.00	0.00	\N	t	\N	\N
290	2026-03-02 15:15:25.09292	\N	Consumidor Final	13.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 31351531531	Rey	13.50	0.00	0.00	\N	t	\N	\N
294	2026-03-02 15:38:12.466397	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
295	2026-03-02 15:52:37.672104	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
296	2026-03-02 17:22:39.236397	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
297	2026-03-02 17:51:04.262517	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
298	2026-03-02 17:59:22.286585	\N	Consumidor Final	1.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.00	0.00	0.00	\N	t	\N	\N
299	2026-03-02 18:47:49.249054	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
300	2026-03-02 18:53:21.114371	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
301	2026-03-02 19:12:11.397491	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
302	2026-03-02 19:15:56.637231	\N	Consumidor Final	5.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.25	0.00	0.00	\N	t	\N	\N
303	2026-03-02 19:16:01.126569	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
304	2026-03-02 19:16:34.228756	\N	Consumidor Final	1.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 561651681	Rey	1.50	0.00	0.00	\N	t	\N	\N
305	2026-03-02 20:41:53.696978	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
306	2026-03-02 21:10:49.885965	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
307	2026-03-02 21:22:33.415194	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
308	2026-03-02 21:22:56.574605	\N	Consumidor Final	7.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 206741802	Rey	7.00	0.00	0.00	\N	t	\N	\N
293	2026-03-02 15:16:36.092003	\N	Consumidor Final	18.75	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 2626206260	Rey	18.75	0.00	0.00	\N	t	\N	\N
309	2026-03-02 21:50:30.255663	\N	Consumidor Final	60.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	60.00	0.00	0.00	\N	t	\N	\N
310	2026-03-02 21:51:24.692544	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
311	2026-03-02 21:52:02.421316	\N	Consumidor Final	7.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	7.50	0.00	0.00	\N	t	\N	\N
312	2026-03-02 21:53:10.91289	\N	Consumidor Final	3.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 207637572	Rey	3.50	0.00	0.00	\N	t	\N	\N
313	2026-03-02 21:55:56.233887	\N	Consumidor Final	2.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: null	Rey	2.00	0.00	0.00	\N	t	\N	\N
314	2026-03-02 22:24:49.458929	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
315	2026-03-02 22:25:09.732934	\N	Consumidor Final	4.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 209488025	Rey	4.50	0.00	0.00	\N	t	\N	\N
316	2026-03-02 22:25:38.814018	\N	Consumidor Final	2.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 209309862	Rey	2.50	0.00	0.00	\N	t	\N	\N
317	2026-03-02 22:27:19.809604	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
318	2026-03-02 22:35:11.481806	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
319	2026-03-02 22:44:44.06269	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
320	2026-03-02 23:11:57.014398	\N	Consumidor Final	1.50	CREDITO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	6	f	\N	\N
321	2026-03-03 17:43:51.511292	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
322	2026-03-03 17:43:59.29886	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
323	2026-03-03 18:31:40.857412	\N	Consumidor Final	1.75	TRANSFERENCIA	MESA	LOCAL	1	PAGADA	Banco: Banco Pichincha | Comprobante: 2204639395	Rey	1.75	0.00	0.00	\N	t	\N	\N
324	2026-03-03 19:20:02.176831	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
352	2026-03-04 23:43:14.846003	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
353	2026-03-04 23:47:46.058783	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
354	2026-03-04 23:50:02.873551	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
325	2026-03-03 19:23:27.488104	\N	Consumidor Final	14.50	TRANSFERENCIA	MESA	LOCAL	1	PAGADA	Banco: Banco Pichincha | Comprobante: 2209998244	Rey	14.50	0.00	0.00	\N	t	\N	\N
326	2026-03-03 19:24:35.162818	\N	Consumidor Final	4.25	TRANSFERENCIA	MESA	LOCAL	2	PAGADA	Banco: Banco Pichincha | Comprobante: 2205689623	Rey	4.25	0.00	0.00	\N	t	\N	\N
327	2026-03-03 19:31:55.208868	\N	Consumidor Final	4.25	EFECTIVO	MESA	LOCAL	1	PAGADA	\N	Rey	4.25	0.00	0.00	\N	t	\N	\N
328	2026-03-03 20:47:29.288078	\N	Consumidor Final	16.00	DIVIDIDO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	16.00	0.00	0.00	\N	t	\N	\N
329	2026-03-03 21:05:06.360765	\N	Consumidor Final	10.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	10.25	0.00	0.00	\N	t	\N	\N
332	2026-03-03 21:30:32.532835	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
333	2026-03-03 22:14:35.330673	\N	Consumidor Final	1.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.00	0.00	0.00	\N	t	\N	\N
334	2026-03-03 22:34:59.379783	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
335	2026-03-03 22:36:43.831112	\N	Consumidor Final	1.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: alex uzcha	Rey	1.00	0.00	0.00	\N	t	\N	\N
336	2026-03-03 22:52:31.632046	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
337	2026-03-04 15:47:15.175922	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
338	2026-03-04 16:03:48.208848	\N	Consumidor Final	3.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.25	0.00	0.00	\N	t	\N	\N
339	2026-03-04 16:03:53.131458	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
341	2026-03-04 18:57:02.04808	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
342	2026-03-04 19:18:47.864179	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
343	2026-03-04 19:43:11.300973	\N	Consumidor Final	1.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 66516388	Rey	1.50	0.00	0.00	\N	t	\N	\N
344	2026-03-04 19:56:20.279169	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
345	2026-03-04 19:56:33.265719	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
346	2026-03-04 19:56:48.578589	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
347	2026-03-04 20:07:58.164246	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
340	2026-03-04 18:39:25.454026	\N	Consumidor Final	8.75	EFECTIVO	MESA	LOCAL	1	ABIERTA	\N	Rey	8.75	0.00	0.00	\N	t	\N	\N
348	2026-03-04 22:30:54.662668	\N	Consumidor Final	1.75	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 74970135	Rey	1.75	0.00	0.00	\N	t	\N	\N
349	2026-03-04 23:01:13.183772	\N	Consumidor Final	17.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	17.00	0.00	0.00	\N	t	\N	\N
350	2026-03-04 23:01:24.595828	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
351	2026-03-04 23:40:06.679679	\N	Consumidor Final	8.75	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 900088781	Rey	8.75	0.00	0.00	\N	t	\N	\N
355	2026-03-05 22:59:08.467459	\N	Consumidor Final	2.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Administrador	2.25	0.00	0.00	\N	t	\N	\N
356	2026-03-05 22:59:53.517925	\N	Consumidor Final	2.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 48414194	Administrador	2.00	0.00	0.00	\N	t	\N	\N
357	2026-03-05 23:00:35.099712	\N	Consumidor Final	3.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 54113983	Administrador	3.50	0.00	0.00	\N	t	\N	\N
358	2026-03-05 23:00:49.716357	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Administrador	1.50	0.00	0.00	\N	t	\N	\N
359	2026-03-05 23:01:26.927696	\N	Consumidor Final	6.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Administrador	6.00	0.00	0.00	\N	t	\N	\N
360	2026-03-05 23:06:24.063577	\N	Consumidor Final	2.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Administrador	2.25	0.00	0.00	\N	t	\N	\N
361	2026-03-05 23:08:04.75606	\N	Consumidor Final	14.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Administrador	14.75	0.00	0.00	\N	t	\N	\N
362	2026-03-05 23:10:08.623793	\N	Consumidor Final	10.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Administrador	10.25	0.00	0.00	\N	t	\N	\N
363	2026-03-05 23:11:19.547228	\N	Consumidor Final	3.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 69486411	Administrador	3.50	0.00	0.00	\N	t	\N	\N
364	2026-03-05 23:11:46.899934	\N	Consumidor Final	2.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 71996534	Administrador	2.50	0.00	0.00	\N	t	\N	\N
365	2026-03-05 23:14:29.571713	\N	Consumidor Final	20.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Administrador	20.25	0.00	0.00	\N	t	\N	\N
366	2026-03-05 23:16:43.033659	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Administrador	5.00	0.00	0.00	\N	t	\N	\N
367	2026-03-05 23:17:55.407164	\N	Consumidor Final	3.00	DIVIDIDO	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha	Administrador	3.00	0.00	0.00	\N	t	\N	\N
368	2026-03-05 23:18:29.427062	\N	Consumidor Final	6.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Administrador	6.00	0.00	0.00	\N	t	\N	\N
369	2026-03-05 23:19:09.292136	\N	Consumidor Final	2.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 74869728	Administrador	2.50	0.00	0.00	\N	t	\N	\N
370	2026-03-05 23:19:09.292644	\N	Consumidor Final	2.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 74869728	Administrador	2.50	0.00	0.00	\N	t	\N	\N
371	2026-03-05 23:19:19.94581	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Administrador	1.75	0.00	0.00	\N	t	\N	\N
372	2026-03-05 23:19:54.074525	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Administrador	3.50	0.00	0.00	\N	t	\N	\N
373	2026-03-05 23:34:37.831685	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Administrador	3.00	0.00	0.00	\N	t	\N	\N
374	2026-03-05 23:39:45.198371	\N	Consumidor Final	2.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Administrador	2.75	0.00	0.00	\N	t	\N	\N
\.


--
-- Data for Name: ventas_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ventas_items (id, venta_id, producto_id, nombre, precio, cantidad, subtotal, image_url) FROM stdin;
63	23	7	Coco Loco	5.00	1.00	5.00	\N
133	38	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
134	38	19	Agua de Coco	1.50	4.00	6.00	\N
135	38	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
136	38	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
137	39	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
138	39	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
139	40	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
580	259	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
366	142	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
590	264	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
391	153	19	Agua de Coco	1.50	1.00	1.50	\N
559	247	25	Helado + Topping	3.50	1.00	3.50	\N
152	43	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
153	43	4	Coco-Coffe	2.50	1.00	2.50	/uploads/1770091539173-351007575.jpeg
154	43	10	Paleta Coco	0.75	5.00	3.75	/uploads/1770091625649-935062879.jpeg
155	44	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
156	44	19	Agua de Coco	1.50	1.00	1.50	\N
157	30	8	Guarapo	3.50	1.00	3.50	\N
158	30	20	Agua sin gas	0.75	1.00	0.75	\N
161	22	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
162	22	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
163	22	16	Jugo de CaÃ±a	1.00	3.00	3.00	\N
164	22	19	Agua de Coco	1.50	2.00	3.00	\N
165	22	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
166	46	17	Pipa de Coco (Entera)	1.75	3.00	5.25	/uploads/1771869920122-501966668.jpeg
98	20	15	Coco Relleno	3.50	2.00	7.00	/uploads/1770091958846-900674604.jpeg
99	20	20	Agua sin gas	0.75	2.00	1.50	\N
100	28	4	Coco-Coffe	2.50	1.00	2.50	/uploads/1770091539173-351007575.jpeg
101	28	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
102	29	19	Agua de Coco	1.50	1.00	1.50	\N
167	46	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
168	45	15	Coco Relleno	3.50	2.00	7.00	/uploads/1770091958846-900674604.jpeg
169	45	19	Agua de Coco	1.50	1.00	1.50	\N
111	31	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
112	32	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
173	47	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
174	47	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
175	47	15	Coco Relleno	3.50	3.00	10.50	/uploads/1770091958846-900674604.jpeg
176	47	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
55	21	15	Coco Relleno	3.50	3.00	10.50	/uploads/1770091958846-900674604.jpeg
56	21	20	Agua sin gas	0.75	2.00	1.50	\N
57	21	19	Agua de Coco	1.50	1.00	1.50	\N
177	48	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
178	49	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
179	50	19	Agua de Coco	1.50	1.00	1.50	\N
190	52	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
191	52	16	Jugo de CaÃ±a	1.00	1.00	1.00	\N
192	51	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
193	51	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
194	51	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
195	51	18	CaÃ±a Manabita	1.50	1.00	1.50	\N
196	53	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
197	54	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
198	54	20	Agua sin gas	0.75	1.00	0.75	\N
200	56	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
201	56	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
204	55	5	Jugo de Coco	2.50	3.00	7.50	/uploads/1770091554071-9703308.jpeg
205	58	19	Agua de Coco	1.50	1.00	1.50	\N
206	58	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
207	59	16	Jugo de CaÃ±a	1.00	1.00	1.00	\N
211	63	2	Aranda-Coco	2.50	3.00	7.50	/uploads/1770091502229-810802818.jpeg
212	64	19	Agua de Coco	1.50	2.00	3.00	\N
213	64	16	Jugo de CaÃ±a	1.00	2.00	2.00	\N
215	66	2	Aranda-Coco	2.50	3.00	7.50	/uploads/1770091502229-810802818.jpeg
216	67	19	Agua de Coco	1.50	4.00	6.00	\N
217	68	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
218	68	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
219	69	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
220	69	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
227	73	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
228	73	19	Agua de Coco	1.50	1.00	1.50	\N
229	74	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
230	75	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
231	75	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
232	76	16	Jugo de CaÃ±a	1.00	1.00	1.00	\N
233	77	6	Limonada de Coco	2.50	2.00	5.00	/uploads/1770091614274-113135252.jpeg
234	78	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
235	79	6	Limonada de Coco	2.50	2.00	5.00	/uploads/1770091614274-113135252.jpeg
236	80	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
237	80	19	Agua de Coco	1.50	2.00	3.00	\N
363	140	19	Agua de Coco	0.90	3.00	2.70	\N
581	260	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
582	260	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
374	119	17	Pipa de Coco (Entera)	1.75	4.00	7.00	/uploads/1771869920122-501966668.jpeg
242	85	6	Limonada de Coco	2.50	2.00	5.00	/uploads/1770091614274-113135252.jpeg
243	86	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
591	264	6	Limonada de Coco	2.50	2.00	5.00	/uploads/1770091614274-113135252.jpeg
598	271	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
392	154	7	Coco Loco	5.00	2.00	10.00	/uploads/1772154002579-269043330.png
393	154	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
248	88	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
249	89	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
250	90	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
251	90	5	Jugo de Coco	2.50	2.00	5.00	/uploads/1770091554071-9703308.jpeg
252	90	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
253	90	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
254	91	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
255	92	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
256	93	19	Agua de Coco	1.50	1.00	1.50	\N
257	93	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
258	94	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
259	94	19	Agua de Coco	1.50	1.00	1.50	\N
260	94	16	Jugo de CaÃ±a	1.00	1.00	1.00	\N
261	95	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
262	95	16	Jugo de CaÃ±a	1.00	1.00	1.00	\N
263	96	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
264	97	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
265	98	19	Agua de Coco	1.00	14.00	14.00	\N
266	99	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
267	99	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
268	100	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
269	101	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
270	102	16	Jugo de CaÃ±a	1.00	1.00	1.00	\N
271	103	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
272	104	19	Agua de Coco	1.00	20.00	20.00	\N
273	105	19	Agua de Coco	1.00	5.00	5.00	\N
274	106	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
275	107	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
276	108	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
277	109	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
278	109	22	Ron	2.50	1.00	2.50	\N
279	110	19	Agua de Coco	1.50	3.00	4.50	\N
280	111	10	Paleta Coco	0.75	4.00	3.00	/uploads/1770091625649-935062879.jpeg
396	156	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
398	158	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
283	112	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
284	114	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
285	115	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
286	116	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
287	117	10	Paleta Coco	0.75	5.00	3.75	/uploads/1770091625649-935062879.jpeg
288	118	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
290	120	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
291	120	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
292	121	16	Jugo de CaÃ±a	1.00	2.00	2.00	\N
294	122	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
295	122	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
296	123	10	Paleta Coco	0.75	4.00	3.00	/uploads/1770091625649-935062879.jpeg
297	124	19	Agua de Coco	1.50	2.00	3.00	\N
298	124	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
299	125	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
300	126	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
301	127	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
306	129	15	Coco Relleno	3.50	2.00	7.00	/uploads/1770091958846-900674604.jpeg
307	129	19	Agua de Coco	1.50	4.00	6.00	\N
308	130	19	Agua de Coco	1.50	1.00	1.50	\N
309	128	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
310	128	19	Agua de Coco	1.50	1.00	1.50	\N
312	132	19	Agua de Coco	1.50	2.00	3.00	\N
313	132	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
316	134	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
317	134	19	Agua de Coco	1.50	1.00	1.50	\N
318	135	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
322	137	19	Agua de Coco	1.00	30.00	30.00	\N
323	138	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
364	141	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
365	141	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
375	144	15	Coco Relleno	3.50	3.00	10.50	/uploads/1770091958846-900674604.jpeg
376	144	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
377	144	20	Agua sin gas	0.75	1.00	0.75	/uploads/1772074039133-796578609.jpeg
378	144	19	Agua de Coco	1.50	1.00	1.50	\N
390	152	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
394	155	16	Jugo de CaÃ±a	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
395	155	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
397	157	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
399	159	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
400	159	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
401	160	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
402	161	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
403	162	7	Coco Loco	5.00	4.00	20.00	/uploads/1772154002579-269043330.png
404	163	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
405	143	16	Jugo de CaÃ±a	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
354	139	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
355	139	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
360	133	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
361	133	16	Jugo de CaÃ±a	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
406	143	23	Vaso con Pulpa	1.75	1.00	1.75	/uploads/1772144018286-603382465.jpeg
407	136	23	Vaso con Pulpa	1.75	2.00	3.50	/uploads/1772144018286-603382465.jpeg
408	136	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
409	136	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
410	136	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
411	164	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
412	164	19	Agua de Coco	1.50	4.00	6.00	/uploads/1772154137183-309473636.jpeg
413	165	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
414	166	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
415	167	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
416	168	15	Coco Relleno	3.50	3.00	10.50	/uploads/1770091958846-900674604.jpeg
417	169	8	Guarapo	3.50	5.00	17.50	/uploads/1772074074837-724919799.jpeg
418	170	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
419	171	4	Coco-Coffe	2.50	2.00	5.00	/uploads/1770091539173-351007575.jpeg
420	171	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
421	172	16	Jugo de CaÃ±a	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
422	172	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
423	173	8	Guarapo	3.50	1.00	3.50	/uploads/1772074074837-724919799.jpeg
424	174	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
425	174	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
426	175	1	PiÃ±a-Coco	2.50	2.00	5.00	/uploads/1770091190187-729842799.jpeg
427	175	2	Aranda-Coco	2.50	2.00	5.00	/uploads/1770091502229-810802818.jpeg
428	175	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
429	175	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
430	176	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
431	177	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
432	178	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
433	179	1	PiÃ±a-Coco	2.50	2.00	5.00	/uploads/1770091190187-729842799.jpeg
434	179	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
435	179	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
436	180	5	Jugo de Coco	2.50	3.00	7.50	/uploads/1770091554071-9703308.jpeg
437	181	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
438	182	7	Coco Loco	5.00	3.00	15.00	/uploads/1772154002579-269043330.png
439	183	16	Jugo de CaÃ±a	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
440	184	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
441	185	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
442	185	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
443	186	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
444	186	16	Jugo de CaÃ±a	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
445	187	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
446	187	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
447	188	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
448	189	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
449	190	4	Coco-Coffe	2.50	1.00	2.50	/uploads/1770091539173-351007575.jpeg
450	190	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
451	191	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
452	192	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
453	193	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
454	194	8	Guarapo	3.50	1.00	3.50	/uploads/1772074074837-724919799.jpeg
455	194	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
456	195	8	Guarapo	3.50	2.00	7.00	/uploads/1772074074837-724919799.jpeg
457	196	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
458	197	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
459	198	8	Guarapo	3.50	1.00	3.50	/uploads/1772074074837-724919799.jpeg
460	199	16	Jugo de CaÃ±a	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
461	199	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
462	200	16	Jugo de CaÃ±a	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
463	201	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
464	202	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
465	203	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
466	204	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
467	205	16	Jugo de CaÃ±a	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
468	206	16	Jugo de CaÃ±a	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
469	207	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
470	208	8	Guarapo	3.50	1.00	3.50	/uploads/1772074074837-724919799.jpeg
471	209	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
472	209	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
473	209	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
474	210	4	Coco-Coffe	2.50	1.00	2.50	/uploads/1770091539173-351007575.jpeg
475	210	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
476	211	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
477	212	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
478	213	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
583	261	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
584	261	16	Jugo de CaÃ±a	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
585	261	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
599	272	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
601	274	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
602	274	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
604	276	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
607	278	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
614	281	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
616	283	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
618	285	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
620	287	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
622	289	19	Agua de Coco	1.00	25.00	25.00	/uploads/1772154137183-309473636.jpeg
627	294	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
629	296	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
631	298	16	Jugo de CaÃ±a	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
633	300	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
635	302	17	Pipa de Coco (Entera)	1.75	3.00	5.25	/uploads/1771869920122-501966668.jpeg
637	304	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
639	306	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
641	308	17	Pipa de Coco (Entera)	1.75	4.00	7.00	/uploads/1771869920122-501966668.jpeg
643	309	19	Agua de Coco	1.00	60.00	60.00	/uploads/1772154137183-309473636.jpeg
645	311	4	Coco-Coffe	2.50	2.00	5.00	/uploads/1770091539173-351007575.jpeg
646	311	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
648	313	16	Jugo de CaÃ±a	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
650	315	19	Agua de Coco	1.50	3.00	4.50	/uploads/1772154137183-309473636.jpeg
652	317	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
654	319	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
656	321	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
658	323	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
671	325	2	Aranda-Coco	2.50	2.00	5.00	/uploads/1770091502229-810802818.jpeg
672	325	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
673	325	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
674	325	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
675	325	19	Agua de Coco	1.50	3.00	4.50	/uploads/1772154137183-309473636.jpeg
684	327	25	Helado + Topping	3.50	1.00	3.50	\N
685	327	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
688	329	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
689	329	20	Agua sin gas	0.75	1.00	0.75	/uploads/1772074039133-796578609.jpeg
690	329	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
691	329	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
692	329	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
695	332	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
697	334	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
699	336	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
700	337	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
703	339	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
706	341	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
708	343	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
710	345	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
600	273	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
603	275	16	Jugo de CaÃ±a	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
605	277	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
606	277	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
608	279	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
612	280	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
542	235	3	Coco & CaÃ±a	2.50	1.00	2.50	/uploads/1770091527798-395873077.jpeg
543	235	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
544	235	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
545	236	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
546	237	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
547	237	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
548	238	19	Agua de Coco	1.00	7.00	7.00	/uploads/1772154137183-309473636.jpeg
549	238	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
550	239	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
551	240	17	Pipa de Coco (Entera)	1.75	3.00	5.25	/uploads/1771869920122-501966668.jpeg
552	241	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
553	242	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
554	242	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
555	243	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
613	280	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
615	282	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
617	284	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
563	249	10	Paleta Coco	0.75	6.00	4.50	/uploads/1770091625649-935062879.jpeg
564	248	6	Limonada de Coco	2.50	3.00	7.50	/uploads/1770091614274-113135252.jpeg
565	248	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
566	248	9	Paleta Frutos Rojos	0.75	2.00	1.50	/uploads/1770091634345-225726818.jpeg
619	286	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
621	288	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
569	251	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
570	252	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
571	252	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
572	250	10	Paleta Coco	0.75	4.00	3.00	/uploads/1770091625649-935062879.jpeg
573	250	19	Agua de Coco	1.50	4.00	6.00	/uploads/1772154137183-309473636.jpeg
574	253	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
623	290	19	Agua de Coco	0.90	15.00	13.50	/uploads/1772154137183-309473636.jpeg
628	295	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
630	297	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
579	258	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
632	299	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
634	301	19	Agua de Coco	1.00	5.00	5.00	/uploads/1772154137183-309473636.jpeg
636	303	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
638	305	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
640	307	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
642	293	16	Jugo de CaÃ±a	0.75	25.00	18.75	/uploads/1772074012217-453295926.jpeg
644	310	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
647	312	8	Guarapo	3.50	1.00	3.50	/uploads/1772074074837-724919799.jpeg
649	314	16	Jugo de CaÃ±a	1.00	3.00	3.00	/uploads/1772074012217-453295926.jpeg
651	316	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
653	318	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
655	320	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
657	322	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
659	324	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
679	326	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
680	326	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
686	328	6	Limonada de Coco	2.50	4.00	10.00	/uploads/1770091614274-113135252.jpeg
687	328	21	WhiskyCoco	6.00	1.00	6.00	/uploads/1772153958722-630179910.png
696	333	26	Hielo	1.00	1.00	1.00	\N
698	335	16	Jugo de CaÃ±a	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
701	338	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
702	338	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
707	342	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
709	344	10	Paleta Coco	0.75	4.00	3.00	/uploads/1770091625649-935062879.jpeg
711	346	16	Jugo de CaÃ±a	1.00	3.00	3.00	/uploads/1772074012217-453295926.jpeg
712	347	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
713	340	17	Pipa de Coco (Entera)	1.75	5.00	8.75	/uploads/1771869920122-501966668.jpeg
714	348	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
715	349	15	Coco Relleno	3.50	4.00	14.00	/uploads/1770091958846-900674604.jpeg
716	349	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
717	350	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
718	350	16	Jugo de CaÃ±a	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
719	351	17	Pipa de Coco (Entera)	1.75	5.00	8.75	/uploads/1771869920122-501966668.jpeg
720	352	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
721	353	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
722	354	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
723	354	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
724	355	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
725	356	16	Jugo de CaÃ±a	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
726	357	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
727	358	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
729	359	19	Agua de Coco	1.00	6.00	6.00	/uploads/1772154137183-309473636.jpeg
730	360	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
731	360	9	Paleta Frutos Rojos	0.75	2.00	1.50	/uploads/1770091634345-225726818.jpeg
732	361	10	Paleta Coco	0.75	8.00	6.00	/uploads/1770091625649-935062879.jpeg
733	361	15	Coco Relleno	3.50	2.00	7.00	/uploads/1770091958846-900674604.jpeg
734	361	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
735	362	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
736	362	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
737	362	9	Paleta Frutos Rojos	0.75	2.00	1.50	/uploads/1770091634345-225726818.jpeg
738	362	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
739	362	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
740	363	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
741	364	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
742	365	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
743	365	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
744	365	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
745	365	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
746	365	9	Paleta Frutos Rojos	0.75	8.00	6.00	/uploads/1770091634345-225726818.jpeg
747	365	21	WhiskyCoco	6.00	1.00	6.00	/uploads/1772153958722-630179910.png
748	366	27	Paloma	5.00	1.00	5.00	/uploads/1772770582626-841215985.jpg
749	367	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
750	368	19	Agua de Coco	1.50	4.00	6.00	/uploads/1772154137183-309473636.jpeg
751	369	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
752	370	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
753	371	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
754	372	16	Jugo de CaÃ±a	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
755	372	1	PiÃ±a-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
756	373	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
757	374	16	Jugo de CaÃ±a	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
758	374	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
\.


--
-- Name: bodega_insumos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bodega_insumos_id_seq', 1, false);


--
-- Name: bodega_movimientos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bodega_movimientos_id_seq', 1, false);


--
-- Name: bodega_productos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bodega_productos_id_seq', 1, false);


--
-- Name: caja_chica_ahorros_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.caja_chica_ahorros_id_seq', 1, true);


--
-- Name: caja_cierres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.caja_cierres_id_seq', 1, false);


--
-- Name: caja_movimientos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.caja_movimientos_id_seq', 432, true);


--
-- Name: caja_turnos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.caja_turnos_id_seq', 12, true);


--
-- Name: categorias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categorias_id_seq', 5, true);


--
-- Name: clientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_id_seq', 7, true);


--
-- Name: config_impresora_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.config_impresora_id_seq', 1, false);


--
-- Name: detalle_ventas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalle_ventas_id_seq', 1, false);


--
-- Name: facturas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.facturas_id_seq', 33, true);


--
-- Name: facturas_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.facturas_items_id_seq', 50, true);


--
-- Name: facturas_secuencia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.facturas_secuencia_id_seq', 1, false);


--
-- Name: gastos_mensuales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gastos_mensuales_id_seq', 8, true);


--
-- Name: insumos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insumos_id_seq', 19, true);


--
-- Name: mesas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mesas_id_seq', 1, false);


--
-- Name: movimientos_inventario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movimientos_inventario_id_seq', 669, true);


--
-- Name: productos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.productos_id_seq', 27, true);


--
-- Name: recetas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recetas_id_seq', 28, true);


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 3, true);


--
-- Name: ventas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ventas_id_seq', 374, true);


--
-- Name: ventas_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ventas_items_id_seq', 758, true);


--
-- Name: bodega_insumos bodega_insumos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bodega_insumos
    ADD CONSTRAINT bodega_insumos_pkey PRIMARY KEY (id);


--
-- Name: bodega_movimientos bodega_movimientos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bodega_movimientos
    ADD CONSTRAINT bodega_movimientos_pkey PRIMARY KEY (id);


--
-- Name: bodega_productos bodega_productos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bodega_productos
    ADD CONSTRAINT bodega_productos_pkey PRIMARY KEY (id);


--
-- Name: caja_chica_ahorros caja_chica_ahorros_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_chica_ahorros
    ADD CONSTRAINT caja_chica_ahorros_pkey PRIMARY KEY (id);


--
-- Name: caja_cierres caja_cierres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_cierres
    ADD CONSTRAINT caja_cierres_pkey PRIMARY KEY (id);


--
-- Name: caja_movimientos caja_movimientos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT caja_movimientos_pkey PRIMARY KEY (id);


--
-- Name: caja_turnos caja_turnos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_turnos
    ADD CONSTRAINT caja_turnos_pkey PRIMARY KEY (id);


--
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


--
-- Name: config_impresora config_impresora_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.config_impresora
    ADD CONSTRAINT config_impresora_pkey PRIMARY KEY (id);


--
-- Name: detalle_ventas detalle_ventas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_ventas
    ADD CONSTRAINT detalle_ventas_pkey PRIMARY KEY (id);


--
-- Name: facturas_items facturas_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas_items
    ADD CONSTRAINT facturas_items_pkey PRIMARY KEY (id);


--
-- Name: facturas facturas_numero_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT facturas_numero_key UNIQUE (numero);


--
-- Name: facturas facturas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT facturas_pkey PRIMARY KEY (id);


--
-- Name: facturas_secuencia facturas_secuencia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas_secuencia
    ADD CONSTRAINT facturas_secuencia_pkey PRIMARY KEY (id);


--
-- Name: gastos_mensuales gastos_mensuales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gastos_mensuales
    ADD CONSTRAINT gastos_mensuales_pkey PRIMARY KEY (id);


--
-- Name: insumos insumos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insumos
    ADD CONSTRAINT insumos_pkey PRIMARY KEY (id);


--
-- Name: mesas mesas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mesas
    ADD CONSTRAINT mesas_pkey PRIMARY KEY (id);


--
-- Name: movimientos_inventario movimientos_inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimientos_inventario
    ADD CONSTRAINT movimientos_inventario_pkey PRIMARY KEY (id);


--
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id);


--
-- Name: recetas recetas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recetas
    ADD CONSTRAINT recetas_pkey PRIMARY KEY (id);


--
-- Name: usuarios usuarios_pin_acceso_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pin_acceso_key UNIQUE (pin_acceso);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- Name: ventas_items ventas_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas_items
    ADD CONSTRAINT ventas_items_pkey PRIMARY KEY (id);


--
-- Name: ventas ventas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_pkey PRIMARY KEY (id);


--
-- Name: idx_caja_chica_ahorros_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_caja_chica_ahorros_fecha ON public.caja_chica_ahorros USING btree (fecha);


--
-- Name: idx_caja_cierres_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_caja_cierres_fecha ON public.caja_cierres USING btree (fecha_cierre);


--
-- Name: idx_caja_cierres_turno; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_caja_cierres_turno ON public.caja_cierres USING btree (turno_id);


--
-- Name: idx_caja_mov_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_caja_mov_fecha ON public.caja_movimientos USING btree (fecha);


--
-- Name: idx_caja_turno; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_caja_turno ON public.caja_movimientos USING btree (turno_id);


--
-- Name: idx_facturas_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_facturas_estado ON public.facturas USING btree (estado);


--
-- Name: idx_facturas_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_facturas_fecha ON public.facturas USING btree (fecha);


--
-- Name: idx_facturas_items_factura; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_facturas_items_factura ON public.facturas_items USING btree (factura_id);


--
-- Name: idx_facturas_numero; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_facturas_numero ON public.facturas USING btree (numero);


--
-- Name: idx_facturas_venta; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_facturas_venta ON public.facturas USING btree (venta_id);


--
-- Name: idx_gastos_mensuales_caja; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_gastos_mensuales_caja ON public.gastos_mensuales USING btree (caja_origen);


--
-- Name: idx_gastos_mensuales_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_gastos_mensuales_fecha ON public.gastos_mensuales USING btree (fecha);


--
-- Name: idx_mov_inv_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_mov_inv_fecha ON public.movimientos_inventario USING btree (fecha);


--
-- Name: idx_mov_inv_insumo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_mov_inv_insumo ON public.movimientos_inventario USING btree (insumo_id);


--
-- Name: idx_ventas_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ventas_estado ON public.ventas USING btree (estado);


--
-- Name: idx_ventas_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ventas_fecha ON public.ventas USING btree (fecha);


--
-- Name: idx_ventas_mesa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ventas_mesa ON public.ventas USING btree (mesa);


--
-- Name: bodega_movimientos bodega_movimientos_insumo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bodega_movimientos
    ADD CONSTRAINT bodega_movimientos_insumo_id_fkey FOREIGN KEY (insumo_id) REFERENCES public.bodega_insumos(id) ON DELETE SET NULL;


--
-- Name: caja_cierres caja_cierres_turno_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_cierres
    ADD CONSTRAINT caja_cierres_turno_id_fkey FOREIGN KEY (turno_id) REFERENCES public.caja_turnos(id) ON DELETE CASCADE;


--
-- Name: caja_movimientos caja_movimientos_turno_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT caja_movimientos_turno_id_fkey FOREIGN KEY (turno_id) REFERENCES public.caja_turnos(id) ON DELETE CASCADE;


--
-- Name: detalle_ventas detalle_ventas_id_producto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_ventas
    ADD CONSTRAINT detalle_ventas_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.productos(id);


--
-- Name: detalle_ventas detalle_ventas_id_venta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_ventas
    ADD CONSTRAINT detalle_ventas_id_venta_fkey FOREIGN KEY (id_venta) REFERENCES public.ventas(id) ON DELETE CASCADE;


--
-- Name: facturas_items facturas_items_factura_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas_items
    ADD CONSTRAINT facturas_items_factura_id_fkey FOREIGN KEY (factura_id) REFERENCES public.facturas(id) ON DELETE CASCADE;


--
-- Name: facturas facturas_venta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT facturas_venta_id_fkey FOREIGN KEY (venta_id) REFERENCES public.ventas(id) ON DELETE SET NULL;


--
-- Name: ventas fk_ventas_cliente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT fk_ventas_cliente FOREIGN KEY (cliente_id) REFERENCES public.clientes(id) ON DELETE SET NULL;


--
-- Name: movimientos_inventario movimientos_inventario_insumo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimientos_inventario
    ADD CONSTRAINT movimientos_inventario_insumo_id_fkey FOREIGN KEY (insumo_id) REFERENCES public.insumos(id) ON DELETE CASCADE;


--
-- Name: productos productos_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categorias(id);


--
-- Name: recetas recetas_id_insumo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recetas
    ADD CONSTRAINT recetas_id_insumo_fkey FOREIGN KEY (id_insumo) REFERENCES public.insumos(id);


--
-- Name: recetas recetas_id_producto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recetas
    ADD CONSTRAINT recetas_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.productos(id) ON DELETE CASCADE;


--
-- Name: ventas ventas_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id);


--
-- Name: ventas_items ventas_items_venta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas_items
    ADD CONSTRAINT ventas_items_venta_id_fkey FOREIGN KEY (venta_id) REFERENCES public.ventas(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

