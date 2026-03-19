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
-- Name: bodega_insumos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bodega_insumos (
    id integer NOT NULL,
    nombre character varying(120) NOT NULL,
    stock_actual numeric(12,3) DEFAULT 0 NOT NULL,
    unidad_medida character varying(20) NOT NULL,
    stock_minimo numeric(12,3) DEFAULT 0 NOT NULL
);


--
-- Name: bodega_insumos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bodega_insumos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bodega_insumos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bodega_insumos_id_seq OWNED BY public.bodega_insumos.id;


--
-- Name: bodega_movimientos; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: bodega_movimientos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bodega_movimientos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bodega_movimientos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bodega_movimientos_id_seq OWNED BY public.bodega_movimientos.id;


--
-- Name: bodega_productos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bodega_productos (
    id integer NOT NULL,
    nombre character varying(120) NOT NULL,
    precio numeric(12,2) DEFAULT 0 NOT NULL,
    id_categoria integer,
    es_preparado boolean DEFAULT true NOT NULL,
    image_url text
);


--
-- Name: bodega_productos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bodega_productos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bodega_productos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bodega_productos_id_seq OWNED BY public.bodega_productos.id;


--
-- Name: caja_chica_ahorros; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: caja_chica_ahorros_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.caja_chica_ahorros_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: caja_chica_ahorros_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.caja_chica_ahorros_id_seq OWNED BY public.caja_chica_ahorros.id;


--
-- Name: caja_cierres; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.caja_cierres (
    id integer NOT NULL,
    turno_id integer NOT NULL,
    resumen jsonb NOT NULL,
    ventas jsonb NOT NULL,
    movimientos jsonb NOT NULL,
    fecha_cierre timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: caja_cierres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.caja_cierres_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: caja_cierres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.caja_cierres_id_seq OWNED BY public.caja_cierres.id;


--
-- Name: caja_movimientos; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: caja_movimientos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.caja_movimientos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: caja_movimientos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.caja_movimientos_id_seq OWNED BY public.caja_movimientos.id;


--
-- Name: caja_turnos; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: caja_turnos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.caja_turnos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: caja_turnos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.caja_turnos_id_seq OWNED BY public.caja_turnos.id;


--
-- Name: categorias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categorias (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    icono character varying(50)
);


--
-- Name: categorias_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categorias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categorias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categorias_id_seq OWNED BY public.categorias.id;


--
-- Name: clientes; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: clientes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clientes_id_seq OWNED BY public.clientes.id;


--
-- Name: config_impresora; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.config_impresora (
    id integer NOT NULL,
    nombre_impresora text DEFAULT ''::text NOT NULL,
    tipo character varying(20) DEFAULT 'TERMICA'::character varying NOT NULL,
    ancho_mm integer DEFAULT 80 NOT NULL,
    auto_imprimir boolean DEFAULT false NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: config_impresora_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.config_impresora_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: config_impresora_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.config_impresora_id_seq OWNED BY public.config_impresora.id;


--
-- Name: detalle_ventas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.detalle_ventas (
    id integer NOT NULL,
    id_venta integer,
    id_producto integer,
    cantidad integer NOT NULL,
    precio_unitario numeric(10,2) NOT NULL,
    subtotal numeric(10,2) NOT NULL
);


--
-- Name: detalle_ventas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.detalle_ventas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: detalle_ventas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.detalle_ventas_id_seq OWNED BY public.detalle_ventas.id;


--
-- Name: facturas; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: facturas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.facturas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: facturas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.facturas_id_seq OWNED BY public.facturas.id;


--
-- Name: facturas_items; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: facturas_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.facturas_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: facturas_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.facturas_items_id_seq OWNED BY public.facturas_items.id;


--
-- Name: facturas_secuencia; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facturas_secuencia (
    id integer NOT NULL,
    prefijo character varying(10) DEFAULT 'REC'::character varying NOT NULL,
    siguiente integer DEFAULT 1 NOT NULL
);


--
-- Name: facturas_secuencia_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.facturas_secuencia_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: facturas_secuencia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.facturas_secuencia_id_seq OWNED BY public.facturas_secuencia.id;


--
-- Name: gastos_mensuales; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: gastos_mensuales_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gastos_mensuales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gastos_mensuales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.gastos_mensuales_id_seq OWNED BY public.gastos_mensuales.id;


--
-- Name: insumos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.insumos (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    stock_actual numeric(10,3) DEFAULT 0,
    unidad_medida character varying(20) NOT NULL,
    stock_minimo numeric(10,3) DEFAULT 5
);


--
-- Name: insumos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.insumos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: insumos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.insumos_id_seq OWNED BY public.insumos.id;


--
-- Name: mesas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mesas (
    id integer NOT NULL,
    nombre character varying(20) NOT NULL,
    estado character varying(20) DEFAULT 'LIBRE'::character varying
);


--
-- Name: mesas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mesas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mesas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mesas_id_seq OWNED BY public.mesas.id;


--
-- Name: movimientos_inventario; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: movimientos_inventario_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.movimientos_inventario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: movimientos_inventario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.movimientos_inventario_id_seq OWNED BY public.movimientos_inventario.id;


--
-- Name: productos; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: productos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.productos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: productos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.productos_id_seq OWNED BY public.productos.id;


--
-- Name: recetas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recetas (
    id integer NOT NULL,
    id_producto integer,
    id_insumo integer,
    cantidad_requerida numeric(10,3) NOT NULL
);


--
-- Name: recetas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recetas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recetas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recetas_id_seq OWNED BY public.recetas.id;


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    pin_acceso character varying(4) NOT NULL,
    rol character varying(20) NOT NULL,
    activo boolean DEFAULT true
);


--
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- Name: ventas; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: ventas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ventas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ventas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ventas_id_seq OWNED BY public.ventas.id;


--
-- Name: ventas_items; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: ventas_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ventas_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ventas_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ventas_items_id_seq OWNED BY public.ventas_items.id;


--
-- Name: bodega_insumos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bodega_insumos ALTER COLUMN id SET DEFAULT nextval('public.bodega_insumos_id_seq'::regclass);


--
-- Name: bodega_movimientos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bodega_movimientos ALTER COLUMN id SET DEFAULT nextval('public.bodega_movimientos_id_seq'::regclass);


--
-- Name: bodega_productos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bodega_productos ALTER COLUMN id SET DEFAULT nextval('public.bodega_productos_id_seq'::regclass);


--
-- Name: caja_chica_ahorros id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caja_chica_ahorros ALTER COLUMN id SET DEFAULT nextval('public.caja_chica_ahorros_id_seq'::regclass);


--
-- Name: caja_cierres id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caja_cierres ALTER COLUMN id SET DEFAULT nextval('public.caja_cierres_id_seq'::regclass);


--
-- Name: caja_movimientos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caja_movimientos ALTER COLUMN id SET DEFAULT nextval('public.caja_movimientos_id_seq'::regclass);


--
-- Name: caja_turnos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caja_turnos ALTER COLUMN id SET DEFAULT nextval('public.caja_turnos_id_seq'::regclass);


--
-- Name: categorias id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias ALTER COLUMN id SET DEFAULT nextval('public.categorias_id_seq'::regclass);


--
-- Name: clientes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id SET DEFAULT nextval('public.clientes_id_seq'::regclass);


--
-- Name: config_impresora id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.config_impresora ALTER COLUMN id SET DEFAULT nextval('public.config_impresora_id_seq'::regclass);


--
-- Name: detalle_ventas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_ventas ALTER COLUMN id SET DEFAULT nextval('public.detalle_ventas_id_seq'::regclass);


--
-- Name: facturas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facturas ALTER COLUMN id SET DEFAULT nextval('public.facturas_id_seq'::regclass);


--
-- Name: facturas_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facturas_items ALTER COLUMN id SET DEFAULT nextval('public.facturas_items_id_seq'::regclass);


--
-- Name: facturas_secuencia id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facturas_secuencia ALTER COLUMN id SET DEFAULT nextval('public.facturas_secuencia_id_seq'::regclass);


--
-- Name: gastos_mensuales id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gastos_mensuales ALTER COLUMN id SET DEFAULT nextval('public.gastos_mensuales_id_seq'::regclass);


--
-- Name: insumos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insumos ALTER COLUMN id SET DEFAULT nextval('public.insumos_id_seq'::regclass);


--
-- Name: mesas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mesas ALTER COLUMN id SET DEFAULT nextval('public.mesas_id_seq'::regclass);


--
-- Name: movimientos_inventario id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movimientos_inventario ALTER COLUMN id SET DEFAULT nextval('public.movimientos_inventario_id_seq'::regclass);


--
-- Name: productos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.productos ALTER COLUMN id SET DEFAULT nextval('public.productos_id_seq'::regclass);


--
-- Name: recetas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recetas ALTER COLUMN id SET DEFAULT nextval('public.recetas_id_seq'::regclass);


--
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- Name: ventas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ventas ALTER COLUMN id SET DEFAULT nextval('public.ventas_id_seq'::regclass);


--
-- Name: ventas_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ventas_items ALTER COLUMN id SET DEFAULT nextval('public.ventas_items_id_seq'::regclass);


--
-- Data for Name: bodega_insumos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bodega_insumos (id, nombre, stock_actual, unidad_medida, stock_minimo) FROM stdin;
\.


--
-- Data for Name: bodega_movimientos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bodega_movimientos (id, insumo_id, tipo, cantidad, unidad_medida, motivo, referencia, usuario, fecha) FROM stdin;
\.


--
-- Data for Name: bodega_productos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bodega_productos (id, nombre, precio, id_categoria, es_preparado, image_url) FROM stdin;
\.


--
-- Data for Name: caja_chica_ahorros; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.caja_chica_ahorros (id, fecha, monto, referencia, usuario, created_at, comprobante_url) FROM stdin;
\.


--
-- Data for Name: caja_cierres; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.caja_cierres (id, turno_id, resumen, ventas, movimientos, fecha_cierre) FROM stdin;
\.


--
-- Data for Name: caja_movimientos; Type: TABLE DATA; Schema: public; Owner: -
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
433	13	VENTA	EFECTIVO	3.50	Venta 375	Rey	375	2026-03-06 16:28:32.062504
435	13	VENTA	EFECTIVO	40.00	Venta 377	Rey	377	2026-03-06 16:30:22.813188
436	13	VENTA	TRANSFERENCIA	20.00	Venta 378	Rey	378	2026-03-06 16:31:51.962446
437	13	EGRESO	EFECTIVO	8.00	gasto taxi	Rey	\N	2026-03-06 16:33:27.587092
438	13	VENTA	TRANSFERENCIA	16.50	Venta 379	Rey	379	2026-03-06 16:38:29.719492
439	13	VENTA	EFECTIVO	1.50	Venta 380	Rey	380	2026-03-06 17:55:19.498284
440	13	VENTA	EFECTIVO	5.00	Venta 382	Rey	382	2026-03-06 18:00:46.934243
441	13	VENTA	EFECTIVO	2.50	Venta 383	Rey	383	2026-03-06 18:10:39.838615
442	13	INGRESO	EFECTIVO	5.10	DIO ANTONY	Rey	\N	2026-03-06 18:11:32.696054
443	13	VENTA	TRANSFERENCIA	4.00	Venta 384	Rey	384	2026-03-06 18:26:03.636636
444	13	VENTA	EFECTIVO	1.75	Venta 385	Rey	385	2026-03-06 18:33:54.359345
445	13	VENTA	EFECTIVO	1.75	Venta 386	Rey	386	2026-03-06 18:36:22.969995
446	13	VENTA	EFECTIVO	7.00	Venta 387	Rey	387	2026-03-06 19:01:50.825645
447	13	VENTA	TRANSFERENCIA	2.50	Venta 388	Rey	388	2026-03-06 20:15:16.484686
448	13	VENTA	TRANSFERENCIA	1.75	Venta 389	Rey	389	2026-03-06 20:15:47.556474
449	13	VENTA	EFECTIVO	2.50	Venta 390	Rey	390	2026-03-06 20:16:07.617138
450	13	EGRESO	EFECTIVO	2.00	ALEX ANTICIPO	Rey	\N	2026-03-06 20:16:39.096824
451	13	VENTA	EFECTIVO	5.00	Venta 391	Rey	391	2026-03-06 20:38:20.971623
452	13	VENTA	TRANSFERENCIA	5.00	Venta 392	Rey	392	2026-03-06 20:57:47.819751
453	13	VENTA	EFECTIVO	1.75	Venta 393	Rey	393	2026-03-06 20:58:08.170311
455	13	VENTA	EFECTIVO	3.50	Venta 395	Rey	395	2026-03-06 20:58:44.491236
456	13	VENTA	EFECTIVO	0.75	Venta 394	Rey	394	2026-03-06 21:01:50.339806
457	13	VENTA	EFECTIVO	1.50	Venta 396	Rey	396	2026-03-06 21:02:05.252475
458	13	VENTA	EFECTIVO	7.00	Venta 397	Rey	397	2026-03-06 21:28:36.602791
459	13	VENTA	EFECTIVO	3.50	Venta 398	Rey	398	2026-03-06 21:28:50.762704
460	13	VENTA	EFECTIVO	2.00	Venta 399	Rey	399	2026-03-06 21:28:58.087793
461	13	VENTA	EFECTIVO	1.00	Venta 400	Rey	400	2026-03-06 21:36:13.086324
462	13	VENTA	EFECTIVO	1.50	Venta 402	Rey	402	2026-03-06 21:38:43.602184
463	13	VENTA	EFECTIVO	3.50	Venta 403	Rey	403	2026-03-06 21:40:31.265142
464	13	VENTA	EFECTIVO	6.75	Venta 404	Rey	404	2026-03-06 21:51:45.244759
465	13	VENTA	EFECTIVO	0.75	Venta 405	Rey	405	2026-03-06 21:56:26.272245
466	13	VENTA	TRANSFERENCIA	6.75	Venta 406	Rey	406	2026-03-06 22:41:44.074634
467	13	VENTA	EFECTIVO	4.50	Venta 407	Rey	407	2026-03-06 22:42:45.111849
468	13	VENTA	EFECTIVO	5.00	Venta 408	Rey	408	2026-03-06 22:42:53.83003
469	13	VENTA	EFECTIVO	3.50	Parte 1	Rey	409	2026-03-06 22:48:40.190336
470	13	VENTA	TRANSFERENCIA	3.50	Parte 2 | Banco: Banco Pichincha | Comprobante: 73625371	Rey	409	2026-03-06 22:48:40.190336
471	13	VENTA	EFECTIVO	5.00	Venta 410	Rey	410	2026-03-06 22:55:03.288549
472	13	VENTA	EFECTIVO	4.25	Venta 411	Rey	411	2026-03-06 22:56:37.967376
473	13	VENTA	TRANSFERENCIA	6.00	Parte 1 | Banco: Banco Pichincha | Comprobante: 900792441	Rey	340	2026-03-06 23:26:49.636839
474	13	VENTA	TRANSFERENCIA	5.75	Parte 2 | Banco: Banco Pichincha | Comprobante: 900667759	Rey	340	2026-03-06 23:26:49.636839
475	13	VENTA	TRANSFERENCIA	5.00	Venta 412	Rey	412	2026-03-06 23:29:12.404863
478	13	VENTA	TRANSFERENCIA	3.50	Venta 415	Rey	415	2026-03-06 23:30:24.584723
479	13	VENTA	DE_UNA	2.25	Venta 416	Rey	416	2026-03-06 23:31:03.683377
480	13	VENTA	TRANSFERENCIA	9.00	Venta 417	Rey	417	2026-03-06 23:33:03.117888
481	13	VENTA	EFECTIVO	3.50	Venta 418	Rey	418	2026-03-06 23:56:29.053967
482	13	VENTA	EFECTIVO	5.00	Venta 419	Rey	419	2026-03-06 23:56:49.094209
483	13	VENTA	TRANSFERENCIA	5.00	Venta 420	Rey	420	2026-03-07 00:09:05.50142
484	13	VENTA	EFECTIVO	2.50	Venta 421	Rey	421	2026-03-07 00:09:34.423653
485	13	VENTA	EFECTIVO	7.00	Venta 422	Rey	422	2026-03-07 00:27:18.471386
486	13	EGRESO	EFECTIVO	5.00	ANTICIPO rey	Rey	\N	2026-03-07 15:21:35.146349
487	13	EGRESO	EFECTIVO	2.50	comida rey	Rey	\N	2026-03-07 15:48:12.985298
488	13	VENTA	EFECTIVO	8.25	Venta 423	Rey	423	2026-03-07 16:04:57.949596
489	13	VENTA	EFECTIVO	1.75	Venta 424	Rey	424	2026-03-07 16:07:39.114647
490	13	INGRESO	EFECTIVO	10.00	Alex puso	Rey	\N	2026-03-07 16:08:10.482003
491	13	VENTA	EFECTIVO	2.50	Venta 425	Rey	425	2026-03-07 16:09:03.491664
492	13	VENTA	EFECTIVO	0.75	Venta 426	Rey	426	2026-03-07 16:09:33.975424
493	14	VENTA	EFECTIVO	3.50	Venta 427	Rey	427	2026-03-07 16:25:10.403506
494	14	VENTA	EFECTIVO	1.00	Venta 428	Rey	428	2026-03-07 16:25:21.479217
495	14	EGRESO	EFECTIVO	2.00	taxi	Rey	\N	2026-03-07 16:26:10.401242
496	14	VENTA	EFECTIVO	3.75	Venta 429	Rey	429	2026-03-07 16:33:55.072927
497	14	EGRESO	EFECTIVO	26.00	envases, frutas y carrera	Rey	\N	2026-03-07 16:58:40.33316
498	14	EGRESO	EFECTIVO	6.00	hielo	Rey	\N	2026-03-07 16:58:53.24911
499	14	VENTA	EFECTIVO	2.50	Venta 430	Rey	430	2026-03-07 17:21:52.913227
500	14	VENTA	EFECTIVO	0.75	Venta 431	Rey	431	2026-03-07 17:50:06.52413
501	14	VENTA	EFECTIVO	1.50	Venta 433	Rey	433	2026-03-07 19:58:47.570847
502	14	VENTA	EFECTIVO	2.25	Venta 434	Rey	434	2026-03-07 19:58:59.797054
503	14	VENTA	EFECTIVO	1.00	Venta 435	Rey	435	2026-03-07 19:59:08.220432
504	14	VENTA	EFECTIVO	3.50	Venta 436	Rey	436	2026-03-07 20:11:33.320428
505	14	VENTA	EFECTIVO	1.75	Venta 437	Rey	437	2026-03-07 20:11:45.056468
506	14	VENTA	EFECTIVO	8.75	Venta 438	Rey	438	2026-03-07 20:25:31.534955
507	14	VENTA	TRANSFERENCIA	5.50	Venta 439	Rey	439	2026-03-07 20:51:40.42394
508	14	VENTA	EFECTIVO	1.75	Venta 440	Rey	440	2026-03-07 20:51:54.396745
509	14	VENTA	EFECTIVO	3.50	Venta 441	Rey	441	2026-03-07 21:44:10.375486
511	14	VENTA	EFECTIVO	3.50	Venta 443	Rey	443	2026-03-07 21:45:05.800393
512	14	VENTA	EFECTIVO	5.00	Venta 444	Rey	444	2026-03-07 21:45:15.463633
513	14	VENTA	TRANSFERENCIA	2.25	Venta 445	Rey	445	2026-03-07 21:45:44.65841
514	14	VENTA	EFECTIVO	6.00	Venta 446	Rey	446	2026-03-07 21:46:28.813719
515	14	VENTA	EFECTIVO	3.00	Venta 447	Rey	447	2026-03-07 21:58:34.585351
516	14	VENTA	EFECTIVO	1.75	Venta 448	Rey	448	2026-03-07 22:32:05.727358
517	14	VENTA	EFECTIVO	5.00	Venta 449	Rey	449	2026-03-07 22:32:33.390299
518	14	VENTA	EFECTIVO	5.00	Venta 450	Rey	450	2026-03-07 22:32:42.405757
519	14	VENTA	EFECTIVO	2.00	Venta 451	Rey	451	2026-03-07 22:33:46.849014
520	14	VENTA	EFECTIVO	4.25	Venta 452	Rey	452	2026-03-07 22:37:40.642177
521	14	VENTA	TRANSFERENCIA	3.00	Venta 453	Rey	453	2026-03-07 22:38:24.743542
522	14	VENTA	EFECTIVO	1.50	Venta 454	Rey	454	2026-03-07 22:40:04.607683
523	14	VENTA	EFECTIVO	2.50	Venta 455	Rey	455	2026-03-07 22:55:29.973852
544	14	VENTA	EFECTIVO	6.00	Venta 476	Rey	476	2026-03-07 23:46:03.859788
545	14	VENTA	TRANSFERENCIA	20.00	Venta 477	Rey	477	2026-03-07 23:46:32.669666
546	14	EGRESO	EFECTIVO	2.50	comida rey	Rey	\N	2026-03-07 23:46:58.237936
547	14	VENTA	EFECTIVO	3.50	Venta 478	Rey	478	2026-03-07 23:47:53.96466
548	14	VENTA	EFECTIVO	1.50	Venta 479	Rey	479	2026-03-07 23:48:02.354463
549	14	VENTA	EFECTIVO	5.00	Venta 480	Rey	480	2026-03-07 23:48:22.053323
552	14	VENTA	EFECTIVO	7.00	Venta 483	Rey	483	2026-03-08 00:04:47.375678
554	14	VENTA	EFECTIVO	0.75	Venta 482	Rey	482	2026-03-08 00:12:33.460323
556	15	VENTA	EFECTIVO	2.50	Venta 516	Rey	516	2026-03-09 17:30:52.65707
557	15	VENTA	EFECTIVO	3.50	Venta 517	Rey	517	2026-03-09 17:31:01.091298
558	15	VENTA	EFECTIVO	5.00	Venta 518	Rey	518	2026-03-09 17:31:46.477123
559	15	VENTA	EFECTIVO	1.50	Venta 519	Rey	519	2026-03-09 17:31:57.357329
560	15	VENTA	EFECTIVO	35.00	Venta 520	Rey	520	2026-03-09 17:34:13.474934
561	15	VENTA	EFECTIVO	10.00	Venta 521	Rey	521	2026-03-09 17:34:42.464791
562	15	EGRESO	EFECTIVO	2.00	taxi	Rey	\N	2026-03-09 17:38:08.372413
563	15	VENTA	EFECTIVO	2.50	Venta 522	Rey	522	2026-03-09 17:42:41.272325
564	15	VENTA	TRANSFERENCIA	4.25	Venta 523	Rey	523	2026-03-09 19:31:40.278804
565	15	VENTA	EFECTIVO	6.00	Venta 524	Rey	524	2026-03-09 19:32:06.193894
566	15	VENTA	EFECTIVO	5.25	Venta 525	Rey	525	2026-03-09 19:45:00.439872
567	15	VENTA	EFECTIVO	3.00	Venta 526	Rey	526	2026-03-09 20:26:22.070732
570	15	VENTA	EFECTIVO	4.00	Venta 529	Rey	529	2026-03-09 20:46:58.790316
571	15	VENTA	EFECTIVO	4.75	Venta 531	Rey	531	2026-03-09 21:09:43.489401
572	15	VENTA	TRANSFERENCIA	4.25	Venta 530	Rey	530	2026-03-09 21:34:07.520567
573	15	VENTA	TRANSFERENCIA	5.00	Venta 532	Rey	532	2026-03-09 21:46:48.02144
574	15	VENTA	TRANSFERENCIA	5.25	Venta 533	Rey	533	2026-03-09 21:47:18.043703
575	15	VENTA	EFECTIVO	2.50	Venta 534	Rey	534	2026-03-09 21:47:39.704882
576	15	VENTA	EFECTIVO	2.50	Venta 535	Rey	535	2026-03-09 21:48:08.198057
579	15	VENTA	EFECTIVO	6.50	Venta 538	Rey	538	2026-03-09 21:48:38.472027
580	15	VENTA	EFECTIVO	5.00	Venta 539	Rey	539	2026-03-09 22:21:49.857642
581	15	VENTA	EFECTIVO	3.00	Venta 540	Rey	540	2026-03-09 22:22:04.211964
582	15	VENTA	TRANSFERENCIA	1.50	Venta 541	Rey	541	2026-03-09 22:22:28.068869
585	15	VENTA	EFECTIVO	5.25	Venta 544	Rey	544	2026-03-09 23:04:49.146641
586	15	VENTA	EFECTIVO	1.00	Venta 545	Rey	545	2026-03-09 23:06:40.32117
587	15	VENTA	EFECTIVO	3.00	Venta 546	Rey	546	2026-03-09 23:10:48.69006
588	15	VENTA	EFECTIVO	8.75	Venta 547	Rey	547	2026-03-09 23:27:46.901006
589	15	EGRESO	EFECTIVO	2.50	rey comida	Rey	\N	2026-03-09 23:28:14.910628
593	15	VENTA	EFECTIVO	4.00	Venta 551	Rey	551	2026-03-09 23:34:14.808186
594	15	VENTA	EFECTIVO	5.25	Venta 548	Rey	548	2026-03-09 23:36:30.833808
595	15	VENTA	EFECTIVO	1.50	Venta 552	Rey	552	2026-03-09 23:36:39.877392
596	16	VENTA	EFECTIVO	1.50	Venta 553	Rey	553	2026-03-10 19:20:20.095318
597	16	VENTA	EFECTIVO	6.00	Venta 554	Rey	554	2026-03-10 19:20:58.463711
598	16	VENTA	EFECTIVO	5.00	Venta 555	Rey	555	2026-03-10 19:21:03.761172
599	16	VENTA	EFECTIVO	6.00	Venta 556	Rey	556	2026-03-10 19:21:39.609173
600	16	VENTA	EFECTIVO	1.00	Venta 557	Rey	557	2026-03-10 19:21:45.246024
603	16	VENTA	TRANSFERENCIA	3.50	Venta 560	Rey	560	2026-03-10 19:45:04.055082
604	16	VENTA	EFECTIVO	11.50	Venta 561	Rey	561	2026-03-10 20:16:41.039642
605	16	VENTA	EFECTIVO	4.50	Venta 562	Rey	562	2026-03-10 20:17:04.323408
606	16	VENTA	EFECTIVO	1.00	Venta 563	Rey	563	2026-03-10 20:18:50.522027
607	16	VENTA	EFECTIVO	3.00	Venta 564	Rey	564	2026-03-10 20:21:44.462351
608	16	VENTA	EFECTIVO	5.00	Venta 565	Rey	565	2026-03-10 20:29:52.79531
609	16	EGRESO	EFECTIVO	2.00	taxi	Rey	\N	2026-03-10 20:30:12.930447
610	16	VENTA	EFECTIVO	2.50	Venta 566	Rey	566	2026-03-10 20:32:04.055952
611	16	VENTA	EFECTIVO	1.50	Venta 567	Rey	567	2026-03-10 21:07:44.86597
612	16	VENTA	TRANSFERENCIA	3.50	Venta 568	Rey	568	2026-03-10 21:11:19.745489
613	16	VENTA	EFECTIVO	3.50	Venta 569	Rey	569	2026-03-10 21:12:12.440962
615	16	VENTA	EFECTIVO	5.00	Venta 571	Rey	571	2026-03-10 21:18:56.905021
616	16	VENTA	EFECTIVO	3.50	Venta 572	Rey	572	2026-03-10 21:20:48.084702
617	16	VENTA	TRANSFERENCIA	3.50	Venta 573	Rey	573	2026-03-10 22:26:55.430932
619	16	VENTA	TRANSFERENCIA	3.00	Venta 574	Rey	574	2026-03-10 22:27:18.481284
620	17	VENTA	TRANSFERENCIA	1.50	Venta 575	Rey	575	2026-03-11 16:33:18.908891
621	17	EGRESO	EFECTIVO	2.50	taxi rey	Rey	\N	2026-03-11 17:07:05.163235
622	17	VENTA	EFECTIVO	1.00	Venta 576	Rey	576	2026-03-11 17:42:13.296073
623	17	VENTA	TRANSFERENCIA	14.00	Venta 577	Rey	577	2026-03-11 18:22:49.783985
624	17	VENTA	EFECTIVO	4.25	Venta 578	Rey	578	2026-03-11 19:08:43.559975
625	17	VENTA	EFECTIVO	7.50	Venta 580	Rey	580	2026-03-11 20:01:19.175148
626	17	EGRESO	EFECTIVO	2.00	moto taxi	Rey	\N	2026-03-11 20:02:56.829316
628	17	VENTA	EFECTIVO	10.00	Venta 582	Rey	582	2026-03-11 21:16:05.229547
631	17	VENTA	EFECTIVO	2.50	Venta 585	Rey	585	2026-03-11 21:28:59.692955
632	17	VENTA	EFECTIVO	1.00	Venta 586	Rey	586	2026-03-11 21:31:41.502967
633	17	VENTA	EFECTIVO	1.50	Venta 587	Rey	587	2026-03-11 21:33:47.929303
634	17	VENTA	EFECTIVO	3.50	Venta 588	Rey	588	2026-03-11 22:14:57.712659
635	17	VENTA	EFECTIVO	5.00	Venta 589	Rey	589	2026-03-11 22:57:23.256362
636	17	VENTA	TRANSFERENCIA	15.00	Venta 590	Rey	590	2026-03-11 22:59:36.884356
637	17	EGRESO	EFECTIVO	3.25	don -miguel anticipo	Rey	\N	2026-03-11 23:02:14.445686
638	17	EGRESO	EFECTIVO	8.50	comida -rey alex	Rey	\N	2026-03-11 23:02:55.507156
639	17	EGRESO	EFECTIVO	2.00	taxi bodega	Rey	\N	2026-03-11 23:03:39.633212
641	17	VENTA	EFECTIVO	2.50	Venta 581	Rey	581	2026-03-11 23:05:36.739168
642	17	EGRESO	EFECTIVO	0.50	cola sprite	Rey	\N	2026-03-11 23:06:21.706108
643	17	VENTA	TRANSFERENCIA	3.00	Venta 591	Rey	591	2026-03-11 23:08:39.028841
644	17	VENTA	TRANSFERENCIA	4.00	Parte 1 | Banco: Banco Pichincha | Comprobante: 900365701	Rey	592	2026-03-11 23:10:29.581465
645	17	VENTA	TRANSFERENCIA	4.00	Parte 2 | Banco: Banco Guayaquil | Comprobante: 0000965786	Rey	592	2026-03-11 23:10:29.581465
646	17	VENTA	TRANSFERENCIA	4.00	Venta 593	Rey	593	2026-03-11 23:13:15.896239
647	18	VENTA	EFECTIVO	6.50	Venta 594	Rey	594	2026-03-12 15:57:08.895851
648	18	VENTA	EFECTIVO	3.50	Venta 595	Rey	595	2026-03-12 15:57:35.276663
649	18	VENTA	EFECTIVO	5.00	Venta 596	Rey	596	2026-03-12 15:58:06.700761
650	18	VENTA	TRANSFERENCIA	14.70	Venta 597	Rey	597	2026-03-12 15:58:58.177977
651	18	VENTA	EFECTIVO	1.50	Venta 598	Rey	598	2026-03-12 15:59:34.213638
652	18	VENTA	EFECTIVO	0.75	Venta 599	Rey	599	2026-03-12 16:14:17.425259
653	18	VENTA	TRANSFERENCIA	3.50	Venta 600	Rey	600	2026-03-12 17:17:35.436667
654	18	VENTA	TRANSFERENCIA	2.00	Venta 601	Rey	601	2026-03-12 17:18:16.74037
657	18	VENTA	EFECTIVO	4.50	Venta 604	Rey	604	2026-03-12 17:19:01.089474
658	18	VENTA	EFECTIVO	8.25	Venta 605	Rey	605	2026-03-12 17:19:12.922808
659	18	EGRESO	EFECTIVO	20.00	Plantitas bonitas	Rey	\N	2026-03-12 17:19:35.231874
660	18	VENTA	EFECTIVO	6.00	Venta 606	Rey	606	2026-03-12 17:43:35.65787
661	18	VENTA	EFECTIVO	1.75	Venta 607	Rey	607	2026-03-12 17:48:07.387539
662	18	VENTA	EFECTIVO	3.25	Venta 608	Rey	608	2026-03-12 18:24:57.155796
663	18	VENTA	EFECTIVO	2.25	Venta 609	Rey	609	2026-03-12 19:03:53.275387
664	18	VENTA	EFECTIVO	2.50	Venta 610	Rey	610	2026-03-12 19:06:34.948873
665	18	VENTA	EFECTIVO	2.50	Venta 611	Rey	611	2026-03-12 19:16:46.895561
666	18	VENTA	EFECTIVO	6.75	Venta 612	Rey	612	2026-03-12 19:38:43.145662
667	18	VENTA	TRANSFERENCIA	20.00	Venta 613	Rey	613	2026-03-12 20:13:49.637834
668	18	EGRESO	EFECTIVO	2.00	taxi	Rey	\N	2026-03-12 20:14:09.826261
669	18	VENTA	TRANSFERENCIA	7.00	Venta 614	Rey	614	2026-03-12 20:49:49.721959
672	18	VENTA	EFECTIVO	6.00	Venta 617	Rey	617	2026-03-12 21:12:57.629044
673	18	VENTA	EFECTIVO	3.50	Venta 618	Rey	618	2026-03-12 21:55:01.970273
674	18	VENTA	TRANSFERENCIA	2.50	Venta 619	Rey	619	2026-03-12 21:55:24.714897
675	18	VENTA	EFECTIVO	3.75	Venta 621	Rey	621	2026-03-12 22:02:30.970868
676	18	VENTA	EFECTIVO	1.50	Venta 622	Rey	622	2026-03-12 22:08:16.327677
677	18	VENTA	EFECTIVO	5.25	Venta 623	Rey	623	2026-03-12 22:11:52.435524
678	18	VENTA	EFECTIVO	9.00	Venta 624	Rey	624	2026-03-12 22:44:08.960934
679	18	VENTA	EFECTIVO	2.50	Venta 625	Rey	625	2026-03-12 22:44:15.722113
680	18	VENTA	EFECTIVO	2.25	Venta 626	Rey	626	2026-03-12 22:44:29.230056
681	18	EGRESO	EFECTIVO	2.50	comida rey	Rey	\N	2026-03-12 22:55:10.217352
683	18	VENTA	EFECTIVO	1.50	Venta 628	Rey	628	2026-03-12 23:03:47.484325
684	18	VENTA	EFECTIVO	3.75	Venta 627	Rey	627	2026-03-12 23:04:34.053233
685	19	EGRESO	EFECTIVO	9.00	alex pago cañas	Rey	\N	2026-03-13 15:42:49.034798
686	19	EGRESO	EFECTIVO	2.00	taxi	Rey	\N	2026-03-13 15:43:14.825151
687	19	VENTA	EFECTIVO	0.75	Venta 629	Rey	629	2026-03-13 15:44:32.664185
688	19	VENTA	EFECTIVO	4.75	Venta 630	Rey	630	2026-03-13 16:37:07.392995
689	19	VENTA	TRANSFERENCIA	5.25	Venta 631	Rey	631	2026-03-13 16:43:00.973857
690	19	VENTA	TRANSFERENCIA	6.75	Venta 632	Rey	632	2026-03-13 16:44:02.417972
691	19	VENTA	EFECTIVO	3.25	Venta 633	Rey	633	2026-03-13 16:59:42.38669
692	19	VENTA	EFECTIVO	3.00	Venta 634	Rey	634	2026-03-13 17:05:41.913317
693	19	VENTA	EFECTIVO	6.00	Venta 635	Rey	635	2026-03-13 17:20:46.328564
694	19	VENTA	EFECTIVO	1.75	Venta 636	Rey	636	2026-03-13 17:34:13.93689
695	19	VENTA	EFECTIVO	35.00	Venta 637	Rey	637	2026-03-13 17:42:55.722005
698	19	VENTA	EFECTIVO	3.25	Venta 640	Rey	640	2026-03-13 17:53:55.582036
699	19	EGRESO	EFECTIVO	2.00	taxi aguas	Rey	\N	2026-03-13 17:55:11.770476
700	19	EGRESO	EFECTIVO	0.50	alex 	Rey	\N	2026-03-13 17:55:23.881504
701	19	VENTA	EFECTIVO	1.75	Venta 641	Rey	641	2026-03-13 18:02:10.852674
702	19	VENTA	EFECTIVO	5.00	Venta 642	Rey	642	2026-03-13 18:07:33.229301
703	19	EGRESO	EFECTIVO	10.00	transferencia	Rey	\N	2026-03-13 18:22:39.775541
704	19	INGRESO	TRANSFERENCIA	10.00	ingreso por transferencia de las 35 aguas (solo 10)	Rey	\N	2026-03-13 18:23:18.226288
705	19	VENTA	EFECTIVO	5.00	Venta 643	Rey	643	2026-03-13 18:30:36.058649
706	19	VENTA	TRANSFERENCIA	2.50	Venta 644	Rey	644	2026-03-13 18:44:25.759229
707	19	VENTA	EFECTIVO	5.00	Venta 645	Rey	645	2026-03-13 19:13:39.915056
708	19	VENTA	EFECTIVO	1.50	Venta 646	Rey	646	2026-03-13 19:13:54.457956
709	19	VENTA	TRANSFERENCIA	24.75	Venta 647	Rey	647	2026-03-13 19:22:02.371255
710	19	VENTA	EFECTIVO	1.50	Venta 648	Rey	648	2026-03-13 19:31:46.704336
711	19	VENTA	EFECTIVO	0.75	Venta 649	Rey	649	2026-03-13 19:45:52.507726
712	19	VENTA	TRANSFERENCIA	10.00	Venta 650	Rey	650	2026-03-13 19:55:01.553463
713	19	VENTA	EFECTIVO	3.25	Venta 651	Rey	651	2026-03-13 20:00:08.553258
714	19	VENTA	EFECTIVO	1.75	Venta 652	Rey	652	2026-03-13 20:23:41.206111
715	19	VENTA	EFECTIVO	1.50	Venta 653	Rey	653	2026-03-13 20:23:50.027972
716	19	VENTA	TRANSFERENCIA	2.50	Venta 655	Rey	655	2026-03-13 20:56:48.067241
717	19	VENTA	EFECTIVO	3.50	Venta 656	Rey	656	2026-03-13 20:56:56.668372
718	19	VENTA	EFECTIVO	0.75	Venta 657	Rey	657	2026-03-13 20:57:20.486716
719	19	VENTA	EFECTIVO	3.50	Venta 654	Rey	654	2026-03-13 20:59:32.732992
720	19	VENTA	EFECTIVO	3.00	Venta 658	Rey	658	2026-03-13 20:59:42.512793
721	19	VENTA	TRANSFERENCIA	5.25	Venta 659	Rey	659	2026-03-13 21:12:12.788167
722	19	VENTA	EFECTIVO	3.50	Venta 661	Rey	661	2026-03-13 21:36:18.415134
723	19	VENTA	EFECTIVO	3.75	Venta 660	Rey	660	2026-03-13 21:36:58.381135
724	19	VENTA	EFECTIVO	2.25	Venta 662	Rey	662	2026-03-13 21:39:40.756841
725	19	VENTA	EFECTIVO	2.50	Venta 663	Rey	663	2026-03-13 21:43:02.677328
726	19	EGRESO	EFECTIVO	10.00	cAFEEEE	Rey	\N	2026-03-13 21:43:25.137069
727	19	VENTA	EFECTIVO	4.00	Venta 664	Rey	664	2026-03-13 21:55:32.786807
728	19	VENTA	EFECTIVO	2.50	Venta 665	Rey	665	2026-03-13 22:15:49.259943
729	19	VENTA	TRANSFERENCIA	5.00	Venta 666	Rey	666	2026-03-13 22:16:18.461317
730	19	VENTA	TRANSFERENCIA	1.75	Venta 667	Rey	667	2026-03-13 22:16:54.385009
731	19	VENTA	TRANSFERENCIA	4.00	Venta 668	Rey	668	2026-03-13 22:18:13.798788
732	19	VENTA	EFECTIVO	3.50	Venta 669	Rey	669	2026-03-13 22:26:34.884604
733	19	VENTA	EFECTIVO	5.25	Venta 670	Rey	670	2026-03-13 22:32:36.891442
734	19	VENTA	EFECTIVO	3.50	Venta 671	Rey	671	2026-03-13 22:36:52.848629
735	19	VENTA	EFECTIVO	2.50	Venta 672	Rey	672	2026-03-13 22:38:23.668236
736	19	VENTA	EFECTIVO	2.00	Venta 673	Rey	673	2026-03-13 22:39:35.69363
737	19	VENTA	TRANSFERENCIA	5.00	Venta 674	Rey	674	2026-03-13 23:09:28.412349
738	19	EGRESO	EFECTIVO	2.50	comida rey	Rey	\N	2026-03-13 23:25:55.019328
739	19	VENTA	EFECTIVO	1.75	Venta 675	Rey	675	2026-03-13 23:29:24.45396
740	19	VENTA	EFECTIVO	2.50	Venta 676	Rey	676	2026-03-13 23:45:59.557857
741	19	VENTA	EFECTIVO	1.50	Venta 677	Rey	677	2026-03-13 23:49:08.601559
742	20	VENTA	EFECTIVO	1.75	Venta 678	Rey	678	2026-03-14 15:57:56.398067
743	20	VENTA	TRANSFERENCIA	13.50	Venta 679	Rey	679	2026-03-14 16:03:34.241526
744	20	VENTA	TRANSFERENCIA	16.50	Venta 680	Rey	680	2026-03-14 16:28:41.558625
745	20	VENTA	EFECTIVO	3.25	Venta 681	Rey	681	2026-03-14 16:37:32.908512
746	20	VENTA	EFECTIVO	1.50	Venta 682	Rey	682	2026-03-14 16:42:16.029433
747	20	VENTA	EFECTIVO	4.75	Venta 683	Rey	683	2026-03-14 17:19:50.965679
748	20	VENTA	EFECTIVO	2.50	Venta 684	Rey	684	2026-03-14 17:20:23.548868
749	20	EGRESO	EFECTIVO	1.50	AGUA DE TOMAR COMPRA-	Rey	\N	2026-03-14 17:47:26.210221
750	20	VENTA	EFECTIVO	1.75	Venta 685	Rey	685	2026-03-14 17:56:03.410359
751	20	VENTA	EFECTIVO	35.00	Venta 686	Rey	686	2026-03-14 17:56:34.813859
752	20	VENTA	EFECTIVO	4.50	Venta 687	Rey	687	2026-03-14 17:56:42.543406
753	20	VENTA	EFECTIVO	3.25	Venta 688	Rey	688	2026-03-14 18:21:28.613423
754	20	VENTA	EFECTIVO	3.00	Venta 689	Rey	689	2026-03-14 18:42:04.141658
755	20	VENTA	EFECTIVO	0.75	Venta 690	Rey	690	2026-03-14 18:52:13.642861
756	20	VENTA	EFECTIVO	8.50	Venta 691	Rey	691	2026-03-14 19:39:46.183392
757	20	VENTA	EFECTIVO	1.50	Venta 692	Rey	692	2026-03-14 19:39:58.207413
758	20	VENTA	EFECTIVO	2.50	Venta 693	Rey	693	2026-03-14 19:40:15.326941
759	20	VENTA	EFECTIVO	1.50	Venta 694	Rey	694	2026-03-14 19:40:25.721169
760	20	VENTA	EFECTIVO	1.50	Venta 695	Rey	695	2026-03-14 19:59:53.856719
761	20	VENTA	EFECTIVO	1.75	Venta 696	Rey	696	2026-03-14 20:04:00.267623
762	20	VENTA	EFECTIVO	5.00	Venta 697	Rey	697	2026-03-14 20:14:19.237699
765	20	VENTA	EFECTIVO	6.00	Venta 700	Rey	700	2026-03-14 20:25:09.605967
766	20	VENTA	EFECTIVO	5.50	Venta 701	Rey	701	2026-03-14 20:56:51.780339
767	20	VENTA	EFECTIVO	4.50	Venta 702	Rey	702	2026-03-14 21:01:18.019209
768	20	VENTA	EFECTIVO	4.25	Venta 703	Rey	703	2026-03-14 21:03:18.789939
769	20	VENTA	EFECTIVO	3.75	Venta 704	Rey	704	2026-03-14 21:06:49.878877
770	20	VENTA	EFECTIVO	0.75	Venta 705	Rey	705	2026-03-14 21:06:57.531579
771	20	VENTA	EFECTIVO	5.00	Venta 706	Rey	706	2026-03-14 21:07:04.358653
772	20	VENTA	EFECTIVO	2.50	Venta 707	Rey	707	2026-03-14 21:08:57.783352
773	20	VENTA	EFECTIVO	1.50	Venta 708	Rey	708	2026-03-14 21:55:42.305538
774	20	VENTA	EFECTIVO	0.75	Venta 709	Rey	709	2026-03-14 21:57:55.826371
775	20	VENTA	EFECTIVO	5.00	Venta 710	Rey	710	2026-03-14 22:12:12.667505
776	20	VENTA	EFECTIVO	5.00	Venta 711	Rey	711	2026-03-14 22:13:01.975064
777	20	VENTA	TRANSFERENCIA	4.25	Venta 712	Rey	712	2026-03-14 22:22:32.302254
778	20	VENTA	EFECTIVO	2.50	Venta 713	Rey	713	2026-03-14 22:24:11.819228
779	20	VENTA	EFECTIVO	1.50	Venta 714	Rey	714	2026-03-14 22:24:24.380637
780	20	VENTA	EFECTIVO	2.00	Venta 715	Rey	715	2026-03-14 22:30:56.496515
781	20	VENTA	EFECTIVO	3.00	Venta 716	Rey	716	2026-03-14 22:36:03.216893
782	20	VENTA	EFECTIVO	6.50	Venta 717	Rey	717	2026-03-14 22:51:10.454035
783	20	VENTA	EFECTIVO	3.25	Venta 718	Rey	718	2026-03-14 22:53:51.139091
784	20	VENTA	TRANSFERENCIA	10.00	Venta 719	Rey	719	2026-03-14 22:59:18.265774
785	20	VENTA	EFECTIVO	3.25	Venta 720	Rey	720	2026-03-14 23:10:06.922359
786	20	VENTA	EFECTIVO	3.50	Venta 721	Rey	721	2026-03-14 23:10:18.468453
787	20	EGRESO	EFECTIVO	2.50	comida rey	Rey	\N	2026-03-14 23:28:04.914367
788	20	VENTA	EFECTIVO	1.75	Venta 722	Rey	722	2026-03-14 23:35:44.006504
789	20	VENTA	TRANSFERENCIA	7.25	Venta 723	Rey	723	2026-03-14 23:40:35.395679
790	20	VENTA	EFECTIVO	4.50	Venta 724	Rey	724	2026-03-14 23:41:57.857114
791	20	VENTA	EFECTIVO	0.75	Venta 725	Rey	725	2026-03-14 23:47:48.935415
792	20	VENTA	EFECTIVO	2.25	Venta 726	Rey	726	2026-03-14 23:50:46.040636
793	20	EGRESO	EFECTIVO	0.60	alex cogio	Rey	\N	2026-03-14 23:51:48.729176
796	20	VENTA	EFECTIVO	1.50	Venta 728	Rey	728	2026-03-14 23:56:36.143536
797	20	EGRESO	EFECTIVO	2.00	taxi	Rey	\N	2026-03-14 23:57:42.401432
798	20	INGRESO	EFECTIVO	0.25	4 vasos venta	Rey	\N	2026-03-14 23:58:19.681563
799	20	VENTA	EFECTIVO	1.75	Venta 729	Rey	729	2026-03-14 23:58:27.382445
800	20	VENTA	EFECTIVO	4.25	Venta 730	Rey	730	2026-03-15 00:12:04.669857
801	20	VENTA	EFECTIVO	2.50	Venta 731	Rey	731	2026-03-15 00:12:11.663878
802	20	EGRESO	EFECTIVO	100.00	anticipo rey	Rey	\N	2026-03-15 00:18:34.819806
803	20	EGRESO	EFECTIVO	20.00	anticipo alex	Rey	\N	2026-03-15 00:18:48.01028
804	21	VENTA	EFECTIVO	5.25	Venta 732	Alex	732	2026-03-15 15:48:08.270955
805	21	VENTA	EFECTIVO	2.50	Venta 734	Alex	734	2026-03-15 16:32:09.722416
806	21	VENTA	TRANSFERENCIA	5.00	Venta 735	Alex	735	2026-03-15 16:52:11.002345
807	21	VENTA	TRANSFERENCIA	1.75	Venta 736	Alex	736	2026-03-15 17:20:46.680354
808	21	VENTA	EFECTIVO	6.75	Venta 737	Alex	737	2026-03-15 17:21:01.666985
809	21	VENTA	EFECTIVO	5.50	Venta 738	Alex	738	2026-03-15 17:30:43.03255
810	21	VENTA	EFECTIVO	2.50	Venta 739	Alex	739	2026-03-15 17:45:48.847224
811	21	VENTA	EFECTIVO	1.50	Venta 740	Alex	740	2026-03-15 17:54:43.430605
812	21	VENTA	EFECTIVO	8.25	Venta 741	Alex	741	2026-03-15 18:07:23.910171
813	21	VENTA	EFECTIVO	1.50	Venta 742	Alex	742	2026-03-15 18:08:53.606171
814	21	VENTA	EFECTIVO	2.50	Venta 743	Alex	743	2026-03-15 18:34:39.900709
815	21	VENTA	EFECTIVO	5.00	Venta 744	Alex	744	2026-03-15 19:02:00.229805
816	21	VENTA	TRANSFERENCIA	2.50	Venta 745	Alex	745	2026-03-15 19:11:45.094066
821	21	VENTA	EFECTIVO	5.00	Venta 748	Alex	748	2026-03-15 20:12:01.935965
822	21	VENTA	TRANSFERENCIA	5.00	Venta 733	Alex	733	2026-03-15 20:22:33.133154
823	21	VENTA	EFECTIVO	1.50	Venta 752	Alex	752	2026-03-15 20:23:25.781035
824	21	VENTA	EFECTIVO	10.00	Venta 753	Alex	753	2026-03-15 20:23:36.145795
825	21	VENTA	EFECTIVO	5.00	Venta 754	Alex	754	2026-03-15 20:23:51.588244
826	21	VENTA	EFECTIVO	3.00	Venta 755	Alex	755	2026-03-15 20:29:55.426779
827	21	VENTA	TRANSFERENCIA	0.75	Venta 756	Alex	756	2026-03-15 20:39:00.133583
828	21	VENTA	EFECTIVO	1.50	Venta 757	Alex	757	2026-03-15 20:55:26.183062
829	21	VENTA	EFECTIVO	1.50	Venta 758	Alex	758	2026-03-15 21:01:06.527894
830	21	VENTA	EFECTIVO	2.00	Venta 759	Alex	759	2026-03-15 21:02:58.226075
831	21	VENTA	EFECTIVO	3.00	Venta 760	Alex	760	2026-03-15 21:27:29.105782
832	21	VENTA	EFECTIVO	3.50	Venta 761	Alex	761	2026-03-15 21:30:55.850088
833	21	VENTA	EFECTIVO	1.75	Venta 762	Alex	762	2026-03-15 21:38:14.351895
834	21	VENTA	EFECTIVO	3.50	Venta 763	Alex	763	2026-03-15 21:45:28.854445
835	21	VENTA	EFECTIVO	1.75	Venta 764	Alex	764	2026-03-15 21:55:33.367158
836	21	VENTA	EFECTIVO	17.50	Venta 765	Alex	765	2026-03-16 14:32:10.123008
837	21	VENTA	EFECTIVO	3.75	Venta 766	Alex	766	2026-03-16 16:21:02.105838
838	22	VENTA	EFECTIVO	4.00	Venta 767	Alex	767	2026-03-16 18:00:16.794562
839	22	VENTA	TRANSFERENCIA	8.75	Venta 768	Alex	768	2026-03-16 18:01:19.0261
840	22	VENTA	EFECTIVO	4.50	Venta 769	Alex	769	2026-03-16 18:02:30.067795
841	22	EGRESO	EFECTIVO	3.45	gasto de moto con envases de -smoothie -sorbetes	Alex	\N	2026-03-16 18:07:50.780647
842	22	VENTA	EFECTIVO	5.00	Venta 770	Alex	770	2026-03-16 18:10:19.289374
843	22	VENTA	EFECTIVO	3.00	Venta 771	Alex	771	2026-03-16 18:25:12.565557
844	22	VENTA	EFECTIVO	1.75	Venta 772	Alex	772	2026-03-16 18:27:56.815423
845	22	VENTA	EFECTIVO	2.75	Venta 773	Alex	773	2026-03-16 18:48:03.552519
846	22	VENTA	EFECTIVO	3.25	Venta 774	Alex	774	2026-03-16 19:28:47.776192
847	22	VENTA	EFECTIVO	4.50	Venta 775	Alex	775	2026-03-16 19:34:51.254001
848	22	VENTA	EFECTIVO	30.00	Venta 776	Alex	776	2026-03-16 19:37:20.863211
849	22	VENTA	TRANSFERENCIA	2.50	Venta 777	Alex	777	2026-03-16 20:08:50.564861
852	22	VENTA	EFECTIVO	7.50	Venta 780	Alex	780	2026-03-16 20:19:09.760164
853	22	EGRESO	EFECTIVO	2.00	motorizado alex	Alex	\N	2026-03-16 20:39:12.828771
854	22	VENTA	EFECTIVO	1.75	Venta 781	Alex	781	2026-03-16 20:44:47.516487
855	22	VENTA	EFECTIVO	5.00	Venta 782	Alex	782	2026-03-16 21:03:40.372366
856	22	VENTA	EFECTIVO	3.00	Venta 783	Alex	783	2026-03-16 21:05:10.973339
857	22	VENTA	TRANSFERENCIA	2.00	Venta 784	Alex	784	2026-03-16 21:11:41.0671
858	22	VENTA	TRANSFERENCIA	3.00	Venta 785	Alex	785	2026-03-16 21:14:21.237845
859	22	VENTA	EFECTIVO	1.00	Venta 786	Alex	786	2026-03-16 21:14:29.929612
860	22	VENTA	TRANSFERENCIA	3.00	Venta 787	Alex	787	2026-03-16 21:17:38.113297
861	22	VENTA	TRANSFERENCIA	13.50	Venta 788	Alex	788	2026-03-16 21:19:03.762657
862	22	VENTA	EFECTIVO	2.50	Venta 789	Alex	789	2026-03-16 21:29:46.96218
863	22	VENTA	EFECTIVO	1.50	Venta 791	Alex	791	2026-03-16 21:58:57.117944
864	22	EGRESO	EFECTIVO	2.50	comida rey	Alex	\N	2026-03-16 22:01:18.335572
\.


--
-- Data for Name: caja_turnos; Type: TABLE DATA; Schema: public; Owner: -
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
12	2026-03-05 22:58:38.566814	2026-03-06 03:53:04.523198	27.00	0.00	Administrador	Rey	CERRADA
13	2026-03-06 16:26:56.081252	2026-03-07 16:17:38.886549	27.00	0.00	Rey	Rey	CERRADA
14	2026-03-07 16:25:02.916099	2026-03-08 00:13:18.739559	28.35	0.00	Rey	Rey	CERRADA
15	2026-03-09 17:28:08.420333	2026-03-09 23:39:36.182179	25.00	0.00	Rey	Rey	CERRADA
16	2026-03-10 19:00:15.118442	2026-03-11 16:05:57.291831	31.50	0.00	Rey	Rey	CERRADA
17	2026-03-11 16:06:25.843733	2026-03-11 23:19:37.232737	31.50	0.00	Rey	Rey	CERRADA
18	2026-03-12 15:52:23.806139	2026-03-12 23:09:24.513177	32.00	0.00	Rey	Rey	CERRADA
19	2026-03-13 15:42:28.439903	2026-03-14 00:01:31.707727	32.00	0.00	Rey	Rey	CERRADA
20	2026-03-14 15:57:49.153232	2026-03-15 00:18:52.553544	36.00	0.00	Rey	Rey	CERRADA
21	2026-03-15 15:47:42.651363	2026-03-16 17:59:41.872645	34.00	0.00	Alex	Alex	CERRADA
22	2026-03-16 18:00:04.753654	2026-03-16 22:01:02.56505	27.00	0.00	Alex	Alex	CERRADA
\.


--
-- Data for Name: categorias; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categorias (id, nombre, icono) FROM stdin;
1	Smoothies	blender
2	Cocos/Bebidas	coconut
3	Paletas	icecream
4	Combos/Piqueos	restaurant
5	General	\N
\.


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.clientes (id, nombre, identificacion, telefono, email, direccion, notas, created_at) FROM stdin;
1	MECHE	\N	\N	\N	machala	\N	2026-02-25 21:30:13.28815
3	Velur Plaza	\N	\N	\N	\N	\N	2026-02-26 18:55:11.622089
4	Juan Diego	\N	\N	\N	\N	\N	2026-02-26 19:20:21.704434
5	GABRIEL NAGUA	\N	\N	\N	\N	\N	2026-02-26 23:48:32.396391
6	jhon	\N	\N	\N	\N	\N	2026-02-28 17:04:44.998798
7	DON JUNIOR	\N	\N	\N	\N	\N	2026-02-28 22:30:35.550681
2	Xavier quiteño	\N	\N	\N	\N	\N	2026-02-26 17:37:31.904303
8	ROBERTO	\N	\N	\N	\N	\N	2026-03-06 21:37:55.72332
9	Abigail sigcho	\N	\N	\N	\N	\N	2026-03-11 19:09:49.796432
\.


--
-- Data for Name: config_impresora; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.config_impresora (id, nombre_impresora, tipo, ancho_mm, auto_imprimir, updated_at) FROM stdin;
1		TERMICA	80	f	2026-03-04 19:08:44.278761
\.


--
-- Data for Name: detalle_ventas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.detalle_ventas (id, id_venta, id_producto, cantidad, precio_unitario, subtotal) FROM stdin;
\.


--
-- Data for Name: facturas; Type: TABLE DATA; Schema: public; Owner: -
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
36	REC-000000036	378	RECIBO	2026-03-06 16:31:51.962446	Consumidor Final	9999999999999				20.00	0.00	0.00	20.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 20797778	Rey	\N	\N	t
33	REC-000000033	374	RECIBO	2026-03-05 23:39:45.198371	Consumidor Final	9999999999999				2.75	0.00	0.00	2.75	EFECTIVO	EMITIDA	\N	Administrador	\N	\N	t
34	REC-000000034	375	RECIBO	2026-03-06 16:28:32.062504	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
35	REC-000000035	377	RECIBO	2026-03-06 16:30:22.813188	Consumidor Final	9999999999999				40.00	0.00	0.00	40.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
37	REC-000000037	379	RECIBO	2026-03-06 16:38:29.719492	Consumidor Final	9999999999999				16.50	0.00	0.00	16.50	TRANSFERENCIA	EMITIDA	POR PAGAR | Banco: Banco Pichincha | Comprobante: idk	Rey	\N	\N	f
38	REC-000000038	380	RECIBO	2026-03-06 17:55:19.498284	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
39	REC-000000039	381	RECIBO	2026-03-06 17:55:37.436856	Xavier quiteño	9999999999999				3.75	0.00	0.00	3.75	CREDITO	EMITIDA	\N	Rey	\N	\N	f
40	REC-000000040	382	RECIBO	2026-03-06 18:00:46.934243	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
41	REC-000000041	383	RECIBO	2026-03-06 18:10:39.838615	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	t
42	REC-000000042	384	RECIBO	2026-03-06 18:26:03.636636	Consumidor Final	9999999999999				4.00	0.00	0.00	4.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 59860225	Rey	\N	\N	f
43	REC-000000043	385	RECIBO	2026-03-06 18:33:54.359345	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
44	REC-000000044	386	RECIBO	2026-03-06 18:36:22.969995	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
45	REC-000000045	387	RECIBO	2026-03-06 19:01:50.825645	Consumidor Final	9999999999999				7.00	0.00	0.00	7.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
46	REC-000000046	388	RECIBO	2026-03-06 20:15:16.484686	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 65189284	Rey	\N	\N	f
47	REC-000000047	389	RECIBO	2026-03-06 20:15:47.556474	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 65378235	Rey	\N	\N	f
48	REC-000000048	390	RECIBO	2026-03-06 20:16:07.617138	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
49	REC-000000049	391	RECIBO	2026-03-06 20:38:20.971623	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
50	REC-000000050	392	RECIBO	2026-03-06 20:57:47.819751	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	TRANSFERENCIA	EMITIDA	Banco: Banco del Pacífico | Comprobante: 19122026030620506750	Rey	\N	\N	f
51	REC-000000051	393	RECIBO	2026-03-06 20:58:08.170311	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
52	REC-000000052	394	RECIBO	2026-03-06 20:58:14.806008	Consumidor Final	9999999999999				2.25	0.00	0.00	2.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
53	REC-000000053	395	RECIBO	2026-03-06 20:58:44.491236	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
54	REC-000000054	396	RECIBO	2026-03-06 21:02:05.252475	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
55	REC-000000055	397	RECIBO	2026-03-06 21:28:36.602791	Consumidor Final	9999999999999				7.00	0.00	0.00	7.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
56	REC-000000056	398	RECIBO	2026-03-06 21:28:50.762704	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
57	REC-000000057	399	RECIBO	2026-03-06 21:28:58.087793	Consumidor Final	9999999999999				2.00	0.00	0.00	2.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
58	REC-000000058	400	RECIBO	2026-03-06 21:36:13.086324	Consumidor Final	9999999999999				1.00	0.00	0.00	1.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
59	REC-000000059	401	RECIBO	2026-03-06 21:38:28.777772	ROBERTO	9999999999999				1.50	0.00	0.00	1.50	CREDITO	EMITIDA	\N	Rey	\N	\N	t
60	REC-000000060	402	RECIBO	2026-03-06 21:38:43.602184	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
61	REC-000000061	403	RECIBO	2026-03-06 21:40:31.265142	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
62	REC-000000062	404	RECIBO	2026-03-06 21:51:45.244759	Consumidor Final	9999999999999				6.75	0.00	0.00	6.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
63	REC-000000063	405	RECIBO	2026-03-06 21:56:26.272245	Consumidor Final	9999999999999				0.75	0.00	0.00	0.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
64	REC-000000064	406	RECIBO	2026-03-06 22:41:44.074634	Consumidor Final	9999999999999				6.75	0.00	0.00	6.75	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 2204100099	Rey	\N	\N	f
65	REC-000000065	407	RECIBO	2026-03-06 22:42:45.111849	Consumidor Final	9999999999999				4.50	0.00	0.00	4.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
66	REC-000000066	408	RECIBO	2026-03-06 22:42:53.83003	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
67	REC-000000067	409	RECIBO	2026-03-06 22:48:40.190336	Consumidor Final	9999999999999				7.00	0.00	0.00	7.00	DIVIDIDO	EMITIDA	\N	Rey	\N	\N	f
68	REC-000000068	410	RECIBO	2026-03-06 22:55:03.288549	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
69	REC-000000069	411	RECIBO	2026-03-06 22:56:37.967376	Consumidor Final	9999999999999				4.25	0.00	0.00	4.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
70	REC-000000070	340	RECIBO	2026-03-06 23:26:49.636839	Consumidor Final	9999999999999				11.75	0.00	0.00	11.75	DIVIDIDO	EMITIDA	\N	Rey	\N	\N	f
71	REC-000000071	412	RECIBO	2026-03-06 23:29:12.404863	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	TRANSFERENCIA	EMITIDA	Banco: Banco Bolivariano | Comprobante: 56132677	Rey	\N	\N	f
72	REC-000000072	415	RECIBO	2026-03-06 23:30:24.584723	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 900605752------	Rey	\N	\N	f
73	REC-000000073	416	RECIBO	2026-03-06 23:31:03.683377	Consumidor Final	9999999999999				2.25	0.00	0.00	2.25	DE_UNA	EMITIDA	900477923	Rey	\N	\N	f
74	REC-000000074	417	RECIBO	2026-03-06 23:33:03.117888	Consumidor Final	9999999999999				9.00	0.00	0.00	9.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 73905984	Rey	\N	\N	f
75	REC-000000075	418	RECIBO	2026-03-06 23:56:29.053967	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
76	REC-000000076	419	RECIBO	2026-03-06 23:56:49.094209	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
77	REC-000000077	420	RECIBO	2026-03-07 00:09:05.50142	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 2205962068	Rey	\N	\N	f
78	REC-000000078	421	RECIBO	2026-03-07 00:09:34.423653	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
79	REC-000000079	422	RECIBO	2026-03-07 00:27:18.471386	Consumidor Final	9999999999999				7.00	0.00	0.00	7.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
80	REC-000000080	423	RECIBO	2026-03-07 16:04:57.949596	Consumidor Final	9999999999999				8.25	0.00	0.00	8.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
81	REC-000000081	424	RECIBO	2026-03-07 16:07:39.114647	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
82	REC-000000082	425	RECIBO	2026-03-07 16:09:03.491664	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
83	REC-000000083	426	RECIBO	2026-03-07 16:09:33.975424	Consumidor Final	9999999999999				0.75	0.00	0.00	0.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
84	REC-000000084	427	RECIBO	2026-03-07 16:25:10.403506	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
85	REC-000000085	428	RECIBO	2026-03-07 16:25:21.479217	Consumidor Final	9999999999999				1.00	0.00	0.00	1.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
86	REC-000000086	429	RECIBO	2026-03-07 16:33:55.072927	Consumidor Final	9999999999999				3.75	0.00	0.00	3.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
87	REC-000000087	430	RECIBO	2026-03-07 17:21:52.913227	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
88	REC-000000088	431	RECIBO	2026-03-07 17:50:06.52413	Consumidor Final	9999999999999				0.75	0.00	0.00	0.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
89	REC-000000089	432	RECIBO	2026-03-07 19:33:02.985389	DON JUNIOR	9999999999999				3.50	0.00	0.00	3.50	CREDITO	EMITIDA	\N	Rey	\N	\N	f
90	REC-000000090	433	RECIBO	2026-03-07 19:58:47.570847	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
91	REC-000000091	434	RECIBO	2026-03-07 19:58:59.797054	Consumidor Final	9999999999999				2.25	0.00	0.00	2.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
92	REC-000000092	435	RECIBO	2026-03-07 19:59:08.220432	Consumidor Final	9999999999999				1.00	0.00	0.00	1.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
93	REC-000000093	436	RECIBO	2026-03-07 20:11:33.320428	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
94	REC-000000094	437	RECIBO	2026-03-07 20:11:45.056468	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
95	REC-000000095	438	RECIBO	2026-03-07 20:25:31.534955	Consumidor Final	9999999999999				8.75	0.00	0.00	8.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
96	REC-000000096	439	RECIBO	2026-03-07 20:51:40.42394	Consumidor Final	9999999999999				5.50	0.00	0.00	5.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 51059789	Rey	\N	\N	f
97	REC-000000097	440	RECIBO	2026-03-07 20:51:54.396745	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
98	REC-000000098	441	RECIBO	2026-03-07 21:44:10.375486	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
99	REC-000000099	443	RECIBO	2026-03-07 21:45:05.800393	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
100	REC-000000100	444	RECIBO	2026-03-07 21:45:15.463633	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
101	REC-000000101	445	RECIBO	2026-03-07 21:45:44.65841	Consumidor Final	9999999999999				2.25	0.00	0.00	2.25	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 52986227	Rey	\N	\N	f
102	REC-000000102	446	RECIBO	2026-03-07 21:46:28.813719	Consumidor Final	9999999999999				6.00	0.00	0.00	6.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
103	REC-000000103	447	RECIBO	2026-03-07 21:58:34.585351	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
104	REC-000000104	448	RECIBO	2026-03-07 22:32:05.727358	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
105	REC-000000105	449	RECIBO	2026-03-07 22:32:33.390299	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
106	REC-000000106	450	RECIBO	2026-03-07 22:32:42.405757	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
107	REC-000000107	451	RECIBO	2026-03-07 22:33:46.849014	Consumidor Final	9999999999999				2.00	0.00	0.00	2.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
108	REC-000000108	452	RECIBO	2026-03-07 22:37:40.642177	Consumidor Final	9999999999999				4.25	0.00	0.00	4.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
109	REC-000000109	453	RECIBO	2026-03-07 22:38:24.743542	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 54386265	Rey	\N	\N	f
110	REC-000000110	454	RECIBO	2026-03-07 22:40:04.607683	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
111	REC-000000111	455	RECIBO	2026-03-07 22:55:29.973852	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
112	REC-000000112	476	RECIBO	2026-03-07 23:46:03.859788	Consumidor Final	9999999999999				6.00	0.00	0.00	6.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
113	REC-000000113	477	RECIBO	2026-03-07 23:46:32.669666	Consumidor Final	9999999999999				20.00	0.00	0.00	20.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 55790300	Rey	\N	\N	f
114	REC-000000114	478	RECIBO	2026-03-07 23:47:53.96466	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
115	REC-000000115	479	RECIBO	2026-03-07 23:48:02.354463	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
116	REC-000000116	480	RECIBO	2026-03-07 23:48:22.053323	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
117	REC-000000117	481	RECIBO	2026-03-07 23:55:52.596503	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
118	REC-000000118	482	RECIBO	2026-03-07 23:57:36.107376	Consumidor Final	9999999999999				2.25	0.00	0.00	2.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
119	REC-000000119	483	RECIBO	2026-03-08 00:04:47.375678	Consumidor Final	9999999999999				7.00	0.00	0.00	7.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
120	REC-000000120	484	RECIBO	2026-03-08 18:55:20.643479	Consumidor Final	9999999999999				9.00	0.00	0.00	9.00	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
121	REC-000000121	485	RECIBO	2026-03-08 18:56:05.68496	Consumidor Final	9999999999999				12.25	0.00	0.00	12.25	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
122	REC-000000122	486	RECIBO	2026-03-08 18:58:54.108748	Consumidor Final	9999999999999				6.00	0.00	0.00	6.00	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
123	REC-000000123	487	RECIBO	2026-03-08 19:01:39.965804	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	TARJETA_CREDITO	EMITIDA	carlitos	Alex	\N	\N	f
124	REC-000000124	488	RECIBO	2026-03-08 19:03:29.000871	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	TRANSFERENCIA	EMITIDA	2213209451 | Banco: Banco Pichincha | Comprobante: 2213209451	Alex	\N	\N	f
125	REC-000000125	489	RECIBO	2026-03-08 19:07:58.760062	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
126	REC-000000126	490	RECIBO	2026-03-08 19:08:19.780649	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
127	REC-000000127	491	RECIBO	2026-03-08 19:08:42.644843	Consumidor Final	9999999999999				2.00	0.00	0.00	2.00	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
128	REC-000000128	492	RECIBO	2026-03-08 19:09:06.572028	Consumidor Final	9999999999999				7.50	0.00	0.00	7.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
129	REC-000000129	494	RECIBO	2026-03-08 19:36:52.336145	Consumidor Final	9999999999999				0.75	0.00	0.00	0.75	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
130	REC-000000130	493	RECIBO	2026-03-08 19:42:29.9848	Consumidor Final	9999999999999				9.25	0.00	0.00	9.25	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
131	REC-000000131	495	RECIBO	2026-03-08 19:48:18.110828	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 2207039386	Alex	\N	\N	f
132	REC-000000132	498	RECIBO	2026-03-08 19:51:42.706581	Consumidor Final	9999999999999				4.50	0.00	0.00	4.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
133	REC-000000133	499	RECIBO	2026-03-08 20:05:23.541369	Consumidor Final	9999999999999				2.75	0.00	0.00	2.75	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
134	REC-000000134	500	RECIBO	2026-03-08 20:11:39.145853	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
135	REC-000000135	501	RECIBO	2026-03-08 20:23:01.469319	Consumidor Final	9999999999999				5.25	0.00	0.00	5.25	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
136	REC-000000136	504	RECIBO	2026-03-08 20:31:00.909645	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
137	REC-000000137	505	RECIBO	2026-03-08 20:34:22.821459	Consumidor Final	9999999999999				4.25	0.00	0.00	4.25	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
138	REC-000000138	506	RECIBO	2026-03-08 20:42:42.621532	Consumidor Final	9999999999999				4.00	0.00	0.00	4.00	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
139	REC-000000139	507	RECIBO	2026-03-08 20:50:01.508153	Consumidor Final	9999999999999				3.75	0.00	0.00	3.75	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 220-6148567	Alex	\N	\N	f
140	REC-000000140	510	RECIBO	2026-03-08 20:50:48.00209	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
141	REC-000000141	511	RECIBO	2026-03-08 21:10:11.882469	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
142	REC-000000142	512	RECIBO	2026-03-08 21:26:10.784565	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
143	REC-000000143	515	RECIBO	2026-03-09 16:45:13.382841	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
144	REC-000000144	516	RECIBO	2026-03-09 17:30:52.65707	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
145	REC-000000145	517	RECIBO	2026-03-09 17:31:01.091298	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
146	REC-000000146	518	RECIBO	2026-03-09 17:31:46.477123	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
147	REC-000000147	519	RECIBO	2026-03-09 17:31:57.357329	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
148	REC-000000148	520	RECIBO	2026-03-09 17:34:13.474934	Consumidor Final	9999999999999				35.00	0.00	0.00	35.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	t
149	REC-000000149	521	RECIBO	2026-03-09 17:34:42.464791	Consumidor Final	9999999999999				10.00	0.00	0.00	10.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
150	REC-000000150	522	RECIBO	2026-03-09 17:42:41.272325	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
151	REC-000000151	523	RECIBO	2026-03-09 19:31:40.278804	Consumidor Final	9999999999999				4.25	0.00	0.00	4.25	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 166303280	Rey	\N	\N	f
152	REC-000000152	524	RECIBO	2026-03-09 19:32:06.193894	Consumidor Final	9999999999999				6.00	0.00	0.00	6.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
153	REC-000000153	525	RECIBO	2026-03-09 19:45:00.439872	Consumidor Final	9999999999999				5.25	0.00	0.00	5.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
154	REC-000000154	526	RECIBO	2026-03-09 20:26:22.070732	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
155	REC-000000155	529	RECIBO	2026-03-09 20:46:58.790316	Consumidor Final	9999999999999				4.00	0.00	0.00	4.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
156	REC-000000156	531	RECIBO	2026-03-09 21:09:43.489401	Consumidor Final	9999999999999				4.75	0.00	0.00	4.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
157	REC-000000157	530	RECIBO	2026-03-09 21:34:07.520567	Consumidor Final	9999999999999				4.25	0.00	0.00	4.25	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 175208130	Rey	\N	\N	f
158	REC-000000158	532	RECIBO	2026-03-09 21:46:48.02144	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 174927731	Rey	\N	\N	f
159	REC-000000159	533	RECIBO	2026-03-09 21:47:18.043703	Consumidor Final	9999999999999				5.25	0.00	0.00	5.25	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 173958795	Rey	\N	\N	f
160	REC-000000160	534	RECIBO	2026-03-09 21:47:39.704882	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
161	REC-000000161	535	RECIBO	2026-03-09 21:48:08.198057	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
162	REC-000000162	538	RECIBO	2026-03-09 21:48:38.472027	Consumidor Final	9999999999999				6.50	0.00	0.00	6.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
163	REC-000000163	539	RECIBO	2026-03-09 22:21:49.857642	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
164	REC-000000164	540	RECIBO	2026-03-09 22:22:04.211964	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
165	REC-000000165	541	RECIBO	2026-03-09 22:22:28.068869	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 176480997	Rey	\N	\N	f
166	REC-000000166	544	RECIBO	2026-03-09 23:04:49.146641	Consumidor Final	9999999999999				5.25	0.00	0.00	5.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
167	REC-000000167	545	RECIBO	2026-03-09 23:06:40.32117	Consumidor Final	9999999999999				1.00	0.00	0.00	1.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
168	REC-000000168	546	RECIBO	2026-03-09 23:10:48.69006	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
169	REC-000000169	547	RECIBO	2026-03-09 23:27:46.901006	Consumidor Final	9999999999999				8.75	0.00	0.00	8.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
170	REC-000000170	548	RECIBO	2026-03-09 23:29:51.386216	Consumidor Final	9999999999999				6.75	0.00	0.00	6.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
171	REC-000000171	551	RECIBO	2026-03-09 23:34:14.808186	Consumidor Final	9999999999999				4.00	0.00	0.00	4.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
172	REC-000000172	552	RECIBO	2026-03-09 23:36:39.877392	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
173	REC-000000173	553	RECIBO	2026-03-10 19:20:20.095318	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
174	REC-000000174	554	RECIBO	2026-03-10 19:20:58.463711	Consumidor Final	9999999999999				6.00	0.00	0.00	6.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
175	REC-000000175	555	RECIBO	2026-03-10 19:21:03.761172	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
176	REC-000000176	556	RECIBO	2026-03-10 19:21:39.609173	Consumidor Final	9999999999999				6.00	0.00	0.00	6.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
177	REC-000000177	557	RECIBO	2026-03-10 19:21:45.246024	Consumidor Final	9999999999999				1.00	0.00	0.00	1.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
178	REC-000000178	560	RECIBO	2026-03-10 19:45:04.055082	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	TRANSFERENCIA	EMITIDA	Banco: Banco Guayaquil | Comprobante: 0013413808	Rey	\N	\N	f
179	REC-000000179	561	RECIBO	2026-03-10 20:16:41.039642	Consumidor Final	9999999999999				11.50	0.00	0.00	11.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
180	REC-000000180	562	RECIBO	2026-03-10 20:17:04.323408	Consumidor Final	9999999999999				4.50	0.00	0.00	4.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
181	REC-000000181	563	RECIBO	2026-03-10 20:18:50.522027	Consumidor Final	9999999999999				1.00	0.00	0.00	1.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
182	REC-000000182	564	RECIBO	2026-03-10 20:21:44.462351	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
183	REC-000000183	565	RECIBO	2026-03-10 20:29:52.79531	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
184	REC-000000184	566	RECIBO	2026-03-10 20:32:04.055952	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
185	REC-000000185	567	RECIBO	2026-03-10 21:07:44.86597	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
186	REC-000000186	568	RECIBO	2026-03-10 21:11:19.745489	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 49820448	Rey	\N	\N	f
187	REC-000000187	569	RECIBO	2026-03-10 21:12:12.440962	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
188	REC-000000188	570	RECIBO	2026-03-10 21:18:04.78089	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
189	REC-000000189	571	RECIBO	2026-03-10 21:18:56.905021	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
190	REC-000000190	572	RECIBO	2026-03-10 21:20:48.084702	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
191	REC-000000191	573	RECIBO	2026-03-10 22:26:55.430932	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	TRANSFERENCIA	EMITIDA	Banco: Banco Guayaquil | Comprobante: 1121	Rey	\N	\N	f
192	REC-000000192	574	RECIBO	2026-03-10 22:27:06.177723	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
193	REC-000000193	575	RECIBO	2026-03-11 16:33:18.908891	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 2208640474	Rey	\N	\N	f
194	REC-000000194	576	RECIBO	2026-03-11 17:42:13.296073	Consumidor Final	9999999999999				1.00	0.00	0.00	1.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
195	REC-000000195	577	RECIBO	2026-03-11 18:22:49.783985	Consumidor Final	9999999999999				14.00	0.00	0.00	14.00	TRANSFERENCIA	EMITIDA	Banco: Banco Guayaquil | Comprobante: 0000873004	Rey	\N	\N	f
196	REC-000000196	578	RECIBO	2026-03-11 19:08:43.559975	Consumidor Final	9999999999999				4.25	0.00	0.00	4.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
197	REC-000000197	579	RECIBO	2026-03-11 19:10:35.923618	Abigail sigcho	9999999999999				2.50	0.00	0.00	2.50	CREDITO	EMITIDA	\N	Rey	\N	\N	t
198	REC-000000198	580	RECIBO	2026-03-11 20:01:19.175148	Consumidor Final	9999999999999				7.50	0.00	0.00	7.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
199	REC-000000199	581	RECIBO	2026-03-11 21:15:51.139774	Consumidor Final	9999999999999				3.25	0.00	0.00	3.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
200	REC-000000200	582	RECIBO	2026-03-11 21:16:05.229547	Consumidor Final	9999999999999				10.00	0.00	0.00	10.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
201	REC-000000201	585	RECIBO	2026-03-11 21:28:59.692955	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
202	REC-000000202	586	RECIBO	2026-03-11 21:31:41.502967	Consumidor Final	9999999999999				1.00	0.00	0.00	1.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
203	REC-000000203	587	RECIBO	2026-03-11 21:33:47.929303	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
204	REC-000000204	588	RECIBO	2026-03-11 22:14:57.712659	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
205	REC-000000205	589	RECIBO	2026-03-11 22:57:23.256362	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
206	REC-000000206	590	RECIBO	2026-03-11 22:59:36.884356	Consumidor Final	9999999999999				15.00	0.00	0.00	15.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 61303175	Rey	\N	\N	f
207	REC-000000207	591	RECIBO	2026-03-11 23:08:39.028841	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 63152732	Rey	\N	\N	f
208	REC-000000208	592	RECIBO	2026-03-11 23:10:29.581465	Consumidor Final	9999999999999				8.00	0.00	0.00	8.00	DIVIDIDO	EMITIDA	Banco: Banco Pichincha	Rey	\N	\N	f
209	REC-000000209	593	RECIBO	2026-03-11 23:13:15.896239	Consumidor Final	9999999999999				4.00	0.00	0.00	4.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 900578805	Rey	\N	\N	f
210	REC-000000210	594	RECIBO	2026-03-12 15:57:08.895851	Consumidor Final	9999999999999				6.50	0.00	0.00	6.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
211	REC-000000211	595	RECIBO	2026-03-12 15:57:35.276663	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
212	REC-000000212	596	RECIBO	2026-03-12 15:58:06.700761	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
213	REC-000000213	597	RECIBO	2026-03-12 15:58:58.177977	Consumidor Final	9999999999999				14.70	0.00	0.00	14.70	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: por pagar	Rey	\N	\N	f
214	REC-000000214	598	RECIBO	2026-03-12 15:59:34.213638	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
215	REC-000000215	599	RECIBO	2026-03-12 16:14:17.425259	Consumidor Final	9999999999999				0.75	0.00	0.00	0.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
216	REC-000000216	600	RECIBO	2026-03-12 17:17:35.436667	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 46000015	Rey	\N	\N	f
217	REC-000000217	601	RECIBO	2026-03-12 17:18:16.74037	Consumidor Final	9999999999999				2.00	0.00	0.00	2.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 43584598	Rey	\N	\N	f
218	REC-000000218	604	RECIBO	2026-03-12 17:19:01.089474	Consumidor Final	9999999999999				4.50	0.00	0.00	4.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
219	REC-000000219	605	RECIBO	2026-03-12 17:19:12.922808	Consumidor Final	9999999999999				8.25	0.00	0.00	8.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
220	REC-000000220	606	RECIBO	2026-03-12 17:43:35.65787	Consumidor Final	9999999999999				6.00	0.00	0.00	6.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
221	REC-000000221	607	RECIBO	2026-03-12 17:48:07.387539	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
222	REC-000000222	608	RECIBO	2026-03-12 18:24:57.155796	Consumidor Final	9999999999999				3.25	0.00	0.00	3.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
223	REC-000000223	609	RECIBO	2026-03-12 19:03:53.275387	Consumidor Final	9999999999999				2.25	0.00	0.00	2.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
224	REC-000000224	610	RECIBO	2026-03-12 19:06:34.948873	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
225	REC-000000225	611	RECIBO	2026-03-12 19:16:46.895561	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
226	REC-000000226	612	RECIBO	2026-03-12 19:38:43.145662	Consumidor Final	9999999999999				6.75	0.00	0.00	6.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
227	REC-000000227	613	RECIBO	2026-03-12 20:13:49.637834	Consumidor Final	9999999999999				20.00	0.00	0.00	20.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: idk	Rey	\N	\N	f
228	REC-000000228	614	RECIBO	2026-03-12 20:49:49.721959	Consumidor Final	9999999999999				7.00	0.00	0.00	7.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 60512251	Rey	\N	\N	f
229	REC-000000229	617	RECIBO	2026-03-12 21:12:57.629044	Consumidor Final	9999999999999				6.00	0.00	0.00	6.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
230	REC-000000230	618	RECIBO	2026-03-12 21:55:01.970273	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
231	REC-000000231	619	RECIBO	2026-03-12 21:55:24.714897	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 61811303	Rey	\N	\N	f
232	REC-000000232	620	RECIBO	2026-03-12 21:56:13.176447	Xavier quiteño	9999999999999				16.50	0.00	0.00	16.50	CREDITO	EMITIDA	SEÑOR -QUITEÑO	Rey	\N	\N	f
233	REC-000000233	621	RECIBO	2026-03-12 22:02:30.970868	Consumidor Final	9999999999999				3.75	0.00	0.00	3.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
234	REC-000000234	622	RECIBO	2026-03-12 22:08:16.327677	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
235	REC-000000235	623	RECIBO	2026-03-12 22:11:52.435524	Consumidor Final	9999999999999				5.25	0.00	0.00	5.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
236	REC-000000236	624	RECIBO	2026-03-12 22:44:08.960934	Consumidor Final	9999999999999				9.00	0.00	0.00	9.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
237	REC-000000237	625	RECIBO	2026-03-12 22:44:15.722113	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
238	REC-000000238	626	RECIBO	2026-03-12 22:44:29.230056	Consumidor Final	9999999999999				2.25	0.00	0.00	2.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
239	REC-000000239	627	RECIBO	2026-03-12 23:03:13.836641	Consumidor Final	9999999999999				4.50	0.00	0.00	4.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
240	REC-000000240	628	RECIBO	2026-03-12 23:03:47.484325	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
241	REC-000000241	629	RECIBO	2026-03-13 15:44:32.664185	Consumidor Final	9999999999999				0.75	0.00	0.00	0.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
242	REC-000000242	630	RECIBO	2026-03-13 16:37:07.392995	Consumidor Final	9999999999999				4.75	0.00	0.00	4.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
243	REC-000000243	631	RECIBO	2026-03-13 16:43:00.973857	Consumidor Final	9999999999999				5.25	0.00	0.00	5.25	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 47842590	Rey	\N	\N	f
244	REC-000000244	632	RECIBO	2026-03-13 16:44:02.417972	Consumidor Final	9999999999999				6.75	0.00	0.00	6.75	TRANSFERENCIA	EMITIDA	Banco: Banco Bolivariano | Comprobante: 962875830	Rey	\N	\N	t
245	REC-000000245	633	RECIBO	2026-03-13 16:59:42.38669	Consumidor Final	9999999999999				3.25	0.00	0.00	3.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
246	REC-000000246	634	RECIBO	2026-03-13 17:05:41.913317	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
247	REC-000000247	635	RECIBO	2026-03-13 17:20:46.328564	Consumidor Final	9999999999999				6.00	0.00	0.00	6.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
248	REC-000000248	636	RECIBO	2026-03-13 17:34:13.93689	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
249	REC-000000249	637	RECIBO	2026-03-13 17:42:55.722005	Consumidor Final	9999999999999				35.00	0.00	0.00	35.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
250	REC-000000250	640	RECIBO	2026-03-13 17:53:55.582036	Consumidor Final	9999999999999				3.25	0.00	0.00	3.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
251	REC-000000251	641	RECIBO	2026-03-13 18:02:10.852674	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
252	REC-000000252	642	RECIBO	2026-03-13 18:07:33.229301	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
253	REC-000000253	643	RECIBO	2026-03-13 18:30:36.058649	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
254	REC-000000254	644	RECIBO	2026-03-13 18:44:25.759229	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	TRANSFERENCIA	EMITIDA	Banco: Banco Guayaquil | Comprobante: 0000845397	Rey	\N	\N	f
255	REC-000000255	645	RECIBO	2026-03-13 19:13:39.915056	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
256	REC-000000256	646	RECIBO	2026-03-13 19:13:54.457956	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
257	REC-000000257	647	RECIBO	2026-03-13 19:22:02.371255	Consumidor Final	9999999999999				24.75	0.00	0.00	24.75	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: jbkj	Rey	\N	\N	f
258	REC-000000258	648	RECIBO	2026-03-13 19:31:46.704336	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
259	REC-000000259	649	RECIBO	2026-03-13 19:45:52.507726	Consumidor Final	9999999999999				0.75	0.00	0.00	0.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
260	REC-000000260	650	RECIBO	2026-03-13 19:55:01.553463	Consumidor Final	9999999999999				10.00	0.00	0.00	10.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 62344723	Rey	\N	\N	f
261	REC-000000261	651	RECIBO	2026-03-13 20:00:08.553258	Consumidor Final	9999999999999				3.25	0.00	0.00	3.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
262	REC-000000262	652	RECIBO	2026-03-13 20:23:41.206111	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
263	REC-000000263	653	RECIBO	2026-03-13 20:23:50.027972	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
264	REC-000000264	655	RECIBO	2026-03-13 20:56:48.067241	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 66952601	Rey	\N	\N	f
265	REC-000000265	656	RECIBO	2026-03-13 20:56:56.668372	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
266	REC-000000266	657	RECIBO	2026-03-13 20:57:20.486716	Consumidor Final	9999999999999				0.75	0.00	0.00	0.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
267	REC-000000267	654	RECIBO	2026-03-13 20:59:32.732992	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
268	REC-000000268	658	RECIBO	2026-03-13 20:59:42.512793	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
269	REC-000000269	659	RECIBO	2026-03-13 21:12:12.788167	Consumidor Final	9999999999999				5.25	0.00	0.00	5.25	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 67839869	Rey	\N	\N	t
270	REC-000000270	661	RECIBO	2026-03-13 21:36:18.415134	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
271	REC-000000271	660	RECIBO	2026-03-13 21:36:58.381135	Consumidor Final	9999999999999				3.75	0.00	0.00	3.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
272	REC-000000272	662	RECIBO	2026-03-13 21:39:40.756841	Consumidor Final	9999999999999				2.25	0.00	0.00	2.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
273	REC-000000273	663	RECIBO	2026-03-13 21:43:02.677328	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
274	REC-000000274	664	RECIBO	2026-03-13 21:55:32.786807	Consumidor Final	9999999999999				4.00	0.00	0.00	4.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
275	REC-000000275	665	RECIBO	2026-03-13 22:15:49.259943	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
276	REC-000000276	666	RECIBO	2026-03-13 22:16:18.461317	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 70077336	Rey	\N	\N	f
277	REC-000000277	667	RECIBO	2026-03-13 22:16:54.385009	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 70036804	Rey	\N	\N	f
278	REC-000000278	668	RECIBO	2026-03-13 22:18:13.798788	Consumidor Final	9999999999999				4.00	0.00	0.00	4.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: ES DE -LA -JEPPP---:- JM2026MAR00213201683	Rey	\N	\N	f
279	REC-000000279	669	RECIBO	2026-03-13 22:26:34.884604	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
280	REC-000000280	670	RECIBO	2026-03-13 22:32:36.891442	Consumidor Final	9999999999999				5.25	0.00	0.00	5.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
281	REC-000000281	671	RECIBO	2026-03-13 22:36:52.848629	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
282	REC-000000282	672	RECIBO	2026-03-13 22:38:23.668236	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
283	REC-000000283	673	RECIBO	2026-03-13 22:39:35.69363	Consumidor Final	9999999999999				2.00	0.00	0.00	2.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
284	REC-000000284	674	RECIBO	2026-03-13 23:09:28.412349	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 900842659	Rey	\N	\N	f
285	REC-000000285	675	RECIBO	2026-03-13 23:29:24.45396	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
286	REC-000000286	676	RECIBO	2026-03-13 23:45:59.557857	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
287	REC-000000287	677	RECIBO	2026-03-13 23:49:08.601559	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
288	REC-000000288	678	RECIBO	2026-03-14 15:57:56.398067	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
289	REC-000000289	679	RECIBO	2026-03-14 16:03:34.241526	Consumidor Final	9999999999999				13.50	0.00	0.00	13.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: idk	Rey	\N	\N	f
290	REC-000000290	680	RECIBO	2026-03-14 16:28:41.558625	Consumidor Final	9999999999999				16.50	0.00	0.00	16.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 34639279	Rey	\N	\N	f
291	REC-000000291	681	RECIBO	2026-03-14 16:37:32.908512	Consumidor Final	9999999999999				3.25	0.00	0.00	3.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
292	REC-000000292	682	RECIBO	2026-03-14 16:42:16.029433	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
293	REC-000000293	683	RECIBO	2026-03-14 17:19:50.965679	Consumidor Final	9999999999999				4.75	0.00	0.00	4.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
294	REC-000000294	684	RECIBO	2026-03-14 17:20:23.548868	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
295	REC-000000295	685	RECIBO	2026-03-14 17:56:03.410359	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
296	REC-000000296	686	RECIBO	2026-03-14 17:56:34.813859	Consumidor Final	9999999999999				35.00	0.00	0.00	35.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
297	REC-000000297	687	RECIBO	2026-03-14 17:56:42.543406	Consumidor Final	9999999999999				4.50	0.00	0.00	4.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
298	REC-000000298	688	RECIBO	2026-03-14 18:21:28.613423	Consumidor Final	9999999999999				3.25	0.00	0.00	3.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
299	REC-000000299	689	RECIBO	2026-03-14 18:42:04.141658	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
300	REC-000000300	690	RECIBO	2026-03-14 18:52:13.642861	Consumidor Final	9999999999999				0.75	0.00	0.00	0.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
301	REC-000000301	691	RECIBO	2026-03-14 19:39:46.183392	Consumidor Final	9999999999999				8.50	0.00	0.00	8.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
302	REC-000000302	692	RECIBO	2026-03-14 19:39:58.207413	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
303	REC-000000303	693	RECIBO	2026-03-14 19:40:15.326941	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
304	REC-000000304	694	RECIBO	2026-03-14 19:40:25.721169	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
305	REC-000000305	695	RECIBO	2026-03-14 19:59:53.856719	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
306	REC-000000306	696	RECIBO	2026-03-14 20:04:00.267623	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
307	REC-000000307	697	RECIBO	2026-03-14 20:14:19.237699	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
308	REC-000000308	700	RECIBO	2026-03-14 20:25:09.605967	Consumidor Final	9999999999999				6.00	0.00	0.00	6.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
309	REC-000000309	701	RECIBO	2026-03-14 20:56:51.780339	Consumidor Final	9999999999999				5.50	0.00	0.00	5.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
310	REC-000000310	702	RECIBO	2026-03-14 21:01:18.019209	Consumidor Final	9999999999999				4.50	0.00	0.00	4.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
311	REC-000000311	703	RECIBO	2026-03-14 21:03:18.789939	Consumidor Final	9999999999999				4.25	0.00	0.00	4.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
312	REC-000000312	704	RECIBO	2026-03-14 21:06:49.878877	Consumidor Final	9999999999999				3.75	0.00	0.00	3.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
313	REC-000000313	705	RECIBO	2026-03-14 21:06:57.531579	Consumidor Final	9999999999999				0.75	0.00	0.00	0.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
314	REC-000000314	706	RECIBO	2026-03-14 21:07:04.358653	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
315	REC-000000315	707	RECIBO	2026-03-14 21:08:57.783352	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
316	REC-000000316	708	RECIBO	2026-03-14 21:55:42.305538	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
317	REC-000000317	709	RECIBO	2026-03-14 21:57:55.826371	Consumidor Final	9999999999999				0.75	0.00	0.00	0.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
318	REC-000000318	710	RECIBO	2026-03-14 22:12:12.667505	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
319	REC-000000319	711	RECIBO	2026-03-14 22:13:01.975064	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
320	REC-000000320	712	RECIBO	2026-03-14 22:22:32.302254	Consumidor Final	9999999999999				4.25	0.00	0.00	4.25	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 50951750	Rey	\N	\N	f
321	REC-000000321	713	RECIBO	2026-03-14 22:24:11.819228	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
322	REC-000000322	714	RECIBO	2026-03-14 22:24:24.380637	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
323	REC-000000323	715	RECIBO	2026-03-14 22:30:56.496515	Consumidor Final	9999999999999				2.00	0.00	0.00	2.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
324	REC-000000324	716	RECIBO	2026-03-14 22:36:03.216893	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
325	REC-000000325	717	RECIBO	2026-03-14 22:51:10.454035	Consumidor Final	9999999999999				6.50	0.00	0.00	6.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
326	REC-000000326	718	RECIBO	2026-03-14 22:53:51.139091	Consumidor Final	9999999999999				3.25	0.00	0.00	3.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
327	REC-000000327	719	RECIBO	2026-03-14 22:59:18.265774	Consumidor Final	9999999999999				10.00	0.00	0.00	10.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 51592810	Rey	\N	\N	f
328	REC-000000328	720	RECIBO	2026-03-14 23:10:06.922359	Consumidor Final	9999999999999				3.25	0.00	0.00	3.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
329	REC-000000329	721	RECIBO	2026-03-14 23:10:18.468453	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
330	REC-000000330	722	RECIBO	2026-03-14 23:35:44.006504	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
331	REC-000000331	723	RECIBO	2026-03-14 23:40:35.395679	Consumidor Final	9999999999999				7.25	0.00	0.00	7.25	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 52399584	Rey	\N	\N	f
332	REC-000000332	724	RECIBO	2026-03-14 23:41:57.857114	Consumidor Final	9999999999999				4.50	0.00	0.00	4.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
333	REC-000000333	725	RECIBO	2026-03-14 23:47:48.935415	Consumidor Final	9999999999999				0.75	0.00	0.00	0.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
334	REC-000000334	726	RECIBO	2026-03-14 23:50:46.040636	Consumidor Final	9999999999999				2.25	0.00	0.00	2.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
335	REC-000000335	727	RECIBO	2026-03-14 23:54:25.299428	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
336	REC-000000336	728	RECIBO	2026-03-14 23:56:36.143536	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
337	REC-000000337	729	RECIBO	2026-03-14 23:58:27.382445	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
338	REC-000000338	730	RECIBO	2026-03-15 00:12:04.669857	Consumidor Final	9999999999999				4.25	0.00	0.00	4.25	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
339	REC-000000339	731	RECIBO	2026-03-15 00:12:11.663878	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Rey	\N	\N	f
340	REC-000000340	732	RECIBO	2026-03-15 15:48:08.270955	Consumidor Final	9999999999999				5.25	0.00	0.00	5.25	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
341	REC-000000341	734	RECIBO	2026-03-15 16:32:09.722416	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
342	REC-000000342	735	RECIBO	2026-03-15 16:52:11.002345	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 2204969204	Alex	\N	\N	f
343	REC-000000343	736	RECIBO	2026-03-15 17:20:46.680354	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 2212544750	Alex	\N	\N	f
344	REC-000000344	737	RECIBO	2026-03-15 17:21:01.666985	Consumidor Final	9999999999999				6.75	0.00	0.00	6.75	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
345	REC-000000345	738	RECIBO	2026-03-15 17:30:43.03255	Consumidor Final	9999999999999				5.50	0.00	0.00	5.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
346	REC-000000346	739	RECIBO	2026-03-15 17:45:48.847224	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
347	REC-000000347	740	RECIBO	2026-03-15 17:54:43.430605	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
348	REC-000000348	741	RECIBO	2026-03-15 18:07:23.910171	Consumidor Final	9999999999999				8.25	0.00	0.00	8.25	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
349	REC-000000349	742	RECIBO	2026-03-15 18:08:53.606171	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
350	REC-000000350	743	RECIBO	2026-03-15 18:34:39.900709	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
351	REC-000000351	744	RECIBO	2026-03-15 19:02:00.229805	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
352	REC-000000352	745	RECIBO	2026-03-15 19:11:45.094066	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 2215502424	Alex	\N	\N	f
353	REC-000000353	748	RECIBO	2026-03-15 20:12:01.935965	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
354	REC-000000354	733	RECIBO	2026-03-15 20:22:33.133154	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 2208825571	Alex	\N	\N	f
355	REC-000000355	752	RECIBO	2026-03-15 20:23:25.781035	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
356	REC-000000356	753	RECIBO	2026-03-15 20:23:36.145795	Consumidor Final	9999999999999				10.00	0.00	0.00	10.00	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
357	REC-000000357	754	RECIBO	2026-03-15 20:23:51.588244	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
358	REC-000000358	755	RECIBO	2026-03-15 20:29:55.426779	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
359	REC-000000359	756	RECIBO	2026-03-15 20:39:00.133583	Consumidor Final	9999999999999				0.75	0.00	0.00	0.75	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 2207239459	Alex	\N	\N	f
360	REC-000000360	757	RECIBO	2026-03-15 20:55:26.183062	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
361	REC-000000361	758	RECIBO	2026-03-15 21:01:06.527894	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
362	REC-000000362	759	RECIBO	2026-03-15 21:02:58.226075	Consumidor Final	9999999999999				2.00	0.00	0.00	2.00	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
363	REC-000000363	760	RECIBO	2026-03-15 21:27:29.105782	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
364	REC-000000364	761	RECIBO	2026-03-15 21:30:55.850088	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
365	REC-000000365	762	RECIBO	2026-03-15 21:38:14.351895	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
366	REC-000000366	763	RECIBO	2026-03-15 21:45:28.854445	Consumidor Final	9999999999999				3.50	0.00	0.00	3.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
367	REC-000000367	764	RECIBO	2026-03-15 21:55:33.367158	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
368	REC-000000368	765	RECIBO	2026-03-16 14:32:10.123008	Consumidor Final	9999999999999				17.50	0.00	0.00	17.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
369	REC-000000369	766	RECIBO	2026-03-16 16:21:02.105838	Consumidor Final	9999999999999				3.75	0.00	0.00	3.75	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
370	REC-000000370	767	RECIBO	2026-03-16 18:00:16.794562	Consumidor Final	9999999999999				4.00	0.00	0.00	4.00	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
371	REC-000000371	768	RECIBO	2026-03-16 18:01:19.0261	Consumidor Final	9999999999999				8.75	0.00	0.00	8.75	TRANSFERENCIA	EMITIDA	Banco: Banco Guayaquil | Comprobante: 0000182441	Alex	\N	\N	f
372	REC-000000372	769	RECIBO	2026-03-16 18:02:30.067795	Consumidor Final	9999999999999				4.50	0.00	0.00	4.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
373	REC-000000373	770	RECIBO	2026-03-16 18:10:19.289374	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
374	REC-000000374	771	RECIBO	2026-03-16 18:25:12.565557	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
375	REC-000000375	772	RECIBO	2026-03-16 18:27:56.815423	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
376	REC-000000376	773	RECIBO	2026-03-16 18:48:03.552519	Consumidor Final	9999999999999				2.75	0.00	0.00	2.75	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
377	REC-000000377	774	RECIBO	2026-03-16 19:28:47.776192	Consumidor Final	9999999999999				3.25	0.00	0.00	3.25	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
378	REC-000000378	775	RECIBO	2026-03-16 19:34:51.254001	Consumidor Final	9999999999999				4.50	0.00	0.00	4.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
379	REC-000000379	776	RECIBO	2026-03-16 19:37:20.863211	Consumidor Final	9999999999999				30.00	0.00	0.00	30.00	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
380	REC-000000380	777	RECIBO	2026-03-16 20:08:50.564861	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 160961923	Alex	\N	\N	f
381	REC-000000381	780	RECIBO	2026-03-16 20:19:09.760164	Consumidor Final	9999999999999				7.50	0.00	0.00	7.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
382	REC-000000382	781	RECIBO	2026-03-16 20:44:47.516487	Consumidor Final	9999999999999				1.75	0.00	0.00	1.75	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
383	REC-000000383	782	RECIBO	2026-03-16 21:03:40.372366	Consumidor Final	9999999999999				5.00	0.00	0.00	5.00	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
384	REC-000000384	783	RECIBO	2026-03-16 21:05:10.973339	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
385	REC-000000385	784	RECIBO	2026-03-16 21:11:41.0671	Consumidor Final	9999999999999				2.00	0.00	0.00	2.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 168303279	Alex	\N	\N	f
386	REC-000000386	785	RECIBO	2026-03-16 21:14:21.237845	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 168441981	Alex	\N	\N	f
387	REC-000000387	786	RECIBO	2026-03-16 21:14:29.929612	Consumidor Final	9999999999999				1.00	0.00	0.00	1.00	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
388	REC-000000388	787	RECIBO	2026-03-16 21:17:38.113297	Consumidor Final	9999999999999				3.00	0.00	0.00	3.00	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 168599204	Alex	\N	\N	f
389	REC-000000389	788	RECIBO	2026-03-16 21:19:03.762657	Consumidor Final	9999999999999				13.50	0.00	0.00	13.50	TRANSFERENCIA	EMITIDA	Banco: Banco Pichincha | Comprobante: 164695897	Alex	\N	\N	f
390	REC-000000390	789	RECIBO	2026-03-16 21:29:46.96218	Consumidor Final	9999999999999				2.50	0.00	0.00	2.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
391	REC-000000391	790	RECIBO	2026-03-16 21:37:54.787737	jhon	9999999999999				2.50	0.00	0.00	2.50	CREDITO	EMITIDA	\N	Alex	\N	\N	f
392	REC-000000392	791	RECIBO	2026-03-16 21:58:57.117944	Consumidor Final	9999999999999				1.50	0.00	0.00	1.50	EFECTIVO	EMITIDA	\N	Alex	\N	\N	f
\.


--
-- Data for Name: facturas_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.facturas_items (id, factura_id, producto_id, nombre, cantidad, precio_unitario, subtotal) FROM stdin;
1	1	17	Pipa de Coco (Entera)	1.00	1.75	1.75
2	2	10	Paleta Coco	2.00	0.75	1.50
3	3	10	Paleta Coco	4.00	0.75	3.00
4	4	19	Agua de Coco	1.00	1.50	1.50
6	6	17	Pipa de Coco (Entera)	1.00	1.75	1.75
7	7	17	Pipa de Coco (Entera)	1.00	1.75	1.75
8	8	15	Coco Relleno	4.00	3.50	14.00
9	8	19	Agua de Coco	2.00	1.50	3.00
10	9	19	Agua de Coco	1.00	1.50	1.50
12	10	17	Pipa de Coco (Entera)	5.00	1.75	8.75
13	11	17	Pipa de Coco (Entera)	2.00	1.75	3.50
14	12	10	Paleta Coco	1.00	0.75	0.75
15	13	17	Pipa de Coco (Entera)	1.00	1.75	1.75
16	13	10	Paleta Coco	1.00	0.75	0.75
17	14	10	Paleta Coco	3.00	0.75	2.25
19	16	15	Coco Relleno	1.00	3.50	3.50
20	17	19	Agua de Coco	1.00	1.50	1.50
21	18	19	Agua de Coco	5.00	1.00	5.00
22	19	10	Paleta Coco	1.00	0.75	0.75
23	19	9	Paleta Frutos Rojos	2.00	0.75	1.50
24	20	10	Paleta Coco	8.00	0.75	6.00
25	20	15	Coco Relleno	2.00	3.50	7.00
26	20	17	Pipa de Coco (Entera)	1.00	1.75	1.75
28	21	2	Aranda-Coco	1.00	2.50	2.50
29	21	9	Paleta Frutos Rojos	2.00	0.75	1.50
30	21	10	Paleta Coco	3.00	0.75	2.25
31	21	19	Agua de Coco	1.00	1.50	1.50
32	22	17	Pipa de Coco (Entera)	2.00	1.75	3.50
33	23	2	Aranda-Coco	1.00	2.50	2.50
34	24	2	Aranda-Coco	1.00	2.50	2.50
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
48	32	19	Agua de Coco	2.00	1.50	3.00
50	33	9	Paleta Frutos Rojos	1.00	0.75	0.75
5	5	16	Jugo de Caña	3.00	1.00	3.00
11	9	16	Jugo de Caña	1.00	1.00	1.00
18	15	16	Jugo de Caña	2.00	1.00	2.00
27	21	1	Piña-Coco	1.00	2.50	2.50
35	24	1	Piña-Coco	1.00	2.50	2.50
46	31	16	Jugo de Caña	1.00	1.00	1.00
47	31	1	Piña-Coco	1.00	2.50	2.50
49	33	16	Jugo de Caña	2.00	1.00	2.00
51	34	17	Pipa de Coco (Entera)	2.00	1.75	3.50
52	35	19	Agua de Coco	40.00	1.00	40.00
53	36	19	Agua de Coco	20.00	1.00	20.00
54	37	19	Agua de Coco	10.00	0.90	9.00
55	37	16	Jugo de Caña	10.00	0.75	7.50
56	38	19	Agua de Coco	1.00	1.50	1.50
57	39	19	Agua de Coco	2.00	1.50	3.00
58	39	10	Paleta Coco	1.00	0.75	0.75
59	40	17	Pipa de Coco (Entera)	2.00	1.75	3.50
60	40	10	Paleta Coco	2.00	0.75	1.50
61	41	6	Limonada de Coco	1.00	2.50	2.50
62	42	16	Jugo de Caña	1.00	1.00	1.00
63	42	19	Agua de Coco	2.00	1.50	3.00
64	43	17	Pipa de Coco (Entera)	1.00	1.75	1.75
65	44	17	Pipa de Coco (Entera)	1.00	1.75	1.75
66	45	15	Coco Relleno	2.00	3.50	7.00
67	46	2	Aranda-Coco	1.00	2.50	2.50
68	47	17	Pipa de Coco (Entera)	1.00	1.75	1.75
69	48	10	Paleta Coco	2.00	0.75	1.50
70	48	16	Jugo de Caña	1.00	1.00	1.00
71	49	1	Piña-Coco	2.00	2.50	5.00
72	50	5	Jugo de Coco	1.00	2.50	2.50
73	50	1	Piña-Coco	1.00	2.50	2.50
74	51	17	Pipa de Coco (Entera)	1.00	1.75	1.75
75	52	10	Paleta Coco	3.00	0.75	2.25
76	53	8	Guarapo	1.00	3.50	3.50
77	54	9	Paleta Frutos Rojos	2.00	0.75	1.50
78	55	17	Pipa de Coco (Entera)	4.00	1.75	7.00
79	56	8	Guarapo	1.00	3.50	3.50
80	57	16	Jugo de Caña	2.00	1.00	2.00
81	58	16	Jugo de Caña	1.00	1.00	1.00
82	59	19	Agua de Coco	1.00	1.50	1.50
83	60	19	Agua de Coco	1.00	1.50	1.50
84	61	15	Coco Relleno	1.00	3.50	3.50
85	62	19	Agua de Coco	4.00	1.50	6.00
86	62	9	Paleta Frutos Rojos	1.00	0.75	0.75
87	63	10	Paleta Coco	1.00	0.75	0.75
88	64	25	Helado + Topping	1.00	3.50	3.50
89	64	2	Aranda-Coco	1.00	2.50	2.50
90	64	10	Paleta Coco	1.00	0.75	0.75
91	65	19	Agua de Coco	3.00	1.50	4.50
92	66	6	Limonada de Coco	2.00	2.50	5.00
93	67	25	Helado + Topping	2.00	3.50	7.00
94	68	2	Aranda-Coco	1.00	2.50	2.50
95	68	1	Piña-Coco	1.00	2.50	2.50
96	69	17	Pipa de Coco (Entera)	2.00	1.75	3.50
97	69	9	Paleta Frutos Rojos	1.00	0.75	0.75
98	70	21	WhiskyCoco	1.00	6.00	6.00
99	70	1	Piña-Coco	1.00	2.50	2.50
100	70	2	Aranda-Coco	1.00	2.50	2.50
101	70	10	Paleta Coco	1.00	0.75	0.75
102	71	1	Piña-Coco	2.00	2.50	5.00
103	72	25	Helado + Topping	1.00	3.50	3.50
104	73	10	Paleta Coco	3.00	0.75	2.25
105	74	8	Guarapo	2.00	3.50	7.00
106	74	26	Hielo	2.00	1.00	2.00
107	75	17	Pipa de Coco (Entera)	2.00	1.75	3.50
108	76	1	Piña-Coco	2.00	2.50	5.00
109	77	7	Coco Loco	1.00	5.00	5.00
110	78	4	Coco-Coffe	1.00	2.50	2.50
111	79	17	Pipa de Coco (Entera)	2.00	1.75	3.50
112	79	25	Helado + Topping	1.00	3.50	3.50
113	80	2	Aranda-Coco	2.00	2.50	5.00
114	80	19	Agua de Coco	1.00	1.50	1.50
115	80	17	Pipa de Coco (Entera)	1.00	1.75	1.75
116	81	17	Pipa de Coco (Entera)	1.00	1.75	1.75
117	82	2	Aranda-Coco	1.00	2.50	2.50
118	83	10	Paleta Coco	1.00	0.75	0.75
119	84	17	Pipa de Coco (Entera)	2.00	1.75	3.50
120	85	16	Jugo de Caña	1.00	1.00	1.00
121	86	10	Paleta Coco	5.00	0.75	3.75
122	87	10	Paleta Coco	1.00	0.75	0.75
123	87	17	Pipa de Coco (Entera)	1.00	1.75	1.75
124	88	10	Paleta Coco	1.00	0.75	0.75
125	89	16	Jugo de Caña	2.00	1.00	2.00
126	89	19	Agua de Coco	1.00	1.50	1.50
127	90	19	Agua de Coco	1.00	1.50	1.50
128	91	10	Paleta Coco	2.00	0.75	1.50
129	91	9	Paleta Frutos Rojos	1.00	0.75	0.75
130	92	16	Jugo de Caña	1.00	1.00	1.00
131	93	17	Pipa de Coco (Entera)	2.00	1.75	3.50
132	94	17	Pipa de Coco (Entera)	1.00	1.75	1.75
133	95	10	Paleta Coco	6.00	0.75	4.50
134	95	9	Paleta Frutos Rojos	1.00	0.75	0.75
135	95	17	Pipa de Coco (Entera)	2.00	1.75	3.50
136	96	6	Limonada de Coco	1.00	2.50	2.50
137	96	10	Paleta Coco	1.00	0.75	0.75
138	96	9	Paleta Frutos Rojos	1.00	0.75	0.75
139	96	19	Agua de Coco	1.00	1.50	1.50
140	97	17	Pipa de Coco (Entera)	1.00	1.75	1.75
141	98	25	Helado + Topping	1.00	3.50	3.50
142	99	17	Pipa de Coco (Entera)	2.00	1.75	3.50
143	100	1	Piña-Coco	2.00	2.50	5.00
144	101	10	Paleta Coco	3.00	0.75	2.25
145	102	17	Pipa de Coco (Entera)	3.00	1.75	5.25
146	102	10	Paleta Coco	1.00	0.75	0.75
147	103	19	Agua de Coco	2.00	1.50	3.00
148	104	17	Pipa de Coco (Entera)	1.00	1.75	1.75
149	105	3	Coco & Caña	1.00	2.50	2.50
150	105	22	Ron	1.00	2.50	2.50
151	106	1	Piña-Coco	1.00	2.50	2.50
152	106	5	Jugo de Coco	1.00	2.50	2.50
153	107	16	Jugo de Caña	2.00	1.00	2.00
154	108	17	Pipa de Coco (Entera)	2.00	1.75	3.50
155	108	10	Paleta Coco	1.00	0.75	0.75
156	109	19	Agua de Coco	2.00	1.50	3.00
157	110	19	Agua de Coco	1.00	1.50	1.50
158	111	1	Piña-Coco	1.00	2.50	2.50
159	112	21	WhiskyCoco	1.00	6.00	6.00
160	113	7	Coco Loco	4.00	5.00	20.00
161	114	17	Pipa de Coco (Entera)	2.00	1.75	3.50
162	115	19	Agua de Coco	1.00	1.50	1.50
163	116	6	Limonada de Coco	2.00	2.50	5.00
164	117	10	Paleta Coco	4.00	0.75	3.00
165	118	9	Paleta Frutos Rojos	3.00	0.75	2.25
166	119	25	Helado + Topping	2.00	3.50	7.00
167	120	19	Agua de Coco	6.00	1.50	9.00
168	121	17	Pipa de Coco (Entera)	7.00	1.75	12.25
169	122	10	Paleta Coco	8.00	0.75	6.00
170	123	19	Agua de Coco	1.00	1.50	1.50
171	123	16	Jugo de Caña	1.00	1.00	1.00
172	124	8	Guarapo	1.00	3.50	3.50
173	125	9	Paleta Frutos Rojos	2.00	0.75	1.50
174	126	7	Coco Loco	1.00	5.00	5.00
175	127	16	Jugo de Caña	2.00	1.00	2.00
176	128	1	Piña-Coco	3.00	2.50	7.50
177	129	10	Paleta Coco	1.00	0.75	0.75
178	130	1	Piña-Coco	1.00	2.50	2.50
179	130	6	Limonada de Coco	1.00	2.50	2.50
180	130	3	Coco & Caña	1.00	2.50	2.50
181	130	17	Pipa de Coco (Entera)	1.00	1.75	1.75
182	131	19	Agua de Coco	1.00	1.50	1.50
183	132	19	Agua de Coco	3.00	1.50	4.50
184	133	17	Pipa de Coco (Entera)	1.00	1.75	1.75
185	133	16	Jugo de Caña	1.00	1.00	1.00
186	134	17	Pipa de Coco (Entera)	1.00	1.75	1.75
187	135	17	Pipa de Coco (Entera)	3.00	1.75	5.25
188	136	17	Pipa de Coco (Entera)	1.00	1.75	1.75
189	137	17	Pipa de Coco (Entera)	1.00	1.75	1.75
190	137	6	Limonada de Coco	1.00	2.50	2.50
191	138	10	Paleta Coco	3.00	0.75	2.25
192	138	17	Pipa de Coco (Entera)	1.00	1.75	1.75
193	139	9	Paleta Frutos Rojos	1.00	0.75	0.75
194	139	10	Paleta Coco	4.00	0.75	3.00
195	140	5	Jugo de Coco	1.00	2.50	2.50
196	141	17	Pipa de Coco (Entera)	2.00	1.75	3.50
197	141	9	Paleta Frutos Rojos	2.00	0.75	1.50
198	142	17	Pipa de Coco (Entera)	1.00	1.75	1.75
199	143	6	Limonada de Coco	1.00	2.50	2.50
200	144	6	Limonada de Coco	1.00	2.50	2.50
201	145	17	Pipa de Coco (Entera)	2.00	1.75	3.50
202	146	7	Coco Loco	1.00	5.00	5.00
203	147	19	Agua de Coco	1.00	1.50	1.50
204	148	19	Agua de Coco	35.00	1.00	35.00
205	149	5	Jugo de Coco	4.00	2.50	10.00
206	150	19	Agua de Coco	1.00	1.50	1.50
207	150	16	Jugo de Caña	1.00	1.00	1.00
208	151	1	Piña-Coco	1.00	2.50	2.50
209	151	17	Pipa de Coco (Entera)	1.00	1.75	1.75
210	152	10	Paleta Coco	2.00	0.75	1.50
211	152	19	Agua de Coco	3.00	1.50	4.50
212	153	17	Pipa de Coco (Entera)	3.00	1.75	5.25
213	154	19	Agua de Coco	2.00	1.50	3.00
214	155	5	Jugo de Coco	1.00	2.50	2.50
215	155	19	Agua de Coco	1.00	1.50	1.50
216	156	19	Agua de Coco	2.00	1.50	3.00
217	156	17	Pipa de Coco (Entera)	1.00	1.75	1.75
218	157	10	Paleta Coco	1.00	0.75	0.75
219	157	6	Limonada de Coco	1.00	2.50	2.50
220	157	16	Jugo de Caña	1.00	1.00	1.00
221	158	3	Coco & Caña	1.00	2.50	2.50
222	158	4	Coco-Coffe	1.00	2.50	2.50
223	159	17	Pipa de Coco (Entera)	3.00	1.75	5.25
224	160	6	Limonada de Coco	1.00	2.50	2.50
225	161	19	Agua de Coco	1.00	1.50	1.50
226	161	16	Jugo de Caña	1.00	1.00	1.00
227	162	25	Helado + Topping	1.00	3.50	3.50
228	162	19	Agua de Coco	2.00	1.50	3.00
229	163	7	Coco Loco	1.00	5.00	5.00
230	164	10	Paleta Coco	1.00	0.75	0.75
231	164	19	Agua de Coco	1.00	1.50	1.50
232	164	9	Paleta Frutos Rojos	1.00	0.75	0.75
233	165	19	Agua de Coco	1.00	1.50	1.50
234	166	17	Pipa de Coco (Entera)	1.00	1.75	1.75
235	166	25	Helado + Topping	1.00	3.50	3.50
236	167	26	Hielo	1.00	1.00	1.00
237	168	19	Agua de Coco	2.00	1.50	3.00
238	169	17	Pipa de Coco (Entera)	5.00	1.75	8.75
239	170	10	Paleta Coco	9.00	0.75	6.75
240	171	1	Piña-Coco	1.00	2.50	2.50
241	171	9	Paleta Frutos Rojos	2.00	0.75	1.50
242	172	19	Agua de Coco	1.00	1.50	1.50
243	173	19	Agua de Coco	1.00	1.50	1.50
244	174	15	Coco Relleno	1.00	3.50	3.50
245	174	6	Limonada de Coco	1.00	2.50	2.50
246	175	7	Coco Loco	1.00	5.00	5.00
247	176	2	Aranda-Coco	1.00	2.50	2.50
248	176	1	Piña-Coco	1.00	2.50	2.50
249	176	16	Jugo de Caña	1.00	1.00	1.00
250	177	16	Jugo de Caña	1.00	1.00	1.00
251	178	15	Coco Relleno	1.00	3.50	3.50
252	179	19	Agua de Coco	6.00	1.50	9.00
253	179	1	Piña-Coco	1.00	2.50	2.50
254	180	19	Agua de Coco	3.00	1.50	4.50
255	181	16	Jugo de Caña	1.00	1.00	1.00
256	182	19	Agua de Coco	2.00	1.50	3.00
257	183	19	Agua de Coco	5.00	1.00	5.00
258	184	16	Jugo de Caña	1.00	1.00	1.00
259	184	19	Agua de Coco	1.00	1.50	1.50
260	185	10	Paleta Coco	2.00	0.75	1.50
261	186	15	Coco Relleno	1.00	3.50	3.50
262	187	17	Pipa de Coco (Entera)	2.00	1.75	3.50
263	188	17	Pipa de Coco (Entera)	1.00	1.75	1.75
264	188	10	Paleta Coco	1.00	0.75	0.75
265	189	1	Piña-Coco	2.00	2.50	5.00
266	190	15	Coco Relleno	1.00	3.50	3.50
267	191	17	Pipa de Coco (Entera)	2.00	1.75	3.50
268	192	16	Jugo de Caña	3.00	1.00	3.00
269	193	19	Agua de Coco	1.00	1.50	1.50
270	194	16	Jugo de Caña	1.00	1.00	1.00
271	195	15	Coco Relleno	4.00	3.50	14.00
272	196	6	Limonada de Coco	1.00	2.50	2.50
273	196	17	Pipa de Coco (Entera)	1.00	1.75	1.75
274	197	1	Piña-Coco	1.00	2.50	2.50
275	198	5	Jugo de Coco	2.00	2.50	5.00
276	198	2	Aranda-Coco	1.00	2.50	2.50
277	199	10	Paleta Coco	1.00	0.75	0.75
278	199	6	Limonada de Coco	1.00	2.50	2.50
279	200	7	Coco Loco	2.00	5.00	10.00
280	201	2	Aranda-Coco	1.00	2.50	2.50
281	202	16	Jugo de Caña	1.00	1.00	1.00
282	203	10	Paleta Coco	2.00	0.75	1.50
283	204	15	Coco Relleno	1.00	3.50	3.50
284	205	4	Coco-Coffe	1.00	2.50	2.50
285	205	5	Jugo de Coco	1.00	2.50	2.50
286	206	19	Agua de Coco	15.00	1.00	15.00
287	207	19	Agua de Coco	1.00	1.50	1.50
288	207	10	Paleta Coco	2.00	0.75	1.50
289	208	28	Mojito	2.00	4.00	8.00
290	209	28	Mojito	1.00	4.00	4.00
291	210	2	Aranda-Coco	1.00	2.50	2.50
292	210	17	Pipa de Coco (Entera)	1.00	1.75	1.75
293	210	10	Paleta Coco	3.00	0.75	2.25
294	211	17	Pipa de Coco (Entera)	2.00	1.75	3.50
295	212	19	Agua de Coco	5.00	1.00	5.00
296	213	16	Jugo de Caña	10.00	0.75	7.50
297	213	19	Agua de Coco	8.00	0.90	7.20
298	214	10	Paleta Coco	1.00	0.75	0.75
299	214	9	Paleta Frutos Rojos	1.00	0.75	0.75
300	215	10	Paleta Coco	1.00	0.75	0.75
301	216	17	Pipa de Coco (Entera)	2.00	1.75	3.50
302	217	16	Jugo de Caña	2.00	1.00	2.00
303	218	16	Jugo de Caña	3.00	1.00	3.00
304	218	19	Agua de Coco	1.00	1.50	1.50
305	219	19	Agua de Coco	5.00	1.50	7.50
306	219	10	Paleta Coco	1.00	0.75	0.75
307	220	9	Paleta Frutos Rojos	8.00	0.75	6.00
308	221	17	Pipa de Coco (Entera)	1.00	1.75	1.75
309	222	17	Pipa de Coco (Entera)	1.00	1.75	1.75
310	222	10	Paleta Coco	2.00	0.75	1.50
311	223	10	Paleta Coco	2.00	0.75	1.50
312	223	9	Paleta Frutos Rojos	1.00	0.75	0.75
313	224	2	Aranda-Coco	1.00	2.50	2.50
314	225	17	Pipa de Coco (Entera)	1.00	1.75	1.75
315	225	9	Paleta Frutos Rojos	1.00	0.75	0.75
316	226	2	Aranda-Coco	2.00	2.50	5.00
317	226	17	Pipa de Coco (Entera)	1.00	1.75	1.75
318	227	19	Agua de Coco	20.00	1.00	20.00
319	228	17	Pipa de Coco (Entera)	4.00	1.75	7.00
320	229	15	Coco Relleno	1.00	3.50	3.50
321	229	2	Aranda-Coco	1.00	2.50	2.50
322	230	17	Pipa de Coco (Entera)	2.00	1.75	3.50
323	231	17	Pipa de Coco (Entera)	1.00	1.75	1.75
324	231	10	Paleta Coco	1.00	0.75	0.75
325	232	1	Piña-Coco	1.00	2.50	2.50
326	232	6	Limonada de Coco	1.00	2.50	2.50
327	232	7	Coco Loco	2.00	5.00	10.00
328	232	10	Paleta Coco	2.00	0.75	1.50
329	233	19	Agua de Coco	2.00	1.50	3.00
330	233	10	Paleta Coco	1.00	0.75	0.75
331	234	19	Agua de Coco	1.00	1.50	1.50
332	235	17	Pipa de Coco (Entera)	3.00	1.75	5.25
333	236	19	Agua de Coco	6.00	1.50	9.00
334	237	1	Piña-Coco	1.00	2.50	2.50
335	238	10	Paleta Coco	1.00	0.75	0.75
336	238	19	Agua de Coco	1.00	1.50	1.50
337	239	10	Paleta Coco	4.00	0.75	3.00
338	239	9	Paleta Frutos Rojos	2.00	0.75	1.50
339	240	10	Paleta Coco	2.00	0.75	1.50
340	241	10	Paleta Coco	1.00	0.75	0.75
341	242	2	Aranda-Coco	1.00	2.50	2.50
342	242	10	Paleta Coco	1.00	0.75	0.75
343	242	9	Paleta Frutos Rojos	2.00	0.75	1.50
344	243	15	Coco Relleno	1.00	3.50	3.50
345	243	17	Pipa de Coco (Entera)	1.00	1.75	1.75
346	244	6	Limonada de Coco	2.00	2.50	5.00
347	244	16	Jugo de Caña	1.00	1.00	1.00
348	244	10	Paleta Coco	1.00	0.75	0.75
349	245	17	Pipa de Coco (Entera)	1.00	1.75	1.75
350	245	19	Agua de Coco	1.00	1.50	1.50
351	246	10	Paleta Coco	3.00	0.75	2.25
352	246	9	Paleta Frutos Rojos	1.00	0.75	0.75
353	247	5	Jugo de Coco	1.00	2.50	2.50
354	247	15	Coco Relleno	1.00	3.50	3.50
355	248	17	Pipa de Coco (Entera)	1.00	1.75	1.75
356	249	19	Agua de Coco	35.00	1.00	35.00
357	250	2	Aranda-Coco	1.00	2.50	2.50
358	250	10	Paleta Coco	1.00	0.75	0.75
359	251	17	Pipa de Coco (Entera)	1.00	1.75	1.75
360	252	17	Pipa de Coco (Entera)	2.00	1.75	3.50
361	252	10	Paleta Coco	2.00	0.75	1.50
362	253	19	Agua de Coco	1.00	1.50	1.50
363	253	15	Coco Relleno	1.00	3.50	3.50
364	254	2	Aranda-Coco	1.00	2.50	2.50
365	255	19	Agua de Coco	5.00	1.00	5.00
366	256	19	Agua de Coco	1.00	1.50	1.50
367	257	16	Jugo de Caña	15.00	0.75	11.25
368	257	19	Agua de Coco	15.00	0.90	13.50
369	258	10	Paleta Coco	2.00	0.75	1.50
370	259	10	Paleta Coco	1.00	0.75	0.75
371	260	4	Coco-Coffe	4.00	2.50	10.00
372	261	4	Coco-Coffe	1.00	2.50	2.50
373	261	10	Paleta Coco	1.00	0.75	0.75
374	262	17	Pipa de Coco (Entera)	1.00	1.75	1.75
375	263	19	Agua de Coco	1.00	1.50	1.50
376	264	6	Limonada de Coco	1.00	2.50	2.50
377	265	15	Coco Relleno	1.00	3.50	3.50
378	266	20	Agua sin gas	1.00	0.75	0.75
379	267	17	Pipa de Coco (Entera)	2.00	1.75	3.50
380	268	19	Agua de Coco	2.00	1.50	3.00
381	269	17	Pipa de Coco (Entera)	3.00	1.75	5.25
382	270	17	Pipa de Coco (Entera)	2.00	1.75	3.50
383	271	10	Paleta Coco	1.00	0.75	0.75
384	271	9	Paleta Frutos Rojos	2.00	0.75	1.50
385	271	19	Agua de Coco	1.00	1.50	1.50
386	272	10	Paleta Coco	3.00	0.75	2.25
387	273	6	Limonada de Coco	1.00	2.50	2.50
388	274	26	Hielo	4.00	1.00	4.00
389	275	1	Piña-Coco	1.00	2.50	2.50
390	276	7	Coco Loco	1.00	5.00	5.00
391	277	17	Pipa de Coco (Entera)	1.00	1.75	1.75
392	278	4	Coco-Coffe	1.00	2.50	2.50
393	278	19	Agua de Coco	1.00	1.50	1.50
394	279	17	Pipa de Coco (Entera)	2.00	1.75	3.50
395	280	15	Coco Relleno	1.00	3.50	3.50
396	280	17	Pipa de Coco (Entera)	1.00	1.75	1.75
397	281	15	Coco Relleno	1.00	3.50	3.50
398	282	5	Jugo de Coco	1.00	2.50	2.50
399	283	16	Jugo de Caña	2.00	1.00	2.00
400	284	7	Coco Loco	1.00	5.00	5.00
401	285	17	Pipa de Coco (Entera)	1.00	1.75	1.75
402	286	5	Jugo de Coco	1.00	2.50	2.50
403	287	10	Paleta Coco	1.00	0.75	0.75
404	287	9	Paleta Frutos Rojos	1.00	0.75	0.75
405	288	17	Pipa de Coco (Entera)	1.00	1.75	1.75
406	289	19	Agua de Coco	15.00	0.90	13.50
407	290	15	Coco Relleno	3.00	3.50	10.50
408	290	19	Agua de Coco	2.00	1.50	3.00
409	290	10	Paleta Coco	3.00	0.75	2.25
410	290	9	Paleta Frutos Rojos	1.00	0.75	0.75
411	291	6	Limonada de Coco	1.00	2.50	2.50
412	291	10	Paleta Coco	1.00	0.75	0.75
413	292	19	Agua de Coco	1.00	1.50	1.50
414	293	6	Limonada de Coco	1.00	2.50	2.50
415	293	18	Caña Manabita	1.00	1.50	1.50
416	293	10	Paleta Coco	1.00	0.75	0.75
417	294	1	Piña-Coco	1.00	2.50	2.50
418	295	17	Pipa de Coco (Entera)	1.00	1.75	1.75
419	296	19	Agua de Coco	35.00	1.00	35.00
420	297	19	Agua de Coco	3.00	1.50	4.50
421	298	10	Paleta Coco	2.00	0.75	1.50
422	298	9	Paleta Frutos Rojos	1.00	0.75	0.75
423	298	16	Jugo de Caña	1.00	1.00	1.00
424	299	19	Agua de Coco	2.00	1.50	3.00
425	300	10	Paleta Coco	1.00	0.75	0.75
426	301	2	Aranda-Coco	1.00	2.50	2.50
427	301	4	Coco-Coffe	1.00	2.50	2.50
428	301	15	Coco Relleno	1.00	3.50	3.50
429	302	19	Agua de Coco	1.00	1.50	1.50
430	303	16	Jugo de Caña	1.00	1.00	1.00
431	303	19	Agua de Coco	1.00	1.50	1.50
432	304	19	Agua de Coco	1.00	1.50	1.50
433	305	19	Agua de Coco	1.00	1.50	1.50
434	306	17	Pipa de Coco (Entera)	1.00	1.75	1.75
435	307	6	Limonada de Coco	2.00	2.50	5.00
436	308	15	Coco Relleno	1.00	3.50	3.50
437	308	1	Piña-Coco	1.00	2.50	2.50
438	309	10	Paleta Coco	3.00	0.75	2.25
439	309	9	Paleta Frutos Rojos	3.00	0.75	2.25
440	309	16	Jugo de Caña	1.00	1.00	1.00
441	310	19	Agua de Coco	3.00	1.50	4.50
442	311	15	Coco Relleno	1.00	3.50	3.50
443	311	9	Paleta Frutos Rojos	1.00	0.75	0.75
444	312	10	Paleta Coco	5.00	0.75	3.75
445	313	10	Paleta Coco	1.00	0.75	0.75
446	314	5	Jugo de Coco	1.00	2.50	2.50
447	314	1	Piña-Coco	1.00	2.50	2.50
448	315	5	Jugo de Coco	1.00	2.50	2.50
449	316	19	Agua de Coco	1.00	1.50	1.50
450	317	10	Paleta Coco	1.00	0.75	0.75
451	318	4	Coco-Coffe	1.00	2.50	2.50
452	318	1	Piña-Coco	1.00	2.50	2.50
453	319	5	Jugo de Coco	2.00	2.50	5.00
454	320	1	Piña-Coco	1.00	2.50	2.50
455	320	10	Paleta Coco	1.00	0.75	0.75
456	320	16	Jugo de Caña	1.00	1.00	1.00
457	321	17	Pipa de Coco (Entera)	1.00	1.75	1.75
458	321	9	Paleta Frutos Rojos	1.00	0.75	0.75
459	322	19	Agua de Coco	1.00	1.50	1.50
460	323	16	Jugo de Caña	2.00	1.00	2.00
461	324	19	Agua de Coco	2.00	1.50	3.00
462	325	6	Limonada de Coco	1.00	2.50	2.50
463	325	9	Paleta Frutos Rojos	1.00	0.75	0.75
464	325	10	Paleta Coco	2.00	0.75	1.50
465	325	17	Pipa de Coco (Entera)	1.00	1.75	1.75
466	326	17	Pipa de Coco (Entera)	1.00	1.75	1.75
467	326	10	Paleta Coco	2.00	0.75	1.50
468	327	6	Limonada de Coco	4.00	2.50	10.00
469	328	10	Paleta Coco	1.00	0.75	0.75
470	328	5	Jugo de Coco	1.00	2.50	2.50
471	329	17	Pipa de Coco (Entera)	2.00	1.75	3.50
472	330	17	Pipa de Coco (Entera)	1.00	1.75	1.75
473	331	6	Limonada de Coco	1.00	2.50	2.50
474	331	19	Agua de Coco	1.00	1.50	1.50
475	331	1	Piña-Coco	1.00	2.50	2.50
476	331	10	Paleta Coco	1.00	0.75	0.75
477	332	16	Jugo de Caña	3.00	1.00	3.00
478	332	19	Agua de Coco	1.00	1.50	1.50
479	333	10	Paleta Coco	1.00	0.75	0.75
480	334	10	Paleta Coco	3.00	0.75	2.25
481	335	17	Pipa de Coco (Entera)	1.00	1.75	1.75
482	336	9	Paleta Frutos Rojos	2.00	0.75	1.50
483	337	17	Pipa de Coco (Entera)	1.00	1.75	1.75
484	338	17	Pipa de Coco (Entera)	2.00	1.75	3.50
485	338	10	Paleta Coco	1.00	0.75	0.75
486	339	6	Limonada de Coco	1.00	2.50	2.50
487	340	17	Pipa de Coco (Entera)	3.00	1.75	5.25
488	341	6	Limonada de Coco	1.00	2.50	2.50
489	342	2	Aranda-Coco	1.00	2.50	2.50
490	342	1	Piña-Coco	1.00	2.50	2.50
491	343	17	Pipa de Coco (Entera)	1.00	1.75	1.75
492	344	7	Coco Loco	1.00	5.00	5.00
493	344	17	Pipa de Coco (Entera)	1.00	1.75	1.75
494	345	19	Agua de Coco	2.00	1.50	3.00
495	345	6	Limonada de Coco	1.00	2.50	2.50
496	346	6	Limonada de Coco	1.00	2.50	2.50
497	347	19	Agua de Coco	1.00	1.50	1.50
498	348	10	Paleta Coco	5.00	0.75	3.75
499	348	9	Paleta Frutos Rojos	2.00	0.75	1.50
500	348	19	Agua de Coco	2.00	1.50	3.00
501	349	19	Agua de Coco	1.00	1.50	1.50
502	350	1	Piña-Coco	1.00	2.50	2.50
503	351	2	Aranda-Coco	2.00	2.50	5.00
504	352	1	Piña-Coco	1.00	2.50	2.50
505	353	2	Aranda-Coco	1.00	2.50	2.50
506	353	1	Piña-Coco	1.00	2.50	2.50
507	354	7	Coco Loco	1.00	5.00	5.00
508	355	19	Agua de Coco	1.00	1.50	1.50
509	356	7	Coco Loco	2.00	5.00	10.00
510	357	2	Aranda-Coco	2.00	2.50	5.00
511	358	19	Agua de Coco	2.00	1.50	3.00
512	359	10	Paleta Coco	1.00	0.75	0.75
513	360	19	Agua de Coco	1.00	1.50	1.50
514	361	19	Agua de Coco	1.00	1.50	1.50
515	362	16	Jugo de Caña	2.00	1.00	2.00
516	363	19	Agua de Coco	1.00	1.50	1.50
517	363	10	Paleta Coco	1.00	0.75	0.75
518	363	9	Paleta Frutos Rojos	1.00	0.75	0.75
519	364	17	Pipa de Coco (Entera)	2.00	1.75	3.50
520	365	17	Pipa de Coco (Entera)	1.00	1.75	1.75
521	366	8	Guarapo	1.00	3.50	3.50
522	367	17	Pipa de Coco (Entera)	1.00	1.75	1.75
523	368	15	Coco Relleno	5.00	3.50	17.50
524	369	10	Paleta Coco	5.00	0.75	3.75
525	370	17	Pipa de Coco (Entera)	1.00	1.75	1.75
526	370	20	Agua sin gas	3.00	0.75	2.25
527	371	17	Pipa de Coco (Entera)	5.00	1.75	8.75
528	372	19	Agua de Coco	2.00	1.50	3.00
529	372	10	Paleta Coco	2.00	0.75	1.50
530	373	1	Piña-Coco	1.00	2.50	2.50
531	373	6	Limonada de Coco	1.00	2.50	2.50
532	374	19	Agua de Coco	2.00	1.50	3.00
533	375	17	Pipa de Coco (Entera)	1.00	1.75	1.75
534	376	17	Pipa de Coco (Entera)	1.00	1.75	1.75
535	376	16	Jugo de Caña	1.00	1.00	1.00
536	377	17	Pipa de Coco (Entera)	1.00	1.75	1.75
537	377	10	Paleta Coco	2.00	0.75	1.50
538	378	19	Agua de Coco	3.00	1.50	4.50
539	379	19	Agua de Coco	30.00	1.00	30.00
540	380	1	Piña-Coco	1.00	2.50	2.50
541	381	5	Jugo de Coco	3.00	2.50	7.50
542	382	17	Pipa de Coco (Entera)	1.00	1.75	1.75
543	383	4	Coco-Coffe	1.00	2.50	2.50
544	383	2	Aranda-Coco	1.00	2.50	2.50
545	384	19	Agua de Coco	2.00	1.50	3.00
546	385	16	Jugo de Caña	2.00	1.00	2.00
547	386	19	Agua de Coco	2.00	1.50	3.00
548	387	16	Jugo de Caña	1.00	1.00	1.00
549	388	19	Agua de Coco	2.00	1.50	3.00
550	389	19	Agua de Coco	15.00	0.90	13.50
551	390	6	Limonada de Coco	1.00	2.50	2.50
552	391	1	Piña-Coco	1.00	2.50	2.50
553	392	19	Agua de Coco	1.00	1.50	1.50
\.


--
-- Data for Name: facturas_secuencia; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.facturas_secuencia (id, prefijo, siguiente) FROM stdin;
1	REC	393
\.


--
-- Data for Name: gastos_mensuales; Type: TABLE DATA; Schema: public; Owner: -
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
9	2026-03-05	Compra de envases	14.50	Gastos	CAJA_LOCAL	Ligia Yolanda Aguilar Carrion	/uploads/1772839167224-868362351.jpg	Rey	2026-03-06 18:19:27.228749
10	2026-03-05	Compra Cuchillo	11.50	Gastos	CAJA_LOCAL	Miguel Antonio Benites Davila	/uploads/1772839322562-396152337.jpg	Rey	2026-03-06 18:22:02.564791
11	2026-03-05	pago arriendo	75.00	Gastos	CAJA_LOCAL	miguel	/uploads/1772918639791-132378054.jpeg	Rey	2026-03-07 16:23:59.793983
12	2026-03-07	preparacion helados	23.00	Materia prima	CAJA_LOCAL	batida	\N	Rey	2026-03-07 16:27:27.28536
13	2026-03-11	pago botellas	20.00	Gastos	CAJA_LOCAL	PLASTIQUIMIA	\N	Rey	2026-03-11 23:15:49.722191
14	2026-03-12	Pago flete cocos	10.00	Gastos	CAJA_LOCAL	flete	\N	Rey	2026-03-12 16:15:41.409468
15	2026-03-13	pago hielo	30.00	Gastos	CAJA_LOCAL	Aguilar Diaz Edgar Rodolfo	/uploads/1773528836252-414766820.jpeg	Rey	2026-03-14 17:53:56.264302
\.


--
-- Data for Name: insumos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.insumos (id, nombre, stock_actual, unidad_medida, stock_minimo) FROM stdin;
10	Pan de Yuca (Crudo/Congelado)	0.000	UND	5.000
11	Pipa de Coco (Entera)	20.000	UND	5.000
3	Crema de Arándanos (Porción)	7.000	UND	5.000
9	Jugo de Caña	18.000	UND	5.000
7	Zumo de Limón	4943.000	ML	5.000
2	Crema de Piña (Porción)	11.000	UND	5.000
8	Caña Manabita	7430.865	ML	5.000
5	Hielo	1835.000	ML	5.000
4	Agua Purificada	3738.920	ML	4.000
1	Crema de Coco (Porción)	10.000	UND	5.000
16	Agua de Coco	0.000	UND	0.000
19	Ron	439.853	ML	0.000
6	Café Soluble Manuelito	50.000	GR	5.000
18	Whisky	337.365	ML	0.000
17	Agua sin gas	0.000	UND	0.000
\.


--
-- Data for Name: mesas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mesas (id, nombre, estado) FROM stdin;
\.


--
-- Data for Name: movimientos_inventario; Type: TABLE DATA; Schema: public; Owner: -
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
670	11	INGRESO	15.000	UND	ingreso desde bodega	06-03	Rey	2026-03-06 16:28:20.429935
671	11	EGRESO	2.000	UND	VENTA	VENTA:375	Rey	2026-03-06 16:28:32.062504
672	16	INGRESO	104.000	UND	ingreso desde bodega	06-03	Rey	2026-03-06 16:30:09.599164
673	16	EGRESO	40.000	UND	VENTA	VENTA:377	Rey	2026-03-06 16:30:22.813188
674	16	EGRESO	20.000	UND	VENTA	VENTA:378	Rey	2026-03-06 16:31:51.962446
675	16	EGRESO	10.000	UND	VENTA	VENTA:379	Rey	2026-03-06 16:38:29.719492
676	9	EGRESO	10.000	UND	VENTA	VENTA:379	Rey	2026-03-06 16:38:29.719492
677	16	EGRESO	1.000	UND	VENTA	VENTA:380	Rey	2026-03-06 17:55:19.498284
678	16	EGRESO	2.000	UND	VENTA	VENTA:381	Rey	2026-03-06 17:55:37.436856
679	11	EGRESO	2.000	UND	VENTA	VENTA:382	Rey	2026-03-06 18:00:46.934243
680	1	EGRESO	1.000	UND	VENTA	VENTA:383	Rey	2026-03-06 18:10:39.838615
681	7	EGRESO	1.000	ML	VENTA	VENTA:383	Rey	2026-03-06 18:10:39.838615
682	9	EGRESO	1.000	UND	VENTA	VENTA:384	Rey	2026-03-06 18:26:03.636636
683	16	EGRESO	2.000	UND	VENTA	VENTA:384	Rey	2026-03-06 18:26:03.636636
684	11	EGRESO	1.000	UND	VENTA	VENTA:385	Rey	2026-03-06 18:33:54.359345
685	11	EGRESO	1.000	UND	VENTA	VENTA:386	Rey	2026-03-06 18:36:22.969995
686	9	INGRESO	20.000	UND	INGRESO DESDE BODEGA	0603	Rey	2026-03-06 18:48:46.494837
687	1	EGRESO	1.000	UND	VENTA	VENTA:388	Rey	2026-03-06 20:15:16.484686
688	3	EGRESO	1.000	UND	VENTA	VENTA:388	Rey	2026-03-06 20:15:16.484686
689	5	EGRESO	1.000	ML	VENTA	VENTA:388	Rey	2026-03-06 20:15:16.484686
690	4	EGRESO	29.570	ML	VENTA	VENTA:388	Rey	2026-03-06 20:15:16.484686
691	11	EGRESO	1.000	UND	VENTA	VENTA:389	Rey	2026-03-06 20:15:47.556474
692	9	EGRESO	1.000	UND	VENTA	VENTA:390	Rey	2026-03-06 20:16:07.617138
693	1	EGRESO	2.000	UND	VENTA	VENTA:391	Rey	2026-03-06 20:38:20.971623
694	2	EGRESO	2.000	UND	VENTA	VENTA:391	Rey	2026-03-06 20:38:20.971623
695	5	EGRESO	2.000	ML	VENTA	VENTA:391	Rey	2026-03-06 20:38:20.971623
696	4	EGRESO	59.140	ML	VENTA	VENTA:391	Rey	2026-03-06 20:38:20.971623
697	1	EGRESO	2.000	UND	VENTA	VENTA:392	Rey	2026-03-06 20:57:47.819751
698	5	EGRESO	2.000	ML	VENTA	VENTA:392	Rey	2026-03-06 20:57:47.819751
699	2	EGRESO	1.000	UND	VENTA	VENTA:392	Rey	2026-03-06 20:57:47.819751
700	4	EGRESO	29.570	ML	VENTA	VENTA:392	Rey	2026-03-06 20:57:47.819751
701	11	EGRESO	1.000	UND	VENTA	VENTA:393	Rey	2026-03-06 20:58:08.170311
702	9	EGRESO	1.000	UND	VENTA	VENTA:395	Rey	2026-03-06 20:58:44.491236
703	8	EGRESO	118.280	ML	VENTA	VENTA:395	Rey	2026-03-06 20:58:44.491236
704	11	EGRESO	4.000	UND	VENTA	VENTA:397	Rey	2026-03-06 21:28:36.602791
705	9	EGRESO	1.000	UND	VENTA	VENTA:398	Rey	2026-03-06 21:28:50.762704
706	8	EGRESO	118.280	ML	VENTA	VENTA:398	Rey	2026-03-06 21:28:50.762704
707	9	EGRESO	2.000	UND	VENTA	VENTA:399	Rey	2026-03-06 21:28:58.087793
708	9	EGRESO	1.000	UND	VENTA	VENTA:400	Rey	2026-03-06 21:36:13.086324
709	16	EGRESO	1.000	UND	VENTA	VENTA:401	Rey	2026-03-06 21:38:28.777772
710	16	EGRESO	1.000	UND	VENTA	VENTA:402	Rey	2026-03-06 21:38:43.602184
711	16	EGRESO	4.000	UND	VENTA	VENTA:404	Rey	2026-03-06 21:51:45.244759
712	3	EGRESO	1.000	UND	VENTA	VENTA:406	Rey	2026-03-06 22:41:44.074634
713	1	EGRESO	1.000	UND	VENTA	VENTA:406	Rey	2026-03-06 22:41:44.074634
714	5	EGRESO	1.000	ML	VENTA	VENTA:406	Rey	2026-03-06 22:41:44.074634
715	4	EGRESO	29.570	ML	VENTA	VENTA:406	Rey	2026-03-06 22:41:44.074634
716	16	EGRESO	3.000	UND	VENTA	VENTA:407	Rey	2026-03-06 22:42:45.111849
717	1	EGRESO	2.000	UND	VENTA	VENTA:408	Rey	2026-03-06 22:42:53.83003
718	7	EGRESO	2.000	ML	VENTA	VENTA:408	Rey	2026-03-06 22:42:53.83003
719	3	EGRESO	1.000	UND	VENTA	VENTA:410	Rey	2026-03-06 22:55:03.288549
720	1	EGRESO	2.000	UND	VENTA	VENTA:410	Rey	2026-03-06 22:55:03.288549
721	5	EGRESO	2.000	ML	VENTA	VENTA:410	Rey	2026-03-06 22:55:03.288549
722	4	EGRESO	59.140	ML	VENTA	VENTA:410	Rey	2026-03-06 22:55:03.288549
723	2	EGRESO	1.000	UND	VENTA	VENTA:410	Rey	2026-03-06 22:55:03.288549
724	11	EGRESO	2.000	UND	VENTA	VENTA:411	Rey	2026-03-06 22:56:37.967376
725	11	EGRESO	1.000	UND	VENTA	VENTA:340	Rey	2026-03-06 23:26:49.636839
726	18	EGRESO	162.635	ML	VENTA	VENTA:340	Rey	2026-03-06 23:26:49.636839
727	1	EGRESO	2.000	UND	VENTA	VENTA:340	Rey	2026-03-06 23:26:49.636839
728	2	EGRESO	1.000	UND	VENTA	VENTA:340	Rey	2026-03-06 23:26:49.636839
729	5	EGRESO	2.000	ML	VENTA	VENTA:340	Rey	2026-03-06 23:26:49.636839
730	4	EGRESO	59.140	ML	VENTA	VENTA:340	Rey	2026-03-06 23:26:49.636839
731	3	EGRESO	1.000	UND	VENTA	VENTA:340	Rey	2026-03-06 23:26:49.636839
732	1	EGRESO	2.000	UND	VENTA	VENTA:412	Rey	2026-03-06 23:29:12.404863
733	2	EGRESO	2.000	UND	VENTA	VENTA:412	Rey	2026-03-06 23:29:12.404863
734	5	EGRESO	2.000	ML	VENTA	VENTA:412	Rey	2026-03-06 23:29:12.404863
735	4	EGRESO	59.140	ML	VENTA	VENTA:412	Rey	2026-03-06 23:29:12.404863
736	9	EGRESO	2.000	UND	VENTA	VENTA:417	Rey	2026-03-06 23:33:03.117888
737	8	EGRESO	236.560	ML	VENTA	VENTA:417	Rey	2026-03-06 23:33:03.117888
738	5	EGRESO	2.000	ML	VENTA	VENTA:417	Rey	2026-03-06 23:33:03.117888
739	11	EGRESO	2.000	UND	VENTA	VENTA:418	Rey	2026-03-06 23:56:29.053967
740	1	EGRESO	2.000	UND	VENTA	VENTA:419	Rey	2026-03-06 23:56:49.094209
741	2	EGRESO	2.000	UND	VENTA	VENTA:419	Rey	2026-03-06 23:56:49.094209
742	5	EGRESO	2.000	ML	VENTA	VENTA:419	Rey	2026-03-06 23:56:49.094209
743	4	EGRESO	59.140	ML	VENTA	VENTA:419	Rey	2026-03-06 23:56:49.094209
744	11	EGRESO	1.000	UND	VENTA	VENTA:420	Rey	2026-03-07 00:09:05.50142
745	8	EGRESO	162.635	ML	VENTA	VENTA:420	Rey	2026-03-07 00:09:05.50142
746	1	EGRESO	1.000	UND	VENTA	VENTA:421	Rey	2026-03-07 00:09:34.423653
747	5	EGRESO	1.000	ML	VENTA	VENTA:421	Rey	2026-03-07 00:09:34.423653
748	4	EGRESO	29.570	ML	VENTA	VENTA:421	Rey	2026-03-07 00:09:34.423653
749	11	EGRESO	2.000	UND	VENTA	VENTA:422	Rey	2026-03-07 00:27:18.471386
750	3	EGRESO	4.000	UND	dañadas	\N	Rey	2026-03-07 16:02:09.335447
751	1	EGRESO	2.000	UND	VENTA	VENTA:423	Rey	2026-03-07 16:04:57.949596
752	3	EGRESO	2.000	UND	VENTA	VENTA:423	Rey	2026-03-07 16:04:57.949596
753	5	EGRESO	2.000	ML	VENTA	VENTA:423	Rey	2026-03-07 16:04:57.949596
754	4	EGRESO	59.140	ML	VENTA	VENTA:423	Rey	2026-03-07 16:04:57.949596
755	16	EGRESO	1.000	UND	VENTA	VENTA:423	Rey	2026-03-07 16:04:57.949596
756	11	EGRESO	1.000	UND	VENTA	VENTA:423	Rey	2026-03-07 16:04:57.949596
757	11	EGRESO	1.000	UND	dañada	\N	Rey	2026-03-07 16:05:27.963361
758	11	EGRESO	1.000	UND	VENTA	VENTA:424	Rey	2026-03-07 16:07:39.114647
759	1	EGRESO	1.000	UND	VENTA	VENTA:425	Rey	2026-03-07 16:09:03.491664
760	3	EGRESO	1.000	UND	VENTA	VENTA:425	Rey	2026-03-07 16:09:03.491664
761	5	EGRESO	1.000	ML	VENTA	VENTA:425	Rey	2026-03-07 16:09:03.491664
762	4	EGRESO	29.570	ML	VENTA	VENTA:425	Rey	2026-03-07 16:09:03.491664
763	11	EGRESO	2.000	UND	VENTA	VENTA:427	Rey	2026-03-07 16:25:10.403506
764	9	EGRESO	1.000	UND	VENTA	VENTA:428	Rey	2026-03-07 16:25:21.479217
765	11	EGRESO	1.000	UND	VENTA	VENTA:430	Rey	2026-03-07 17:21:52.913227
766	9	EGRESO	2.000	UND	VENTA	VENTA:432	Rey	2026-03-07 19:33:02.985389
767	16	EGRESO	1.000	UND	VENTA	VENTA:432	Rey	2026-03-07 19:33:02.985389
768	16	EGRESO	1.000	UND	VENTA	VENTA:433	Rey	2026-03-07 19:58:47.570847
769	9	EGRESO	1.000	UND	VENTA	VENTA:435	Rey	2026-03-07 19:59:08.220432
770	11	EGRESO	2.000	UND	VENTA	VENTA:436	Rey	2026-03-07 20:11:33.320428
771	11	EGRESO	1.000	UND	VENTA	VENTA:437	Rey	2026-03-07 20:11:45.056468
772	11	EGRESO	2.000	UND	VENTA	VENTA:438	Rey	2026-03-07 20:25:31.534955
773	1	EGRESO	1.000	UND	VENTA	VENTA:439	Rey	2026-03-07 20:51:40.42394
774	7	EGRESO	1.000	ML	VENTA	VENTA:439	Rey	2026-03-07 20:51:40.42394
775	16	EGRESO	1.000	UND	VENTA	VENTA:439	Rey	2026-03-07 20:51:40.42394
776	11	EGRESO	1.000	UND	VENTA	VENTA:440	Rey	2026-03-07 20:51:54.396745
777	11	INGRESO	30.000	UND	ingreso de bodega	\N	Rey	2026-03-07 21:44:57.513685
778	11	EGRESO	2.000	UND	VENTA	VENTA:443	Rey	2026-03-07 21:45:05.800393
779	2	EGRESO	2.000	UND	VENTA	VENTA:444	Rey	2026-03-07 21:45:15.463633
780	1	EGRESO	2.000	UND	VENTA	VENTA:444	Rey	2026-03-07 21:45:15.463633
781	5	EGRESO	2.000	ML	VENTA	VENTA:444	Rey	2026-03-07 21:45:15.463633
782	4	EGRESO	59.140	ML	VENTA	VENTA:444	Rey	2026-03-07 21:45:15.463633
783	11	EGRESO	3.000	UND	VENTA	VENTA:446	Rey	2026-03-07 21:46:28.813719
784	16	EGRESO	2.000	UND	VENTA	VENTA:447	Rey	2026-03-07 21:58:34.585351
785	11	EGRESO	1.000	UND	VENTA	VENTA:448	Rey	2026-03-07 22:32:05.727358
786	1	EGRESO	1.000	UND	VENTA	VENTA:449	Rey	2026-03-07 22:32:33.390299
787	9	EGRESO	1.000	UND	VENTA	VENTA:449	Rey	2026-03-07 22:32:33.390299
788	19	EGRESO	59.147	ML	VENTA	VENTA:449	Rey	2026-03-07 22:32:33.390299
789	1	EGRESO	2.000	UND	VENTA	VENTA:450	Rey	2026-03-07 22:32:42.405757
790	2	EGRESO	1.000	UND	VENTA	VENTA:450	Rey	2026-03-07 22:32:42.405757
791	5	EGRESO	2.000	ML	VENTA	VENTA:450	Rey	2026-03-07 22:32:42.405757
792	4	EGRESO	29.570	ML	VENTA	VENTA:450	Rey	2026-03-07 22:32:42.405757
793	9	EGRESO	2.000	UND	VENTA	VENTA:451	Rey	2026-03-07 22:33:46.849014
794	11	EGRESO	2.000	UND	VENTA	VENTA:452	Rey	2026-03-07 22:37:40.642177
795	16	EGRESO	2.000	UND	VENTA	VENTA:453	Rey	2026-03-07 22:38:24.743542
796	11	EGRESO	2.000	UND	DAÑADAS	\N	Rey	2026-03-07 22:39:40.692673
797	16	EGRESO	1.000	UND	VENTA	VENTA:454	Rey	2026-03-07 22:40:04.607683
798	1	INGRESO	3.000	UND	bodega	\N	Rey	2026-03-07 22:47:09.203113
799	9	INGRESO	11.000	UND	bodega	\N	Rey	2026-03-07 22:47:56.376164
800	2	EGRESO	1.000	UND	VENTA	VENTA:455	Rey	2026-03-07 22:55:29.973852
801	1	EGRESO	1.000	UND	VENTA	VENTA:455	Rey	2026-03-07 22:55:29.973852
802	5	EGRESO	1.000	ML	VENTA	VENTA:455	Rey	2026-03-07 22:55:29.973852
803	4	EGRESO	29.570	ML	VENTA	VENTA:455	Rey	2026-03-07 22:55:29.973852
824	11	EGRESO	1.000	UND	VENTA	VENTA:476	Rey	2026-03-07 23:46:03.859788
825	18	EGRESO	162.635	ML	VENTA	VENTA:476	Rey	2026-03-07 23:46:03.859788
826	11	EGRESO	4.000	UND	VENTA	VENTA:477	Rey	2026-03-07 23:46:32.669666
827	8	EGRESO	650.540	ML	VENTA	VENTA:477	Rey	2026-03-07 23:46:32.669666
828	11	EGRESO	2.000	UND	VENTA	VENTA:478	Rey	2026-03-07 23:47:53.96466
829	16	EGRESO	1.000	UND	VENTA	VENTA:479	Rey	2026-03-07 23:48:02.354463
830	1	EGRESO	2.000	UND	VENTA	VENTA:480	Rey	2026-03-07 23:48:22.053323
831	7	EGRESO	2.000	ML	VENTA	VENTA:480	Rey	2026-03-07 23:48:22.053323
832	16	EGRESO	6.000	UND	VENTA	VENTA:484	Alex	2026-03-08 18:55:20.643479
833	11	EGRESO	7.000	UND	VENTA	VENTA:485	Alex	2026-03-08 18:56:05.68496
834	16	EGRESO	1.000	UND	VENTA	VENTA:487	Alex	2026-03-08 19:01:39.965804
835	9	EGRESO	1.000	UND	VENTA	VENTA:487	Alex	2026-03-08 19:01:39.965804
836	9	EGRESO	1.000	UND	VENTA	VENTA:488	Alex	2026-03-08 19:03:29.000871
837	8	EGRESO	118.280	ML	VENTA	VENTA:488	Alex	2026-03-08 19:03:29.000871
838	11	EGRESO	1.000	UND	VENTA	VENTA:490	Alex	2026-03-08 19:08:19.780649
839	8	EGRESO	162.635	ML	VENTA	VENTA:490	Alex	2026-03-08 19:08:19.780649
840	9	EGRESO	2.000	UND	VENTA	VENTA:491	Alex	2026-03-08 19:08:42.644843
841	1	EGRESO	3.000	UND	VENTA	VENTA:492	Alex	2026-03-08 19:09:06.572028
842	2	EGRESO	3.000	UND	VENTA	VENTA:492	Alex	2026-03-08 19:09:06.572028
843	5	EGRESO	3.000	ML	VENTA	VENTA:492	Alex	2026-03-08 19:09:06.572028
844	4	EGRESO	88.710	ML	VENTA	VENTA:492	Alex	2026-03-08 19:09:06.572028
845	1	INGRESO	3.000	UND	\N	\N	Alex	2026-03-08 19:42:00.09095
846	2	EGRESO	1.000	UND	VENTA	VENTA:493	Alex	2026-03-08 19:42:29.9848
847	1	EGRESO	3.000	UND	VENTA	VENTA:493	Alex	2026-03-08 19:42:29.9848
848	5	EGRESO	1.000	ML	VENTA	VENTA:493	Alex	2026-03-08 19:42:29.9848
849	4	EGRESO	29.570	ML	VENTA	VENTA:493	Alex	2026-03-08 19:42:29.9848
850	7	EGRESO	1.000	ML	VENTA	VENTA:493	Alex	2026-03-08 19:42:29.9848
851	9	EGRESO	1.000	UND	VENTA	VENTA:493	Alex	2026-03-08 19:42:29.9848
852	11	EGRESO	1.000	UND	VENTA	VENTA:493	Alex	2026-03-08 19:42:29.9848
853	16	EGRESO	1.000	UND	VENTA	VENTA:495	Alex	2026-03-08 19:48:18.110828
854	16	INGRESO	1.000	UND	\N	\N	Alex	2026-03-08 19:51:28.780626
855	16	EGRESO	3.000	UND	VENTA	VENTA:498	Alex	2026-03-08 19:51:42.706581
856	11	EGRESO	1.000	UND	VENTA	VENTA:499	Alex	2026-03-08 20:05:23.541369
857	9	EGRESO	1.000	UND	VENTA	VENTA:499	Alex	2026-03-08 20:05:23.541369
858	11	EGRESO	1.000	UND	VENTA	VENTA:500	Alex	2026-03-08 20:11:39.145853
859	11	EGRESO	3.000	UND	VENTA	VENTA:501	Alex	2026-03-08 20:23:01.469319
860	11	INGRESO	15.000	UND	\N	\N	Alex	2026-03-08 20:30:47.893221
861	11	EGRESO	1.000	UND	VENTA	VENTA:504	Alex	2026-03-08 20:31:00.909645
862	11	EGRESO	1.000	UND	VENTA	VENTA:505	Alex	2026-03-08 20:34:22.821459
863	1	EGRESO	1.000	UND	VENTA	VENTA:505	Alex	2026-03-08 20:34:22.821459
864	7	EGRESO	1.000	ML	VENTA	VENTA:505	Alex	2026-03-08 20:34:22.821459
865	11	EGRESO	1.000	UND	VENTA	VENTA:506	Alex	2026-03-08 20:42:42.621532
866	1	INGRESO	1.000	UND	\N	\N	Alex	2026-03-08 20:50:36.657383
867	1	EGRESO	1.000	UND	VENTA	VENTA:510	Alex	2026-03-08 20:50:48.00209
868	5	EGRESO	1.000	ML	VENTA	VENTA:510	Alex	2026-03-08 20:50:48.00209
869	11	EGRESO	2.000	UND	VENTA	VENTA:511	Alex	2026-03-08 21:10:11.882469
870	11	EGRESO	1.000	UND	VENTA	VENTA:512	Alex	2026-03-08 21:26:10.784565
873	16	INGRESO	68.000	UND	ingreso desde bodega	0903	Rey	2026-03-09 17:28:46.921203
874	11	INGRESO	29.000	UND	bodega	0903	Rey	2026-03-09 17:29:14.036708
875	9	INGRESO	9.000	UND	ingreso desde bodega	0903	Rey	2026-03-09 17:29:47.89757
876	1	INGRESO	5.000	UND	b-odega	\N	Rey	2026-03-09 17:30:02.359192
877	1	EGRESO	1.000	UND	VENTA	VENTA:516	Rey	2026-03-09 17:30:52.65707
878	7	EGRESO	1.000	ML	VENTA	VENTA:516	Rey	2026-03-09 17:30:52.65707
879	11	EGRESO	2.000	UND	VENTA	VENTA:517	Rey	2026-03-09 17:31:01.091298
880	11	EGRESO	1.000	UND	VENTA	VENTA:518	Rey	2026-03-09 17:31:46.477123
881	8	EGRESO	162.635	ML	VENTA	VENTA:518	Rey	2026-03-09 17:31:46.477123
882	16	EGRESO	1.000	UND	VENTA	VENTA:519	Rey	2026-03-09 17:31:57.357329
883	16	EGRESO	35.000	UND	VENTA	VENTA:520	Rey	2026-03-09 17:34:13.474934
884	1	EGRESO	4.000	UND	VENTA	VENTA:521	Rey	2026-03-09 17:34:42.464791
885	5	EGRESO	4.000	ML	VENTA	VENTA:521	Rey	2026-03-09 17:34:42.464791
886	16	EGRESO	1.000	UND	VENTA	VENTA:522	Rey	2026-03-09 17:42:41.272325
887	9	EGRESO	1.000	UND	VENTA	VENTA:522	Rey	2026-03-09 17:42:41.272325
888	16	EGRESO	5.000	UND	REPOSICION DAÑO	\N	Rey	2026-03-09 18:05:36.744189
889	11	EGRESO	5.000	UND	perdida	\N	Rey	2026-03-09 18:09:35.891372
890	1	EGRESO	1.000	UND	VENTA	VENTA:523	Rey	2026-03-09 19:31:40.278804
891	2	EGRESO	1.000	UND	VENTA	VENTA:523	Rey	2026-03-09 19:31:40.278804
892	5	EGRESO	1.000	ML	VENTA	VENTA:523	Rey	2026-03-09 19:31:40.278804
893	4	EGRESO	29.570	ML	VENTA	VENTA:523	Rey	2026-03-09 19:31:40.278804
894	11	EGRESO	1.000	UND	VENTA	VENTA:523	Rey	2026-03-09 19:31:40.278804
895	16	EGRESO	3.000	UND	VENTA	VENTA:524	Rey	2026-03-09 19:32:06.193894
896	11	EGRESO	3.000	UND	VENTA	VENTA:525	Rey	2026-03-09 19:45:00.439872
897	16	EGRESO	2.000	UND	VENTA	VENTA:526	Rey	2026-03-09 20:26:22.070732
898	1	INGRESO	1.000	UND	BODEGA	\N	Rey	2026-03-09 20:46:54.77982
899	1	EGRESO	1.000	UND	VENTA	VENTA:529	Rey	2026-03-09 20:46:58.790316
900	5	EGRESO	1.000	ML	VENTA	VENTA:529	Rey	2026-03-09 20:46:58.790316
901	16	EGRESO	1.000	UND	VENTA	VENTA:529	Rey	2026-03-09 20:46:58.790316
902	16	EGRESO	2.000	UND	VENTA	VENTA:531	Rey	2026-03-09 21:09:43.489401
903	11	EGRESO	1.000	UND	VENTA	VENTA:531	Rey	2026-03-09 21:09:43.489401
904	1	EGRESO	1.000	UND	VENTA	VENTA:530	Rey	2026-03-09 21:34:07.520567
905	7	EGRESO	1.000	ML	VENTA	VENTA:530	Rey	2026-03-09 21:34:07.520567
906	9	EGRESO	1.000	UND	VENTA	VENTA:530	Rey	2026-03-09 21:34:07.520567
907	1	INGRESO	2.000	UND	bodega	\N	Rey	2026-03-09 21:42:35.440342
908	1	EGRESO	2.000	UND	VENTA	VENTA:532	Rey	2026-03-09 21:46:48.02144
909	9	EGRESO	1.000	UND	VENTA	VENTA:532	Rey	2026-03-09 21:46:48.02144
910	5	EGRESO	1.000	ML	VENTA	VENTA:532	Rey	2026-03-09 21:46:48.02144
911	4	EGRESO	29.570	ML	VENTA	VENTA:532	Rey	2026-03-09 21:46:48.02144
912	11	EGRESO	3.000	UND	VENTA	VENTA:533	Rey	2026-03-09 21:47:18.043703
913	1	EGRESO	1.000	UND	VENTA	VENTA:534	Rey	2026-03-09 21:47:39.704882
914	7	EGRESO	1.000	ML	VENTA	VENTA:534	Rey	2026-03-09 21:47:39.704882
915	16	EGRESO	1.000	UND	VENTA	VENTA:535	Rey	2026-03-09 21:48:08.198057
916	9	EGRESO	1.000	UND	VENTA	VENTA:535	Rey	2026-03-09 21:48:08.198057
919	16	EGRESO	2.000	UND	VENTA	VENTA:538	Rey	2026-03-09 21:48:38.472027
920	11	EGRESO	1.000	UND	VENTA	VENTA:539	Rey	2026-03-09 22:21:49.857642
921	8	EGRESO	162.635	ML	VENTA	VENTA:539	Rey	2026-03-09 22:21:49.857642
922	16	EGRESO	1.000	UND	VENTA	VENTA:540	Rey	2026-03-09 22:22:04.211964
923	16	EGRESO	1.000	UND	VENTA	VENTA:541	Rey	2026-03-09 22:22:28.068869
926	11	EGRESO	1.000	UND	VENTA	VENTA:544	Rey	2026-03-09 23:04:49.146641
927	5	EGRESO	1.000	ML	VENTA	VENTA:545	Rey	2026-03-09 23:06:40.32117
928	16	EGRESO	2.000	UND	VENTA	VENTA:546	Rey	2026-03-09 23:10:48.69006
929	11	EGRESO	5.000	UND	VENTA	VENTA:547	Rey	2026-03-09 23:27:46.901006
930	2	EGRESO	1.000	UND	VENTA	VENTA:551	Rey	2026-03-09 23:34:14.808186
931	1	EGRESO	1.000	UND	VENTA	VENTA:551	Rey	2026-03-09 23:34:14.808186
932	5	EGRESO	1.000	ML	VENTA	VENTA:551	Rey	2026-03-09 23:34:14.808186
933	4	EGRESO	29.570	ML	VENTA	VENTA:551	Rey	2026-03-09 23:34:14.808186
934	16	EGRESO	1.000	UND	VENTA	VENTA:552	Rey	2026-03-09 23:36:39.877392
935	1	INGRESO	8.000	UND	\N	\N	Rey	2026-03-10 17:53:37.502817
936	1	INGRESO	8.000	UND	\N	\N	Rey	2026-03-10 17:53:37.5579
937	2	INGRESO	1.000	UND	b	\N	Rey	2026-03-10 17:53:48.700721
938	16	EGRESO	1.000	UND	VENTA	VENTA:553	Rey	2026-03-10 19:20:20.095318
939	1	EGRESO	1.000	UND	VENTA	VENTA:554	Rey	2026-03-10 19:20:58.463711
940	7	EGRESO	1.000	ML	VENTA	VENTA:554	Rey	2026-03-10 19:20:58.463711
941	11	EGRESO	1.000	UND	VENTA	VENTA:555	Rey	2026-03-10 19:21:03.761172
942	8	EGRESO	162.635	ML	VENTA	VENTA:555	Rey	2026-03-10 19:21:03.761172
943	11	INGRESO	20.000	UND	bodega	\N	Rey	2026-03-10 19:21:24.923809
944	11	INGRESO	20.000	UND	bodega	\N	Rey	2026-03-10 19:21:24.933819
945	1	EGRESO	2.000	UND	VENTA	VENTA:556	Rey	2026-03-10 19:21:39.609173
946	3	EGRESO	1.000	UND	VENTA	VENTA:556	Rey	2026-03-10 19:21:39.609173
947	5	EGRESO	2.000	ML	VENTA	VENTA:556	Rey	2026-03-10 19:21:39.609173
948	4	EGRESO	59.140	ML	VENTA	VENTA:556	Rey	2026-03-10 19:21:39.609173
949	2	EGRESO	1.000	UND	VENTA	VENTA:556	Rey	2026-03-10 19:21:39.609173
950	9	EGRESO	1.000	UND	VENTA	VENTA:556	Rey	2026-03-10 19:21:39.609173
951	9	EGRESO	1.000	UND	VENTA	VENTA:557	Rey	2026-03-10 19:21:45.246024
954	16	EGRESO	6.000	UND	VENTA	VENTA:561	Rey	2026-03-10 20:16:41.039642
955	1	EGRESO	1.000	UND	VENTA	VENTA:561	Rey	2026-03-10 20:16:41.039642
956	2	EGRESO	1.000	UND	VENTA	VENTA:561	Rey	2026-03-10 20:16:41.039642
957	5	EGRESO	1.000	ML	VENTA	VENTA:561	Rey	2026-03-10 20:16:41.039642
958	4	EGRESO	29.570	ML	VENTA	VENTA:561	Rey	2026-03-10 20:16:41.039642
959	16	EGRESO	3.000	UND	VENTA	VENTA:562	Rey	2026-03-10 20:17:04.323408
960	16	INGRESO	10.000	UND	bodega	\N	Rey	2026-03-10 20:17:21.063618
961	9	EGRESO	1.000	UND	VENTA	VENTA:563	Rey	2026-03-10 20:18:50.522027
962	16	EGRESO	2.000	UND	VENTA	VENTA:564	Rey	2026-03-10 20:21:44.462351
963	16	EGRESO	5.000	UND	VENTA	VENTA:565	Rey	2026-03-10 20:29:52.79531
964	9	EGRESO	1.000	UND	VENTA	VENTA:566	Rey	2026-03-10 20:32:04.055952
965	16	EGRESO	1.000	UND	VENTA	VENTA:566	Rey	2026-03-10 20:32:04.055952
966	11	EGRESO	2.000	UND	VENTA	VENTA:569	Rey	2026-03-10 21:12:12.440962
968	1	EGRESO	2.000	UND	VENTA	VENTA:571	Rey	2026-03-10 21:18:56.905021
969	2	EGRESO	2.000	UND	VENTA	VENTA:571	Rey	2026-03-10 21:18:56.905021
970	5	EGRESO	2.000	ML	VENTA	VENTA:571	Rey	2026-03-10 21:18:56.905021
971	4	EGRESO	59.140	ML	VENTA	VENTA:571	Rey	2026-03-10 21:18:56.905021
972	11	EGRESO	2.000	UND	VENTA	VENTA:573	Rey	2026-03-10 22:26:55.430932
974	9	EGRESO	3.000	UND	VENTA	VENTA:574	Rey	2026-03-10 22:27:18.481284
975	16	EGRESO	1.000	UND	VENTA	VENTA:575	Rey	2026-03-11 16:33:18.908891
976	9	EGRESO	1.000	UND	VENTA	VENTA:576	Rey	2026-03-11 17:42:13.296073
977	1	EGRESO	1.000	UND	VENTA	VENTA:578	Rey	2026-03-11 19:08:43.559975
978	7	EGRESO	1.000	ML	VENTA	VENTA:578	Rey	2026-03-11 19:08:43.559975
979	11	EGRESO	1.000	UND	VENTA	VENTA:578	Rey	2026-03-11 19:08:43.559975
980	1	EGRESO	1.000	UND	VENTA	VENTA:579	Rey	2026-03-11 19:10:35.923618
981	2	EGRESO	1.000	UND	VENTA	VENTA:579	Rey	2026-03-11 19:10:35.923618
982	5	EGRESO	1.000	ML	VENTA	VENTA:579	Rey	2026-03-11 19:10:35.923618
983	4	EGRESO	29.570	ML	VENTA	VENTA:579	Rey	2026-03-11 19:10:35.923618
984	1	INGRESO	3.000	UND	bodega	\N	Rey	2026-03-11 20:01:09.797321
985	1	EGRESO	3.000	UND	VENTA	VENTA:580	Rey	2026-03-11 20:01:19.175148
986	5	EGRESO	3.000	ML	VENTA	VENTA:580	Rey	2026-03-11 20:01:19.175148
987	3	EGRESO	1.000	UND	VENTA	VENTA:580	Rey	2026-03-11 20:01:19.175148
988	4	EGRESO	29.570	ML	VENTA	VENTA:580	Rey	2026-03-11 20:01:19.175148
989	16	INGRESO	11.000	UND	\N	\N	Rey	2026-03-11 20:27:25.534352
990	9	INGRESO	19.000	UND	\N	\N	Rey	2026-03-11 20:29:21.13759
991	9	EGRESO	6.000	UND	DAÑADAS	\N	Rey	2026-03-11 20:29:45.155915
994	11	EGRESO	2.000	UND	VENTA	VENTA:582	Rey	2026-03-11 21:16:05.229547
995	8	EGRESO	325.270	ML	VENTA	VENTA:582	Rey	2026-03-11 21:16:05.229547
998	3	EGRESO	1.000	UND	VENTA	VENTA:585	Rey	2026-03-11 21:28:59.692955
999	1	EGRESO	1.000	UND	VENTA	VENTA:585	Rey	2026-03-11 21:28:59.692955
1000	5	EGRESO	1.000	ML	VENTA	VENTA:585	Rey	2026-03-11 21:28:59.692955
1001	4	EGRESO	29.570	ML	VENTA	VENTA:585	Rey	2026-03-11 21:28:59.692955
1002	9	EGRESO	1.000	UND	VENTA	VENTA:586	Rey	2026-03-11 21:31:41.502967
1003	1	INGRESO	2.000	UND	\N	\N	Rey	2026-03-11 22:57:14.647158
1004	1	EGRESO	2.000	UND	VENTA	VENTA:589	Rey	2026-03-11 22:57:23.256362
1005	5	EGRESO	2.000	ML	VENTA	VENTA:589	Rey	2026-03-11 22:57:23.256362
1006	4	EGRESO	29.570	ML	VENTA	VENTA:589	Rey	2026-03-11 22:57:23.256362
1007	16	INGRESO	15.000	UND	bodega	\N	Rey	2026-03-11 22:59:05.908138
1008	16	EGRESO	15.000	UND	VENTA	VENTA:590	Rey	2026-03-11 22:59:36.884356
1009	11	EGRESO	1.000	UND	VENTA	VENTA:570	Rey	2026-03-11 23:04:29.047457
1010	1	EGRESO	1.000	UND	VENTA	VENTA:581	Rey	2026-03-11 23:05:36.739168
1011	7	EGRESO	1.000	ML	VENTA	VENTA:581	Rey	2026-03-11 23:05:36.739168
1012	16	EGRESO	1.000	UND	VENTA	VENTA:591	Rey	2026-03-11 23:08:39.028841
1013	1	EGRESO	1.000	UND	VENTA	VENTA:594	Rey	2026-03-12 15:57:08.895851
1014	3	EGRESO	1.000	UND	VENTA	VENTA:594	Rey	2026-03-12 15:57:08.895851
1015	5	EGRESO	1.000	ML	VENTA	VENTA:594	Rey	2026-03-12 15:57:08.895851
1016	4	EGRESO	29.570	ML	VENTA	VENTA:594	Rey	2026-03-12 15:57:08.895851
1017	11	EGRESO	1.000	UND	VENTA	VENTA:594	Rey	2026-03-12 15:57:08.895851
1018	11	EGRESO	2.000	UND	VENTA	VENTA:595	Rey	2026-03-12 15:57:35.276663
1019	16	EGRESO	5.000	UND	VENTA	VENTA:596	Rey	2026-03-12 15:58:06.700761
1020	9	EGRESO	10.000	UND	VENTA	VENTA:597	Rey	2026-03-12 15:58:58.177977
1021	16	EGRESO	8.000	UND	VENTA	VENTA:597	Rey	2026-03-12 15:58:58.177977
1022	11	EGRESO	2.000	UND	VENTA	VENTA:600	Rey	2026-03-12 17:17:35.436667
1023	9	EGRESO	2.000	UND	VENTA	VENTA:601	Rey	2026-03-12 17:18:16.74037
1026	9	EGRESO	3.000	UND	VENTA	VENTA:604	Rey	2026-03-12 17:19:01.089474
1027	16	EGRESO	1.000	UND	VENTA	VENTA:604	Rey	2026-03-12 17:19:01.089474
1028	16	EGRESO	5.000	UND	VENTA	VENTA:605	Rey	2026-03-12 17:19:12.922808
1029	11	EGRESO	1.000	UND	VENTA	VENTA:607	Rey	2026-03-12 17:48:07.387539
1030	11	EGRESO	1.000	UND	VENTA	VENTA:608	Rey	2026-03-12 18:24:57.155796
1031	1	INGRESO	28.000	UND	ingreso desde bodega	1203	Rey	2026-03-12 19:06:21.418744
1032	3	EGRESO	1.000	UND	VENTA	VENTA:610	Rey	2026-03-12 19:06:34.948873
1033	1	EGRESO	1.000	UND	VENTA	VENTA:610	Rey	2026-03-12 19:06:34.948873
1034	5	EGRESO	1.000	ML	VENTA	VENTA:610	Rey	2026-03-12 19:06:34.948873
1035	4	EGRESO	29.570	ML	VENTA	VENTA:610	Rey	2026-03-12 19:06:34.948873
1036	11	EGRESO	1.000	UND	VENTA	VENTA:611	Rey	2026-03-12 19:16:46.895561
1037	3	EGRESO	2.000	UND	VENTA	VENTA:612	Rey	2026-03-12 19:38:43.145662
1038	1	EGRESO	2.000	UND	VENTA	VENTA:612	Rey	2026-03-12 19:38:43.145662
1039	5	EGRESO	2.000	ML	VENTA	VENTA:612	Rey	2026-03-12 19:38:43.145662
1040	4	EGRESO	59.140	ML	VENTA	VENTA:612	Rey	2026-03-12 19:38:43.145662
1041	11	EGRESO	1.000	UND	VENTA	VENTA:612	Rey	2026-03-12 19:38:43.145662
1042	11	INGRESO	15.000	UND	ingreso desde bodega	\N	Rey	2026-03-12 19:53:33.02331
1043	16	INGRESO	76.000	UND	ingreso desde bodega	1203	Rey	2026-03-12 19:57:42.813775
1044	16	EGRESO	5.000	UND	Egreso por reposicion	1203	Rey	2026-03-12 19:58:18.438429
1045	16	EGRESO	20.000	UND	VENTA	VENTA:613	Rey	2026-03-12 20:13:49.637834
1046	2	INGRESO	15.000	UND	bodega	1203	Rey	2026-03-12 20:29:09.430055
1047	11	EGRESO	4.000	UND	VENTA	VENTA:614	Rey	2026-03-12 20:49:49.721959
1056	3	EGRESO	1.000	UND	VENTA	VENTA:617	Rey	2026-03-12 21:12:57.629044
1057	1	EGRESO	1.000	UND	VENTA	VENTA:617	Rey	2026-03-12 21:12:57.629044
1058	5	EGRESO	1.000	ML	VENTA	VENTA:617	Rey	2026-03-12 21:12:57.629044
1059	4	EGRESO	29.570	ML	VENTA	VENTA:617	Rey	2026-03-12 21:12:57.629044
1060	11	EGRESO	2.000	UND	VENTA	VENTA:618	Rey	2026-03-12 21:55:01.970273
1061	11	EGRESO	1.000	UND	VENTA	VENTA:619	Rey	2026-03-12 21:55:24.714897
1062	2	EGRESO	1.000	UND	VENTA	VENTA:620	Rey	2026-03-12 21:56:13.176447
1063	1	EGRESO	2.000	UND	VENTA	VENTA:620	Rey	2026-03-12 21:56:13.176447
1064	5	EGRESO	1.000	ML	VENTA	VENTA:620	Rey	2026-03-12 21:56:13.176447
1065	4	EGRESO	29.570	ML	VENTA	VENTA:620	Rey	2026-03-12 21:56:13.176447
1066	7	EGRESO	1.000	ML	VENTA	VENTA:620	Rey	2026-03-12 21:56:13.176447
1067	11	EGRESO	2.000	UND	VENTA	VENTA:620	Rey	2026-03-12 21:56:13.176447
1068	8	EGRESO	325.270	ML	VENTA	VENTA:620	Rey	2026-03-12 21:56:13.176447
1069	16	EGRESO	2.000	UND	VENTA	VENTA:621	Rey	2026-03-12 22:02:30.970868
1070	16	EGRESO	1.000	UND	VENTA	VENTA:622	Rey	2026-03-12 22:08:16.327677
1071	11	EGRESO	3.000	UND	VENTA	VENTA:623	Rey	2026-03-12 22:11:52.435524
1072	16	EGRESO	6.000	UND	VENTA	VENTA:624	Rey	2026-03-12 22:44:08.960934
1073	2	EGRESO	1.000	UND	VENTA	VENTA:625	Rey	2026-03-12 22:44:15.722113
1074	1	EGRESO	1.000	UND	VENTA	VENTA:625	Rey	2026-03-12 22:44:15.722113
1075	5	EGRESO	1.000	ML	VENTA	VENTA:625	Rey	2026-03-12 22:44:15.722113
1076	4	EGRESO	29.570	ML	VENTA	VENTA:625	Rey	2026-03-12 22:44:15.722113
1077	16	EGRESO	1.000	UND	VENTA	VENTA:626	Rey	2026-03-12 22:44:29.230056
1078	11	INGRESO	20.000	UND	ingreso desde bodega	1303	Rey	2026-03-13 15:43:58.424625
1079	1	EGRESO	1.000	UND	VENTA	VENTA:630	Rey	2026-03-13 16:37:07.392995
1080	3	EGRESO	1.000	UND	VENTA	VENTA:630	Rey	2026-03-13 16:37:07.392995
1081	5	EGRESO	1.000	ML	VENTA	VENTA:630	Rey	2026-03-13 16:37:07.392995
1082	4	EGRESO	29.570	ML	VENTA	VENTA:630	Rey	2026-03-13 16:37:07.392995
1083	11	EGRESO	1.000	UND	VENTA	VENTA:631	Rey	2026-03-13 16:43:00.973857
1084	1	EGRESO	2.000	UND	VENTA	VENTA:632	Rey	2026-03-13 16:44:02.417972
1085	7	EGRESO	2.000	ML	VENTA	VENTA:632	Rey	2026-03-13 16:44:02.417972
1086	9	EGRESO	1.000	UND	VENTA	VENTA:632	Rey	2026-03-13 16:44:02.417972
1087	11	EGRESO	1.000	UND	VENTA	VENTA:633	Rey	2026-03-13 16:59:42.38669
1088	16	EGRESO	1.000	UND	VENTA	VENTA:633	Rey	2026-03-13 16:59:42.38669
1089	1	EGRESO	1.000	UND	VENTA	VENTA:635	Rey	2026-03-13 17:20:46.328564
1090	5	EGRESO	1.000	ML	VENTA	VENTA:635	Rey	2026-03-13 17:20:46.328564
1091	11	EGRESO	1.000	UND	VENTA	VENTA:636	Rey	2026-03-13 17:34:13.93689
1092	16	EGRESO	35.000	UND	VENTA	VENTA:637	Rey	2026-03-13 17:42:55.722005
1093	1	EGRESO	1.000	UND	VENTA	VENTA:640	Rey	2026-03-13 17:53:55.582036
1094	3	EGRESO	1.000	UND	VENTA	VENTA:640	Rey	2026-03-13 17:53:55.582036
1095	5	EGRESO	1.000	ML	VENTA	VENTA:640	Rey	2026-03-13 17:53:55.582036
1096	4	EGRESO	29.570	ML	VENTA	VENTA:640	Rey	2026-03-13 17:53:55.582036
1097	11	EGRESO	1.000	UND	VENTA	VENTA:641	Rey	2026-03-13 18:02:10.852674
1098	11	EGRESO	2.000	UND	VENTA	VENTA:642	Rey	2026-03-13 18:07:33.229301
1099	16	EGRESO	1.000	UND	VENTA	VENTA:643	Rey	2026-03-13 18:30:36.058649
1100	3	INGRESO	1.000	UND	venta	1303	Rey	2026-03-13 18:42:12.546076
1101	1	EGRESO	1.000	UND	VENTA	VENTA:644	Rey	2026-03-13 18:44:25.759229
1102	3	EGRESO	1.000	UND	VENTA	VENTA:644	Rey	2026-03-13 18:44:25.759229
1103	5	EGRESO	1.000	ML	VENTA	VENTA:644	Rey	2026-03-13 18:44:25.759229
1104	4	EGRESO	29.570	ML	VENTA	VENTA:644	Rey	2026-03-13 18:44:25.759229
1105	9	INGRESO	30.000	UND	ingreso desde bodega	1303	Rey	2026-03-13 18:51:37.31137
1106	3	INGRESO	15.000	UND	ingreso desde -bodega	1303	Rey	2026-03-13 19:03:59.181776
1107	16	EGRESO	5.000	UND	VENTA	VENTA:645	Rey	2026-03-13 19:13:39.915056
1108	16	EGRESO	1.000	UND	VENTA	VENTA:646	Rey	2026-03-13 19:13:54.457956
1109	16	INGRESO	49.000	UND	ingreso desde bodega	1303	Rey	2026-03-13 19:20:54.910928
1110	9	EGRESO	15.000	UND	VENTA	VENTA:647	Rey	2026-03-13 19:22:02.371255
1111	16	EGRESO	15.000	UND	VENTA	VENTA:647	Rey	2026-03-13 19:22:02.371255
1112	1	EGRESO	4.000	UND	VENTA	VENTA:650	Rey	2026-03-13 19:55:01.553463
1113	5	EGRESO	4.000	ML	VENTA	VENTA:650	Rey	2026-03-13 19:55:01.553463
1114	4	EGRESO	118.280	ML	VENTA	VENTA:650	Rey	2026-03-13 19:55:01.553463
1115	1	EGRESO	1.000	UND	VENTA	VENTA:651	Rey	2026-03-13 20:00:08.553258
1116	5	EGRESO	1.000	ML	VENTA	VENTA:651	Rey	2026-03-13 20:00:08.553258
1117	4	EGRESO	29.570	ML	VENTA	VENTA:651	Rey	2026-03-13 20:00:08.553258
1118	11	EGRESO	1.000	UND	VENTA	VENTA:652	Rey	2026-03-13 20:23:41.206111
1119	16	EGRESO	1.000	UND	VENTA	VENTA:653	Rey	2026-03-13 20:23:50.027972
1120	1	EGRESO	1.000	UND	VENTA	VENTA:655	Rey	2026-03-13 20:56:48.067241
1121	7	EGRESO	1.000	ML	VENTA	VENTA:655	Rey	2026-03-13 20:56:48.067241
1122	17	EGRESO	1.000	UND	VENTA	VENTA:657	Rey	2026-03-13 20:57:20.486716
1123	11	EGRESO	2.000	UND	VENTA	VENTA:654	Rey	2026-03-13 20:59:32.732992
1124	16	EGRESO	2.000	UND	VENTA	VENTA:658	Rey	2026-03-13 20:59:42.512793
1125	11	EGRESO	3.000	UND	VENTA	VENTA:659	Rey	2026-03-13 21:12:12.788167
1126	11	EGRESO	2.000	UND	VENTA	VENTA:661	Rey	2026-03-13 21:36:18.415134
1127	16	EGRESO	1.000	UND	VENTA	VENTA:660	Rey	2026-03-13 21:36:58.381135
1128	1	EGRESO	1.000	UND	VENTA	VENTA:663	Rey	2026-03-13 21:43:02.677328
1129	7	EGRESO	1.000	ML	VENTA	VENTA:663	Rey	2026-03-13 21:43:02.677328
1130	5	EGRESO	4.000	ML	VENTA	VENTA:664	Rey	2026-03-13 21:55:32.786807
1131	2	EGRESO	1.000	UND	VENTA	VENTA:665	Rey	2026-03-13 22:15:49.259943
1132	1	EGRESO	1.000	UND	VENTA	VENTA:665	Rey	2026-03-13 22:15:49.259943
1133	5	EGRESO	1.000	ML	VENTA	VENTA:665	Rey	2026-03-13 22:15:49.259943
1134	4	EGRESO	29.570	ML	VENTA	VENTA:665	Rey	2026-03-13 22:15:49.259943
1135	11	EGRESO	1.000	UND	VENTA	VENTA:666	Rey	2026-03-13 22:16:18.461317
1136	8	EGRESO	162.635	ML	VENTA	VENTA:666	Rey	2026-03-13 22:16:18.461317
1137	11	EGRESO	1.000	UND	VENTA	VENTA:667	Rey	2026-03-13 22:16:54.385009
1138	1	EGRESO	1.000	UND	VENTA	VENTA:668	Rey	2026-03-13 22:18:13.798788
1139	5	EGRESO	1.000	ML	VENTA	VENTA:668	Rey	2026-03-13 22:18:13.798788
1140	4	EGRESO	29.570	ML	VENTA	VENTA:668	Rey	2026-03-13 22:18:13.798788
1141	16	EGRESO	1.000	UND	VENTA	VENTA:668	Rey	2026-03-13 22:18:13.798788
1142	11	EGRESO	2.000	UND	VENTA	VENTA:669	Rey	2026-03-13 22:26:34.884604
1143	11	EGRESO	1.000	UND	VENTA	VENTA:670	Rey	2026-03-13 22:32:36.891442
1144	1	EGRESO	1.000	UND	VENTA	VENTA:672	Rey	2026-03-13 22:38:23.668236
1145	5	EGRESO	1.000	ML	VENTA	VENTA:672	Rey	2026-03-13 22:38:23.668236
1146	9	EGRESO	2.000	UND	VENTA	VENTA:673	Rey	2026-03-13 22:39:35.69363
1147	11	EGRESO	1.000	UND	VENTA	VENTA:674	Rey	2026-03-13 23:09:28.412349
1148	8	EGRESO	162.635	ML	VENTA	VENTA:674	Rey	2026-03-13 23:09:28.412349
1149	11	EGRESO	1.000	UND	VENTA	VENTA:675	Rey	2026-03-13 23:29:24.45396
1150	1	EGRESO	1.000	UND	VENTA	VENTA:676	Rey	2026-03-13 23:45:59.557857
1151	5	EGRESO	1.000	ML	VENTA	VENTA:676	Rey	2026-03-13 23:45:59.557857
1152	11	EGRESO	1.000	UND	VENTA	VENTA:678	Rey	2026-03-14 15:57:56.398067
1153	16	EGRESO	15.000	UND	VENTA	VENTA:679	Rey	2026-03-14 16:03:34.241526
1154	16	INGRESO	52.000	UND	ingreso desde bodega	1403	Rey	2026-03-14 16:05:08.673015
1155	16	EGRESO	2.000	UND	VENTA	VENTA:680	Rey	2026-03-14 16:28:41.558625
1156	1	EGRESO	1.000	UND	VENTA	VENTA:681	Rey	2026-03-14 16:37:32.908512
1157	7	EGRESO	1.000	ML	VENTA	VENTA:681	Rey	2026-03-14 16:37:32.908512
1158	16	EGRESO	1.000	UND	VENTA	VENTA:682	Rey	2026-03-14 16:42:16.029433
1159	1	EGRESO	1.000	UND	VENTA	VENTA:683	Rey	2026-03-14 17:19:50.965679
1160	7	EGRESO	1.000	ML	VENTA	VENTA:683	Rey	2026-03-14 17:19:50.965679
1161	8	EGRESO	1.000	ML	VENTA	VENTA:683	Rey	2026-03-14 17:19:50.965679
1162	2	EGRESO	1.000	UND	VENTA	VENTA:684	Rey	2026-03-14 17:20:23.548868
1163	1	EGRESO	1.000	UND	VENTA	VENTA:684	Rey	2026-03-14 17:20:23.548868
1164	5	EGRESO	1.000	ML	VENTA	VENTA:684	Rey	2026-03-14 17:20:23.548868
1165	4	EGRESO	29.570	ML	VENTA	VENTA:684	Rey	2026-03-14 17:20:23.548868
1166	11	EGRESO	1.000	UND	VENTA	VENTA:685	Rey	2026-03-14 17:56:03.410359
1167	16	EGRESO	35.000	UND	VENTA	VENTA:686	Rey	2026-03-14 17:56:34.813859
1168	16	EGRESO	3.000	UND	VENTA	VENTA:687	Rey	2026-03-14 17:56:42.543406
1169	16	EGRESO	5.000	UND	EGRESO POR REPOSICON	señora que se dañaron 35 aguas	Rey	2026-03-14 17:59:43.790184
1170	9	EGRESO	1.000	UND	VENTA	VENTA:688	Rey	2026-03-14 18:21:28.613423
1171	16	EGRESO	2.000	UND	VENTA	VENTA:689	Rey	2026-03-14 18:42:04.141658
1172	1	INGRESO	3.000	UND	bodega	1403	Rey	2026-03-14 19:39:31.125236
1173	1	EGRESO	2.000	UND	VENTA	VENTA:691	Rey	2026-03-14 19:39:46.183392
1174	3	EGRESO	1.000	UND	VENTA	VENTA:691	Rey	2026-03-14 19:39:46.183392
1175	5	EGRESO	2.000	ML	VENTA	VENTA:691	Rey	2026-03-14 19:39:46.183392
1176	4	EGRESO	59.140	ML	VENTA	VENTA:691	Rey	2026-03-14 19:39:46.183392
1177	16	EGRESO	1.000	UND	VENTA	VENTA:692	Rey	2026-03-14 19:39:58.207413
1178	9	EGRESO	1.000	UND	VENTA	VENTA:693	Rey	2026-03-14 19:40:15.326941
1179	16	EGRESO	1.000	UND	VENTA	VENTA:693	Rey	2026-03-14 19:40:15.326941
1180	16	EGRESO	1.000	UND	VENTA	VENTA:694	Rey	2026-03-14 19:40:25.721169
1181	16	EGRESO	1.000	UND	VENTA	VENTA:695	Rey	2026-03-14 19:59:53.856719
1182	11	EGRESO	1.000	UND	VENTA	VENTA:696	Rey	2026-03-14 20:04:00.267623
1183	1	INGRESO	1.000	UND	venta	1403	Rey	2026-03-14 20:09:19.27835
1184	1	EGRESO	2.000	UND	VENTA	VENTA:697	Rey	2026-03-14 20:14:19.237699
1185	7	EGRESO	2.000	ML	VENTA	VENTA:697	Rey	2026-03-14 20:14:19.237699
1188	1	INGRESO	1.000	UND	ingreso desde bodehga	1403	Rey	2026-03-14 20:25:02.237998
1189	2	EGRESO	1.000	UND	VENTA	VENTA:700	Rey	2026-03-14 20:25:09.605967
1190	1	EGRESO	1.000	UND	VENTA	VENTA:700	Rey	2026-03-14 20:25:09.605967
1191	5	EGRESO	1.000	ML	VENTA	VENTA:700	Rey	2026-03-14 20:25:09.605967
1192	4	EGRESO	29.570	ML	VENTA	VENTA:700	Rey	2026-03-14 20:25:09.605967
1193	1	INGRESO	1.000	UND	venta	1403	Rey	2026-03-14 20:35:31.890757
1194	1	INGRESO	1.000	UND	venta	1403	Rey	2026-03-14 20:45:35.967244
1195	9	EGRESO	1.000	UND	VENTA	VENTA:701	Rey	2026-03-14 20:56:51.780339
1196	16	EGRESO	3.000	UND	VENTA	VENTA:702	Rey	2026-03-14 21:01:18.019209
1197	1	EGRESO	2.000	UND	VENTA	VENTA:706	Rey	2026-03-14 21:07:04.358653
1198	5	EGRESO	2.000	ML	VENTA	VENTA:706	Rey	2026-03-14 21:07:04.358653
1199	2	EGRESO	1.000	UND	VENTA	VENTA:706	Rey	2026-03-14 21:07:04.358653
1200	4	EGRESO	29.570	ML	VENTA	VENTA:706	Rey	2026-03-14 21:07:04.358653
1201	1	INGRESO	3.000	UND	venta	1403	Rey	2026-03-14 21:08:47.579705
1202	1	EGRESO	1.000	UND	VENTA	VENTA:707	Rey	2026-03-14 21:08:57.783352
1203	5	EGRESO	1.000	ML	VENTA	VENTA:707	Rey	2026-03-14 21:08:57.783352
1204	16	EGRESO	1.000	UND	VENTA	VENTA:708	Rey	2026-03-14 21:55:42.305538
1205	1	INGRESO	2.000	UND	venta	1403	Rey	2026-03-14 22:04:51.873225
1206	1	EGRESO	2.000	UND	VENTA	VENTA:710	Rey	2026-03-14 22:12:12.667505
1207	5	EGRESO	2.000	ML	VENTA	VENTA:710	Rey	2026-03-14 22:12:12.667505
1208	4	EGRESO	59.140	ML	VENTA	VENTA:710	Rey	2026-03-14 22:12:12.667505
1209	2	EGRESO	1.000	UND	VENTA	VENTA:710	Rey	2026-03-14 22:12:12.667505
1210	1	EGRESO	2.000	UND	VENTA	VENTA:711	Rey	2026-03-14 22:13:01.975064
1211	5	EGRESO	2.000	ML	VENTA	VENTA:711	Rey	2026-03-14 22:13:01.975064
1212	1	INGRESO	2.000	UND	venta	1403	Rey	2026-03-14 22:14:55.409584
1213	2	EGRESO	1.000	UND	VENTA	VENTA:712	Rey	2026-03-14 22:22:32.302254
1214	1	EGRESO	1.000	UND	VENTA	VENTA:712	Rey	2026-03-14 22:22:32.302254
1215	5	EGRESO	1.000	ML	VENTA	VENTA:712	Rey	2026-03-14 22:22:32.302254
1216	4	EGRESO	29.570	ML	VENTA	VENTA:712	Rey	2026-03-14 22:22:32.302254
1217	9	EGRESO	1.000	UND	VENTA	VENTA:712	Rey	2026-03-14 22:22:32.302254
1218	1	INGRESO	1.000	UND	venta	1403	Rey	2026-03-14 22:22:49.121427
1219	11	EGRESO	1.000	UND	VENTA	VENTA:713	Rey	2026-03-14 22:24:11.819228
1220	16	EGRESO	1.000	UND	VENTA	VENTA:714	Rey	2026-03-14 22:24:24.380637
1221	9	EGRESO	2.000	UND	VENTA	VENTA:715	Rey	2026-03-14 22:30:56.496515
1222	11	INGRESO	18.000	UND	bodega	1403	Rey	2026-03-14 22:33:38.53825
1223	16	EGRESO	2.000	UND	VENTA	VENTA:716	Rey	2026-03-14 22:36:03.216893
1224	1	INGRESO	1.000	UND	venta	1403	Rey	2026-03-14 22:45:53.495769
1225	1	EGRESO	1.000	UND	VENTA	VENTA:717	Rey	2026-03-14 22:51:10.454035
1226	7	EGRESO	1.000	ML	VENTA	VENTA:717	Rey	2026-03-14 22:51:10.454035
1227	11	EGRESO	1.000	UND	VENTA	VENTA:717	Rey	2026-03-14 22:51:10.454035
1228	1	INGRESO	20.000	UND	ingreso bodega	140	Rey	2026-03-14 22:51:31.870944
1229	11	EGRESO	1.000	UND	VENTA	VENTA:718	Rey	2026-03-14 22:53:51.139091
1230	1	EGRESO	4.000	UND	VENTA	VENTA:719	Rey	2026-03-14 22:59:18.265774
1231	7	EGRESO	4.000	ML	VENTA	VENTA:719	Rey	2026-03-14 22:59:18.265774
1232	1	INGRESO	1.000	UND	venta	1403	Rey	2026-03-14 23:09:53.898017
1233	1	EGRESO	1.000	UND	VENTA	VENTA:720	Rey	2026-03-14 23:10:06.922359
1234	5	EGRESO	1.000	ML	VENTA	VENTA:720	Rey	2026-03-14 23:10:06.922359
1235	11	EGRESO	2.000	UND	VENTA	VENTA:721	Rey	2026-03-14 23:10:18.468453
1236	11	EGRESO	1.000	UND	VENTA	VENTA:722	Rey	2026-03-14 23:35:44.006504
1237	1	EGRESO	2.000	UND	VENTA	VENTA:723	Rey	2026-03-14 23:40:35.395679
1238	7	EGRESO	1.000	ML	VENTA	VENTA:723	Rey	2026-03-14 23:40:35.395679
1239	16	EGRESO	1.000	UND	VENTA	VENTA:723	Rey	2026-03-14 23:40:35.395679
1240	2	EGRESO	1.000	UND	VENTA	VENTA:723	Rey	2026-03-14 23:40:35.395679
1241	5	EGRESO	1.000	ML	VENTA	VENTA:723	Rey	2026-03-14 23:40:35.395679
1242	4	EGRESO	29.570	ML	VENTA	VENTA:723	Rey	2026-03-14 23:40:35.395679
1243	9	EGRESO	3.000	UND	VENTA	VENTA:724	Rey	2026-03-14 23:41:57.857114
1244	16	EGRESO	1.000	UND	VENTA	VENTA:724	Rey	2026-03-14 23:41:57.857114
1245	9	EGRESO	1.000	UND	ALEX TOMO	1403	Rey	2026-03-14 23:45:55.232491
1247	11	EGRESO	1.000	UND	VENTA	VENTA:729	Rey	2026-03-14 23:58:27.382445
1248	11	EGRESO	2.000	UND	VENTA	VENTA:730	Rey	2026-03-15 00:12:04.669857
1249	1	EGRESO	1.000	UND	VENTA	VENTA:731	Rey	2026-03-15 00:12:11.663878
1250	7	EGRESO	1.000	ML	VENTA	VENTA:731	Rey	2026-03-15 00:12:11.663878
1251	11	EGRESO	3.000	UND	VENTA	VENTA:732	Alex	2026-03-15 15:48:08.270955
1252	1	EGRESO	1.000	UND	VENTA	VENTA:734	Alex	2026-03-15 16:32:09.722416
1253	7	EGRESO	1.000	ML	VENTA	VENTA:734	Alex	2026-03-15 16:32:09.722416
1254	3	EGRESO	1.000	UND	VENTA	VENTA:735	Alex	2026-03-15 16:52:11.002345
1255	1	EGRESO	2.000	UND	VENTA	VENTA:735	Alex	2026-03-15 16:52:11.002345
1256	5	EGRESO	2.000	ML	VENTA	VENTA:735	Alex	2026-03-15 16:52:11.002345
1257	4	EGRESO	59.140	ML	VENTA	VENTA:735	Alex	2026-03-15 16:52:11.002345
1258	2	EGRESO	1.000	UND	VENTA	VENTA:735	Alex	2026-03-15 16:52:11.002345
1259	11	EGRESO	1.000	UND	VENTA	VENTA:736	Alex	2026-03-15 17:20:46.680354
1260	11	EGRESO	2.000	UND	VENTA	VENTA:737	Alex	2026-03-15 17:21:01.666985
1261	8	EGRESO	162.635	ML	VENTA	VENTA:737	Alex	2026-03-15 17:21:01.666985
1262	16	INGRESO	19.000	UND	\N	\N	Alex	2026-03-15 17:30:19.05887
1263	16	EGRESO	2.000	UND	VENTA	VENTA:738	Alex	2026-03-15 17:30:43.03255
1264	1	EGRESO	1.000	UND	VENTA	VENTA:738	Alex	2026-03-15 17:30:43.03255
1265	7	EGRESO	1.000	ML	VENTA	VENTA:738	Alex	2026-03-15 17:30:43.03255
1266	1	EGRESO	1.000	UND	VENTA	VENTA:739	Alex	2026-03-15 17:45:48.847224
1267	7	EGRESO	1.000	ML	VENTA	VENTA:739	Alex	2026-03-15 17:45:48.847224
1268	16	EGRESO	1.000	UND	VENTA	VENTA:740	Alex	2026-03-15 17:54:43.430605
1269	16	EGRESO	2.000	UND	VENTA	VENTA:741	Alex	2026-03-15 18:07:23.910171
1270	16	EGRESO	1.000	UND	VENTA	VENTA:742	Alex	2026-03-15 18:08:53.606171
1271	1	EGRESO	1.000	UND	VENTA	VENTA:743	Alex	2026-03-15 18:34:39.900709
1272	2	EGRESO	1.000	UND	VENTA	VENTA:743	Alex	2026-03-15 18:34:39.900709
1273	5	EGRESO	1.000	ML	VENTA	VENTA:743	Alex	2026-03-15 18:34:39.900709
1274	4	EGRESO	29.570	ML	VENTA	VENTA:743	Alex	2026-03-15 18:34:39.900709
1275	1	EGRESO	2.000	UND	VENTA	VENTA:744	Alex	2026-03-15 19:02:00.229805
1276	3	EGRESO	2.000	UND	VENTA	VENTA:744	Alex	2026-03-15 19:02:00.229805
1277	5	EGRESO	2.000	ML	VENTA	VENTA:744	Alex	2026-03-15 19:02:00.229805
1278	4	EGRESO	59.140	ML	VENTA	VENTA:744	Alex	2026-03-15 19:02:00.229805
1279	2	EGRESO	1.000	UND	VENTA	VENTA:745	Alex	2026-03-15 19:11:45.094066
1280	1	EGRESO	1.000	UND	VENTA	VENTA:745	Alex	2026-03-15 19:11:45.094066
1281	5	EGRESO	1.000	ML	VENTA	VENTA:745	Alex	2026-03-15 19:11:45.094066
1282	4	EGRESO	29.570	ML	VENTA	VENTA:745	Alex	2026-03-15 19:11:45.094066
1283	3	EGRESO	1.000	UND	VENTA	VENTA:748	Alex	2026-03-15 20:12:01.935965
1284	1	EGRESO	2.000	UND	VENTA	VENTA:748	Alex	2026-03-15 20:12:01.935965
1285	5	EGRESO	2.000	ML	VENTA	VENTA:748	Alex	2026-03-15 20:12:01.935965
1286	4	EGRESO	59.140	ML	VENTA	VENTA:748	Alex	2026-03-15 20:12:01.935965
1287	2	EGRESO	1.000	UND	VENTA	VENTA:748	Alex	2026-03-15 20:12:01.935965
1288	11	EGRESO	1.000	UND	VENTA	VENTA:733	Alex	2026-03-15 20:22:33.133154
1289	8	EGRESO	162.635	ML	VENTA	VENTA:733	Alex	2026-03-15 20:22:33.133154
1290	16	EGRESO	1.000	UND	VENTA	VENTA:752	Alex	2026-03-15 20:23:25.781035
1291	11	EGRESO	2.000	UND	VENTA	VENTA:753	Alex	2026-03-15 20:23:36.145795
1292	8	EGRESO	325.270	ML	VENTA	VENTA:753	Alex	2026-03-15 20:23:36.145795
1293	3	EGRESO	2.000	UND	VENTA	VENTA:754	Alex	2026-03-15 20:23:51.588244
1294	1	EGRESO	2.000	UND	VENTA	VENTA:754	Alex	2026-03-15 20:23:51.588244
1295	5	EGRESO	2.000	ML	VENTA	VENTA:754	Alex	2026-03-15 20:23:51.588244
1296	4	EGRESO	59.140	ML	VENTA	VENTA:754	Alex	2026-03-15 20:23:51.588244
1297	16	EGRESO	2.000	UND	VENTA	VENTA:755	Alex	2026-03-15 20:29:55.426779
1298	16	EGRESO	1.000	UND	VENTA	VENTA:757	Alex	2026-03-15 20:55:26.183062
1299	16	EGRESO	1.000	UND	VENTA	VENTA:758	Alex	2026-03-15 21:01:06.527894
1300	9	EGRESO	2.000	UND	VENTA	VENTA:759	Alex	2026-03-15 21:02:58.226075
1301	16	EGRESO	1.000	UND	VENTA	VENTA:760	Alex	2026-03-15 21:27:29.105782
1302	11	EGRESO	2.000	UND	VENTA	VENTA:761	Alex	2026-03-15 21:30:55.850088
1303	11	EGRESO	1.000	UND	VENTA	VENTA:762	Alex	2026-03-15 21:38:14.351895
1304	9	EGRESO	1.000	UND	VENTA	VENTA:763	Alex	2026-03-15 21:45:28.854445
1305	8	EGRESO	118.280	ML	VENTA	VENTA:763	Alex	2026-03-15 21:45:28.854445
1306	11	EGRESO	1.000	UND	VENTA	VENTA:764	Alex	2026-03-15 21:55:33.367158
1307	11	EGRESO	1.000	UND	VENTA	VENTA:767	Alex	2026-03-16 18:00:16.794562
1308	17	EGRESO	3.000	UND	VENTA	VENTA:767	Alex	2026-03-16 18:00:16.794562
1309	11	EGRESO	5.000	UND	VENTA	VENTA:768	Alex	2026-03-16 18:01:19.0261
1310	16	EGRESO	2.000	UND	VENTA	VENTA:769	Alex	2026-03-16 18:02:30.067795
1311	11	INGRESO	24.000	UND	ingreso desdebodega	1603 (reset de insumos)	Alex	2026-03-16 18:04:25.072509
1312	2	EGRESO	1.000	UND	VENTA	VENTA:770	Alex	2026-03-16 18:10:19.289374
1313	1	EGRESO	2.000	UND	VENTA	VENTA:770	Alex	2026-03-16 18:10:19.289374
1314	5	EGRESO	1.000	ML	VENTA	VENTA:770	Alex	2026-03-16 18:10:19.289374
1315	4	EGRESO	29.570	ML	VENTA	VENTA:770	Alex	2026-03-16 18:10:19.289374
1316	7	EGRESO	1.000	ML	VENTA	VENTA:770	Alex	2026-03-16 18:10:19.289374
1317	9	INGRESO	18.000	UND	ingreso desde bodega	1603 (reajuste de inventario)	Alex	2026-03-16 18:22:52.678521
1318	16	INGRESO	57.000	UND	ingreso desde bodega	1603	Alex	2026-03-16 18:24:45.205817
1319	16	EGRESO	2.000	UND	VENTA	VENTA:771	Alex	2026-03-16 18:25:12.565557
1320	11	EGRESO	1.000	UND	VENTA	VENTA:772	Alex	2026-03-16 18:27:56.815423
1321	11	EGRESO	1.000	UND	VENTA	VENTA:773	Alex	2026-03-16 18:48:03.552519
1322	9	EGRESO	1.000	UND	VENTA	VENTA:773	Alex	2026-03-16 18:48:03.552519
1323	11	EGRESO	1.000	UND	VENTA	VENTA:774	Alex	2026-03-16 19:28:47.776192
1324	16	EGRESO	3.000	UND	VENTA	VENTA:775	Alex	2026-03-16 19:34:51.254001
1325	16	EGRESO	30.000	UND	VENTA	VENTA:776	Alex	2026-03-16 19:37:20.863211
1326	2	INGRESO	12.000	UND	ingreso por rey	1603	Alex	2026-03-16 19:44:48.40728
1327	1	EGRESO	1.000	UND	VENTA	VENTA:777	Alex	2026-03-16 20:08:50.564861
1328	2	EGRESO	1.000	UND	VENTA	VENTA:777	Alex	2026-03-16 20:08:50.564861
1329	5	EGRESO	1.000	ML	VENTA	VENTA:777	Alex	2026-03-16 20:08:50.564861
1330	4	EGRESO	29.570	ML	VENTA	VENTA:777	Alex	2026-03-16 20:08:50.564861
1331	1	INGRESO	3.000	UND	ingreso por venta	1603	Alex	2026-03-16 20:19:05.038102
1332	1	EGRESO	3.000	UND	VENTA	VENTA:780	Alex	2026-03-16 20:19:09.760164
1333	5	EGRESO	3.000	ML	VENTA	VENTA:780	Alex	2026-03-16 20:19:09.760164
1334	11	EGRESO	1.000	UND	VENTA	VENTA:781	Alex	2026-03-16 20:44:47.516487
1335	1	INGRESO	2.000	UND	venta	1603	Alex	2026-03-16 21:03:28.996742
1336	1	EGRESO	2.000	UND	VENTA	VENTA:782	Alex	2026-03-16 21:03:40.372366
1337	5	EGRESO	2.000	ML	VENTA	VENTA:782	Alex	2026-03-16 21:03:40.372366
1338	4	EGRESO	59.140	ML	VENTA	VENTA:782	Alex	2026-03-16 21:03:40.372366
1339	3	EGRESO	1.000	UND	VENTA	VENTA:782	Alex	2026-03-16 21:03:40.372366
1340	16	EGRESO	2.000	UND	VENTA	VENTA:783	Alex	2026-03-16 21:05:10.973339
1341	9	EGRESO	2.000	UND	VENTA	VENTA:784	Alex	2026-03-16 21:11:41.0671
1342	16	EGRESO	2.000	UND	VENTA	VENTA:785	Alex	2026-03-16 21:14:21.237845
1343	9	EGRESO	1.000	UND	VENTA	VENTA:786	Alex	2026-03-16 21:14:29.929612
1344	16	EGRESO	2.000	UND	VENTA	VENTA:787	Alex	2026-03-16 21:17:38.113297
1345	16	EGRESO	15.000	UND	VENTA	VENTA:788	Alex	2026-03-16 21:19:03.762657
1346	1	INGRESO	1.000	UND	venta	1603	Alex	2026-03-16 21:29:31.52551
1347	1	EGRESO	1.000	UND	VENTA	VENTA:789	Alex	2026-03-16 21:29:46.96218
1348	7	EGRESO	1.000	ML	VENTA	VENTA:789	Alex	2026-03-16 21:29:46.96218
1349	1	INGRESO	1.000	UND	venta	1603	Alex	2026-03-16 21:37:35.445271
1350	2	EGRESO	1.000	UND	VENTA	VENTA:790	Alex	2026-03-16 21:37:54.787737
1351	1	EGRESO	1.000	UND	VENTA	VENTA:790	Alex	2026-03-16 21:37:54.787737
1352	5	EGRESO	1.000	ML	VENTA	VENTA:790	Alex	2026-03-16 21:37:54.787737
1353	4	EGRESO	29.570	ML	VENTA	VENTA:790	Alex	2026-03-16 21:37:54.787737
1354	1	INGRESO	10.000	UND	ingreso desde -bodega	1603	Alex	2026-03-16 21:57:13.900164
1355	16	EGRESO	1.000	UND	VENTA	VENTA:791	Alex	2026-03-16 21:58:57.117944
\.


--
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.productos (id, nombre, precio, id_categoria, es_preparado, image_url, stock_actual, unidad_medida, stock_minimo) FROM stdin;
21	WhiskyCoco	6.00	\N	t	/uploads/1772153958722-630179910.png	0.000	UND	0.000
2	Aranda-Coco	2.50	1	t	/uploads/1770091502229-810802818.jpeg	0.000	UND	0.000
4	Coco-Coffe	2.50	1	t	/uploads/1770091539173-351007575.jpeg	0.000	UND	0.000
5	Jugo de Coco	2.50	1	t	/uploads/1770091554071-9703308.jpeg	0.000	UND	0.000
6	Limonada de Coco	2.50	1	t	/uploads/1770091614274-113135252.jpeg	0.000	UND	0.000
26	Hielo	1.00	\N	t	\N	3.000	UND	0.000
23	Vaso con Pulpa	1.75	2	t	/uploads/1772144018286-603382465.jpeg	3.000	UND	0.000
24	Sprite	0.65	2	f	/uploads/1772155376162-699313250.jpeg	8.000	UND	0.000
13	Porción Pan de Yuca (Unitario)	0.50	4	t	\N	0.000	UND	0.000
1	Piña-Coco	2.50	1	t	/uploads/1770091190187-729842799.jpeg	0.000	UND	0.000
3	Coco & Caña	2.50	1	t	/uploads/1770091527798-395873077.jpeg	0.000	UND	0.000
10	Paleta Coco	0.75	3	t	/uploads/1770091625649-935062879.jpeg	31.000	UND	0.000
15	Coco Relleno	3.50	3	t	/uploads/1770091958846-900674604.jpeg	0.000	UND	0.000
16	Jugo de Caña	1.00	2	f	/uploads/1772074012217-453295926.jpeg	18.000	UND	5.000
18	Caña Manabita	1.50	\N	f	/uploads/1772153991048-60347243.jpeg	7430.865	ML	5.000
17	Pipa de Coco (Entera)	1.75	2	f	/uploads/1771869920122-501966668.jpeg	20.000	UND	5.000
20	Agua sin gas	0.75	\N	f	/uploads/1772074039133-796578609.jpeg	0.000	UND	0.000
19	Agua de Coco	1.50	\N	f	/uploads/1772154137183-309473636.jpeg	0.000	UND	0.000
9	Paleta Frutos Rojos	0.75	3	t	/uploads/1770091634345-225726818.jpeg	51.000	UND	0.000
12	Combo Dúo (8 Panes)	8.00	4	t	\N	0.000	UND	0.000
11	Combo Personal (5 Panes)	5.00	4	t	\N	0.000	UND	0.000
8	Guarapo	3.50	2	t	/uploads/1772074074837-724919799.jpeg	0.000	UND	0.000
7	Coco Loco	5.00	2	t	/uploads/1772154002579-269043330.png	0.000	UND	0.000
25	Helado + Topping	3.50	\N	f	\N	1.000	UND	0.000
22	Ron	2.50	\N	f	/uploads/1772153980717-263725156.jpeg	439.853	ML	0.000
28	Mojito	4.00	\N	t	\N	1.000	UND	0.000
27	Paloma	5.00	2	t	/uploads/1772770582626-841215985.jpg	0.000	UND	1.000
\.


--
-- Data for Name: recetas; Type: TABLE DATA; Schema: public; Owner: -
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
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.usuarios (id, nombre, pin_acceso, rol, activo) FROM stdin;
1	Admin	0000	ADMIN	t
2	Rey	3333	ADMIN	t
3	Alex	2222	ADMIN	t
\.


--
-- Data for Name: ventas; Type: TABLE DATA; Schema: public; Owner: -
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
375	2026-03-06 16:28:32.062504	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
377	2026-03-06 16:30:22.813188	\N	Consumidor Final	40.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	40.00	0.00	0.00	\N	t	\N	\N
378	2026-03-06 16:31:51.962446	\N	Consumidor Final	20.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 20797778	Rey	20.00	0.00	0.00	\N	t	\N	\N
379	2026-03-06 16:38:29.719492	\N	Consumidor Final	16.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	POR PAGAR | Banco: Banco Pichincha | Comprobante: idk	Rey	16.50	0.00	0.00	\N	t	\N	\N
380	2026-03-06 17:55:19.498284	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
381	2026-03-06 17:55:37.436856	\N	Consumidor Final	3.75	CREDITO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.75	0.00	0.00	2	f	\N	\N
382	2026-03-06 18:00:46.934243	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
383	2026-03-06 18:10:39.838615	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
384	2026-03-06 18:26:03.636636	\N	Consumidor Final	4.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 59860225	Rey	4.00	0.00	0.00	\N	t	\N	\N
385	2026-03-06 18:33:54.359345	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
386	2026-03-06 18:36:22.969995	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
387	2026-03-06 19:01:50.825645	\N	Consumidor Final	7.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	7.00	0.00	0.00	\N	t	\N	\N
388	2026-03-06 20:15:16.484686	\N	Consumidor Final	2.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 65189284	Rey	2.50	0.00	0.00	\N	t	\N	\N
389	2026-03-06 20:15:47.556474	\N	Consumidor Final	1.75	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 65378235	Rey	1.75	0.00	0.00	\N	t	\N	\N
390	2026-03-06 20:16:07.617138	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
391	2026-03-06 20:38:20.971623	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
392	2026-03-06 20:57:47.819751	\N	Consumidor Final	5.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco del Pacífico | Comprobante: 19122026030620506750	Rey	5.00	0.00	0.00	\N	t	\N	\N
393	2026-03-06 20:58:08.170311	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
395	2026-03-06 20:58:44.491236	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
394	2026-03-06 20:58:14.806008	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
396	2026-03-06 21:02:05.252475	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
397	2026-03-06 21:28:36.602791	\N	Consumidor Final	7.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	7.00	0.00	0.00	\N	t	\N	\N
398	2026-03-06 21:28:50.762704	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
399	2026-03-06 21:28:58.087793	\N	Consumidor Final	2.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.00	0.00	0.00	\N	t	\N	\N
400	2026-03-06 21:36:13.086324	\N	Consumidor Final	1.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.00	0.00	0.00	\N	t	\N	\N
401	2026-03-06 21:38:28.777772	\N	Consumidor Final	1.50	CREDITO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	8	f	\N	\N
402	2026-03-06 21:38:43.602184	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
403	2026-03-06 21:40:31.265142	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
404	2026-03-06 21:51:45.244759	\N	Consumidor Final	6.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	6.75	0.00	0.00	\N	t	\N	\N
405	2026-03-06 21:56:26.272245	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
406	2026-03-06 22:41:44.074634	\N	Consumidor Final	6.75	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 2204100099	Rey	6.75	0.00	0.00	\N	t	\N	\N
407	2026-03-06 22:42:45.111849	\N	Consumidor Final	4.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.50	0.00	0.00	\N	t	\N	\N
408	2026-03-06 22:42:53.83003	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
409	2026-03-06 22:48:40.190336	\N	Consumidor Final	7.00	DIVIDIDO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	7.00	0.00	0.00	\N	t	\N	\N
410	2026-03-06 22:55:03.288549	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
411	2026-03-06 22:56:37.967376	\N	Consumidor Final	4.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.25	0.00	0.00	\N	t	\N	\N
340	2026-03-06 23:26:49.636839	\N	Consumidor Final	11.75	DIVIDIDO	MESA	LOCAL	1	PAGADA	\N	Rey	11.75	0.00	0.00	\N	t	\N	\N
412	2026-03-06 23:29:12.404863	\N	Consumidor Final	5.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Bolivariano | Comprobante: 56132677	Rey	5.00	0.00	0.00	\N	t	\N	\N
415	2026-03-06 23:30:24.584723	\N	Consumidor Final	3.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 900605752------	Rey	3.50	0.00	0.00	\N	t	\N	\N
416	2026-03-06 23:31:03.683377	\N	Consumidor Final	2.25	DE_UNA	DIRECTA	LOCAL	\N	PAGADA	900477923	Rey	2.25	0.00	0.00	\N	t	\N	\N
417	2026-03-06 23:33:03.117888	\N	Consumidor Final	9.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 73905984	Rey	9.00	0.00	0.00	\N	t	\N	\N
418	2026-03-06 23:56:29.053967	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
419	2026-03-06 23:56:49.094209	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
420	2026-03-07 00:09:05.50142	\N	Consumidor Final	5.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 2205962068	Rey	5.00	0.00	0.00	\N	t	\N	\N
421	2026-03-07 00:09:34.423653	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
422	2026-03-07 00:27:18.471386	\N	Consumidor Final	7.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	7.00	0.00	0.00	\N	t	\N	\N
423	2026-03-07 16:04:57.949596	\N	Consumidor Final	8.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	8.25	0.00	0.00	\N	t	\N	\N
424	2026-03-07 16:07:39.114647	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
425	2026-03-07 16:09:03.491664	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
426	2026-03-07 16:09:33.975424	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
427	2026-03-07 16:25:10.403506	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
428	2026-03-07 16:25:21.479217	\N	Consumidor Final	1.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.00	0.00	0.00	\N	t	\N	\N
429	2026-03-07 16:33:55.072927	\N	Consumidor Final	3.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.75	0.00	0.00	\N	t	\N	\N
430	2026-03-07 17:21:52.913227	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
431	2026-03-07 17:50:06.52413	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
432	2026-03-07 19:33:02.985389	\N	Consumidor Final	3.50	CREDITO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	7	f	\N	\N
433	2026-03-07 19:58:47.570847	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
434	2026-03-07 19:58:59.797054	\N	Consumidor Final	2.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.25	0.00	0.00	\N	t	\N	\N
435	2026-03-07 19:59:08.220432	\N	Consumidor Final	1.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.00	0.00	0.00	\N	t	\N	\N
436	2026-03-07 20:11:33.320428	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
437	2026-03-07 20:11:45.056468	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
438	2026-03-07 20:25:31.534955	\N	Consumidor Final	8.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	8.75	0.00	0.00	\N	t	\N	\N
439	2026-03-07 20:51:40.42394	\N	Consumidor Final	5.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 51059789	Rey	5.50	0.00	0.00	\N	t	\N	\N
440	2026-03-07 20:51:54.396745	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
441	2026-03-07 21:44:10.375486	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
443	2026-03-07 21:45:05.800393	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
444	2026-03-07 21:45:15.463633	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
445	2026-03-07 21:45:44.65841	\N	Consumidor Final	2.25	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 52986227	Rey	2.25	0.00	0.00	\N	t	\N	\N
446	2026-03-07 21:46:28.813719	\N	Consumidor Final	6.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	6.00	0.00	0.00	\N	t	\N	\N
447	2026-03-07 21:58:34.585351	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
448	2026-03-07 22:32:05.727358	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
449	2026-03-07 22:32:33.390299	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
450	2026-03-07 22:32:42.405757	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
451	2026-03-07 22:33:46.849014	\N	Consumidor Final	2.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.00	0.00	0.00	\N	t	\N	\N
452	2026-03-07 22:37:40.642177	\N	Consumidor Final	4.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.25	0.00	0.00	\N	t	\N	\N
453	2026-03-07 22:38:24.743542	\N	Consumidor Final	3.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 54386265	Rey	3.00	0.00	0.00	\N	t	\N	\N
454	2026-03-07 22:40:04.607683	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
455	2026-03-07 22:55:29.973852	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
476	2026-03-07 23:46:03.859788	\N	Consumidor Final	6.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	6.00	0.00	0.00	\N	t	\N	\N
477	2026-03-07 23:46:32.669666	\N	Consumidor Final	20.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 55790300	Rey	20.00	0.00	0.00	\N	t	\N	\N
478	2026-03-07 23:47:53.96466	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
479	2026-03-07 23:48:02.354463	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
480	2026-03-07 23:48:22.053323	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
483	2026-03-08 00:04:47.375678	\N	Consumidor Final	7.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	7.00	0.00	0.00	\N	t	\N	\N
481	2026-03-07 23:55:52.596503	\N	Consumidor Final	0.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.00	0.00	0.00	\N	t	\N	\N
482	2026-03-07 23:57:36.107376	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
484	2026-03-08 18:55:20.643479	\N	Consumidor Final	9.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	9.00	0.00	0.00	\N	t	\N	\N
485	2026-03-08 18:56:05.68496	\N	Consumidor Final	12.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	12.25	0.00	0.00	\N	t	\N	\N
486	2026-03-08 18:58:54.108748	\N	Consumidor Final	6.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	6.00	0.00	0.00	\N	t	\N	\N
487	2026-03-08 19:01:39.965804	\N	Consumidor Final	2.50	TARJETA_CREDITO	DIRECTA	LOCAL	\N	PAGADA	carlitos	Alex	2.50	0.00	0.00	\N	t	\N	\N
488	2026-03-08 19:03:29.000871	\N	Consumidor Final	3.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	2213209451 | Banco: Banco Pichincha | Comprobante: 2213209451	Alex	3.50	0.00	0.00	\N	t	\N	\N
489	2026-03-08 19:07:58.760062	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	1.50	0.00	0.00	\N	t	\N	\N
490	2026-03-08 19:08:19.780649	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	5.00	0.00	0.00	\N	t	\N	\N
491	2026-03-08 19:08:42.644843	\N	Consumidor Final	2.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	2.00	0.00	0.00	\N	t	\N	\N
492	2026-03-08 19:09:06.572028	\N	Consumidor Final	7.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	7.50	0.00	0.00	\N	t	\N	\N
494	2026-03-08 19:36:52.336145	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	0.75	0.00	0.00	\N	t	\N	\N
493	2026-03-08 19:42:29.9848	\N	Consumidor Final	9.25	EFECTIVO	MESA	LOCAL	2	PAGADA	\N	Alex	9.25	0.00	0.00	\N	t	\N	\N
495	2026-03-08 19:48:18.110828	\N	Consumidor Final	1.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 2207039386	Alex	1.50	0.00	0.00	\N	t	\N	\N
498	2026-03-08 19:51:42.706581	\N	Consumidor Final	4.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	4.50	0.00	0.00	\N	t	\N	\N
499	2026-03-08 20:05:23.541369	\N	Consumidor Final	2.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	2.75	0.00	0.00	\N	t	\N	\N
500	2026-03-08 20:11:39.145853	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	1.75	0.00	0.00	\N	t	\N	\N
501	2026-03-08 20:23:01.469319	\N	Consumidor Final	5.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	5.25	0.00	0.00	\N	t	\N	\N
504	2026-03-08 20:31:00.909645	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	1.75	0.00	0.00	\N	t	\N	\N
505	2026-03-08 20:34:22.821459	\N	Consumidor Final	4.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	4.25	0.00	0.00	\N	t	\N	\N
506	2026-03-08 20:42:42.621532	\N	Consumidor Final	4.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	4.00	0.00	0.00	\N	t	\N	\N
507	2026-03-08 20:50:01.508153	\N	Consumidor Final	3.75	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 220-6148567	Alex	3.75	0.00	0.00	\N	t	\N	\N
510	2026-03-08 20:50:48.00209	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	2.50	0.00	0.00	\N	t	\N	\N
511	2026-03-08 21:10:11.882469	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	5.00	0.00	0.00	\N	t	\N	\N
512	2026-03-08 21:26:10.784565	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	1.75	0.00	0.00	\N	t	\N	\N
515	2026-03-09 16:45:13.382841	\N	Consumidor Final	0.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.00	0.00	0.00	\N	t	\N	\N
516	2026-03-09 17:30:52.65707	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
517	2026-03-09 17:31:01.091298	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
518	2026-03-09 17:31:46.477123	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
519	2026-03-09 17:31:57.357329	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
520	2026-03-09 17:34:13.474934	\N	Consumidor Final	35.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	35.00	0.00	0.00	\N	t	\N	\N
521	2026-03-09 17:34:42.464791	\N	Consumidor Final	10.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	10.00	0.00	0.00	\N	t	\N	\N
522	2026-03-09 17:42:41.272325	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
523	2026-03-09 19:31:40.278804	\N	Consumidor Final	4.25	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 166303280	Rey	4.25	0.00	0.00	\N	t	\N	\N
524	2026-03-09 19:32:06.193894	\N	Consumidor Final	6.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	6.00	0.00	0.00	\N	t	\N	\N
525	2026-03-09 19:45:00.439872	\N	Consumidor Final	5.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.25	0.00	0.00	\N	t	\N	\N
526	2026-03-09 20:26:22.070732	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
529	2026-03-09 20:46:58.790316	\N	Consumidor Final	4.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.00	0.00	0.00	\N	t	\N	\N
531	2026-03-09 21:09:43.489401	\N	Consumidor Final	4.75	EFECTIVO	MESA	LOCAL	2	PAGADA	\N	Rey	4.75	0.00	0.00	\N	t	\N	\N
530	2026-03-09 21:34:07.520567	\N	Consumidor Final	4.25	TRANSFERENCIA	MESA	LOCAL	1	PAGADA	Banco: Banco Pichincha | Comprobante: 175208130	Rey	4.25	0.00	0.00	\N	t	\N	\N
532	2026-03-09 21:46:48.02144	\N	Consumidor Final	5.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 174927731	Rey	5.00	0.00	0.00	\N	t	\N	\N
533	2026-03-09 21:47:18.043703	\N	Consumidor Final	5.25	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 173958795	Rey	5.25	0.00	0.00	\N	t	\N	\N
534	2026-03-09 21:47:39.704882	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
535	2026-03-09 21:48:08.198057	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
538	2026-03-09 21:48:38.472027	\N	Consumidor Final	6.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	6.50	0.00	0.00	\N	t	\N	\N
539	2026-03-09 22:21:49.857642	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
540	2026-03-09 22:22:04.211964	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
541	2026-03-09 22:22:28.068869	\N	Consumidor Final	1.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 176480997	Rey	1.50	0.00	0.00	\N	t	\N	\N
544	2026-03-09 23:04:49.146641	\N	Consumidor Final	5.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.25	0.00	0.00	\N	t	\N	\N
545	2026-03-09 23:06:40.32117	\N	Consumidor Final	1.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.00	0.00	0.00	\N	t	\N	\N
546	2026-03-09 23:10:48.69006	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
547	2026-03-09 23:27:46.901006	\N	Consumidor Final	8.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	8.75	0.00	0.00	\N	t	\N	\N
551	2026-03-09 23:34:14.808186	\N	Consumidor Final	4.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.00	0.00	0.00	\N	t	\N	\N
548	2026-03-09 23:29:51.386216	\N	Consumidor Final	5.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.25	0.00	0.00	\N	t	\N	\N
552	2026-03-09 23:36:39.877392	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
553	2026-03-10 19:20:20.095318	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
554	2026-03-10 19:20:58.463711	\N	Consumidor Final	6.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	6.00	0.00	0.00	\N	t	\N	\N
555	2026-03-10 19:21:03.761172	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
556	2026-03-10 19:21:39.609173	\N	Consumidor Final	6.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	6.00	0.00	0.00	\N	t	\N	\N
557	2026-03-10 19:21:45.246024	\N	Consumidor Final	1.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.00	0.00	0.00	\N	t	\N	\N
560	2026-03-10 19:45:04.055082	\N	Consumidor Final	3.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Guayaquil | Comprobante: 0013413808	Rey	3.50	0.00	0.00	\N	t	\N	\N
561	2026-03-10 20:16:41.039642	\N	Consumidor Final	11.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	11.50	0.00	0.00	\N	t	\N	\N
562	2026-03-10 20:17:04.323408	\N	Consumidor Final	4.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.50	0.00	0.00	\N	t	\N	\N
563	2026-03-10 20:18:50.522027	\N	Consumidor Final	1.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.00	0.00	0.00	\N	t	\N	\N
564	2026-03-10 20:21:44.462351	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
565	2026-03-10 20:29:52.79531	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
566	2026-03-10 20:32:04.055952	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
567	2026-03-10 21:07:44.86597	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
568	2026-03-10 21:11:19.745489	\N	Consumidor Final	3.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 49820448	Rey	3.50	0.00	0.00	\N	t	\N	\N
569	2026-03-10 21:12:12.440962	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
571	2026-03-10 21:18:56.905021	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
572	2026-03-10 21:20:48.084702	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
573	2026-03-10 22:26:55.430932	\N	Consumidor Final	3.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Guayaquil | Comprobante: 1121	Rey	3.50	0.00	0.00	\N	t	\N	\N
574	2026-03-10 22:27:06.177723	\N	Consumidor Final	3.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
575	2026-03-11 16:33:18.908891	\N	Consumidor Final	1.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 2208640474	Rey	1.50	0.00	0.00	\N	t	\N	\N
576	2026-03-11 17:42:13.296073	\N	Consumidor Final	1.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.00	0.00	0.00	\N	t	\N	\N
577	2026-03-11 18:22:49.783985	\N	Consumidor Final	14.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Guayaquil | Comprobante: 0000873004	Rey	14.00	0.00	0.00	\N	t	\N	\N
578	2026-03-11 19:08:43.559975	\N	Consumidor Final	4.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.25	0.00	0.00	\N	t	\N	\N
579	2026-03-11 19:10:35.923618	\N	Consumidor Final	2.50	CREDITO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	9	f	\N	\N
580	2026-03-11 20:01:19.175148	\N	Consumidor Final	7.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	7.50	0.00	0.00	\N	t	\N	\N
582	2026-03-11 21:16:05.229547	\N	Consumidor Final	10.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	10.00	0.00	0.00	\N	t	\N	\N
585	2026-03-11 21:28:59.692955	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
586	2026-03-11 21:31:41.502967	\N	Consumidor Final	1.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.00	0.00	0.00	\N	t	\N	\N
587	2026-03-11 21:33:47.929303	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
588	2026-03-11 22:14:57.712659	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
589	2026-03-11 22:57:23.256362	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
590	2026-03-11 22:59:36.884356	\N	Consumidor Final	15.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 61303175	Rey	15.00	0.00	0.00	\N	t	\N	\N
570	2026-03-10 21:18:04.78089	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
581	2026-03-11 21:15:51.139774	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
591	2026-03-11 23:08:39.028841	\N	Consumidor Final	3.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 63152732	Rey	3.00	0.00	0.00	\N	t	\N	\N
592	2026-03-11 23:10:29.581465	\N	Consumidor Final	8.00	DIVIDIDO	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha	Rey	8.00	0.00	0.00	\N	t	\N	\N
593	2026-03-11 23:13:15.896239	\N	Consumidor Final	4.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 900578805	Rey	4.00	0.00	0.00	\N	t	\N	\N
594	2026-03-12 15:57:08.895851	\N	Consumidor Final	6.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	6.50	0.00	0.00	\N	t	\N	\N
595	2026-03-12 15:57:35.276663	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
596	2026-03-12 15:58:06.700761	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
597	2026-03-12 15:58:58.177977	\N	Consumidor Final	14.70	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: por pagar	Rey	14.70	0.00	0.00	\N	t	\N	\N
598	2026-03-12 15:59:34.213638	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
599	2026-03-12 16:14:17.425259	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
600	2026-03-12 17:17:35.436667	\N	Consumidor Final	3.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 46000015	Rey	3.50	0.00	0.00	\N	t	\N	\N
601	2026-03-12 17:18:16.74037	\N	Consumidor Final	2.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 43584598	Rey	2.00	0.00	0.00	\N	t	\N	\N
604	2026-03-12 17:19:01.089474	\N	Consumidor Final	4.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.50	0.00	0.00	\N	t	\N	\N
605	2026-03-12 17:19:12.922808	\N	Consumidor Final	8.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	8.25	0.00	0.00	\N	t	\N	\N
606	2026-03-12 17:43:35.65787	\N	Consumidor Final	6.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	6.00	0.00	0.00	\N	t	\N	\N
607	2026-03-12 17:48:07.387539	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
608	2026-03-12 18:24:57.155796	\N	Consumidor Final	3.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.25	0.00	0.00	\N	t	\N	\N
609	2026-03-12 19:03:53.275387	\N	Consumidor Final	2.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.25	0.00	0.00	\N	t	\N	\N
610	2026-03-12 19:06:34.948873	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
611	2026-03-12 19:16:46.895561	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
612	2026-03-12 19:38:43.145662	\N	Consumidor Final	6.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	6.75	0.00	0.00	\N	t	\N	\N
613	2026-03-12 20:13:49.637834	\N	Consumidor Final	20.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: idk	Rey	20.00	0.00	0.00	\N	t	\N	\N
614	2026-03-12 20:49:49.721959	\N	Consumidor Final	7.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 60512251	Rey	7.00	0.00	0.00	\N	t	\N	\N
617	2026-03-12 21:12:57.629044	\N	Consumidor Final	6.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	6.00	0.00	0.00	\N	t	\N	\N
618	2026-03-12 21:55:01.970273	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
619	2026-03-12 21:55:24.714897	\N	Consumidor Final	2.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 61811303	Rey	2.50	0.00	0.00	\N	t	\N	\N
620	2026-03-12 21:56:13.176447	\N	Consumidor Final	16.50	CREDITO	DIRECTA	LOCAL	\N	PAGADA	SEÑOR -QUITEÑO	Rey	16.50	0.00	0.00	2	f	\N	\N
621	2026-03-12 22:02:30.970868	\N	Consumidor Final	3.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.75	0.00	0.00	\N	t	\N	\N
622	2026-03-12 22:08:16.327677	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
623	2026-03-12 22:11:52.435524	\N	Consumidor Final	5.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.25	0.00	0.00	\N	t	\N	\N
624	2026-03-12 22:44:08.960934	\N	Consumidor Final	9.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	9.00	0.00	0.00	\N	t	\N	\N
625	2026-03-12 22:44:15.722113	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
626	2026-03-12 22:44:29.230056	\N	Consumidor Final	2.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.25	0.00	0.00	\N	t	\N	\N
628	2026-03-12 23:03:47.484325	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
627	2026-03-12 23:03:13.836641	\N	Consumidor Final	3.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.75	0.00	0.00	\N	t	\N	\N
629	2026-03-13 15:44:32.664185	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
630	2026-03-13 16:37:07.392995	\N	Consumidor Final	4.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.75	0.00	0.00	\N	t	\N	\N
631	2026-03-13 16:43:00.973857	\N	Consumidor Final	5.25	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 47842590	Rey	5.25	0.00	0.00	\N	t	\N	\N
632	2026-03-13 16:44:02.417972	\N	Consumidor Final	6.75	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Bolivariano | Comprobante: 962875830	Rey	6.75	0.00	0.00	\N	t	\N	\N
633	2026-03-13 16:59:42.38669	\N	Consumidor Final	3.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.25	0.00	0.00	\N	t	\N	\N
634	2026-03-13 17:05:41.913317	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
635	2026-03-13 17:20:46.328564	\N	Consumidor Final	6.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	6.00	0.00	0.00	\N	t	\N	\N
636	2026-03-13 17:34:13.93689	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
637	2026-03-13 17:42:55.722005	\N	Consumidor Final	35.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	35.00	0.00	0.00	\N	t	\N	\N
640	2026-03-13 17:53:55.582036	\N	Consumidor Final	3.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.25	0.00	0.00	\N	t	\N	\N
641	2026-03-13 18:02:10.852674	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
642	2026-03-13 18:07:33.229301	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
643	2026-03-13 18:30:36.058649	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
644	2026-03-13 18:44:25.759229	\N	Consumidor Final	2.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Guayaquil | Comprobante: 0000845397	Rey	2.50	0.00	0.00	\N	t	\N	\N
645	2026-03-13 19:13:39.915056	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
646	2026-03-13 19:13:54.457956	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
647	2026-03-13 19:22:02.371255	\N	Consumidor Final	24.75	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: jbkj	Rey	24.75	0.00	0.00	\N	t	\N	\N
648	2026-03-13 19:31:46.704336	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
649	2026-03-13 19:45:52.507726	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
650	2026-03-13 19:55:01.553463	\N	Consumidor Final	10.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 62344723	Rey	10.00	0.00	0.00	\N	t	\N	\N
651	2026-03-13 20:00:08.553258	\N	Consumidor Final	3.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.25	0.00	0.00	\N	t	\N	\N
652	2026-03-13 20:23:41.206111	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
653	2026-03-13 20:23:50.027972	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
655	2026-03-13 20:56:48.067241	\N	Consumidor Final	2.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 66952601	Rey	2.50	0.00	0.00	\N	t	\N	\N
656	2026-03-13 20:56:56.668372	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
657	2026-03-13 20:57:20.486716	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
654	2026-03-13 20:59:32.732992	\N	Consumidor Final	3.50	EFECTIVO	MESA	LOCAL	2	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
658	2026-03-13 20:59:42.512793	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
659	2026-03-13 21:12:12.788167	\N	Consumidor Final	5.25	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 67839869	Rey	5.25	0.00	0.00	\N	t	\N	\N
661	2026-03-13 21:36:18.415134	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
660	2026-03-13 21:36:58.381135	\N	Consumidor Final	3.75	EFECTIVO	MESA	LOCAL	2	PAGADA	\N	Rey	3.75	0.00	0.00	\N	t	\N	\N
662	2026-03-13 21:39:40.756841	\N	Consumidor Final	2.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.25	0.00	0.00	\N	t	\N	\N
663	2026-03-13 21:43:02.677328	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
664	2026-03-13 21:55:32.786807	\N	Consumidor Final	4.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.00	0.00	0.00	\N	t	\N	\N
665	2026-03-13 22:15:49.259943	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
666	2026-03-13 22:16:18.461317	\N	Consumidor Final	5.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 70077336	Rey	5.00	0.00	0.00	\N	t	\N	\N
667	2026-03-13 22:16:54.385009	\N	Consumidor Final	1.75	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 70036804	Rey	1.75	0.00	0.00	\N	t	\N	\N
732	2026-03-15 15:48:08.270955	\N	Consumidor Final	5.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	5.25	0.00	0.00	\N	t	\N	\N
668	2026-03-13 22:18:13.798788	\N	Consumidor Final	4.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: ES DE -LA -JEPPP---:- JM2026MAR00213201683	Rey	4.00	0.00	0.00	\N	t	\N	\N
669	2026-03-13 22:26:34.884604	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
670	2026-03-13 22:32:36.891442	\N	Consumidor Final	5.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.25	0.00	0.00	\N	t	\N	\N
671	2026-03-13 22:36:52.848629	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
672	2026-03-13 22:38:23.668236	\N	Consumidor Final	2.50	EFECTIVO	MESA	LOCAL	2	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
673	2026-03-13 22:39:35.69363	\N	Consumidor Final	2.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.00	0.00	0.00	\N	t	\N	\N
674	2026-03-13 23:09:28.412349	\N	Consumidor Final	5.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 900842659	Rey	5.00	0.00	0.00	\N	t	\N	\N
675	2026-03-13 23:29:24.45396	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
676	2026-03-13 23:45:59.557857	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
677	2026-03-13 23:49:08.601559	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
678	2026-03-14 15:57:56.398067	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
679	2026-03-14 16:03:34.241526	\N	Consumidor Final	13.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: idk	Rey	13.50	0.00	0.00	\N	t	\N	\N
680	2026-03-14 16:28:41.558625	\N	Consumidor Final	16.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 34639279	Rey	16.50	0.00	0.00	\N	t	\N	\N
681	2026-03-14 16:37:32.908512	\N	Consumidor Final	3.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.25	0.00	0.00	\N	t	\N	\N
682	2026-03-14 16:42:16.029433	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
683	2026-03-14 17:19:50.965679	\N	Consumidor Final	4.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.75	0.00	0.00	\N	t	\N	\N
684	2026-03-14 17:20:23.548868	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
685	2026-03-14 17:56:03.410359	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
686	2026-03-14 17:56:34.813859	\N	Consumidor Final	35.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	35.00	0.00	0.00	\N	t	\N	\N
687	2026-03-14 17:56:42.543406	\N	Consumidor Final	4.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.50	0.00	0.00	\N	t	\N	\N
688	2026-03-14 18:21:28.613423	\N	Consumidor Final	3.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.25	0.00	0.00	\N	t	\N	\N
689	2026-03-14 18:42:04.141658	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
690	2026-03-14 18:52:13.642861	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
691	2026-03-14 19:39:46.183392	\N	Consumidor Final	8.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	8.50	0.00	0.00	\N	t	\N	\N
692	2026-03-14 19:39:58.207413	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
693	2026-03-14 19:40:15.326941	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
694	2026-03-14 19:40:25.721169	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
695	2026-03-14 19:59:53.856719	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
696	2026-03-14 20:04:00.267623	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
697	2026-03-14 20:14:19.237699	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
700	2026-03-14 20:25:09.605967	\N	Consumidor Final	6.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	6.00	0.00	0.00	\N	t	\N	\N
701	2026-03-14 20:56:51.780339	\N	Consumidor Final	5.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.50	0.00	0.00	\N	t	\N	\N
702	2026-03-14 21:01:18.019209	\N	Consumidor Final	4.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.50	0.00	0.00	\N	t	\N	\N
703	2026-03-14 21:03:18.789939	\N	Consumidor Final	4.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.25	0.00	0.00	\N	t	\N	\N
704	2026-03-14 21:06:49.878877	\N	Consumidor Final	3.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.75	0.00	0.00	\N	t	\N	\N
705	2026-03-14 21:06:57.531579	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
706	2026-03-14 21:07:04.358653	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
707	2026-03-14 21:08:57.783352	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
708	2026-03-14 21:55:42.305538	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
709	2026-03-14 21:57:55.826371	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
710	2026-03-14 22:12:12.667505	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
711	2026-03-14 22:13:01.975064	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	5.00	0.00	0.00	\N	t	\N	\N
712	2026-03-14 22:22:32.302254	\N	Consumidor Final	4.25	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 50951750	Rey	4.25	0.00	0.00	\N	t	\N	\N
713	2026-03-14 22:24:11.819228	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
714	2026-03-14 22:24:24.380637	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
715	2026-03-14 22:30:56.496515	\N	Consumidor Final	2.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.00	0.00	0.00	\N	t	\N	\N
716	2026-03-14 22:36:03.216893	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.00	0.00	0.00	\N	t	\N	\N
717	2026-03-14 22:51:10.454035	\N	Consumidor Final	6.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	6.50	0.00	0.00	\N	t	\N	\N
718	2026-03-14 22:53:51.139091	\N	Consumidor Final	3.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.25	0.00	0.00	\N	t	\N	\N
719	2026-03-14 22:59:18.265774	\N	Consumidor Final	10.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 51592810	Rey	10.00	0.00	0.00	\N	t	\N	\N
720	2026-03-14 23:10:06.922359	\N	Consumidor Final	3.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.25	0.00	0.00	\N	t	\N	\N
721	2026-03-14 23:10:18.468453	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	3.50	0.00	0.00	\N	t	\N	\N
722	2026-03-14 23:35:44.006504	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
723	2026-03-14 23:40:35.395679	\N	Consumidor Final	7.25	TRANSFERENCIA	MESA	LOCAL	2	PAGADA	Banco: Banco Pichincha | Comprobante: 52399584	Rey	7.25	0.00	0.00	\N	t	\N	\N
724	2026-03-14 23:41:57.857114	\N	Consumidor Final	4.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.50	0.00	0.00	\N	t	\N	\N
725	2026-03-14 23:47:48.935415	\N	Consumidor Final	0.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.75	0.00	0.00	\N	t	\N	\N
726	2026-03-14 23:50:46.040636	\N	Consumidor Final	2.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.25	0.00	0.00	\N	t	\N	\N
727	2026-03-14 23:54:25.299428	\N	Consumidor Final	0.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	0.00	0.00	0.00	\N	t	\N	\N
728	2026-03-14 23:56:36.143536	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.50	0.00	0.00	\N	t	\N	\N
729	2026-03-14 23:58:27.382445	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	1.75	0.00	0.00	\N	t	\N	\N
730	2026-03-15 00:12:04.669857	\N	Consumidor Final	4.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	4.25	0.00	0.00	\N	t	\N	\N
731	2026-03-15 00:12:11.663878	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Rey	2.50	0.00	0.00	\N	t	\N	\N
734	2026-03-15 16:32:09.722416	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	2.50	0.00	0.00	\N	t	\N	\N
735	2026-03-15 16:52:11.002345	\N	Consumidor Final	5.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 2204969204	Alex	5.00	0.00	0.00	\N	t	\N	\N
736	2026-03-15 17:20:46.680354	\N	Consumidor Final	1.75	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 2212544750	Alex	1.75	0.00	0.00	\N	t	\N	\N
737	2026-03-15 17:21:01.666985	\N	Consumidor Final	6.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	6.75	0.00	0.00	\N	t	\N	\N
738	2026-03-15 17:30:43.03255	\N	Consumidor Final	5.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	5.50	0.00	0.00	\N	t	\N	\N
739	2026-03-15 17:45:48.847224	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	2.50	0.00	0.00	\N	t	\N	\N
740	2026-03-15 17:54:43.430605	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	1.50	0.00	0.00	\N	t	\N	\N
741	2026-03-15 18:07:23.910171	\N	Consumidor Final	8.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	8.25	0.00	0.00	\N	t	\N	\N
742	2026-03-15 18:08:53.606171	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	1.50	0.00	0.00	\N	t	\N	\N
743	2026-03-15 18:34:39.900709	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	2.50	0.00	0.00	\N	t	\N	\N
744	2026-03-15 19:02:00.229805	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	5.00	0.00	0.00	\N	t	\N	\N
745	2026-03-15 19:11:45.094066	\N	Consumidor Final	2.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 2215502424	Alex	2.50	0.00	0.00	\N	t	\N	\N
782	2026-03-16 21:03:40.372366	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	5.00	0.00	0.00	\N	t	\N	\N
783	2026-03-16 21:05:10.973339	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	3.00	0.00	0.00	\N	t	\N	\N
784	2026-03-16 21:11:41.0671	\N	Consumidor Final	2.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 168303279	Alex	2.00	0.00	0.00	\N	t	\N	\N
751	2026-03-15 20:11:52.842409	\N	Consumidor Final	7.25	EFECTIVO	MESA	LOCAL	1	ABIERTA	\N	Alex	7.25	0.00	0.00	\N	t	\N	\N
748	2026-03-15 20:12:01.935965	\N	Consumidor Final	5.00	EFECTIVO	MESA	LOCAL	3	PAGADA	\N	Alex	5.00	0.00	0.00	\N	t	\N	\N
733	2026-03-15 20:22:33.133154	\N	Consumidor Final	5.00	TRANSFERENCIA	MESA	LOCAL	2	PAGADA	Banco: Banco Pichincha | Comprobante: 2208825571	Alex	5.00	0.00	0.00	\N	t	\N	\N
752	2026-03-15 20:23:25.781035	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	1.50	0.00	0.00	\N	t	\N	\N
753	2026-03-15 20:23:36.145795	\N	Consumidor Final	10.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	10.00	0.00	0.00	\N	t	\N	\N
754	2026-03-15 20:23:51.588244	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	5.00	0.00	0.00	\N	t	\N	\N
755	2026-03-15 20:29:55.426779	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	3.00	0.00	0.00	\N	t	\N	\N
756	2026-03-15 20:39:00.133583	\N	Consumidor Final	0.75	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 2207239459	Alex	0.75	0.00	0.00	\N	t	\N	\N
757	2026-03-15 20:55:26.183062	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	1.50	0.00	0.00	\N	t	\N	\N
758	2026-03-15 21:01:06.527894	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	1.50	0.00	0.00	\N	t	\N	\N
759	2026-03-15 21:02:58.226075	\N	Consumidor Final	2.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	2.00	0.00	0.00	\N	t	\N	\N
760	2026-03-15 21:27:29.105782	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	3.00	0.00	0.00	\N	t	\N	\N
761	2026-03-15 21:30:55.850088	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	3.50	0.00	0.00	\N	t	\N	\N
762	2026-03-15 21:38:14.351895	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	1.75	0.00	0.00	\N	t	\N	\N
763	2026-03-15 21:45:28.854445	\N	Consumidor Final	3.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	3.50	0.00	0.00	\N	t	\N	\N
764	2026-03-15 21:55:33.367158	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	1.75	0.00	0.00	\N	t	\N	\N
765	2026-03-16 14:32:10.123008	\N	Consumidor Final	17.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	17.50	0.00	0.00	\N	t	\N	\N
766	2026-03-16 16:21:02.105838	\N	Consumidor Final	3.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	3.75	0.00	0.00	\N	t	\N	\N
767	2026-03-16 18:00:16.794562	\N	Consumidor Final	4.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	4.00	0.00	0.00	\N	t	\N	\N
768	2026-03-16 18:01:19.0261	\N	Consumidor Final	8.75	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Guayaquil | Comprobante: 0000182441	Alex	8.75	0.00	0.00	\N	t	\N	\N
769	2026-03-16 18:02:30.067795	\N	Consumidor Final	4.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	4.50	0.00	0.00	\N	t	\N	\N
770	2026-03-16 18:10:19.289374	\N	Consumidor Final	5.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	5.00	0.00	0.00	\N	t	\N	\N
771	2026-03-16 18:25:12.565557	\N	Consumidor Final	3.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	3.00	0.00	0.00	\N	t	\N	\N
772	2026-03-16 18:27:56.815423	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	1.75	0.00	0.00	\N	t	\N	\N
773	2026-03-16 18:48:03.552519	\N	Consumidor Final	2.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	2.75	0.00	0.00	\N	t	\N	\N
774	2026-03-16 19:28:47.776192	\N	Consumidor Final	3.25	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	3.25	0.00	0.00	\N	t	\N	\N
775	2026-03-16 19:34:51.254001	\N	Consumidor Final	4.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	4.50	0.00	0.00	\N	t	\N	\N
776	2026-03-16 19:37:20.863211	\N	Consumidor Final	30.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	30.00	0.00	0.00	\N	t	\N	\N
777	2026-03-16 20:08:50.564861	\N	Consumidor Final	2.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 160961923	Alex	2.50	0.00	0.00	\N	t	\N	\N
780	2026-03-16 20:19:09.760164	\N	Consumidor Final	7.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	7.50	0.00	0.00	\N	t	\N	\N
781	2026-03-16 20:44:47.516487	\N	Consumidor Final	1.75	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	1.75	0.00	0.00	\N	t	\N	\N
785	2026-03-16 21:14:21.237845	\N	Consumidor Final	3.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 168441981	Alex	3.00	0.00	0.00	\N	t	\N	\N
786	2026-03-16 21:14:29.929612	\N	Consumidor Final	1.00	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	1.00	0.00	0.00	\N	t	\N	\N
787	2026-03-16 21:17:38.113297	\N	Consumidor Final	3.00	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 168599204	Alex	3.00	0.00	0.00	\N	t	\N	\N
788	2026-03-16 21:19:03.762657	\N	Consumidor Final	13.50	TRANSFERENCIA	DIRECTA	LOCAL	\N	PAGADA	Banco: Banco Pichincha | Comprobante: 164695897	Alex	13.50	0.00	0.00	\N	t	\N	\N
789	2026-03-16 21:29:46.96218	\N	Consumidor Final	2.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	2.50	0.00	0.00	\N	t	\N	\N
790	2026-03-16 21:37:54.787737	\N	Consumidor Final	2.50	CREDITO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	2.50	0.00	0.00	6	f	\N	\N
791	2026-03-16 21:58:57.117944	\N	Consumidor Final	1.50	EFECTIVO	DIRECTA	LOCAL	\N	PAGADA	\N	Alex	1.50	0.00	0.00	\N	t	\N	\N
\.


--
-- Data for Name: ventas_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ventas_items (id, venta_id, producto_id, nombre, precio, cantidad, subtotal, image_url) FROM stdin;
63	23	7	Coco Loco	5.00	1.00	5.00	\N
133	38	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
134	38	19	Agua de Coco	1.50	4.00	6.00	\N
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
112	32	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
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
192	51	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
194	51	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
196	53	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
197	54	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
198	54	20	Agua sin gas	0.75	1.00	0.75	\N
200	56	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
201	56	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
204	55	5	Jugo de Coco	2.50	3.00	7.50	/uploads/1770091554071-9703308.jpeg
205	58	19	Agua de Coco	1.50	1.00	1.50	\N
206	58	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
211	63	2	Aranda-Coco	2.50	3.00	7.50	/uploads/1770091502229-810802818.jpeg
212	64	19	Agua de Coco	1.50	2.00	3.00	\N
215	66	2	Aranda-Coco	2.50	3.00	7.50	/uploads/1770091502229-810802818.jpeg
216	67	19	Agua de Coco	1.50	4.00	6.00	\N
217	68	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
218	68	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
219	69	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
220	69	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
228	73	19	Agua de Coco	1.50	1.00	1.50	\N
229	74	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
230	75	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
231	75	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
233	77	6	Limonada de Coco	2.50	2.00	5.00	/uploads/1770091614274-113135252.jpeg
234	78	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
235	79	6	Limonada de Coco	2.50	2.00	5.00	/uploads/1770091614274-113135252.jpeg
163	22	16	Jugo de Caña	1.00	3.00	3.00	\N
236	80	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
237	80	19	Agua de Coco	1.50	2.00	3.00	\N
363	140	19	Agua de Coco	0.90	3.00	2.70	\N
581	260	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
582	260	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
374	119	17	Pipa de Coco (Entera)	1.75	4.00	7.00	/uploads/1771869920122-501966668.jpeg
242	85	6	Limonada de Coco	2.50	2.00	5.00	/uploads/1770091614274-113135252.jpeg
243	86	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
591	264	6	Limonada de Coco	2.50	2.00	5.00	/uploads/1770091614274-113135252.jpeg
392	154	7	Coco Loco	5.00	2.00	10.00	/uploads/1772154002579-269043330.png
393	154	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
248	88	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
249	89	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
251	90	5	Jugo de Coco	2.50	2.00	5.00	/uploads/1770091554071-9703308.jpeg
252	90	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
253	90	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
254	91	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
255	92	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
256	93	19	Agua de Coco	1.50	1.00	1.50	\N
257	93	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
258	94	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
259	94	19	Agua de Coco	1.50	1.00	1.50	\N
261	95	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
263	96	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
264	97	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
265	98	19	Agua de Coco	1.00	14.00	14.00	\N
266	99	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
267	99	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
268	100	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
269	101	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
271	103	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
272	104	19	Agua de Coco	1.00	20.00	20.00	\N
273	105	19	Agua de Coco	1.00	5.00	5.00	\N
274	106	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
275	107	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
276	108	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
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
395	155	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
397	157	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
400	159	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
401	160	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
402	161	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
403	162	7	Coco Loco	5.00	4.00	20.00	/uploads/1772154002579-269043330.png
404	163	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
355	139	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
360	133	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
406	143	23	Vaso con Pulpa	1.75	1.00	1.75	/uploads/1772144018286-603382465.jpeg
407	136	23	Vaso con Pulpa	1.75	2.00	3.50	/uploads/1772144018286-603382465.jpeg
408	136	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
409	136	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
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
422	172	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
423	173	8	Guarapo	3.50	1.00	3.50	/uploads/1772074074837-724919799.jpeg
425	174	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
427	175	2	Aranda-Coco	2.50	2.00	5.00	/uploads/1770091502229-810802818.jpeg
428	175	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
429	175	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
430	176	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
431	177	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
432	178	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
434	179	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
435	179	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
436	180	5	Jugo de Coco	2.50	3.00	7.50	/uploads/1770091554071-9703308.jpeg
437	181	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
438	182	7	Coco Loco	5.00	3.00	15.00	/uploads/1772154002579-269043330.png
440	184	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
441	185	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
442	185	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
443	186	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
445	187	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
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
461	199	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
463	201	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
464	202	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
465	203	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
466	204	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
469	207	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
470	208	8	Guarapo	3.50	1.00	3.50	/uploads/1772074074837-724919799.jpeg
471	209	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
472	209	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
473	209	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
474	210	4	Coco-Coffe	2.50	1.00	2.50	/uploads/1770091539173-351007575.jpeg
476	211	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
477	212	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
478	213	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
583	261	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
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
633	300	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
635	302	17	Pipa de Coco (Entera)	1.75	3.00	5.25	/uploads/1771869920122-501966668.jpeg
637	304	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
639	306	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
641	308	17	Pipa de Coco (Entera)	1.75	4.00	7.00	/uploads/1771869920122-501966668.jpeg
643	309	19	Agua de Coco	1.00	60.00	60.00	/uploads/1772154137183-309473636.jpeg
645	311	4	Coco-Coffe	2.50	2.00	5.00	/uploads/1770091539173-351007575.jpeg
646	311	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
650	315	19	Agua de Coco	1.50	3.00	4.50	/uploads/1772154137183-309473636.jpeg
652	317	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
654	319	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
656	321	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
658	323	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
671	325	2	Aranda-Coco	2.50	2.00	5.00	/uploads/1770091502229-810802818.jpeg
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
460	199	16	Jugo de Caña	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
1005	538	25	Helado + Topping	3.50	1.00	3.50	\N
600	273	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
605	277	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
606	277	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
608	279	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
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
630	297	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
579	258	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
632	299	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
634	301	19	Agua de Coco	1.00	5.00	5.00	/uploads/1772154137183-309473636.jpeg
636	303	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
638	305	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
640	307	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
644	310	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
647	312	8	Guarapo	3.50	1.00	3.50	/uploads/1772074074837-724919799.jpeg
653	318	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
655	320	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
657	322	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
659	324	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
679	326	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
680	326	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
686	328	6	Limonada de Coco	2.50	4.00	10.00	/uploads/1770091614274-113135252.jpeg
687	328	21	WhiskyCoco	6.00	1.00	6.00	/uploads/1772153958722-630179910.png
696	333	26	Hielo	1.00	1.00	1.00	\N
701	338	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
702	338	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
707	342	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
709	344	10	Paleta Coco	0.75	4.00	3.00	/uploads/1770091625649-935062879.jpeg
712	347	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
714	348	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
715	349	15	Coco Relleno	3.50	4.00	14.00	/uploads/1770091958846-900674604.jpeg
716	349	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
717	350	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
719	351	17	Pipa de Coco (Entera)	1.75	5.00	8.75	/uploads/1771869920122-501966668.jpeg
720	352	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
721	353	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
722	354	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
723	354	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
724	355	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
726	357	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
727	358	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
729	359	19	Agua de Coco	1.00	6.00	6.00	/uploads/1772154137183-309473636.jpeg
730	360	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
731	360	9	Paleta Frutos Rojos	0.75	2.00	1.50	/uploads/1770091634345-225726818.jpeg
732	361	10	Paleta Coco	0.75	8.00	6.00	/uploads/1770091625649-935062879.jpeg
733	361	15	Coco Relleno	3.50	2.00	7.00	/uploads/1770091958846-900674604.jpeg
734	361	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
736	362	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
737	362	9	Paleta Frutos Rojos	0.75	2.00	1.50	/uploads/1770091634345-225726818.jpeg
738	362	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
739	362	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
740	363	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
741	364	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
742	365	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
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
756	373	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
758	374	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
135	38	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
111	31	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
173	47	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
191	52	16	Jugo de Caña	1.00	1.00	1.00	\N
193	51	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
195	51	18	Caña Manabita	1.50	1.00	1.50	\N
207	59	16	Jugo de Caña	1.00	1.00	1.00	\N
213	64	16	Jugo de Caña	1.00	2.00	2.00	\N
227	73	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
232	76	16	Jugo de Caña	1.00	1.00	1.00	\N
598	271	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
250	90	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
260	94	16	Jugo de Caña	1.00	1.00	1.00	\N
262	95	16	Jugo de Caña	1.00	1.00	1.00	\N
270	102	16	Jugo de Caña	1.00	1.00	1.00	\N
277	109	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
292	121	16	Jugo de Caña	1.00	2.00	2.00	\N
394	155	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
399	159	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
405	143	16	Jugo de Caña	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
354	139	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
361	133	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
410	136	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
421	172	16	Jugo de Caña	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
424	174	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
426	175	1	Piña-Coco	2.50	2.00	5.00	/uploads/1770091190187-729842799.jpeg
433	179	1	Piña-Coco	2.50	2.00	5.00	/uploads/1770091190187-729842799.jpeg
439	183	16	Jugo de Caña	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
444	186	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
446	187	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
462	200	16	Jugo de Caña	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
467	205	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
468	206	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
475	210	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
584	261	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
725	356	16	Jugo de Caña	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
631	298	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
648	313	16	Jugo de Caña	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
672	325	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
603	275	16	Jugo de Caña	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
612	280	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
542	235	3	Coco & Caña	2.50	1.00	2.50	/uploads/1770091527798-395873077.jpeg
628	295	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
642	293	16	Jugo de Caña	0.75	25.00	18.75	/uploads/1772074012217-453295926.jpeg
649	314	16	Jugo de Caña	1.00	3.00	3.00	/uploads/1772074012217-453295926.jpeg
651	316	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
698	335	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
711	346	16	Jugo de Caña	1.00	3.00	3.00	/uploads/1772074012217-453295926.jpeg
718	350	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
735	362	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
743	365	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
754	372	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
755	372	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
757	374	16	Jugo de Caña	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
759	375	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
761	377	19	Agua de Coco	1.00	40.00	40.00	/uploads/1772154137183-309473636.jpeg
762	378	19	Agua de Coco	1.00	20.00	20.00	/uploads/1772154137183-309473636.jpeg
763	379	19	Agua de Coco	0.90	10.00	9.00	/uploads/1772154137183-309473636.jpeg
764	379	16	Jugo de Caña	0.75	10.00	7.50	/uploads/1772074012217-453295926.jpeg
765	380	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
766	381	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
767	381	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
768	382	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
769	382	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
770	383	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
771	384	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
772	384	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
773	385	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
774	386	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
775	387	15	Coco Relleno	3.50	2.00	7.00	/uploads/1770091958846-900674604.jpeg
776	388	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
777	389	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
778	390	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
779	390	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
780	391	1	Piña-Coco	2.50	2.00	5.00	/uploads/1770091190187-729842799.jpeg
781	392	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
782	392	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
783	393	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
785	395	8	Guarapo	3.50	1.00	3.50	/uploads/1772074074837-724919799.jpeg
786	394	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
787	396	9	Paleta Frutos Rojos	0.75	2.00	1.50	/uploads/1770091634345-225726818.jpeg
788	397	17	Pipa de Coco (Entera)	1.75	4.00	7.00	/uploads/1771869920122-501966668.jpeg
789	398	8	Guarapo	3.50	1.00	3.50	/uploads/1772074074837-724919799.jpeg
790	399	16	Jugo de Caña	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
791	400	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
792	401	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
793	402	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
794	403	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
795	404	19	Agua de Coco	1.50	4.00	6.00	/uploads/1772154137183-309473636.jpeg
796	404	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
797	405	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
798	406	25	Helado + Topping	3.50	1.00	3.50	\N
799	406	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
800	406	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
803	407	19	Agua de Coco	1.50	3.00	4.50	/uploads/1772154137183-309473636.jpeg
804	408	6	Limonada de Coco	2.50	2.00	5.00	/uploads/1770091614274-113135252.jpeg
805	409	25	Helado + Topping	3.50	2.00	7.00	\N
806	410	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
807	410	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
808	411	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
809	411	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
810	340	21	WhiskyCoco	6.00	1.00	6.00	/uploads/1772153958722-630179910.png
811	340	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
812	340	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
813	340	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
814	412	1	Piña-Coco	2.50	2.00	5.00	/uploads/1770091190187-729842799.jpeg
817	415	25	Helado + Topping	3.50	1.00	3.50	\N
818	416	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
819	417	8	Guarapo	3.50	2.00	7.00	/uploads/1772074074837-724919799.jpeg
820	417	26	Hielo	1.00	2.00	2.00	\N
821	418	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
822	419	1	Piña-Coco	2.50	2.00	5.00	/uploads/1770091190187-729842799.jpeg
823	420	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
824	421	4	Coco-Coffe	2.50	1.00	2.50	/uploads/1770091539173-351007575.jpeg
825	422	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
826	422	25	Helado + Topping	3.50	1.00	3.50	\N
827	423	2	Aranda-Coco	2.50	2.00	5.00	/uploads/1770091502229-810802818.jpeg
828	423	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
829	423	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
830	424	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
831	425	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
832	426	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
833	427	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
834	428	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
835	429	10	Paleta Coco	0.75	5.00	3.75	/uploads/1770091625649-935062879.jpeg
836	430	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
837	430	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
838	431	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
839	432	16	Jugo de Caña	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
840	432	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
841	433	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
842	434	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
843	434	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
844	435	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
845	436	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
846	437	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
847	438	10	Paleta Coco	0.75	6.00	4.50	/uploads/1770091625649-935062879.jpeg
848	438	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
849	438	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
850	439	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
851	439	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
852	439	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
853	439	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
854	440	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
855	441	25	Helado + Topping	3.50	1.00	3.50	\N
857	443	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
858	444	1	Piña-Coco	2.50	2.00	5.00	/uploads/1770091190187-729842799.jpeg
859	445	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
860	446	17	Pipa de Coco (Entera)	1.75	3.00	5.25	/uploads/1771869920122-501966668.jpeg
861	446	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
862	447	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
863	448	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
864	449	3	Coco & Caña	2.50	1.00	2.50	/uploads/1770091527798-395873077.jpeg
865	449	22	Ron	2.50	1.00	2.50	/uploads/1772153980717-263725156.jpeg
866	450	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
867	450	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
868	451	16	Jugo de Caña	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
869	452	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
870	452	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
871	453	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
872	454	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
873	455	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
894	476	21	WhiskyCoco	6.00	1.00	6.00	/uploads/1772153958722-630179910.png
895	477	7	Coco Loco	5.00	4.00	20.00	/uploads/1772154002579-269043330.png
896	478	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
897	479	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
898	480	6	Limonada de Coco	2.50	2.00	5.00	/uploads/1770091614274-113135252.jpeg
901	483	25	Helado + Topping	3.50	2.00	7.00	\N
902	482	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
903	484	19	Agua de Coco	1.50	6.00	9.00	/uploads/1772154137183-309473636.jpeg
904	485	17	Pipa de Coco (Entera)	1.75	7.00	12.25	/uploads/1771869920122-501966668.jpeg
905	486	10	Paleta Coco	0.75	8.00	6.00	/uploads/1770091625649-935062879.jpeg
906	487	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
907	487	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
908	488	8	Guarapo	3.50	1.00	3.50	/uploads/1772074074837-724919799.jpeg
909	489	9	Paleta Frutos Rojos	0.75	2.00	1.50	/uploads/1770091634345-225726818.jpeg
910	490	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
911	491	16	Jugo de Caña	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
912	492	1	Piña-Coco	2.50	3.00	7.50	/uploads/1770091190187-729842799.jpeg
917	494	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
934	493	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
935	493	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
936	493	3	Coco & Caña	2.50	1.00	2.50	/uploads/1770091527798-395873077.jpeg
937	493	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
938	495	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
941	498	19	Agua de Coco	1.50	3.00	4.50	/uploads/1772154137183-309473636.jpeg
942	499	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
943	499	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
944	500	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
945	501	17	Pipa de Coco (Entera)	1.75	3.00	5.25	/uploads/1771869920122-501966668.jpeg
948	504	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
949	505	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
950	505	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
951	506	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
952	506	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
953	507	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
954	507	10	Paleta Coco	0.75	4.00	3.00	/uploads/1770091625649-935062879.jpeg
957	510	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
958	511	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
959	511	9	Paleta Frutos Rojos	0.75	2.00	1.50	/uploads/1770091634345-225726818.jpeg
960	512	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
964	516	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
965	517	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
966	518	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
967	519	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
968	520	19	Agua de Coco	1.00	35.00	35.00	/uploads/1772154137183-309473636.jpeg
969	521	5	Jugo de Coco	2.50	4.00	10.00	/uploads/1770091554071-9703308.jpeg
970	522	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
971	522	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
972	523	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
973	523	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
974	524	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
975	524	19	Agua de Coco	1.50	3.00	4.50	/uploads/1772154137183-309473636.jpeg
976	525	17	Pipa de Coco (Entera)	1.75	3.00	5.25	/uploads/1771869920122-501966668.jpeg
977	526	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
982	529	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
983	529	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
989	531	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
990	531	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
991	530	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
992	530	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
993	530	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
994	532	3	Coco & Caña	2.50	1.00	2.50	/uploads/1770091527798-395873077.jpeg
995	532	4	Coco-Coffe	2.50	1.00	2.50	/uploads/1770091539173-351007575.jpeg
996	533	17	Pipa de Coco (Entera)	1.75	3.00	5.25	/uploads/1771869920122-501966668.jpeg
997	534	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
998	535	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
999	535	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
1004	538	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
1006	539	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
1007	540	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1008	540	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1009	540	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
1010	541	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1015	544	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1016	544	25	Helado + Topping	3.50	1.00	3.50	\N
1017	545	26	Hielo	1.00	1.00	1.00	\N
1018	546	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
1019	547	17	Pipa de Coco (Entera)	1.75	5.00	8.75	/uploads/1771869920122-501966668.jpeg
1025	551	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
1026	551	9	Paleta Frutos Rojos	0.75	2.00	1.50	/uploads/1770091634345-225726818.jpeg
1027	548	10	Paleta Coco	0.75	7.00	5.25	/uploads/1770091625649-935062879.jpeg
1028	552	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1029	553	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1030	554	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
1031	554	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
1032	555	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
1033	556	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
1034	556	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
1035	556	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
1036	557	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
1039	560	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
1040	561	19	Agua de Coco	1.50	6.00	9.00	/uploads/1772154137183-309473636.jpeg
1041	561	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
1042	562	19	Agua de Coco	1.50	3.00	4.50	/uploads/1772154137183-309473636.jpeg
1043	563	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
1044	564	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
1045	565	19	Agua de Coco	1.00	5.00	5.00	/uploads/1772154137183-309473636.jpeg
1046	566	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
1047	566	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1048	567	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
1049	568	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
1050	569	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
1053	571	1	Piña-Coco	2.50	2.00	5.00	/uploads/1770091190187-729842799.jpeg
1054	572	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
1055	573	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
1057	574	16	Jugo de Caña	1.00	3.00	3.00	/uploads/1772074012217-453295926.jpeg
1058	575	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1059	576	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
1060	577	15	Coco Relleno	3.50	4.00	14.00	/uploads/1770091958846-900674604.jpeg
1061	578	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
1062	578	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1063	579	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
1064	580	5	Jugo de Coco	2.50	2.00	5.00	/uploads/1770091554071-9703308.jpeg
1065	580	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
1068	582	7	Coco Loco	5.00	2.00	10.00	/uploads/1772154002579-269043330.png
1071	585	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
1072	586	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
1073	587	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
1074	588	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
1075	589	4	Coco-Coffe	2.50	1.00	2.50	/uploads/1770091539173-351007575.jpeg
1076	589	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
1077	590	19	Agua de Coco	1.00	15.00	15.00	/uploads/1772154137183-309473636.jpeg
1078	570	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1079	581	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
1080	591	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1081	591	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
1082	592	28	Mojito	4.00	2.00	8.00	\N
1083	593	28	Mojito	4.00	1.00	4.00	\N
1084	594	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
1085	594	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1086	594	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
1087	595	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
1088	596	19	Agua de Coco	1.00	5.00	5.00	/uploads/1772154137183-309473636.jpeg
1089	597	16	Jugo de Caña	0.75	10.00	7.50	/uploads/1772074012217-453295926.jpeg
1090	597	19	Agua de Coco	0.90	8.00	7.20	/uploads/1772154137183-309473636.jpeg
1091	598	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1092	598	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
1093	599	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1094	600	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
1095	601	16	Jugo de Caña	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
1100	604	16	Jugo de Caña	1.00	3.00	3.00	/uploads/1772074012217-453295926.jpeg
1101	604	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1102	605	19	Agua de Coco	1.50	5.00	7.50	/uploads/1772154137183-309473636.jpeg
1103	605	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1104	606	9	Paleta Frutos Rojos	0.75	8.00	6.00	/uploads/1770091634345-225726818.jpeg
1105	607	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1106	608	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1107	608	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
1108	609	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
1109	609	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
1110	610	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
1111	611	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1112	611	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
1113	612	2	Aranda-Coco	2.50	2.00	5.00	/uploads/1770091502229-810802818.jpeg
1114	612	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1115	613	19	Agua de Coco	1.00	20.00	20.00	/uploads/1772154137183-309473636.jpeg
1116	614	17	Pipa de Coco (Entera)	1.75	4.00	7.00	/uploads/1771869920122-501966668.jpeg
1121	617	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
1122	617	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
1123	618	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
1124	619	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1125	619	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1126	620	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
1127	620	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
1128	620	7	Coco Loco	5.00	2.00	10.00	/uploads/1772154002579-269043330.png
1129	620	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
1130	621	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
1131	621	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1132	622	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1133	623	17	Pipa de Coco (Entera)	1.75	3.00	5.25	/uploads/1771869920122-501966668.jpeg
1134	624	19	Agua de Coco	1.50	6.00	9.00	/uploads/1772154137183-309473636.jpeg
1135	625	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
1136	626	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1137	626	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1140	628	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
1141	627	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
1142	627	9	Paleta Frutos Rojos	0.75	2.00	1.50	/uploads/1770091634345-225726818.jpeg
1143	629	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1144	630	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
1145	630	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1146	630	9	Paleta Frutos Rojos	0.75	2.00	1.50	/uploads/1770091634345-225726818.jpeg
1147	631	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
1148	631	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1149	632	6	Limonada de Coco	2.50	2.00	5.00	/uploads/1770091614274-113135252.jpeg
1150	632	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
1151	632	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1152	633	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1153	633	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1154	634	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
1155	634	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
1156	635	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
1157	635	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
1158	636	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1159	637	19	Agua de Coco	1.00	35.00	35.00	/uploads/1772154137183-309473636.jpeg
1164	640	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
1165	640	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1166	641	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1167	642	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
1168	642	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
1169	643	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1170	643	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
1171	644	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
1172	645	19	Agua de Coco	1.00	5.00	5.00	/uploads/1772154137183-309473636.jpeg
1173	646	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1174	647	16	Jugo de Caña	0.75	15.00	11.25	/uploads/1772074012217-453295926.jpeg
1175	647	19	Agua de Coco	0.90	15.00	13.50	/uploads/1772154137183-309473636.jpeg
1176	648	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
1177	649	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1178	650	4	Coco-Coffe	2.50	4.00	10.00	/uploads/1770091539173-351007575.jpeg
1179	651	4	Coco-Coffe	2.50	1.00	2.50	/uploads/1770091539173-351007575.jpeg
1180	651	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1181	652	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1182	653	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1184	655	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
1185	656	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
1186	657	20	Agua sin gas	0.75	1.00	0.75	/uploads/1772074039133-796578609.jpeg
1187	654	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
1188	658	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
1189	659	17	Pipa de Coco (Entera)	1.75	3.00	5.25	/uploads/1771869920122-501966668.jpeg
1193	661	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
1194	660	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1195	660	9	Paleta Frutos Rojos	0.75	2.00	1.50	/uploads/1770091634345-225726818.jpeg
1196	660	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1197	662	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
1198	663	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
1199	664	26	Hielo	1.00	4.00	4.00	\N
1200	665	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
1201	666	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
1202	667	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1203	668	4	Coco-Coffe	2.50	1.00	2.50	/uploads/1770091539173-351007575.jpeg
1204	668	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1205	669	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
1206	670	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
1207	670	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1208	671	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
1209	672	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
1210	673	16	Jugo de Caña	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
1211	674	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
1212	675	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1213	676	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
1214	677	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1215	677	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
1216	678	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1217	679	19	Agua de Coco	0.90	15.00	13.50	/uploads/1772154137183-309473636.jpeg
1218	680	15	Coco Relleno	3.50	3.00	10.50	/uploads/1770091958846-900674604.jpeg
1219	680	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
1220	680	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
1221	680	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
1222	681	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
1223	681	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1224	682	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1225	683	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
1226	683	18	Caña Manabita	1.50	1.00	1.50	/uploads/1772153991048-60347243.jpeg
1227	683	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1228	684	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
1229	685	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1230	686	19	Agua de Coco	1.00	35.00	35.00	/uploads/1772154137183-309473636.jpeg
1231	687	19	Agua de Coco	1.50	3.00	4.50	/uploads/1772154137183-309473636.jpeg
1232	688	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
1233	688	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
1234	688	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
1235	689	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
1236	690	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1237	691	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
1238	691	4	Coco-Coffe	2.50	1.00	2.50	/uploads/1770091539173-351007575.jpeg
1239	691	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
1240	692	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1241	693	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
1242	693	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1243	694	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1244	695	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1245	696	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1246	697	6	Limonada de Coco	2.50	2.00	5.00	/uploads/1770091614274-113135252.jpeg
1251	700	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
1252	700	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
1253	701	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
1254	701	9	Paleta Frutos Rojos	0.75	3.00	2.25	/uploads/1770091634345-225726818.jpeg
1255	701	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
1256	702	19	Agua de Coco	1.50	3.00	4.50	/uploads/1772154137183-309473636.jpeg
1257	703	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
1258	703	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
1259	704	10	Paleta Coco	0.75	5.00	3.75	/uploads/1770091625649-935062879.jpeg
1260	705	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1261	706	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
1262	706	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
1263	707	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
1264	708	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1265	709	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1266	710	4	Coco-Coffe	2.50	1.00	2.50	/uploads/1770091539173-351007575.jpeg
1267	710	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
1268	711	5	Jugo de Coco	2.50	2.00	5.00	/uploads/1770091554071-9703308.jpeg
1269	712	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
1270	712	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1271	712	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
1272	713	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1273	713	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
1274	714	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1275	715	16	Jugo de Caña	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
1276	716	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
1277	717	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
1278	717	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
1279	717	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
1280	717	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1281	718	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1282	718	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
1283	719	6	Limonada de Coco	2.50	4.00	10.00	/uploads/1770091614274-113135252.jpeg
1284	720	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1285	720	5	Jugo de Coco	2.50	1.00	2.50	/uploads/1770091554071-9703308.jpeg
1286	721	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
1287	722	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1288	723	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
1289	723	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1290	723	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
1291	723	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1292	724	16	Jugo de Caña	1.00	3.00	3.00	/uploads/1772074012217-453295926.jpeg
1293	724	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1294	725	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1295	726	10	Paleta Coco	0.75	3.00	2.25	/uploads/1770091625649-935062879.jpeg
1297	728	9	Paleta Frutos Rojos	0.75	2.00	1.50	/uploads/1770091634345-225726818.jpeg
1298	729	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1299	730	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
1300	730	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1301	731	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
1302	732	17	Pipa de Coco (Entera)	1.75	3.00	5.25	/uploads/1771869920122-501966668.jpeg
1305	734	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
1306	735	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
1307	735	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
1308	736	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1309	737	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
1310	737	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1311	738	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
1312	738	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
1313	739	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
1314	740	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1315	741	10	Paleta Coco	0.75	5.00	3.75	/uploads/1770091625649-935062879.jpeg
1316	741	9	Paleta Frutos Rojos	0.75	2.00	1.50	/uploads/1770091634345-225726818.jpeg
1317	741	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
1318	742	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1319	743	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
1320	744	2	Aranda-Coco	2.50	2.00	5.00	/uploads/1770091502229-810802818.jpeg
1321	745	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
1336	751	10	Paleta Coco	0.75	5.00	3.75	/uploads/1770091625649-935062879.jpeg
1337	751	15	Coco Relleno	3.50	1.00	3.50	/uploads/1770091958846-900674604.jpeg
1338	748	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
1339	748	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
1340	733	7	Coco Loco	5.00	1.00	5.00	/uploads/1772154002579-269043330.png
1341	752	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1342	753	7	Coco Loco	5.00	2.00	10.00	/uploads/1772154002579-269043330.png
1343	754	2	Aranda-Coco	2.50	2.00	5.00	/uploads/1770091502229-810802818.jpeg
1344	755	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
1345	756	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1346	757	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1347	758	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1348	759	16	Jugo de Caña	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
1349	760	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
1350	760	10	Paleta Coco	0.75	1.00	0.75	/uploads/1770091625649-935062879.jpeg
1351	760	9	Paleta Frutos Rojos	0.75	1.00	0.75	/uploads/1770091634345-225726818.jpeg
1352	761	17	Pipa de Coco (Entera)	1.75	2.00	3.50	/uploads/1771869920122-501966668.jpeg
1353	762	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1354	763	8	Guarapo	3.50	1.00	3.50	/uploads/1772074074837-724919799.jpeg
1355	764	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1356	765	15	Coco Relleno	3.50	5.00	17.50	/uploads/1770091958846-900674604.jpeg
1357	766	10	Paleta Coco	0.75	5.00	3.75	/uploads/1770091625649-935062879.jpeg
1358	767	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1359	767	20	Agua sin gas	0.75	3.00	2.25	/uploads/1772074039133-796578609.jpeg
1360	768	17	Pipa de Coco (Entera)	1.75	5.00	8.75	/uploads/1771869920122-501966668.jpeg
1361	769	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
1362	769	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
1363	770	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
1364	770	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
1365	771	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
1366	772	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1367	773	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1368	773	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
1369	774	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1370	774	10	Paleta Coco	0.75	2.00	1.50	/uploads/1770091625649-935062879.jpeg
1371	775	19	Agua de Coco	1.50	3.00	4.50	/uploads/1772154137183-309473636.jpeg
1372	776	19	Agua de Coco	1.00	30.00	30.00	/uploads/1772154137183-309473636.jpeg
1373	777	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
1376	780	5	Jugo de Coco	2.50	3.00	7.50	/uploads/1770091554071-9703308.jpeg
1377	781	17	Pipa de Coco (Entera)	1.75	1.00	1.75	/uploads/1771869920122-501966668.jpeg
1378	782	4	Coco-Coffe	2.50	1.00	2.50	/uploads/1770091539173-351007575.jpeg
1379	782	2	Aranda-Coco	2.50	1.00	2.50	/uploads/1770091502229-810802818.jpeg
1380	783	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
1381	784	16	Jugo de Caña	1.00	2.00	2.00	/uploads/1772074012217-453295926.jpeg
1382	785	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
1383	786	16	Jugo de Caña	1.00	1.00	1.00	/uploads/1772074012217-453295926.jpeg
1384	787	19	Agua de Coco	1.50	2.00	3.00	/uploads/1772154137183-309473636.jpeg
1385	788	19	Agua de Coco	0.90	15.00	13.50	/uploads/1772154137183-309473636.jpeg
1386	789	6	Limonada de Coco	2.50	1.00	2.50	/uploads/1770091614274-113135252.jpeg
1387	790	1	Piña-Coco	2.50	1.00	2.50	/uploads/1770091190187-729842799.jpeg
1388	791	19	Agua de Coco	1.50	1.00	1.50	/uploads/1772154137183-309473636.jpeg
\.


--
-- Name: bodega_insumos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bodega_insumos_id_seq', 1, false);


--
-- Name: bodega_movimientos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bodega_movimientos_id_seq', 1, false);


--
-- Name: bodega_productos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bodega_productos_id_seq', 1, false);


--
-- Name: caja_chica_ahorros_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.caja_chica_ahorros_id_seq', 1, true);


--
-- Name: caja_cierres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.caja_cierres_id_seq', 1, false);


--
-- Name: caja_movimientos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.caja_movimientos_id_seq', 864, true);


--
-- Name: caja_turnos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.caja_turnos_id_seq', 22, true);


--
-- Name: categorias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categorias_id_seq', 5, true);


--
-- Name: clientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.clientes_id_seq', 9, true);


--
-- Name: config_impresora_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.config_impresora_id_seq', 1, false);


--
-- Name: detalle_ventas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.detalle_ventas_id_seq', 1, false);


--
-- Name: facturas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.facturas_id_seq', 392, true);


--
-- Name: facturas_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.facturas_items_id_seq', 553, true);


--
-- Name: facturas_secuencia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.facturas_secuencia_id_seq', 1, false);


--
-- Name: gastos_mensuales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gastos_mensuales_id_seq', 15, true);


--
-- Name: insumos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.insumos_id_seq', 19, true);


--
-- Name: mesas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.mesas_id_seq', 1, false);


--
-- Name: movimientos_inventario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.movimientos_inventario_id_seq', 1355, true);


--
-- Name: productos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.productos_id_seq', 28, true);


--
-- Name: recetas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.recetas_id_seq', 28, true);


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 3, true);


--
-- Name: ventas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ventas_id_seq', 791, true);


--
-- Name: ventas_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ventas_items_id_seq', 1388, true);


--
-- Name: bodega_insumos bodega_insumos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bodega_insumos
    ADD CONSTRAINT bodega_insumos_pkey PRIMARY KEY (id);


--
-- Name: bodega_movimientos bodega_movimientos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bodega_movimientos
    ADD CONSTRAINT bodega_movimientos_pkey PRIMARY KEY (id);


--
-- Name: bodega_productos bodega_productos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bodega_productos
    ADD CONSTRAINT bodega_productos_pkey PRIMARY KEY (id);


--
-- Name: caja_chica_ahorros caja_chica_ahorros_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caja_chica_ahorros
    ADD CONSTRAINT caja_chica_ahorros_pkey PRIMARY KEY (id);


--
-- Name: caja_cierres caja_cierres_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caja_cierres
    ADD CONSTRAINT caja_cierres_pkey PRIMARY KEY (id);


--
-- Name: caja_movimientos caja_movimientos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT caja_movimientos_pkey PRIMARY KEY (id);


--
-- Name: caja_turnos caja_turnos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caja_turnos
    ADD CONSTRAINT caja_turnos_pkey PRIMARY KEY (id);


--
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


--
-- Name: config_impresora config_impresora_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.config_impresora
    ADD CONSTRAINT config_impresora_pkey PRIMARY KEY (id);


--
-- Name: detalle_ventas detalle_ventas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_ventas
    ADD CONSTRAINT detalle_ventas_pkey PRIMARY KEY (id);


--
-- Name: facturas_items facturas_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facturas_items
    ADD CONSTRAINT facturas_items_pkey PRIMARY KEY (id);


--
-- Name: facturas facturas_numero_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT facturas_numero_key UNIQUE (numero);


--
-- Name: facturas facturas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT facturas_pkey PRIMARY KEY (id);


--
-- Name: facturas_secuencia facturas_secuencia_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facturas_secuencia
    ADD CONSTRAINT facturas_secuencia_pkey PRIMARY KEY (id);


--
-- Name: gastos_mensuales gastos_mensuales_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gastos_mensuales
    ADD CONSTRAINT gastos_mensuales_pkey PRIMARY KEY (id);


--
-- Name: insumos insumos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insumos
    ADD CONSTRAINT insumos_pkey PRIMARY KEY (id);


--
-- Name: mesas mesas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mesas
    ADD CONSTRAINT mesas_pkey PRIMARY KEY (id);


--
-- Name: movimientos_inventario movimientos_inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movimientos_inventario
    ADD CONSTRAINT movimientos_inventario_pkey PRIMARY KEY (id);


--
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id);


--
-- Name: recetas recetas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recetas
    ADD CONSTRAINT recetas_pkey PRIMARY KEY (id);


--
-- Name: usuarios usuarios_pin_acceso_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pin_acceso_key UNIQUE (pin_acceso);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- Name: ventas_items ventas_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ventas_items
    ADD CONSTRAINT ventas_items_pkey PRIMARY KEY (id);


--
-- Name: ventas ventas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_pkey PRIMARY KEY (id);


--
-- Name: idx_caja_chica_ahorros_fecha; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_caja_chica_ahorros_fecha ON public.caja_chica_ahorros USING btree (fecha);


--
-- Name: idx_caja_cierres_fecha; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_caja_cierres_fecha ON public.caja_cierres USING btree (fecha_cierre);


--
-- Name: idx_caja_cierres_turno; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_caja_cierres_turno ON public.caja_cierres USING btree (turno_id);


--
-- Name: idx_caja_mov_fecha; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_caja_mov_fecha ON public.caja_movimientos USING btree (fecha);


--
-- Name: idx_caja_turno; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_caja_turno ON public.caja_movimientos USING btree (turno_id);


--
-- Name: idx_facturas_estado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_facturas_estado ON public.facturas USING btree (estado);


--
-- Name: idx_facturas_fecha; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_facturas_fecha ON public.facturas USING btree (fecha);


--
-- Name: idx_facturas_items_factura; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_facturas_items_factura ON public.facturas_items USING btree (factura_id);


--
-- Name: idx_facturas_numero; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_facturas_numero ON public.facturas USING btree (numero);


--
-- Name: idx_facturas_venta; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_facturas_venta ON public.facturas USING btree (venta_id);


--
-- Name: idx_gastos_mensuales_caja; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_gastos_mensuales_caja ON public.gastos_mensuales USING btree (caja_origen);


--
-- Name: idx_gastos_mensuales_fecha; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_gastos_mensuales_fecha ON public.gastos_mensuales USING btree (fecha);


--
-- Name: idx_mov_inv_fecha; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mov_inv_fecha ON public.movimientos_inventario USING btree (fecha);


--
-- Name: idx_mov_inv_insumo; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mov_inv_insumo ON public.movimientos_inventario USING btree (insumo_id);


--
-- Name: idx_ventas_estado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ventas_estado ON public.ventas USING btree (estado);


--
-- Name: idx_ventas_fecha; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ventas_fecha ON public.ventas USING btree (fecha);


--
-- Name: idx_ventas_mesa; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ventas_mesa ON public.ventas USING btree (mesa);


--
-- Name: bodega_movimientos bodega_movimientos_insumo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bodega_movimientos
    ADD CONSTRAINT bodega_movimientos_insumo_id_fkey FOREIGN KEY (insumo_id) REFERENCES public.bodega_insumos(id) ON DELETE SET NULL;


--
-- Name: caja_cierres caja_cierres_turno_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caja_cierres
    ADD CONSTRAINT caja_cierres_turno_id_fkey FOREIGN KEY (turno_id) REFERENCES public.caja_turnos(id) ON DELETE CASCADE;


--
-- Name: caja_movimientos caja_movimientos_turno_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caja_movimientos
    ADD CONSTRAINT caja_movimientos_turno_id_fkey FOREIGN KEY (turno_id) REFERENCES public.caja_turnos(id) ON DELETE CASCADE;


--
-- Name: detalle_ventas detalle_ventas_id_producto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_ventas
    ADD CONSTRAINT detalle_ventas_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.productos(id);


--
-- Name: detalle_ventas detalle_ventas_id_venta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detalle_ventas
    ADD CONSTRAINT detalle_ventas_id_venta_fkey FOREIGN KEY (id_venta) REFERENCES public.ventas(id) ON DELETE CASCADE;


--
-- Name: facturas_items facturas_items_factura_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facturas_items
    ADD CONSTRAINT facturas_items_factura_id_fkey FOREIGN KEY (factura_id) REFERENCES public.facturas(id) ON DELETE CASCADE;


--
-- Name: facturas facturas_venta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facturas
    ADD CONSTRAINT facturas_venta_id_fkey FOREIGN KEY (venta_id) REFERENCES public.ventas(id) ON DELETE SET NULL;


--
-- Name: ventas fk_ventas_cliente; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT fk_ventas_cliente FOREIGN KEY (cliente_id) REFERENCES public.clientes(id) ON DELETE SET NULL;


--
-- Name: movimientos_inventario movimientos_inventario_insumo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movimientos_inventario
    ADD CONSTRAINT movimientos_inventario_insumo_id_fkey FOREIGN KEY (insumo_id) REFERENCES public.insumos(id) ON DELETE CASCADE;


--
-- Name: productos productos_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categorias(id);


--
-- Name: recetas recetas_id_insumo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recetas
    ADD CONSTRAINT recetas_id_insumo_fkey FOREIGN KEY (id_insumo) REFERENCES public.insumos(id);


--
-- Name: recetas recetas_id_producto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recetas
    ADD CONSTRAINT recetas_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.productos(id) ON DELETE CASCADE;


--
-- Name: ventas ventas_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id);


--
-- Name: ventas_items ventas_items_venta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ventas_items
    ADD CONSTRAINT ventas_items_venta_id_fkey FOREIGN KEY (venta_id) REFERENCES public.ventas(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

