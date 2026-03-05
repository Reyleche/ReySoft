const express = require('express');
const cors = require('cors'); // <--- IMPORTANTE
const pool = require('./db');
const jwt = require('jsonwebtoken');
const path = require('path');
const fs = require('fs');
const multer = require('multer');
const XLSX = require('xlsx');

const app = express();
const port = 3000;
const JWT_SECRET = process.env.JWT_SECRET || 'dev_secret_reysoft';
const JWT_EXPIRES_IN = '8h';

// HABILITAR CORS PARA QUE ANGULAR ENTRE
app.use(cors()); // <--- ESTA LÍNEA ES VITAL
app.use(express.json({ limit: '10mb' }));

const uploadsDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadsDir)) {
    fs.mkdirSync(uploadsDir, { recursive: true });
}
app.use('/uploads', express.static(uploadsDir));

const storage = multer.diskStorage({
    destination: (_req, _file, cb) => cb(null, uploadsDir),
    filename: (_req, file, cb) => {
        const ext = path.extname(file.originalname);
        const safeName = `${Date.now()}-${Math.round(Math.random() * 1e9)}${ext}`;
        cb(null, safeName);
    }
});
const upload = multer({ storage });

const normalizeName = (value) => String(value || '')
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/\s+/g, ' ')
    .trim();

async function initDb() {
    // Asegurar columna de imagen en productos
    await pool.query('ALTER TABLE productos ADD COLUMN IF NOT EXISTS image_url TEXT');
    await pool.query('ALTER TABLE productos ADD COLUMN IF NOT EXISTS stock_actual NUMERIC(12,3) DEFAULT 0');
    await pool.query("ALTER TABLE productos ADD COLUMN IF NOT EXISTS unidad_medida VARCHAR(20) DEFAULT 'UND'");
    await pool.query('ALTER TABLE productos ADD COLUMN IF NOT EXISTS stock_minimo NUMERIC(12,3) DEFAULT 0');

    // Movimientos de inventario
    await pool.query(`
        CREATE TABLE IF NOT EXISTS movimientos_inventario (
            id SERIAL PRIMARY KEY,
            insumo_id INTEGER NOT NULL REFERENCES insumos(id) ON DELETE CASCADE,
            tipo VARCHAR(30) NOT NULL,
            cantidad NUMERIC(12,3) NOT NULL,
            unidad_medida TEXT NOT NULL,
            motivo TEXT,
            referencia TEXT,
            usuario TEXT,
            fecha TIMESTAMP NOT NULL DEFAULT NOW()
        )
    `);
    await pool.query('CREATE INDEX IF NOT EXISTS idx_mov_inv_insumo ON movimientos_inventario(insumo_id)');
    await pool.query('CREATE INDEX IF NOT EXISTS idx_mov_inv_fecha ON movimientos_inventario(fecha)');

    // Clientes
    await pool.query(`
        CREATE TABLE IF NOT EXISTS clientes (
            id SERIAL PRIMARY KEY,
            nombre VARCHAR(120) NOT NULL,
            identificacion VARCHAR(50),
            telefono VARCHAR(50),
            email VARCHAR(120),
            direccion TEXT,
            notas TEXT,
            created_at TIMESTAMP NOT NULL DEFAULT NOW()
        )
    `);

    // Ventas y detalle
    await pool.query(`
        CREATE TABLE IF NOT EXISTS ventas (
            id SERIAL PRIMARY KEY,
            tipo VARCHAR(20) NOT NULL,
            canal VARCHAR(20) NOT NULL DEFAULT 'LOCAL',
            mesa INTEGER,
            estado VARCHAR(20) NOT NULL DEFAULT 'ABIERTA',
            metodo_pago VARCHAR(30),
            total NUMERIC(12,2) NOT NULL DEFAULT 0,
            notas TEXT,
            usuario TEXT,
            cliente_id INTEGER REFERENCES clientes(id) ON DELETE SET NULL,
            fecha TIMESTAMP NOT NULL DEFAULT NOW()
        )
    `);
    await pool.query('ALTER TABLE ventas ADD COLUMN IF NOT EXISTS tipo VARCHAR(20)');
    await pool.query("ALTER TABLE ventas ADD COLUMN IF NOT EXISTS canal VARCHAR(20) DEFAULT 'LOCAL'");
    await pool.query('ALTER TABLE ventas ADD COLUMN IF NOT EXISTS mesa INTEGER');
    await pool.query("ALTER TABLE ventas ADD COLUMN IF NOT EXISTS estado VARCHAR(20) DEFAULT 'ABIERTA'");
    await pool.query('ALTER TABLE ventas ADD COLUMN IF NOT EXISTS metodo_pago VARCHAR(30)');
    await pool.query('ALTER TABLE ventas ADD COLUMN IF NOT EXISTS total NUMERIC(12,2) DEFAULT 0');
    await pool.query('ALTER TABLE ventas ADD COLUMN IF NOT EXISTS subtotal NUMERIC(12,2) DEFAULT 0');
    await pool.query('ALTER TABLE ventas ADD COLUMN IF NOT EXISTS impuesto_pct NUMERIC(5,2) DEFAULT 0');
    await pool.query('ALTER TABLE ventas ADD COLUMN IF NOT EXISTS impuesto_monto NUMERIC(12,2) DEFAULT 0');
    await pool.query('ALTER TABLE ventas ADD COLUMN IF NOT EXISTS notas TEXT');
    await pool.query('ALTER TABLE ventas ADD COLUMN IF NOT EXISTS usuario TEXT');
    await pool.query('ALTER TABLE ventas ADD COLUMN IF NOT EXISTS credito_pagado BOOLEAN DEFAULT true');
    await pool.query('ALTER TABLE ventas ADD COLUMN IF NOT EXISTS credito_metodo_pago VARCHAR(30)');
    await pool.query('ALTER TABLE ventas ADD COLUMN IF NOT EXISTS credito_fecha_pago TIMESTAMP');
    await pool.query('ALTER TABLE ventas ADD COLUMN IF NOT EXISTS cliente_id INTEGER');
    await pool.query(`
        DO $$
        BEGIN
            IF NOT EXISTS (
                SELECT 1 FROM pg_constraint WHERE conname = 'fk_ventas_cliente'
            ) THEN
                ALTER TABLE ventas
                ADD CONSTRAINT fk_ventas_cliente
                FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE SET NULL;
            END IF;
        END $$;
    `);
    await pool.query('ALTER TABLE ventas ADD COLUMN IF NOT EXISTS fecha TIMESTAMP NOT NULL DEFAULT NOW()');
    await pool.query(`
        CREATE TABLE IF NOT EXISTS ventas_items (
            id SERIAL PRIMARY KEY,
            venta_id INTEGER NOT NULL REFERENCES ventas(id) ON DELETE CASCADE,
            producto_id INTEGER,
            nombre TEXT NOT NULL,
            precio NUMERIC(12,2) NOT NULL,
            cantidad NUMERIC(12,2) NOT NULL,
            subtotal NUMERIC(12,2) NOT NULL,
            image_url TEXT
        )
    `);
    await pool.query('ALTER TABLE ventas_items ADD COLUMN IF NOT EXISTS producto_id INTEGER');
    await pool.query('ALTER TABLE ventas_items ADD COLUMN IF NOT EXISTS nombre TEXT');
    await pool.query('ALTER TABLE ventas_items ADD COLUMN IF NOT EXISTS precio NUMERIC(12,2)');
    await pool.query('ALTER TABLE ventas_items ADD COLUMN IF NOT EXISTS cantidad NUMERIC(12,2)');
    await pool.query('ALTER TABLE ventas_items ADD COLUMN IF NOT EXISTS subtotal NUMERIC(12,2)');
    await pool.query('ALTER TABLE ventas_items ADD COLUMN IF NOT EXISTS image_url TEXT');
    await pool.query('CREATE INDEX IF NOT EXISTS idx_ventas_fecha ON ventas(fecha)');
    await pool.query('CREATE INDEX IF NOT EXISTS idx_ventas_estado ON ventas(estado)');
    await pool.query('CREATE INDEX IF NOT EXISTS idx_ventas_mesa ON ventas(mesa)');

    // Caja y arqueo
    await pool.query(`
        CREATE TABLE IF NOT EXISTS caja_turnos (
            id SERIAL PRIMARY KEY,
            fecha_apertura TIMESTAMP NOT NULL DEFAULT NOW(),
            fecha_cierre TIMESTAMP,
            saldo_inicial NUMERIC(12,2) NOT NULL DEFAULT 0,
            saldo_final NUMERIC(12,2),
            usuario_apertura TEXT,
            usuario_cierre TEXT,
            estado VARCHAR(20) NOT NULL DEFAULT 'ABIERTA'
        )
    `);
    await pool.query(`
        CREATE TABLE IF NOT EXISTS caja_movimientos (
            id SERIAL PRIMARY KEY,
            turno_id INTEGER NOT NULL REFERENCES caja_turnos(id) ON DELETE CASCADE,
            tipo VARCHAR(20) NOT NULL,
            metodo_pago VARCHAR(30),
            monto NUMERIC(12,2) NOT NULL,
            referencia TEXT,
            usuario TEXT,
            venta_id INTEGER,
            fecha TIMESTAMP NOT NULL DEFAULT NOW()
        )
    `);
    await pool.query('CREATE INDEX IF NOT EXISTS idx_caja_turno ON caja_movimientos(turno_id)');
    await pool.query('CREATE INDEX IF NOT EXISTS idx_caja_mov_fecha ON caja_movimientos(fecha)');

    await pool.query(`
        CREATE TABLE IF NOT EXISTS caja_cierres (
            id SERIAL PRIMARY KEY,
            turno_id INTEGER NOT NULL REFERENCES caja_turnos(id) ON DELETE CASCADE,
            resumen JSONB NOT NULL,
            ventas JSONB NOT NULL,
            movimientos JSONB NOT NULL,
            fecha_cierre TIMESTAMP NOT NULL DEFAULT NOW()
        )
    `);
    await pool.query('CREATE INDEX IF NOT EXISTS idx_caja_cierres_turno ON caja_cierres(turno_id)');
    await pool.query('CREATE INDEX IF NOT EXISTS idx_caja_cierres_fecha ON caja_cierres(fecha_cierre)');

    // Gastos administrativos/facturas (descuentan la ganancia mensual)
    await pool.query(`
        CREATE TABLE IF NOT EXISTS gastos_mensuales (
            id SERIAL PRIMARY KEY,
            fecha DATE NOT NULL,
            descripcion TEXT NOT NULL,
            monto NUMERIC(12,2) NOT NULL,
            categoria VARCHAR(80),
            caja_origen VARCHAR(20) NOT NULL DEFAULT 'CAJA_LOCAL',
            proveedor TEXT,
            factura_url TEXT,
            usuario TEXT,
            created_at TIMESTAMP NOT NULL DEFAULT NOW()
        )
    `);
    await pool.query('CREATE INDEX IF NOT EXISTS idx_gastos_mensuales_fecha ON gastos_mensuales(fecha)');
    await pool.query('CREATE INDEX IF NOT EXISTS idx_gastos_mensuales_caja ON gastos_mensuales(caja_origen)');

    // Caja chica: solo ahorros (no gastos operativos)
    await pool.query(`
        CREATE TABLE IF NOT EXISTS caja_chica_ahorros (
            id SERIAL PRIMARY KEY,
            fecha DATE NOT NULL,
            monto NUMERIC(12,2) NOT NULL,
            referencia TEXT,
            comprobante_url TEXT,
            usuario TEXT,
            created_at TIMESTAMP NOT NULL DEFAULT NOW()
        )
    `);
    await pool.query('CREATE INDEX IF NOT EXISTS idx_caja_chica_ahorros_fecha ON caja_chica_ahorros(fecha)');
    // Agregar columna comprobante_url si no existe
    await pool.query(`ALTER TABLE caja_chica_ahorros ADD COLUMN IF NOT EXISTS comprobante_url TEXT`);

    // Bodega (inventario separado)
    await pool.query(`
        CREATE TABLE IF NOT EXISTS bodega_insumos (
            id SERIAL PRIMARY KEY,
            nombre VARCHAR(120) NOT NULL,
            stock_actual NUMERIC(12,3) NOT NULL DEFAULT 0,
            unidad_medida VARCHAR(20) NOT NULL,
            stock_minimo NUMERIC(12,3) NOT NULL DEFAULT 0
        )
    `);
    await pool.query(`
        CREATE TABLE IF NOT EXISTS bodega_productos (
            id SERIAL PRIMARY KEY,
            nombre VARCHAR(120) NOT NULL,
            precio NUMERIC(12,2) NOT NULL DEFAULT 0,
            id_categoria INTEGER,
            es_preparado BOOLEAN NOT NULL DEFAULT true,
            image_url TEXT
        )
    `);
    await pool.query(`
        CREATE TABLE IF NOT EXISTS bodega_movimientos (
            id SERIAL PRIMARY KEY,
            insumo_id INTEGER REFERENCES bodega_insumos(id) ON DELETE SET NULL,
            tipo VARCHAR(20) NOT NULL,
            cantidad NUMERIC(12,3) NOT NULL,
            unidad_medida TEXT NOT NULL,
            motivo TEXT,
            referencia TEXT,
            usuario TEXT,
            fecha TIMESTAMP NOT NULL DEFAULT NOW()
        )
    `);

        // Productos base que también se venden desde insumos
        await pool.query(
                `INSERT INTO productos (nombre, precio, id_categoria, es_preparado, stock_actual, unidad_medida, stock_minimo)
                 SELECT TRIM(i.nombre), 0, NULL, false, i.stock_actual, i.unidad_medida, i.stock_minimo
                 FROM insumos i
                 WHERE (
                        LOWER(TRIM(i.nombre)) LIKE '%pipa%'
                        OR LOWER(TRIM(i.nombre)) LIKE '%caña%'
                        OR LOWER(TRIM(i.nombre)) LIKE '%cana%'
                        OR LOWER(TRIM(i.nombre)) = LOWER('Pipa de Coco (Entera)')
                        OR LOWER(TRIM(i.nombre)) = LOWER('Agua de Coco')
                        OR LOWER(TRIM(i.nombre)) = LOWER('Agua sin gas')
                        OR LOWER(TRIM(i.nombre)) = LOWER('Ron')
                 )
                     AND NOT EXISTS (
                         SELECT 1 FROM productos p WHERE LOWER(TRIM(p.nombre)) = LOWER(TRIM(i.nombre))
                     )`
        );

        // Insumo base: Agua de Coco (botellas)
        await pool.query(
            `INSERT INTO insumos (nombre, stock_actual, unidad_medida, stock_minimo)
             SELECT 'Agua de Coco', 0, 'UND', 0
             WHERE NOT EXISTS (SELECT 1 FROM insumos WHERE LOWER(nombre) = LOWER('Agua de Coco'))`
        );
        await pool.query(
            `UPDATE insumos SET unidad_medida = 'UND'
             WHERE LOWER(nombre) = LOWER('Agua de Coco')`
        );

        // Insumo base: Agua sin gas (botellas)
        await pool.query(
            `INSERT INTO insumos (nombre, stock_actual, unidad_medida, stock_minimo)
             SELECT 'Agua sin gas', 0, 'UND', 0
             WHERE NOT EXISTS (SELECT 1 FROM insumos WHERE LOWER(nombre) = LOWER('Agua sin gas'))`
        );
        await pool.query(
            `UPDATE insumos SET unidad_medida = 'UND'
             WHERE LOWER(nombre) = LOWER('Agua sin gas')`
        );

        // Insumo base: Ron (ml)
        await pool.query(
            `INSERT INTO insumos (nombre, stock_actual, unidad_medida, stock_minimo)
             SELECT 'Ron', 0, 'ML', 0
             WHERE NOT EXISTS (SELECT 1 FROM insumos WHERE LOWER(nombre) = LOWER('Ron'))`
        );
        await pool.query(
            `UPDATE insumos SET unidad_medida = 'ML'
             WHERE LOWER(nombre) = LOWER('Ron')`
        );

        // Insumo base: Whisky
        await pool.query(
            `INSERT INTO insumos (nombre, stock_actual, unidad_medida, stock_minimo)
             SELECT 'Whisky', 0, 'ML', 0
             WHERE NOT EXISTS (SELECT 1 FROM insumos WHERE LOWER(nombre) = LOWER('Whisky'))`
        );

        // Producto base: WhiskyCoco
        await pool.query(
            `INSERT INTO productos (nombre, precio, id_categoria, es_preparado, stock_actual, unidad_medida, stock_minimo)
             SELECT 'WhiskyCoco', 0, NULL, true, 0, 'UND', 0
             WHERE NOT EXISTS (SELECT 1 FROM productos WHERE LOWER(nombre) = LOWER('WhiskyCoco'))`
        );

        // Producto base: Helado + Topping
        await pool.query(
            `INSERT INTO productos (nombre, precio, id_categoria, es_preparado, stock_actual, unidad_medida, stock_minimo)
             SELECT 'Helado + Topping', 3.50, NULL, false, 0, 'UND', 0
             WHERE NOT EXISTS (SELECT 1 FROM productos WHERE LOWER(nombre) = LOWER('Helado + Topping'))`
        );

        // Limpiar stock de productos que dependen solo de insumos
        await pool.query(
            `UPDATE productos
             SET stock_actual = 0, stock_minimo = 0
             WHERE LOWER(nombre) LIKE '%smoothie%'
            OR LOWER(nombre) LIKE '%combo%'
            OR LOWER(nombre) LIKE '%coco loco%'
            OR LOWER(nombre) LIKE '%guarapo%'
            OR LOWER(nombre) LIKE '%coco y cana%'
            OR LOWER(nombre) LIKE '%coco cana%'
            OR LOWER(nombre) LIKE '%coco & cana%'`
        );

    // Facturas / Recibos
    await pool.query(`
        CREATE TABLE IF NOT EXISTS facturas (
            id SERIAL PRIMARY KEY,
            numero VARCHAR(30) NOT NULL UNIQUE,
            venta_id INTEGER REFERENCES ventas(id) ON DELETE SET NULL,
            tipo VARCHAR(20) NOT NULL DEFAULT 'RECIBO',
            fecha TIMESTAMP NOT NULL DEFAULT NOW(),
            cliente_nombre VARCHAR(200) NOT NULL DEFAULT 'Consumidor Final',
            cliente_identificacion VARCHAR(50) DEFAULT '9999999999999',
            cliente_direccion TEXT,
            cliente_telefono VARCHAR(50),
            cliente_email VARCHAR(120),
            subtotal NUMERIC(12,2) NOT NULL DEFAULT 0,
            impuesto_pct NUMERIC(5,2) NOT NULL DEFAULT 0,
            impuesto_monto NUMERIC(12,2) NOT NULL DEFAULT 0,
            total NUMERIC(12,2) NOT NULL DEFAULT 0,
            metodo_pago VARCHAR(30),
            estado VARCHAR(20) NOT NULL DEFAULT 'EMITIDA',
            notas TEXT,
            usuario TEXT,
            anulada_motivo TEXT,
            anulada_fecha TIMESTAMP,
            impresa BOOLEAN NOT NULL DEFAULT false
        )
    `);
    await pool.query('CREATE INDEX IF NOT EXISTS idx_facturas_numero ON facturas(numero)');
    await pool.query('CREATE INDEX IF NOT EXISTS idx_facturas_venta ON facturas(venta_id)');
    await pool.query('CREATE INDEX IF NOT EXISTS idx_facturas_fecha ON facturas(fecha)');
    await pool.query('CREATE INDEX IF NOT EXISTS idx_facturas_estado ON facturas(estado)');

    await pool.query(`
        CREATE TABLE IF NOT EXISTS facturas_items (
            id SERIAL PRIMARY KEY,
            factura_id INTEGER NOT NULL REFERENCES facturas(id) ON DELETE CASCADE,
            producto_id INTEGER,
            nombre TEXT NOT NULL,
            cantidad NUMERIC(12,2) NOT NULL,
            precio_unitario NUMERIC(12,2) NOT NULL,
            subtotal NUMERIC(12,2) NOT NULL
        )
    `);
    await pool.query('CREATE INDEX IF NOT EXISTS idx_facturas_items_factura ON facturas_items(factura_id)');

    // Configuración impresora
    await pool.query(`
        CREATE TABLE IF NOT EXISTS config_impresora (
            id SERIAL PRIMARY KEY,
            nombre_impresora TEXT NOT NULL DEFAULT '',
            tipo VARCHAR(20) NOT NULL DEFAULT 'TERMICA',
            ancho_mm INTEGER NOT NULL DEFAULT 80,
            auto_imprimir BOOLEAN NOT NULL DEFAULT false,
            updated_at TIMESTAMP NOT NULL DEFAULT NOW()
        )
    `);
    await pool.query(`
        INSERT INTO config_impresora (id, nombre_impresora, tipo, ancho_mm, auto_imprimir)
        SELECT 1, '', 'TERMICA', 80, false
        WHERE NOT EXISTS (SELECT 1 FROM config_impresora WHERE id = 1)
    `);

    // Secuencia de factura
    await pool.query(`
        CREATE TABLE IF NOT EXISTS facturas_secuencia (
            id SERIAL PRIMARY KEY,
            prefijo VARCHAR(10) NOT NULL DEFAULT 'REC',
            siguiente INTEGER NOT NULL DEFAULT 1
        )
    `);
    await pool.query(`
        INSERT INTO facturas_secuencia (id, prefijo, siguiente)
        SELECT 1, 'REC', 1
        WHERE NOT EXISTS (SELECT 1 FROM facturas_secuencia WHERE id = 1)
    `);
}

const esProductoSoloInsumos = (nombreNorm) => {
    return (
        nombreNorm.includes('smoothie') ||
        nombreNorm.includes('combo') ||
        nombreNorm.includes('coco loco') ||
        nombreNorm.includes('guarapo') ||
        nombreNorm.includes('coco y cana') ||
        nombreNorm.includes('coco cana') ||
        nombreNorm.includes('coco & cana')
    );
};

const usaStockProductoDirecto = (nombreNorm) => {
    return nombreNorm.includes('paleta') || nombreNorm.includes('coco relleno') || nombreNorm.includes('vaso con pulpa');
};

async function calcularEgresosPorItems(client, items, opciones = { throwOnMissing: true }) {
    const AGUA_ONZA_ML = 29.57;
    const insumosRes = await client.query('SELECT id, nombre, unidad_medida, stock_actual FROM insumos');
    const insumos = insumosRes.rows;
    const insumosMap = new Map(insumos.map((i) => [normalizeName(i.nombre), i]));
    const panYuca = insumos.find((i) => normalizeName(i.nombre).includes('pan de yuca'));
    const jugoCana = insumos.find((i) => normalizeName(i.nombre).includes('jugo de cana'));
    const pipaCoco = insumos.find((i) => normalizeName(i.nombre).includes('pipa de coco'));
    const canaManabita = insumos.find((i) => normalizeName(i.nombre).includes('cana manabita'));
    const whisky = insumos.find((i) => normalizeName(i.nombre).includes('whisky'));
    const ron = insumos.find((i) => normalizeName(i.nombre).includes('ron'));
    const hielo = insumos.find((i) => normalizeName(i.nombre).includes('hielo'));
    const agua = insumos.find((i) => normalizeName(i.nombre).includes('agua purificada'));
    const aguaCoco = insumosMap.get(normalizeName('Agua de Coco')) || insumos.find((i) => normalizeName(i.nombre).includes('agua de coco'));
    const aguaSinGas = insumosMap.get(normalizeName('Agua sin gas')) || insumos.find((i) => normalizeName(i.nombre).includes('agua sin gas'));
    const limon = insumos.find((i) => {
        const nombre = normalizeName(i.nombre);
        return nombre.includes('limon') || nombre.includes('limón');
    });
    const cremas = insumos
        .filter((i) => normalizeName(i.nombre).startsWith('crema de'))
        .map((i) => ({
            ...i,
            clave: normalizeName(i.nombre)
                .replace('crema de', '')
                .replace('(porcion)', '')
                .replace('(porcion)', '')
                .replace(/\(|\)/g, '')
                .trim()
        }));

    const productosRes = await client.query('SELECT id, nombre, es_preparado, stock_actual FROM productos');
    const productos = productosRes.rows;
    const productosMap = new Map(productos.map((p) => [Number(p.id), p]));
    const productosByName = new Map(productos.map((p) => [normalizeName(p.nombre), p]));

    const productosUsanInsumoStock = new Set([
        'pipa de coco',
        'pipa de coco (entera)',
        'porcion pan de yuca (unitario)',
        'pan de yuca',
        'pan de yuca (crudo/congelado)',
        'jugo de cana',
        'ron'
    ]);

    const acumulado = new Map();
    const acumuladoProductos = new Map();
    const faltantes = new Set();

    const agregarInsumo = (insumo, cantidad) => {
        if (!insumo || !cantidad) return;
        const key = insumo.id;
        acumulado.set(key, {
            insumo,
            cantidad: (acumulado.get(key)?.cantidad || 0) + Number(cantidad)
        });
    };

    const agregarProducto = (producto, cantidad) => {
        if (!producto || !cantidad) return;
        const key = producto.id;
        acumuladoProductos.set(key, {
            producto,
            cantidad: (acumuladoProductos.get(key)?.cantidad || 0) + Number(cantidad)
        });
    };

    const tokensProducto = (nombre) => normalizeName(nombre).split(/[\s\-+&/]+/).filter(Boolean);
    const smoothiesEspeciales = new Set([
        'pina coco',
        'coco cana',
        'coco & cana',
        'coco y cana',
        'limonada de coco',
        'aranda coco',
        'arandano coco',
        'coco cafe',
        'coco coffee',
        'coco coffe',
        'jugo de coco'
    ]);
    const esSmoothieNombre = (nombre) => {
        const n = normalizeName(nombre);
        return n.includes('smoothie') || n.includes('-') || smoothiesEspeciales.has(n);
    };

    const aplicarRecetaHeuristica = (nombreProducto, esPreparado, cantidadItem, agregarInsumoFn) => {
        const nombreNorm = normalizeName(nombreProducto);
        const onzas = AGUA_ONZA_ML;

        if (nombreNorm.includes('limonada de coco')) {
            const cremaCoco = cremas.find((c) => c.clave && normalizeName(c.clave).includes('coco'));
            if (cremaCoco) {
                agregarInsumoFn(cremaCoco, cantidadItem);
            } else {
                faltantes.add('Insumo faltante: Crema de Coco');
            }
            if (limon) {
                agregarInsumoFn(limon, cantidadItem);
            } else {
                faltantes.add('Insumo faltante: Limón');
            }
            return;
        }

        if (nombreNorm.includes('jugo de coco')) {
            const cremaCoco = cremas.find((c) => c.clave && normalizeName(c.clave).includes('coco'));
            if (cremaCoco) {
                agregarInsumoFn(cremaCoco, cantidadItem);
            } else {
                faltantes.add('Insumo faltante: Crema de Coco');
            }
            if (!hielo) {
                faltantes.add('Insumo faltante: Hielo');
            } else {
                agregarInsumoFn(hielo, cantidadItem);
            }
            return;
        }

        if (nombreNorm.includes('coco y cana') || nombreNorm.includes('coco cana') || nombreNorm.includes('coco & cana')) {
            const cremaCoco = cremas.find((c) => c.clave && normalizeName(c.clave).includes('coco'));
            if (cremaCoco) {
                agregarInsumoFn(cremaCoco, cantidadItem);
            } else {
                faltantes.add('Insumo faltante: Crema de Coco');
            }
            if (jugoCana) {
                agregarInsumoFn(jugoCana, cantidadItem);
            } else {
                faltantes.add('Insumo faltante: Jugo de Caña');
            }
            return;
        }

        if (nombreNorm.includes('agua de coco')) {
            if (aguaCoco) {
                agregarInsumoFn(aguaCoco, cantidadItem);
            } else {
                faltantes.add('Insumo faltante: Agua de Coco');
            }
            return;
        }

        if (nombreNorm.includes('agua sin gas')) {
            if (aguaSinGas) {
                agregarInsumoFn(aguaSinGas, cantidadItem);
            } else {
                faltantes.add('Insumo faltante: Agua sin gas');
            }
            return;
        }

        if (nombreNorm === 'ron') {
            if (ron) {
                agregarInsumoFn(ron, 59.1470591 * cantidadItem);
            } else {
                faltantes.add('Insumo faltante: Ron');
            }
            return;
        }

        if (usaStockProductoDirecto(nombreNorm)) {
            return;
        }

        if (nombreNorm.includes('whiskycoco') || nombreNorm.includes('whisky coco')) {
            if (pipaCoco) agregarInsumoFn(pipaCoco, cantidadItem);
            else faltantes.add('Insumo faltante: Pipa de Coco');
            if (whisky) agregarInsumoFn(whisky, 5.5 * onzas * cantidadItem);
            else faltantes.add('Insumo faltante: Whisky');
            return;
        }

        if (nombreNorm.includes('coco loco')) {
            if (pipaCoco) agregarInsumoFn(pipaCoco, cantidadItem);
            else faltantes.add('Insumo faltante: Pipa de Coco');
            if (canaManabita) agregarInsumoFn(canaManabita, 5.5 * onzas * cantidadItem);
            else faltantes.add('Insumo faltante: Caña Manabita');
            return;
        }

        if (nombreNorm.includes('guarapo')) {
            if (jugoCana) agregarInsumoFn(jugoCana, cantidadItem);
            else faltantes.add('Insumo faltante: Jugo de Caña');
            if (canaManabita) agregarInsumoFn(canaManabita, 4 * onzas * cantidadItem);
            else faltantes.add('Insumo faltante: Caña Manabita');
            return;
        }

        if (esSmoothieNombre(nombreProducto)) {
            const tokens = tokensProducto(nombreProducto);
            let cremaEncontrada = false;
            cremas.forEach((crema) => {
                if (!crema.clave) return;
                if (tokens.some((t) => crema.clave.includes(t) || t.includes(crema.clave)) || nombreNorm.includes(crema.clave)) {
                    agregarInsumoFn(crema, cantidadItem);
                    cremaEncontrada = true;
                }
            });

            if (!cremaEncontrada) {
                faltantes.add(`No se encontró crema para smoothie: ${nombreProducto}`);
            }

            if (!hielo) {
                faltantes.add('Insumo faltante: Hielo');
            } else {
                agregarInsumoFn(hielo, cantidadItem);
            }

            if (!agua) {
                faltantes.add('Insumo faltante: Agua Purificada');
            } else {
                agregarInsumoFn(agua, cantidadItem * AGUA_ONZA_ML);
            }
            return;
        }

        if (!esPreparado || nombreNorm.includes('jugo de cana')) {
            if (nombreNorm.includes('jugo de cana')) {
                if (jugoCana) {
                    agregarInsumoFn(jugoCana, cantidadItem);
                } else {
                    faltantes.add('Insumo faltante: Jugo de Caña');
                }
                return;
            }
            const directo = insumosMap.get(nombreNorm);
            if (directo) {
                agregarInsumoFn(directo, cantidadItem);
            }
            return;
        }

        if (!esSmoothieNombre(nombreProducto)) {
            const directo = insumosMap.get(nombreNorm);
            if (directo) {
                agregarInsumoFn(directo, cantidadItem);
            }
        }
    };

    for (const item of items) {
        const itemName = normalizeName(item.nombre);
        const cantidadItem = Number(item.cantidad || 1);
        let insumoAplicado = false;
        const agregarInsumoLocal = (insumo, cantidad) => {
            insumoAplicado = true;
            agregarInsumo(insumo, cantidad);
        };

        if (itemName.includes('combo personal')) {
            if (panYuca) {
                agregarInsumoLocal(panYuca, 5 * cantidadItem);
            } else {
                faltantes.add('Insumo faltante: Pan de Yuca');
            }
            const partes = item.nombre.split('+').map((p) => p.trim());
            const smoothies = partes.slice(1);
            smoothies.forEach((nombre) => aplicarRecetaHeuristica(nombre, true, cantidadItem, agregarInsumoLocal));
            continue;
        }
        if (itemName.includes('combo duo') || itemName.includes('combo duo') || itemName.includes('combo dúo')) {
            if (panYuca) {
                agregarInsumoLocal(panYuca, 8 * cantidadItem);
            } else {
                faltantes.add('Insumo faltante: Pan de Yuca');
            }
            const partes = item.nombre.split('+').map((p) => p.trim());
            const smoothies = partes.slice(1);
            smoothies.forEach((nombre) => aplicarRecetaHeuristica(nombre, true, cantidadItem, agregarInsumoLocal));
            continue;
        }

        const producto = item.producto_id ? productosMap.get(Number(item.producto_id)) : productosByName.get(itemName);
        if (producto) {
            const esPreparado = Boolean(producto.es_preparado);
            const nombreNorm = normalizeName(producto.nombre);
            const esSoloInsumos = esProductoSoloInsumos(nombreNorm);
            const insumoDirecto = insumosMap.get(nombreNorm);

            if (usaStockProductoDirecto(nombreNorm)) {
                agregarProducto(producto, cantidadItem);
            }

            aplicarRecetaHeuristica(producto.nombre, esPreparado, cantidadItem, agregarInsumoLocal);

            if (!esSoloInsumos && !productosUsanInsumoStock.has(nombreNorm) && !insumoAplicado && !insumoDirecto && !usaStockProductoDirecto(nombreNorm)) {
                agregarProducto(producto, cantidadItem);
            }
            continue;
        }
        faltantes.add(`Producto no encontrado: ${item.nombre}`);
    }

    if (faltantes.size && opciones.throwOnMissing) {
        throw new Error(Array.from(faltantes).join(' | '));
    }

    return { acumulado, acumuladoProductos, faltantes };
}

async function registrarEgresosPorVenta(client, venta, items) {
    if (!venta || !items || !items.length) return;

    const { acumulado, acumuladoProductos, faltantes } = await calcularEgresosPorItems(client, items, { throwOnMissing: true });
    if (faltantes.size) {
        throw new Error(Array.from(faltantes).join(' | '));
    }

    for (const { insumo, cantidad } of acumulado.values()) {
        const nuevoStock = Number(insumo.stock_actual ?? 0) - Number(cantidad || 0);
        if (nuevoStock < 0) {
            throw new Error(`Stock insuficiente para ${insumo.nombre}`);
        }
        await client.query('UPDATE insumos SET stock_actual = $1 WHERE id = $2', [nuevoStock, insumo.id]);
        await client.query(
            `INSERT INTO movimientos_inventario (insumo_id, tipo, cantidad, unidad_medida, motivo, referencia, usuario)
             VALUES ($1, 'EGRESO', $2, $3, $4, $5, $6)`,
            [
                insumo.id,
                Number(cantidad || 0),
                insumo.unidad_medida,
                'VENTA',
                `VENTA:${venta.id}`,
                venta.usuario || null
            ]
        );
    }

    for (const { producto, cantidad } of acumuladoProductos.values()) {
        const nuevoStockProducto = Number(producto.stock_actual ?? 0) - Number(cantidad || 0);
        if (nuevoStockProducto < 0) {
            throw new Error(`Stock insuficiente para producto: ${producto.nombre}`);
        }
        await client.query('UPDATE productos SET stock_actual = $1 WHERE id = $2', [nuevoStockProducto, producto.id]);
    }

    // Sincronizar stock de productos con insumos equivalentes
    await client.query(
        `UPDATE productos p
         SET stock_actual = i.stock_actual,
             unidad_medida = i.unidad_medida,
             stock_minimo = i.stock_minimo
         FROM insumos i
         WHERE LOWER(TRIM(p.nombre)) = LOWER(TRIM(i.nombre))
           AND (
             LOWER(TRIM(i.nombre)) LIKE '%pipa%'
             OR LOWER(TRIM(i.nombre)) LIKE '%caña%'
             OR LOWER(TRIM(i.nombre)) LIKE '%cana%'
             OR LOWER(TRIM(i.nombre)) = LOWER('Pipa de Coco (Entera)')
             OR LOWER(TRIM(i.nombre)) = LOWER('Agua de Coco')
                         OR LOWER(TRIM(i.nombre)) = LOWER('Agua sin gas')
                         OR LOWER(TRIM(i.nombre)) = LOWER('Ron')
           )`
    );
}

async function revertirEgresosPorVenta(client, items) {
    if (!items || !items.length) return;
    const { acumulado, acumuladoProductos } = await calcularEgresosPorItems(client, items, { throwOnMissing: false });

    for (const { insumo, cantidad } of acumulado.values()) {
        const nuevoStock = Number(insumo.stock_actual ?? 0) + Number(cantidad || 0);
        await client.query('UPDATE insumos SET stock_actual = $1 WHERE id = $2', [nuevoStock, insumo.id]);
    }

    for (const { producto, cantidad } of acumuladoProductos.values()) {
        const nuevoStockProducto = Number(producto.stock_actual ?? 0) + Number(cantidad || 0);
        await client.query('UPDATE productos SET stock_actual = $1 WHERE id = $2', [nuevoStockProducto, producto.id]);
    }
}

// 1. Ruta de prueba
app.get('/', (req, res) => {
  res.send('Backend Coco y Caña Funcionando');
});

// 2. Ruta de Usuarios (ESTA ES LA QUE LLAMA EL LOGIN)
app.get('/api/usuarios', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM usuarios');
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al conectar BD' });
    }
});

// Clientes
app.get('/api/clientes', async (_req, res) => {
    try {
        const result = await pool.query('SELECT * FROM clientes ORDER BY nombre');
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al listar clientes' });
    }
});

app.post('/api/clientes', async (req, res) => {
    const { nombre, identificacion, telefono, email, direccion, notas } = req.body;
    if (!nombre) {
        return res.status(400).json({ error: 'Nombre es obligatorio' });
    }
    try {
        const result = await pool.query(
            `INSERT INTO clientes (nombre, identificacion, telefono, email, direccion, notas)
             VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
            [
                String(nombre).trim(),
                identificacion ? String(identificacion).trim() : null,
                telefono ? String(telefono).trim() : null,
                email ? String(email).trim() : null,
                direccion ? String(direccion).trim() : null,
                notas ? String(notas).trim() : null
            ]
        );
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al crear cliente' });
    }
});

app.put('/api/clientes/:id', async (req, res) => {
    const { id } = req.params;
    const { nombre, identificacion, telefono, email, direccion, notas } = req.body;
    if (!nombre) {
        return res.status(400).json({ error: 'Nombre es obligatorio' });
    }
    try {
        const result = await pool.query(
            `UPDATE clientes
             SET nombre = $1, identificacion = $2, telefono = $3, email = $4, direccion = $5, notas = $6
             WHERE id = $7 RETURNING *`,
            [
                String(nombre).trim(),
                identificacion ? String(identificacion).trim() : null,
                telefono ? String(telefono).trim() : null,
                email ? String(email).trim() : null,
                direccion ? String(direccion).trim() : null,
                notas ? String(notas).trim() : null,
                Number(id)
            ]
        );
        if (result.rowCount === 0) return res.status(404).json({ error: 'Cliente no encontrado' });
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al actualizar cliente' });
    }
});

app.delete('/api/clientes/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const result = await pool.query('DELETE FROM clientes WHERE id = $1 RETURNING *', [Number(id)]);
        if (result.rowCount === 0) return res.status(404).json({ error: 'Cliente no encontrado' });
        res.json({ success: true });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al eliminar cliente' });
    }
});

// Inventario - Insumos
app.get('/api/insumos', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM insumos ORDER BY id');
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al listar insumos' });
    }
});

app.post('/api/insumos', async (req, res) => {
    const { nombre, stock_actual, unidad_medida, stock_minimo } = req.body;
    if (!nombre || !unidad_medida) {
        return res.status(400).json({ error: 'Nombre y unidad_medida son obligatorios' });
    }
    try {
        const result = await pool.query(
            `INSERT INTO insumos (nombre, stock_actual, unidad_medida, stock_minimo)
             VALUES ($1, $2, $3, $4) RETURNING *`,
            [
                String(nombre).trim(),
                Number(stock_actual ?? 0),
                String(unidad_medida).trim(),
                Number(stock_minimo ?? 0)
            ]
        );
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al crear insumo' });
    }
});

app.delete('/api/insumos/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const result = await pool.query('DELETE FROM insumos WHERE id = $1 RETURNING *', [id]);
        if (result.rowCount === 0) return res.status(404).json({ error: 'Insumo no encontrado' });
        res.json({ success: true });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al eliminar insumo' });
    }
});

app.put('/api/insumos/:id', async (req, res) => {
    const { id } = req.params;
    const { nombre, stock_actual, unidad_medida, stock_minimo } = req.body;
    if (!nombre || !unidad_medida) {
        return res.status(400).json({ error: 'Nombre y unidad_medida son obligatorios' });
    }
    try {
        const result = await pool.query(
            `UPDATE insumos
             SET nombre = $1, stock_actual = $2, unidad_medida = $3, stock_minimo = $4
             WHERE id = $5 RETURNING *`,
            [
                String(nombre).trim(),
                Number(stock_actual ?? 0),
                String(unidad_medida).trim(),
                Number(stock_minimo ?? 0),
                id
            ]
        );
        if (result.rowCount === 0) return res.status(404).json({ error: 'Insumo no encontrado' });
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al actualizar insumo' });
    }
});

// Catálogo
app.get('/api/categorias', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM categorias ORDER BY id');
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al listar categorías' });
    }
});

// Productos
app.get('/api/productos', async (req, res) => {
    try {
                await pool.query(
                    `INSERT INTO productos (nombre, precio, id_categoria, es_preparado, stock_actual, unidad_medida, stock_minimo)
                     SELECT TRIM(i.nombre), 0, NULL, false, i.stock_actual, i.unidad_medida, i.stock_minimo
                         FROM insumos i
                         WHERE (
                                LOWER(TRIM(i.nombre)) LIKE '%pipa%'
                                OR LOWER(TRIM(i.nombre)) LIKE '%caña%'
                                OR LOWER(TRIM(i.nombre)) LIKE '%cana%'
                                OR LOWER(TRIM(i.nombre)) = LOWER('Pipa de Coco (Entera)')
                                OR LOWER(TRIM(i.nombre)) = LOWER('Agua de Coco')
                             OR LOWER(TRIM(i.nombre)) = LOWER('Agua sin gas')
                         )
                             AND NOT EXISTS (
                                 SELECT 1 FROM productos p WHERE LOWER(TRIM(p.nombre)) = LOWER(TRIM(i.nombre))
                             )`
                );
                await pool.query(
                        `UPDATE productos p
                         SET stock_actual = i.stock_actual,
                                 unidad_medida = i.unidad_medida,
                                 stock_minimo = i.stock_minimo
                         FROM insumos i
                         WHERE LOWER(TRIM(p.nombre)) = LOWER(TRIM(i.nombre))
                             AND (
                                 LOWER(TRIM(i.nombre)) LIKE '%pipa%'
                                 OR LOWER(TRIM(i.nombre)) LIKE '%caña%'
                                 OR LOWER(TRIM(i.nombre)) LIKE '%cana%'
                                 OR LOWER(TRIM(i.nombre)) = LOWER('Pipa de Coco (Entera)')
                                 OR LOWER(TRIM(i.nombre)) = LOWER('Agua de Coco')
                                 OR LOWER(TRIM(i.nombre)) = LOWER('Agua sin gas')
                             )`
                );
        const result = await pool.query(
            `SELECT p.*, c.nombre AS categoria_nombre
             FROM productos p
             LEFT JOIN categorias c ON c.id = p.id_categoria
             ORDER BY p.id`
        );
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al listar productos' });
    }
});

app.post('/api/productos', async (req, res) => {
    const { nombre, precio, id_categoria, es_preparado, stock_actual, unidad_medida, stock_minimo } = req.body;
    if (!nombre || precio === undefined || precio === null) {
        return res.status(400).json({ error: 'Nombre y precio son obligatorios' });
    }
    try {
        const precioValue = Number(precio);
        if (Number.isNaN(precioValue)) {
            return res.status(400).json({ error: 'Precio inválido' });
        }
        const result = await pool.query(
            `INSERT INTO productos (nombre, precio, id_categoria, es_preparado, stock_actual, unidad_medida, stock_minimo)
             VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
            [
                String(nombre).trim(),
                precioValue,
                id_categoria ? Number(id_categoria) : null,
                es_preparado === undefined ? true : Boolean(es_preparado),
                Number(stock_actual ?? 0),
                String(unidad_medida || 'UND').trim(),
                Number(stock_minimo ?? 0)
            ]
        );
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al crear producto' });
    }
});

app.delete('/api/productos/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const result = await pool.query('DELETE FROM productos WHERE id = $1 RETURNING *', [id]);
        if (result.rowCount === 0) return res.status(404).json({ error: 'Producto no encontrado' });
        res.json({ success: true });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al eliminar producto' });
    }
});

app.put('/api/productos/:id', async (req, res) => {
    const { id } = req.params;
    const { nombre, precio, id_categoria, es_preparado, stock_actual, unidad_medida, stock_minimo } = req.body;
    if (!nombre || precio === undefined || precio === null) {
        return res.status(400).json({ error: 'Nombre y precio son obligatorios' });
    }
    try {
        const result = await pool.query(
            `UPDATE productos
             SET nombre = $1, precio = $2, id_categoria = $3, es_preparado = $4,
                 stock_actual = $5, unidad_medida = $6, stock_minimo = $7
             WHERE id = $8 RETURNING *`,
            [
                String(nombre).trim(),
                Number(precio),
                id_categoria ? Number(id_categoria) : null,
                es_preparado === undefined ? true : Boolean(es_preparado),
                Number(stock_actual ?? 0),
                String(unidad_medida || 'UND').trim(),
                Number(stock_minimo ?? 0),
                id
            ]
        );
        if (result.rowCount === 0) return res.status(404).json({ error: 'Producto no encontrado' });
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al actualizar producto' });
    }
});

app.post('/api/productos/:id/imagen', upload.single('imagen'), async (req, res) => {
    const { id } = req.params;
    if (!req.file) return res.status(400).json({ error: 'Archivo requerido' });
    const imageUrl = `/uploads/${req.file.filename}`;
    try {
        const result = await pool.query(
            'UPDATE productos SET image_url = $1 WHERE id = $2 RETURNING *',
            [imageUrl, id]
        );
        if (result.rowCount === 0) return res.status(404).json({ error: 'Producto no encontrado' });
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al guardar imagen' });
    }
});

// Ventas
app.get('/api/ventas', async (req, res) => {
    const { estado, mesa, tipo, fecha, desde, hasta } = req.query;
    const filters = [];
    const values = [];
    let idx = 1;

    if (estado) {
        filters.push(`v.estado = $${idx++}`);
        values.push(String(estado));
    }
    if (mesa) {
        filters.push(`v.mesa = $${idx++}`);
        values.push(Number(mesa));
    }
    if (tipo) {
        filters.push(`v.tipo = $${idx++}`);
        values.push(String(tipo));
    }
    if (fecha) {
        filters.push(`DATE(v.fecha) = $${idx++}`);
        values.push(String(fecha));
    }
    if (desde) {
        filters.push(`v.fecha >= $${idx++}`);
        values.push(String(desde));
    }
    if (hasta) {
        filters.push(`v.fecha <= $${idx++}`);
        values.push(String(hasta));
    }

    const where = filters.length ? `WHERE ${filters.join(' AND ')}` : '';

    try {
        const result = await pool.query(
            `SELECT v.*,
                CASE
                    WHEN UPPER(COALESCE(v.metodo_pago, '')) = 'CREDITO' AND v.credito_fecha_pago IS NULL THEN false
                    ELSE COALESCE(v.credito_pagado, true)
                END AS credito_pagado,
                COALESCE(
                json_agg(
                    json_build_object(
                        'id', i.id,
                        'producto_id', i.producto_id,
                        'nombre', i.nombre,
                        'precio', i.precio,
                        'cantidad', i.cantidad,
                        'subtotal', i.subtotal,
                        'image_url', i.image_url
                    )
                ) FILTER (WHERE i.id IS NOT NULL), '[]'
            ) AS items
            FROM ventas v
            LEFT JOIN ventas_items i ON i.venta_id = v.id
            ${where}
            GROUP BY v.id
            ORDER BY v.fecha DESC`,
            values
        );
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al listar ventas' });
    }
});

app.get('/api/ventas/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const result = await pool.query(
            `SELECT v.*,
                CASE
                    WHEN UPPER(COALESCE(v.metodo_pago, '')) = 'CREDITO' AND v.credito_fecha_pago IS NULL THEN false
                    ELSE COALESCE(v.credito_pagado, true)
                END AS credito_pagado,
                COALESCE(
                json_agg(
                    json_build_object(
                        'id', i.id,
                        'producto_id', i.producto_id,
                        'nombre', i.nombre,
                        'precio', i.precio,
                        'cantidad', i.cantidad,
                        'subtotal', i.subtotal,
                        'image_url', i.image_url
                    )
                ) FILTER (WHERE i.id IS NOT NULL), '[]'
            ) AS items
            FROM ventas v
            LEFT JOIN ventas_items i ON i.venta_id = v.id
            WHERE v.id = $1
            GROUP BY v.id`,
            [Number(id)]
        );
        if (result.rowCount === 0) {
            return res.status(404).json({ error: 'Venta no encontrada' });
        }
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al obtener venta' });
    }
});

app.post('/api/ventas', async (req, res) => {
    const { tipo, canal, mesa, estado, metodo_pago, total, subtotal, impuesto_pct, impuesto_monto, notas, usuario, cliente_id, items, pagos_divididos } = req.body;
    if (!tipo || !estado) {
        return res.status(400).json({ error: 'Tipo y estado son obligatorios' });
    }
    if (!Array.isArray(items) || items.length === 0) {
        return res.status(400).json({ error: 'La venta debe incluir items' });
    }

    const client = await pool.connect();
    try {
        await client.query('BEGIN');
        const ventaRes = await client.query(
            `INSERT INTO ventas (tipo, canal, mesa, estado, metodo_pago, total, subtotal, impuesto_pct, impuesto_monto, notas, usuario, cliente_id, credito_pagado)
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13) RETURNING *`,
            [
                String(tipo),
                String(canal || 'LOCAL'),
                mesa !== undefined && mesa !== null ? Number(mesa) : null,
                String(estado),
                metodo_pago ? String(metodo_pago) : null,
                Number(total || 0),
                Number(subtotal || 0),
                Number(impuesto_pct || 0),
                Number(impuesto_monto || 0),
                notas ? String(notas) : null,
                usuario ? String(usuario) : null,
                cliente_id ? Number(cliente_id) : null,
                String(metodo_pago || '').toUpperCase() === 'CREDITO' ? false : true
            ]
        );
        const venta = ventaRes.rows[0];

        const values = [];
        const placeholders = [];
        let idx = 1;
        items.forEach((item) => {
            placeholders.push(`($${idx++}, $${idx++}, $${idx++}, $${idx++}, $${idx++}, $${idx++}, $${idx++})`);
            values.push(
                venta.id,
                item.producto_id ?? null,
                String(item.nombre || ''),
                Number(item.precio || 0),
                Number(item.cantidad || 0),
                Number(item.subtotal || 0),
                item.image_url ? String(item.image_url) : null
            );
        });
        await client.query(
            `INSERT INTO ventas_items (venta_id, producto_id, nombre, precio, cantidad, subtotal, image_url)
             VALUES ${placeholders.join(', ')}`,
            values
        );

        const metodoUpper = String(metodo_pago || '').toUpperCase();
        if (String(estado).toUpperCase() === 'PAGADA' || metodoUpper === 'CREDITO') {
            const turnoRes = await client.query(
                `SELECT * FROM caja_turnos WHERE estado = 'ABIERTA' ORDER BY fecha_apertura DESC LIMIT 1`
            );
            const turno = turnoRes.rows[0];
            if (turno && metodoUpper !== 'CREDITO') {
                if (metodoUpper === 'DIVIDIDO' && Array.isArray(pagos_divididos) && pagos_divididos.length) {
                    const suma = pagos_divididos.reduce((acc, p) => acc + Number(p.monto || 0), 0);
                    if (Math.abs(Number(total || 0) - suma) > 0.01) {
                        throw new Error('La suma de pagos divididos no coincide con el total.');
                    }
                    for (const pago of pagos_divididos) {
                        await client.query(
                            `INSERT INTO caja_movimientos (turno_id, tipo, metodo_pago, monto, referencia, usuario, venta_id)
                             VALUES ($1, 'VENTA', $2, $3, $4, $5, $6)`,
                            [
                                turno.id,
                                pago.metodo_pago ? String(pago.metodo_pago) : null,
                                Number(pago.monto || 0),
                                pago.referencia ? String(pago.referencia) : `Venta ${venta.id}`,
                                usuario ? String(usuario) : null,
                                venta.id
                            ]
                        );
                    }
                } else {
                    await client.query(
                        `INSERT INTO caja_movimientos (turno_id, tipo, metodo_pago, monto, referencia, usuario, venta_id)
                         VALUES ($1, 'VENTA', $2, $3, $4, $5, $6)`,
                        [
                            turno.id,
                            metodo_pago ? String(metodo_pago) : null,
                            Number(total || 0),
                            `Venta ${venta.id}`,
                            usuario ? String(usuario) : null,
                            venta.id
                        ]
                    );
                }
            }

            await registrarEgresosPorVenta(client, venta, items);
        }

        // Auto-generar factura para toda venta PAGADA
        if (String(estado).toUpperCase() === 'PAGADA') {
            try {
                await crearFacturaDesdeVenta(client, venta.id, { usuario: usuario || null });
            } catch (factErr) {
                console.error('Error auto-generando factura:', factErr.message);
            }
        }

        await client.query('COMMIT');
        res.json(venta);
    } catch (err) {
        await client.query('ROLLBACK');
        console.error(err);
        const message = err?.message || '';
        if (message.includes('Stock insuficiente')) {
            return res.status(400).json({ error: message });
        }
        res.status(500).json({ error: 'Error al crear venta' });
    } finally {
        client.release();
    }
});

app.put('/api/ventas/:id', async (req, res) => {
    const { id } = req.params;
    const { tipo, canal, mesa, estado, metodo_pago, total, subtotal, impuesto_pct, impuesto_monto, notas, usuario, cliente_id, items, pagos_divididos } = req.body;
    if (!tipo || !estado) {
        return res.status(400).json({ error: 'Tipo y estado son obligatorios' });
    }
    if (!Array.isArray(items)) {
        return res.status(400).json({ error: 'Items inválidos' });
    }

    const client = await pool.connect();
    try {
        await client.query('BEGIN');
        // FOR UPDATE bloquea la fila para evitar race conditions entre guardar y cobrar
        const prevVentaRes = await client.query('SELECT * FROM ventas WHERE id = $1 FOR UPDATE', [Number(id)]);
        if (prevVentaRes.rowCount === 0) {
            await client.query('ROLLBACK');
            return res.status(404).json({ error: 'Venta no encontrada' });
        }
        const prevVenta = prevVentaRes.rows[0];

        const estadoUpper = String(estado).toUpperCase();
        const prevEstadoUpper = String(prevVenta.estado || '').toUpperCase();

        // Impedir degradar una venta PAGADA a ABIERTA (race condition guardar/cobrar mesa)
        if (prevEstadoUpper === 'PAGADA' && estadoUpper === 'ABIERTA') {
            await client.query('ROLLBACK');
            return res.status(409).json({ error: 'La venta ya fue pagada, no se puede reabrir.' });
        }

        const prevItemsRes = await client.query('SELECT * FROM ventas_items WHERE venta_id = $1', [Number(id)]);
        const prevItems = prevItemsRes.rows;

        const prevMovRes = await client.query(
            'SELECT 1 FROM movimientos_inventario WHERE referencia = $1 LIMIT 1',
            [`VENTA:${id}`]
        );
        if (prevMovRes.rowCount > 0) {
            await revertirEgresosPorVenta(client, prevItems);
        }
        const marcarFechaPago = estadoUpper === 'PAGADA' && prevEstadoUpper !== 'PAGADA';

        const metodoPagoUpper = String(metodo_pago || '').toUpperCase();
        const prevMetodoUpper = String(prevVenta.metodo_pago || '').toUpperCase();
        let creditoPagado = true;
        let creditoMetodoPago = null;
        let creditoFechaPago = null;
        if (metodoPagoUpper === 'CREDITO') {
            if (prevMetodoUpper === 'CREDITO') {
                creditoPagado = Boolean(prevVenta.credito_pagado);
                creditoMetodoPago = prevVenta.credito_metodo_pago || null;
                creditoFechaPago = prevVenta.credito_fecha_pago || null;
            } else {
                creditoPagado = false;
            }
        }
        const updateRes = await client.query(
            `UPDATE ventas
             SET tipo = $1, canal = $2, mesa = $3, estado = $4, metodo_pago = $5,
                 total = $6, subtotal = $7, impuesto_pct = $8, impuesto_monto = $9,
                 notas = $10, usuario = $11, cliente_id = $12,
                 credito_pagado = $13, credito_metodo_pago = $14, credito_fecha_pago = $15,
                 fecha = CASE WHEN $16 THEN NOW() ELSE fecha END
             WHERE id = $17 RETURNING *`,
            [
                String(tipo),
                String(canal || 'LOCAL'),
                mesa !== undefined && mesa !== null ? Number(mesa) : null,
                String(estado),
                metodo_pago ? String(metodo_pago) : null,
                Number(total || 0),
                Number(subtotal || 0),
                Number(impuesto_pct || 0),
                Number(impuesto_monto || 0),
                notas ? String(notas) : null,
                usuario ? String(usuario) : null,
                cliente_id ? Number(cliente_id) : null,
                creditoPagado,
                creditoMetodoPago,
                creditoFechaPago,
                marcarFechaPago,
                Number(id)
            ]
        );
        if (updateRes.rowCount === 0) {
            await client.query('ROLLBACK');
            return res.status(404).json({ error: 'Venta no encontrada' });
        }

        await client.query('DELETE FROM ventas_items WHERE venta_id = $1', [Number(id)]);
        await client.query('DELETE FROM caja_movimientos WHERE venta_id = $1', [Number(id)]);
        await client.query('DELETE FROM movimientos_inventario WHERE referencia = $1', [`VENTA:${id}`]);

        if (items.length) {
            const values = [];
            const placeholders = [];
            let idx = 1;
            items.forEach((item) => {
                placeholders.push(`($${idx++}, $${idx++}, $${idx++}, $${idx++}, $${idx++}, $${idx++}, $${idx++})`);
                values.push(
                    Number(id),
                    item.producto_id ?? null,
                    String(item.nombre || ''),
                    Number(item.precio || 0),
                    Number(item.cantidad || 0),
                    Number(item.subtotal || 0),
                    item.image_url ? String(item.image_url) : null
                );
            });
            await client.query(
                `INSERT INTO ventas_items (venta_id, producto_id, nombre, precio, cantidad, subtotal, image_url)
                 VALUES ${placeholders.join(', ')}`,
                values
            );
        }

        if (String(estado).toUpperCase() === 'PAGADA' || metodoPagoUpper === 'CREDITO') {
            const turnoRes = await client.query(
                `SELECT * FROM caja_turnos WHERE estado = 'ABIERTA' ORDER BY fecha_apertura DESC LIMIT 1`
            );
            const turno = turnoRes.rows[0];
            if (turno && metodoPagoUpper !== 'CREDITO') {
                if (metodoPagoUpper === 'DIVIDIDO' && Array.isArray(pagos_divididos) && pagos_divididos.length) {
                    const suma = pagos_divididos.reduce((acc, p) => acc + Number(p.monto || 0), 0);
                    if (Math.abs(Number(total || 0) - suma) > 0.01) {
                        throw new Error('La suma de pagos divididos no coincide con el total.');
                    }
                    for (const pago of pagos_divididos) {
                        await client.query(
                            `INSERT INTO caja_movimientos (turno_id, tipo, metodo_pago, monto, referencia, usuario, venta_id)
                             VALUES ($1, 'VENTA', $2, $3, $4, $5, $6)`,
                            [
                                turno.id,
                                pago.metodo_pago ? String(pago.metodo_pago) : null,
                                Number(pago.monto || 0),
                                pago.referencia ? String(pago.referencia) : `Venta ${id}`,
                                usuario ? String(usuario) : null,
                                Number(id)
                            ]
                        );
                    }
                } else {
                    await client.query(
                        `INSERT INTO caja_movimientos (turno_id, tipo, metodo_pago, monto, referencia, usuario, venta_id)
                         VALUES ($1, 'VENTA', $2, $3, $4, $5, $6)`,
                        [
                            turno.id,
                            metodo_pago ? String(metodo_pago) : null,
                            Number(total || 0),
                            `Venta ${id}`,
                            usuario ? String(usuario) : null,
                            Number(id)
                        ]
                    );
                }
            }

            await registrarEgresosPorVenta(client, updateRes.rows[0], items);
        }

        // Auto-generar factura al pasar a PAGADA (si no tiene factura ya)
        if (estadoUpper === 'PAGADA' && prevEstadoUpper !== 'PAGADA') {
            const existeFactura = await client.query(
                'SELECT 1 FROM facturas WHERE venta_id = $1 AND estado != $2 LIMIT 1',
                [Number(id), 'ANULADA']
            );
            if (!existeFactura.rows.length) {
                try {
                    await crearFacturaDesdeVenta(client, Number(id), { usuario: usuario || null });
                } catch (factErr) {
                    console.error('Error auto-generando factura en update:', factErr.message);
                }
            }
        }

        await client.query('COMMIT');
        res.json(updateRes.rows[0]);
    } catch (err) {
        await client.query('ROLLBACK');
        console.error(err);
        const message = err?.message || '';
        if (message.includes('Stock insuficiente')) {
            return res.status(400).json({ error: message });
        }
        res.status(500).json({ error: 'Error al actualizar venta' });
    } finally {
        client.release();
    }
});

app.delete('/api/ventas/:id', async (req, res) => {
    const { id } = req.params;
    const client = await pool.connect();
    try {
        await client.query('BEGIN');
        const ventaRes = await client.query('SELECT * FROM ventas WHERE id = $1', [Number(id)]);
        if (ventaRes.rowCount === 0) {
            await client.query('ROLLBACK');
            return res.status(404).json({ error: 'Venta no encontrada' });
        }
        const venta = ventaRes.rows[0];
        const itemsRes = await client.query('SELECT * FROM ventas_items WHERE venta_id = $1', [Number(id)]);
        const items = itemsRes.rows;

        const movRes = await client.query(
            'SELECT 1 FROM movimientos_inventario WHERE referencia = $1 LIMIT 1',
            [`VENTA:${id}`]
        );
        if (movRes.rowCount > 0) {
            await revertirEgresosPorVenta(client, items);
        }

        await client.query('DELETE FROM ventas_items WHERE venta_id = $1', [Number(id)]);
        await client.query('DELETE FROM caja_movimientos WHERE venta_id = $1', [Number(id)]);
        await client.query('DELETE FROM movimientos_inventario WHERE referencia = $1', [`VENTA:${id}`]);
        await client.query('DELETE FROM ventas WHERE id = $1', [Number(id)]);

        await client.query('COMMIT');
        res.json({ success: true });
    } catch (err) {
        await client.query('ROLLBACK');
        console.error(err);
        res.status(500).json({ error: 'Error al eliminar venta' });
    } finally {
        client.release();
    }
});

app.post('/api/ventas/:id/cobrar-credito', async (req, res) => {
    const { id } = req.params;
    const { metodo_pago, usuario, referencia } = req.body;
    const metodoUpper = String(metodo_pago || '').toUpperCase();
    if (!metodoUpper || metodoUpper === 'CREDITO') {
        return res.status(400).json({ error: 'Metodo de pago inválido' });
    }
    const client = await pool.connect();
    try {
        await client.query('BEGIN');
        const ventaRes = await client.query('SELECT * FROM ventas WHERE id = $1', [Number(id)]);
        if (ventaRes.rowCount === 0) {
            await client.query('ROLLBACK');
            return res.status(404).json({ error: 'Venta no encontrada' });
        }
        const venta = ventaRes.rows[0];
        if (String(venta.metodo_pago || '').toUpperCase() !== 'CREDITO') {
            await client.query('ROLLBACK');
            return res.status(400).json({ error: 'La venta no es crédito' });
        }
        if (venta.credito_pagado) {
            await client.query('ROLLBACK');
            return res.status(400).json({ error: 'El crédito ya fue cobrado' });
        }

        const turnoRes = await client.query(
            `SELECT * FROM caja_turnos WHERE estado = 'ABIERTA' ORDER BY fecha_apertura DESC LIMIT 1`
        );
        const turno = turnoRes.rows[0];
        if (!turno) {
            await client.query('ROLLBACK');
            return res.status(400).json({ error: 'No hay caja abierta' });
        }

        await client.query(
            `INSERT INTO caja_movimientos (turno_id, tipo, metodo_pago, monto, referencia, usuario, venta_id)
             VALUES ($1, 'INGRESO', $2, $3, $4, $5, $6)`,
            [
                turno.id,
                metodoUpper,
                Number(venta.total || 0),
                referencia ? String(referencia) : `Cobro crédito venta ${venta.id}`,
                usuario ? String(usuario) : null,
                venta.id
            ]
        );

        await client.query(
            `UPDATE ventas
             SET credito_pagado = true, credito_metodo_pago = $1, credito_fecha_pago = NOW()
             WHERE id = $2`,
            [metodoUpper, venta.id]
        );

        await client.query('COMMIT');
        res.json({ success: true });
    } catch (err) {
        await client.query('ROLLBACK');
        console.error(err);
        res.status(500).json({ error: 'Error al cobrar crédito' });
    } finally {
        client.release();
    }
});

// Caja y arqueo
app.get('/api/caja/estado', async (_req, res) => {
    try {
        const turnoRes = await pool.query(
            `SELECT * FROM caja_turnos WHERE estado = 'ABIERTA' ORDER BY fecha_apertura DESC LIMIT 1`
        );
        const turno = turnoRes.rows[0] || null;
        if (!turno) {
            return res.json({ turno: null, ventas: [], movimientos: [], resumen: {} });
        }

        const ventasRes = await pool.query(
            `SELECT
                COALESCE(v.id, cm.venta_id) AS id,
                COALESCE(v.tipo, 'DIRECTA') AS tipo,
                COALESCE(v.canal, 'LOCAL') AS canal,
                cm.metodo_pago AS metodo_pago,
                cm.monto AS total,
                cm.fecha AS fecha
             FROM caja_movimientos cm
             LEFT JOIN ventas v ON v.id = cm.venta_id
                         WHERE cm.turno_id = $1
                             AND UPPER(TRIM(cm.tipo)) = 'VENTA'
             ORDER BY cm.fecha DESC`,
            [turno.id]
        );
        const movimientosRes = await pool.query(
            `SELECT * FROM caja_movimientos WHERE turno_id = $1 ORDER BY fecha DESC`,
            [turno.id]
        );

        const ventas = ventasRes.rows;
        const movimientos = movimientosRes.rows;
        const ventasMov = movimientos.filter(m => String(m.tipo || '').trim().toUpperCase() === 'VENTA');

        const resumenMetodos = ventasMov.reduce((acc, m) => {
            const key = String(m.metodo_pago || 'OTRO').toUpperCase();
            acc[key] = (acc[key] || 0) + Number(m.monto || 0);
            return acc;
        }, {});
        const totalVentas = ventasMov.reduce((acc, m) => acc + Number(m.monto || 0), 0);
        const totalEgresos = movimientos
            .filter(m => String(m.tipo || '').trim().toUpperCase() === 'EGRESO')
            .reduce((acc, m) => acc + Number(m.monto || 0), 0);
        const totalIngresos = movimientos
            .filter(m => String(m.tipo || '').trim().toUpperCase() === 'INGRESO')
            .reduce((acc, m) => acc + Number(m.monto || 0), 0);
        const totalNeto = totalVentas + totalIngresos - totalEgresos;

        res.json({
            turno,
            ventas,
            movimientos,
            resumen: {
                totalVentas,
                totalIngresos,
                totalEgresos,
                totalNeto,
                porMetodo: resumenMetodos
            }
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al obtener estado de caja' });
    }
});

app.get('/api/caja/historial', async (req, res) => {
    const limit = Number(req.query.limit || 20);
    try {
        const result = await pool.query(
            `SELECT t.*,
                COALESCE(SUM(v.total), 0) AS total_ventas,
                COALESCE(SUM(CASE WHEN UPPER(v.metodo_pago) = 'EFECTIVO' THEN v.total ELSE 0 END), 0) AS total_efectivo
             FROM caja_turnos t
             LEFT JOIN ventas v
               ON v.fecha >= t.fecha_apertura
              AND v.fecha <= t.fecha_cierre
             WHERE t.estado = 'CERRADA'
             GROUP BY t.id
             ORDER BY t.fecha_cierre DESC
             LIMIT $1`,
            [Number.isFinite(limit) && limit > 0 ? limit : 20]
        );
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al obtener historial de caja' });
    }
});

app.get('/api/caja/cierres', async (req, res) => {
    const { desde, hasta, usuario, metodo_pago, tipo_movimiento } = req.query;
    const filters = [`t.estado = 'CERRADA'`];
    const values = [];
    let idx = 1;

    if (desde) {
        filters.push(`t.fecha_cierre >= $${idx++}`);
        values.push(String(desde));
    }
    if (hasta) {
        filters.push(`t.fecha_cierre <= $${idx++}`);
        values.push(String(hasta));
    }
    if (usuario) {
        filters.push(`LOWER(COALESCE(t.usuario_cierre, '')) LIKE $${idx++}`);
        values.push(`%${String(usuario).toLowerCase()}%`);
    }

    const where = filters.length ? `WHERE ${filters.join(' AND ')}` : '';

    const metodoPagoFiltro = metodo_pago ? String(metodo_pago).trim().toUpperCase() : '';
    const tipoMovimientoFiltro = tipo_movimiento ? String(tipo_movimiento).trim().toUpperCase() : '';

    try {
        const turnosRes = await pool.query(
            `SELECT t.*
             FROM caja_turnos t
             ${where}
             ORDER BY t.fecha_cierre DESC`,
            values
        );

        const cierres = await Promise.all(
            turnosRes.rows.map(async (turno) => {
                const ventasRes = await pool.query(
                    `SELECT * FROM ventas WHERE fecha >= $1 AND fecha <= $2 ORDER BY fecha DESC`,
                    [turno.fecha_apertura, turno.fecha_cierre]
                );
                const movFilters = ['turno_id = $1'];
                const movValues = [turno.id];
                let movIdx = 2;
                if (tipoMovimientoFiltro) {
                    movFilters.push(`UPPER(COALESCE(tipo, '')) = $${movIdx++}`);
                    movValues.push(tipoMovimientoFiltro);
                }
                if (metodoPagoFiltro) {
                    movFilters.push(`UPPER(COALESCE(metodo_pago, '')) = $${movIdx++}`);
                    movValues.push(metodoPagoFiltro);
                }
                const movimientosRes = await pool.query(
                    `SELECT * FROM caja_movimientos WHERE ${movFilters.join(' AND ')} ORDER BY fecha DESC`,
                    movValues
                );
                const movimientos = movimientosRes.rows;
                if ((tipoMovimientoFiltro || metodoPagoFiltro) && movimientos.length === 0) {
                    return null;
                }
                const ventas = ventasRes.rows;
                const totalVentas = ventas.reduce((acc, v) => acc + Number(v.total || 0), 0);
                const totalEgresos = movimientos
                    .filter(m => String(m.tipo || '').trim().toUpperCase() === 'EGRESO')
                    .reduce((acc, m) => acc + Number(m.monto || 0), 0);
                const totalIngresos = movimientos
                    .filter(m => String(m.tipo || '').trim().toUpperCase() === 'INGRESO')
                    .reduce((acc, m) => acc + Number(m.monto || 0), 0);
                const totalNeto = totalVentas + totalIngresos - totalEgresos;

                return {
                    turno_id: turno.id,
                    resumen: {
                        totalVentas,
                        totalIngresos,
                        totalEgresos,
                        totalNeto,
                        saldo_final: Number(turno.saldo_final || 0)
                    },
                    ventas,
                    movimientos,
                    fecha_cierre: turno.fecha_cierre,
                    fecha_apertura: turno.fecha_apertura,
                    saldo_inicial: turno.saldo_inicial,
                    saldo_final: turno.saldo_final,
                    usuario_apertura: turno.usuario_apertura,
                    usuario_cierre: turno.usuario_cierre
                };
            })
        );

        res.json(cierres.filter(Boolean));
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al listar cierres' });
    }
});

app.post('/api/caja/abrir', async (req, res) => {
    const { saldo_inicial, usuario } = req.body;
    try {
        const existente = await pool.query(
            `SELECT * FROM caja_turnos WHERE estado = 'ABIERTA' ORDER BY fecha_apertura DESC LIMIT 1`
        );
        if (existente.rows.length) {
            return res.status(400).json({ error: 'Ya existe una caja abierta' });
        }
        const result = await pool.query(
            `INSERT INTO caja_turnos (saldo_inicial, usuario_apertura)
             VALUES ($1, $2) RETURNING *`,
            [Number(saldo_inicial || 0), usuario ? String(usuario) : null]
        );
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al abrir caja' });
    }
});

app.post('/api/caja/cerrar', async (req, res) => {
    const { turno_id, saldo_real, usuario } = req.body;
    if (!turno_id) {
        return res.status(400).json({ error: 'turno_id requerido' });
    }
    try {
        const result = await pool.query(
            `UPDATE caja_turnos
             SET fecha_cierre = NOW(), saldo_final = $1, usuario_cierre = $2, estado = 'CERRADA'
             WHERE id = $3 AND estado = 'ABIERTA' RETURNING *`,
            [Number(saldo_real || 0), usuario ? String(usuario) : null, Number(turno_id)]
        );
        if (result.rowCount === 0) {
            return res.status(404).json({ error: 'Caja abierta no encontrada' });
        }

        const ventasRes = await pool.query(
            `SELECT * FROM ventas WHERE fecha >= $1 AND fecha <= $2 ORDER BY fecha DESC`,
            [result.rows[0].fecha_apertura, result.rows[0].fecha_cierre]
        );
        const movimientosRes = await pool.query(
            `SELECT * FROM caja_movimientos WHERE turno_id = $1 ORDER BY fecha DESC`,
            [Number(turno_id)]
        );
        const movimientos = movimientosRes.rows;
        const ventas = ventasRes.rows;
        const totalVentas = movimientos
            .filter(m => String(m.tipo || '').trim().toUpperCase() === 'VENTA')
            .reduce((acc, m) => acc + Number(m.monto || 0), 0);
        const totalEgresos = movimientos
            .filter(m => String(m.tipo || '').trim().toUpperCase() === 'EGRESO')
            .reduce((acc, m) => acc + Number(m.monto || 0), 0);
        const totalIngresos = movimientos
            .filter(m => String(m.tipo || '').trim().toUpperCase() === 'INGRESO')
            .reduce((acc, m) => acc + Number(m.monto || 0), 0);
        const totalNeto = totalVentas + totalIngresos - totalEgresos;

        await pool.query(
            `INSERT INTO caja_cierres (turno_id, resumen, ventas, movimientos)
             VALUES ($1, $2, $3, $4)`,
            [
                Number(turno_id),
                { totalVentas, totalIngresos, totalEgresos, totalNeto, saldo_final: Number(saldo_real || 0) },
                ventas,
                movimientos
            ]
        );
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al cerrar caja' });
    }
});

app.put('/api/caja/saldo-inicial', async (req, res) => {
    const { turno_id, saldo_inicial } = req.body;
    if (!turno_id) {
        return res.status(400).json({ error: 'turno_id requerido' });
    }
    try {
        const result = await pool.query(
            `UPDATE caja_turnos
             SET saldo_inicial = $1
             WHERE id = $2 AND estado = 'ABIERTA' RETURNING *`,
            [Number(saldo_inicial || 0), Number(turno_id)]
        );
        if (result.rowCount === 0) {
            return res.status(404).json({ error: 'Caja abierta no encontrada' });
        }
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al actualizar saldo inicial' });
    }
});

app.get('/api/caja/historial/movimientos', async (req, res) => {
    const { desde, hasta, tipo, metodo, usuario, referencia } = req.query;
    const filters = [];
    const values = [];
    let idx = 1;

    if (desde) {
        filters.push(`m.fecha >= $${idx++}`);
        values.push(String(desde));
    }
    if (hasta) {
        filters.push(`m.fecha <= $${idx++}`);
        values.push(String(hasta));
    }
    if (tipo) {
        filters.push(`UPPER(TRIM(m.tipo)) = $${idx++}`);
        values.push(String(tipo).toUpperCase());
    }
    if (metodo) {
        filters.push(`UPPER(TRIM(m.metodo_pago)) = $${idx++}`);
        values.push(String(metodo).toUpperCase());
    }
    if (usuario) {
        filters.push(`LOWER(COALESCE(m.usuario, '')) LIKE $${idx++}`);
        values.push(`%${String(usuario).toLowerCase()}%`);
    }
    if (referencia) {
        filters.push(`LOWER(COALESCE(m.referencia, '')) LIKE $${idx++}`);
        values.push(`%${String(referencia).toLowerCase()}%`);
    }

    const where = filters.length ? `WHERE ${filters.join(' AND ')}` : '';

    try {
        const result = await pool.query(
            `SELECT m.*, t.fecha_apertura, t.fecha_cierre, t.estado AS turno_estado
             FROM caja_movimientos m
             JOIN caja_turnos t ON t.id = m.turno_id
             ${where}
             ORDER BY m.fecha DESC`,
            values
        );
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al listar historial de movimientos' });
    }
});

app.post('/api/caja/movimientos', async (req, res) => {
    const { turno_id, tipo, metodo_pago, monto, referencia, usuario } = req.body;
    if (!turno_id || !tipo || monto === undefined || monto === null) {
        return res.status(400).json({ error: 'turno_id, tipo y monto son obligatorios' });
    }
    const montoValue = Number(monto);
    if (Number.isNaN(montoValue) || montoValue <= 0) {
        return res.status(400).json({ error: 'Monto inválido' });
    }
    try {
        const result = await pool.query(
            `INSERT INTO caja_movimientos (turno_id, tipo, metodo_pago, monto, referencia, usuario)
             VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
            [
                Number(turno_id),
                String(tipo).toUpperCase(),
                metodo_pago ? String(metodo_pago) : null,
                montoValue,
                referencia ? String(referencia) : null,
                usuario ? String(usuario) : null
            ]
        );
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al registrar movimiento de caja' });
    }
});

app.put('/api/caja/movimientos/:id', async (req, res) => {
    const { id } = req.params;
    const { tipo, metodo_pago, monto, referencia, usuario } = req.body;
    if (!tipo || monto === undefined || monto === null) {
        return res.status(400).json({ error: 'tipo y monto son obligatorios' });
    }
    const montoValue = Number(monto);
    if (Number.isNaN(montoValue) || montoValue <= 0) {
        return res.status(400).json({ error: 'Monto inválido' });
    }
    try {
        const result = await pool.query(
            `UPDATE caja_movimientos
             SET tipo = $1, metodo_pago = $2, monto = $3, referencia = $4, usuario = $5
             WHERE id = $6 RETURNING *`,
            [
                String(tipo).toUpperCase(),
                metodo_pago ? String(metodo_pago) : null,
                montoValue,
                referencia ? String(referencia) : null,
                usuario ? String(usuario) : null,
                Number(id)
            ]
        );
        if (result.rowCount === 0) return res.status(404).json({ error: 'Movimiento no encontrado' });
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al actualizar movimiento de caja' });
    }
});

app.delete('/api/caja/movimientos/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const result = await pool.query('DELETE FROM caja_movimientos WHERE id = $1 RETURNING *', [Number(id)]);
        if (result.rowCount === 0) return res.status(404).json({ error: 'Movimiento no encontrado' });
        res.json({ success: true });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al eliminar movimiento de caja' });
    }
});

app.get('/api/gastos', async (req, res) => {
    const { desde, hasta, caja_origen } = req.query;
    const filters = [];
    const values = [];
    let idx = 1;

    if (desde) {
        filters.push(`g.fecha >= $${idx++}`);
        values.push(String(desde));
    }
    if (hasta) {
        filters.push(`g.fecha <= $${idx++}`);
        values.push(String(hasta));
    }
    if (caja_origen) {
        filters.push(`UPPER(TRIM(g.caja_origen)) = $${idx++}`);
        values.push(String(caja_origen).trim().toUpperCase());
    }

    const where = filters.length ? `WHERE ${filters.join(' AND ')}` : '';

    try {
        const result = await pool.query(
            `SELECT g.*,
                    TO_CHAR(g.fecha, 'YYYY-MM-DD') AS fecha_iso
             FROM gastos_mensuales g
             ${where}
             ORDER BY g.fecha DESC, g.id DESC`,
            values
        );
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al listar gastos' });
    }
});

app.post('/api/gastos', upload.single('factura'), async (req, res) => {
    const { fecha, descripcion, monto, categoria, caja_origen, proveedor, usuario } = req.body || {};
    if (!fecha || !descripcion || monto === undefined || monto === null) {
        return res.status(400).json({ error: 'fecha, descripcion y monto son obligatorios' });
    }

    const montoValue = Number(monto);
    if (Number.isNaN(montoValue) || montoValue <= 0) {
        return res.status(400).json({ error: 'Monto inválido' });
    }

    const cajaIngresada = String(caja_origen || 'CAJA_LOCAL').trim().toUpperCase();
    if (cajaIngresada !== 'CAJA_LOCAL') {
        return res.status(400).json({ error: 'Caja chica es solo para ahorros. Los gastos se registran en Caja del local.' });
    }
    const caja = 'CAJA_LOCAL';

    const facturaUrl = req.file ? `/uploads/${req.file.filename}` : null;

    try {
        const result = await pool.query(
            `INSERT INTO gastos_mensuales (fecha, descripcion, monto, categoria, caja_origen, proveedor, factura_url, usuario)
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
             RETURNING *, TO_CHAR(fecha, 'YYYY-MM-DD') AS fecha_iso`,
            [
                String(fecha),
                String(descripcion).trim(),
                montoValue,
                categoria ? String(categoria).trim() : null,
                caja,
                proveedor ? String(proveedor).trim() : null,
                facturaUrl,
                usuario ? String(usuario).trim() : null
            ]
        );
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al registrar gasto' });
    }
});

app.delete('/api/gastos/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const result = await pool.query('DELETE FROM gastos_mensuales WHERE id = $1 RETURNING *', [Number(id)]);
        if (result.rowCount === 0) return res.status(404).json({ error: 'Gasto no encontrado' });

        const gasto = result.rows[0];
        if (gasto?.factura_url) {
            const filePath = path.join(uploadsDir, path.basename(String(gasto.factura_url)));
            if (fs.existsSync(filePath)) {
                fs.unlink(filePath, () => {});
            }
        }

        res.json({ success: true });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al eliminar gasto' });
    }
});

app.put('/api/gastos/:id', upload.single('factura'), async (req, res) => {
    const { id } = req.params;
    const { fecha, descripcion, monto, categoria, caja_origen, proveedor, usuario, mantener_factura } = req.body || {};

    if (!fecha || !descripcion || monto === undefined || monto === null) {
        return res.status(400).json({ error: 'fecha, descripcion y monto son obligatorios' });
    }

    const montoValue = Number(monto);
    if (Number.isNaN(montoValue) || montoValue <= 0) {
        return res.status(400).json({ error: 'Monto inválido' });
    }

    const cajaIngresada = String(caja_origen || 'CAJA_LOCAL').trim().toUpperCase();
    if (cajaIngresada !== 'CAJA_LOCAL') {
        return res.status(400).json({ error: 'Caja chica es solo para ahorros. Los gastos se registran en Caja del local.' });
    }
    const caja = 'CAJA_LOCAL';

    try {
        const anteriorRes = await pool.query('SELECT * FROM gastos_mensuales WHERE id = $1', [Number(id)]);
        if (anteriorRes.rowCount === 0) return res.status(404).json({ error: 'Gasto no encontrado' });
        const anterior = anteriorRes.rows[0];

        let facturaUrl = anterior.factura_url || null;
        if (req.file) {
            facturaUrl = `/uploads/${req.file.filename}`;
            if (anterior.factura_url) {
                const oldPath = path.join(uploadsDir, path.basename(String(anterior.factura_url)));
                if (fs.existsSync(oldPath)) fs.unlink(oldPath, () => {});
            }
        } else if (String(mantener_factura || '').toLowerCase() === 'false') {
            facturaUrl = null;
            if (anterior.factura_url) {
                const oldPath = path.join(uploadsDir, path.basename(String(anterior.factura_url)));
                if (fs.existsSync(oldPath)) fs.unlink(oldPath, () => {});
            }
        }

        const result = await pool.query(
            `UPDATE gastos_mensuales
             SET fecha = $1,
                 descripcion = $2,
                 monto = $3,
                 categoria = $4,
                 caja_origen = $5,
                 proveedor = $6,
                 factura_url = $7,
                 usuario = $8
             WHERE id = $9
             RETURNING *, TO_CHAR(fecha, 'YYYY-MM-DD') AS fecha_iso`,
            [
                String(fecha),
                String(descripcion).trim(),
                montoValue,
                categoria ? String(categoria).trim() : null,
                caja,
                proveedor ? String(proveedor).trim() : null,
                facturaUrl,
                usuario ? String(usuario).trim() : null,
                Number(id)
            ]
        );
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al actualizar gasto' });
    }
});

app.get('/api/caja-chica/ahorros', async (req, res) => {
    const { desde, hasta } = req.query;
    const filters = [];
    const values = [];
    let idx = 1;

    if (desde) {
        filters.push(`a.fecha >= $${idx++}`);
        values.push(String(desde));
    }
    if (hasta) {
        filters.push(`a.fecha <= $${idx++}`);
        values.push(String(hasta));
    }

    const where = filters.length ? `WHERE ${filters.join(' AND ')}` : '';

    try {
        const result = await pool.query(
            `SELECT a.*, TO_CHAR(a.fecha, 'YYYY-MM-DD') AS fecha_iso
             FROM caja_chica_ahorros a
             ${where}
             ORDER BY a.fecha DESC, a.id DESC`,
            values
        );
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al listar ahorros de caja chica' });
    }
});

app.post('/api/caja-chica/ahorros', upload.single('comprobante'), async (req, res) => {
    const { fecha, monto, referencia, usuario } = req.body || {};
    if (!fecha || monto === undefined || monto === null) {
        return res.status(400).json({ error: 'fecha y monto son obligatorios' });
    }

    const montoValue = Number(monto);
    if (Number.isNaN(montoValue) || montoValue <= 0) {
        return res.status(400).json({ error: 'Monto inválido' });
    }

    const comprobanteUrl = req.file ? `/uploads/${req.file.filename}` : null;

    try {
        const result = await pool.query(
            `INSERT INTO caja_chica_ahorros (fecha, monto, referencia, comprobante_url, usuario)
             VALUES ($1, $2, $3, $4, $5)
             RETURNING *, TO_CHAR(fecha, 'YYYY-MM-DD') AS fecha_iso`,
            [
                String(fecha),
                montoValue,
                referencia ? String(referencia).trim() : null,
                comprobanteUrl,
                usuario ? String(usuario).trim() : null
            ]
        );
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al registrar ahorro en caja chica' });
    }
});

app.delete('/api/caja-chica/ahorros/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const result = await pool.query('DELETE FROM caja_chica_ahorros WHERE id = $1 RETURNING *', [Number(id)]);
        if (result.rowCount === 0) return res.status(404).json({ error: 'Ahorro no encontrado' });
        // Limpiar archivo comprobante si existe
        const row = result.rows[0];
        if (row?.comprobante_url) {
            const filePath = path.join(uploadsDir, path.basename(String(row.comprobante_url)));
            fs.unlink(filePath, () => {});
        }
        res.json({ success: true });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al eliminar ahorro de caja chica' });
    }
});

// Sugerencias de categorías y proveedores para gastos
app.get('/api/gastos/sugerencias', async (req, res) => {
    try {
        const catResult = await pool.query(
            `SELECT DISTINCT TRIM(categoria) AS valor FROM gastos_mensuales WHERE categoria IS NOT NULL AND TRIM(categoria) != '' ORDER BY valor`
        );
        const provResult = await pool.query(
            `SELECT DISTINCT TRIM(proveedor) AS valor FROM gastos_mensuales WHERE proveedor IS NOT NULL AND TRIM(proveedor) != '' ORDER BY valor`
        );
        res.json({
            categorias: catResult.rows.map(r => r.valor),
            proveedores: provResult.rows.map(r => r.valor)
        });
    } catch (err) {
        console.error(err);
        res.json({ categorias: [], proveedores: [] });
    }
});

// Movimientos de Inventario
app.post('/api/inventario/movimientos', async (req, res) => {
    const { insumo_id, tipo, cantidad, motivo, referencia, usuario } = req.body;
    if (!insumo_id || !tipo || cantidad === undefined || cantidad === null) {
        return res.status(400).json({ error: 'Insumo, tipo y cantidad son obligatorios' });
    }
    const cantidadValue = Number(cantidad);
    if (Number.isNaN(cantidadValue) || cantidadValue <= 0) {
        return res.status(400).json({ error: 'Cantidad inválida' });
    }

    const client = await pool.connect();
    try {
        await client.query('BEGIN');
        const insumoRes = await client.query('SELECT * FROM insumos WHERE id = $1', [insumo_id]);
        if (insumoRes.rowCount === 0) {
            await client.query('ROLLBACK');
            return res.status(404).json({ error: 'Insumo no encontrado' });
        }
        const insumo = insumoRes.rows[0];
        const tipoUpper = String(tipo).toUpperCase();
        const esSalida = ['EGRESO', 'PRODUCCION', 'TRANSFORMACION_SALIDA'].includes(tipoUpper);
        const delta = esSalida ? -cantidadValue : cantidadValue;
        const nuevoStock = Number(insumo.stock_actual ?? 0) + delta;
        if (nuevoStock < 0) {
            await client.query('ROLLBACK');
            return res.status(400).json({ error: 'Stock insuficiente' });
        }

        await client.query('UPDATE insumos SET stock_actual = $1 WHERE id = $2', [nuevoStock, insumo_id]);
        const movRes = await client.query(
            `INSERT INTO movimientos_inventario (insumo_id, tipo, cantidad, unidad_medida, motivo, referencia, usuario)
             VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
            [
                insumo_id,
                tipoUpper,
                cantidadValue,
                insumo.unidad_medida,
                motivo || null,
                referencia || null,
                usuario || null
            ]
        );
        await client.query('COMMIT');
        res.json(movRes.rows[0]);
    } catch (err) {
        await client.query('ROLLBACK');
        console.error(err);
        res.status(500).json({ error: 'Error al registrar movimiento' });
    } finally {
        client.release();
    }
});

app.post('/api/inventario/transformacion', async (req, res) => {
    const { insumo_origen_id, insumo_destino_id, cantidad_origen, cantidad_destino, motivo, referencia, usuario } = req.body;
    if (!insumo_origen_id || !insumo_destino_id || cantidad_origen === undefined || cantidad_destino === undefined) {
        return res.status(400).json({ error: 'Datos de transformación incompletos' });
    }
    if (insumo_origen_id === insumo_destino_id) {
        return res.status(400).json({ error: 'El insumo origen y destino deben ser distintos' });
    }
    const cantOrigen = Number(cantidad_origen);
    const cantDestino = Number(cantidad_destino);
    if (Number.isNaN(cantOrigen) || cantOrigen <= 0 || Number.isNaN(cantDestino) || cantDestino <= 0) {
        return res.status(400).json({ error: 'Cantidades inválidas' });
    }

    const client = await pool.connect();
    try {
        await client.query('BEGIN');
        const origenRes = await client.query('SELECT * FROM insumos WHERE id = $1', [insumo_origen_id]);
        const destinoRes = await client.query('SELECT * FROM insumos WHERE id = $1', [insumo_destino_id]);
        if (origenRes.rowCount === 0 || destinoRes.rowCount === 0) {
            await client.query('ROLLBACK');
            return res.status(404).json({ error: 'Insumo origen o destino no encontrado' });
        }

        const origen = origenRes.rows[0];
        const destino = destinoRes.rows[0];
        const nuevoStockOrigen = Number(origen.stock_actual ?? 0) - cantOrigen;
        if (nuevoStockOrigen < 0) {
            await client.query('ROLLBACK');
            return res.status(400).json({ error: 'Stock insuficiente en el insumo origen' });
        }
        const nuevoStockDestino = Number(destino.stock_actual ?? 0) + cantDestino;

        await client.query('UPDATE insumos SET stock_actual = $1 WHERE id = $2', [nuevoStockOrigen, insumo_origen_id]);
        await client.query('UPDATE insumos SET stock_actual = $1 WHERE id = $2', [nuevoStockDestino, insumo_destino_id]);

        const referenciaFinal = referencia || `Transformación ${insumo_origen_id}→${insumo_destino_id}`;
        await client.query(
            `INSERT INTO movimientos_inventario (insumo_id, tipo, cantidad, unidad_medida, motivo, referencia, usuario)
             VALUES ($1, 'TRANSFORMACION_SALIDA', $2, $3, $4, $5, $6)`,
            [insumo_origen_id, cantOrigen, origen.unidad_medida, motivo || null, referenciaFinal, usuario || null]
        );
        await client.query(
            `INSERT INTO movimientos_inventario (insumo_id, tipo, cantidad, unidad_medida, motivo, referencia, usuario)
             VALUES ($1, 'TRANSFORMACION_ENTRADA', $2, $3, $4, $5, $6)`,
            [insumo_destino_id, cantDestino, destino.unidad_medida, motivo || null, referenciaFinal, usuario || null]
        );

        await client.query('COMMIT');
        res.json({ success: true });
    } catch (err) {
        await client.query('ROLLBACK');
        console.error(err);
        res.status(500).json({ error: 'Error al registrar transformación' });
    } finally {
        client.release();
    }
});

// Bodega - Insumos
app.get('/api/bodega/insumos', async (_req, res) => {
    try {
        const result = await pool.query('SELECT * FROM bodega_insumos ORDER BY id');
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al listar insumos de bodega' });
    }
});

app.post('/api/bodega/insumos', async (req, res) => {
    const { nombre, stock_actual, unidad_medida, stock_minimo } = req.body;
    if (!nombre || !unidad_medida) {
        return res.status(400).json({ error: 'Nombre y unidad_medida son obligatorios' });
    }
    try {
        const result = await pool.query(
            `INSERT INTO bodega_insumos (nombre, stock_actual, unidad_medida, stock_minimo)
             VALUES ($1, $2, $3, $4) RETURNING *`,
            [
                String(nombre).trim(),
                Number(stock_actual ?? 0),
                String(unidad_medida).trim(),
                Number(stock_minimo ?? 0)
            ]
        );
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al crear insumo de bodega' });
    }
});

app.put('/api/bodega/insumos/:id', async (req, res) => {
    const { id } = req.params;
    const { nombre, stock_actual, unidad_medida, stock_minimo } = req.body;
    if (!nombre || !unidad_medida) {
        return res.status(400).json({ error: 'Nombre y unidad_medida son obligatorios' });
    }
    try {
        const result = await pool.query(
            `UPDATE bodega_insumos
             SET nombre = $1, stock_actual = $2, unidad_medida = $3, stock_minimo = $4
             WHERE id = $5 RETURNING *`,
            [
                String(nombre).trim(),
                Number(stock_actual ?? 0),
                String(unidad_medida).trim(),
                Number(stock_minimo ?? 0),
                id
            ]
        );
        if (result.rowCount === 0) return res.status(404).json({ error: 'Insumo de bodega no encontrado' });
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al actualizar insumo de bodega' });
    }
});

app.delete('/api/bodega/insumos/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const result = await pool.query('DELETE FROM bodega_insumos WHERE id = $1 RETURNING *', [id]);
        if (result.rowCount === 0) return res.status(404).json({ error: 'Insumo de bodega no encontrado' });
        res.json({ success: true });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al eliminar insumo de bodega' });
    }
});

// Bodega - Productos
app.get('/api/bodega/productos', async (_req, res) => {
    try {
        const result = await pool.query('SELECT * FROM bodega_productos ORDER BY id');
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al listar productos de bodega' });
    }
});

app.post('/api/bodega/productos', async (req, res) => {
    const { nombre, precio, id_categoria, es_preparado } = req.body;
    if (!nombre) {
        return res.status(400).json({ error: 'Nombre es obligatorio' });
    }
    try {
        const result = await pool.query(
            `INSERT INTO bodega_productos (nombre, precio, id_categoria, es_preparado)
             VALUES ($1, $2, $3, $4) RETURNING *`,
            [
                String(nombre).trim(),
                Number(precio ?? 0),
                id_categoria ? Number(id_categoria) : null,
                es_preparado === undefined ? true : Boolean(es_preparado)
            ]
        );
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al crear producto de bodega' });
    }
});

app.put('/api/bodega/productos/:id', async (req, res) => {
    const { id } = req.params;
    const { nombre, precio, id_categoria, es_preparado } = req.body;
    if (!nombre) {
        return res.status(400).json({ error: 'Nombre es obligatorio' });
    }
    try {
        const result = await pool.query(
            `UPDATE bodega_productos
             SET nombre = $1, precio = $2, id_categoria = $3, es_preparado = $4
             WHERE id = $5 RETURNING *`,
            [
                String(nombre).trim(),
                Number(precio ?? 0),
                id_categoria ? Number(id_categoria) : null,
                es_preparado === undefined ? true : Boolean(es_preparado),
                id
            ]
        );
        if (result.rowCount === 0) return res.status(404).json({ error: 'Producto de bodega no encontrado' });
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al actualizar producto de bodega' });
    }
});

app.delete('/api/bodega/productos/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const result = await pool.query('DELETE FROM bodega_productos WHERE id = $1 RETURNING *', [id]);
        if (result.rowCount === 0) return res.status(404).json({ error: 'Producto de bodega no encontrado' });
        res.json({ success: true });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al eliminar producto de bodega' });
    }
});

// Transferencia de bodega a local (insumos)
app.post('/api/bodega/transferir', async (req, res) => {
    const { bodega_insumo_id, cantidad, usuario } = req.body;
    if (!bodega_insumo_id || cantidad === undefined || cantidad === null) {
        return res.status(400).json({ error: 'Insumo y cantidad son obligatorios' });
    }
    const cantidadValue = Number(cantidad);
    if (Number.isNaN(cantidadValue) || cantidadValue <= 0) {
        return res.status(400).json({ error: 'Cantidad inválida' });
    }

    const client = await pool.connect();
    try {
        await client.query('BEGIN');
        const bodegaRes = await client.query('SELECT * FROM bodega_insumos WHERE id = $1', [bodega_insumo_id]);
        if (bodegaRes.rowCount === 0) {
            await client.query('ROLLBACK');
            return res.status(404).json({ error: 'Insumo de bodega no encontrado' });
        }
        const bodegaInsumo = bodegaRes.rows[0];
        const nuevoStockBodega = Number(bodegaInsumo.stock_actual ?? 0) - cantidadValue;
        if (nuevoStockBodega < 0) {
            await client.query('ROLLBACK');
            return res.status(400).json({ error: 'Stock insuficiente en bodega' });
        }
        await client.query('UPDATE bodega_insumos SET stock_actual = $1 WHERE id = $2', [nuevoStockBodega, bodega_insumo_id]);

        const localRes = await client.query('SELECT * FROM insumos WHERE LOWER(nombre) = LOWER($1)', [bodegaInsumo.nombre]);
        let localInsumo = localRes.rows[0];
        if (!localInsumo) {
            const creado = await client.query(
                `INSERT INTO insumos (nombre, stock_actual, unidad_medida, stock_minimo)
                 VALUES ($1, $2, $3, $4) RETURNING *`,
                [bodegaInsumo.nombre, 0, bodegaInsumo.unidad_medida, 0]
            );
            localInsumo = creado.rows[0];
        }
        const nuevoStockLocal = Number(localInsumo.stock_actual ?? 0) + cantidadValue;
        await client.query('UPDATE insumos SET stock_actual = $1 WHERE id = $2', [nuevoStockLocal, localInsumo.id]);

        await client.query(
            `INSERT INTO bodega_movimientos (insumo_id, tipo, cantidad, unidad_medida, motivo, referencia, usuario)
             VALUES ($1, 'SALIDA', $2, $3, $4, $5, $6)`,
            [
                bodegaInsumo.id,
                cantidadValue,
                bodegaInsumo.unidad_medida,
                'TRANSFERENCIA_LOCAL',
                `LOCAL:${localInsumo.id}`,
                usuario || null
            ]
        );
        await client.query(
            `INSERT INTO movimientos_inventario (insumo_id, tipo, cantidad, unidad_medida, motivo, referencia, usuario)
             VALUES ($1, 'INGRESO', $2, $3, $4, $5, $6)`,
            [
                localInsumo.id,
                cantidadValue,
                localInsumo.unidad_medida,
                'TRANSFERENCIA_BODEGA',
                `BODEGA:${bodegaInsumo.id}`,
                usuario || null
            ]
        );

        await client.query('COMMIT');
        res.json({ success: true });
    } catch (err) {
        await client.query('ROLLBACK');
        console.error(err);
        res.status(500).json({ error: 'Error al transferir a local' });
    } finally {
        client.release();
    }
});

app.get('/api/inventario/movimientos', async (req, res) => {
    const { insumoId, tipo, desde, hasta } = req.query;
    const filters = [];
    const values = [];
    let idx = 1;

    if (insumoId) {
        filters.push(`m.insumo_id = $${idx++}`);
        values.push(Number(insumoId));
    }
    if (tipo) {
        filters.push(`m.tipo = $${idx++}`);
        values.push(String(tipo).toUpperCase());
    }
    if (desde) {
        filters.push(`m.fecha >= $${idx++}`);
        values.push(String(desde));
    }
    if (hasta) {
        filters.push(`m.fecha <= $${idx++}`);
        values.push(String(hasta));
    }

    const where = filters.length ? `WHERE ${filters.join(' AND ')}` : '';

    try {
        const result = await pool.query(
            `SELECT m.*, i.nombre AS insumo_nombre
             FROM movimientos_inventario m
             JOIN insumos i ON i.id = m.insumo_id
             ${where}
             ORDER BY m.fecha DESC, m.id DESC`,
            values
        );
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al listar movimientos' });
    }
});

app.get('/api/inventario/kardex', async (req, res) => {
    const { insumoId, desde, hasta } = req.query;
    const filters = [];
    const values = [];
    let idx = 1;

    if (insumoId) {
        filters.push(`m.insumo_id = $${idx++}`);
        values.push(Number(insumoId));
    }
    if (desde) {
        filters.push(`m.fecha >= $${idx++}`);
        values.push(String(desde));
    }
    if (hasta) {
        filters.push(`m.fecha <= $${idx++}`);
        values.push(String(hasta));
    }

    const where = filters.length ? `WHERE ${filters.join(' AND ')}` : '';

    try {
        const result = await pool.query(
            `SELECT m.*, i.nombre AS insumo_nombre,
                i.stock_actual -
                SUM(CASE WHEN m.tipo IN ('EGRESO','PRODUCCION','TRANSFORMACION_SALIDA') THEN -m.cantidad ELSE m.cantidad END)
                OVER (PARTITION BY m.insumo_id ORDER BY m.fecha DESC, m.id DESC)
                + (CASE WHEN m.tipo IN ('EGRESO','PRODUCCION','TRANSFORMACION_SALIDA') THEN -m.cantidad ELSE m.cantidad END)
                AS saldo
             FROM movimientos_inventario m
             JOIN insumos i ON i.id = m.insumo_id
             ${where}
             ORDER BY m.fecha ASC, m.id ASC`,
            values
        );
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al listar kardex' });
    }
});

// Kardex de productos (ventas)
app.get('/api/productos/kardex', async (req, res) => {
    const { productoId, desde, hasta } = req.query;
    const filters = [];
    const values = [];
    let idx = 1;

    if (productoId) {
        filters.push(`vi.producto_id = $${idx++}`);
        values.push(Number(productoId));
    }
    if (desde) {
        filters.push(`v.fecha >= $${idx++}`);
        values.push(String(desde));
    }
    if (hasta) {
        filters.push(`v.fecha <= $${idx++}`);
        values.push(String(hasta));
    }

    const where = filters.length ? `WHERE ${filters.join(' AND ')}` : '';

    try {
        const result = await pool.query(
            `SELECT v.fecha, vi.producto_id, p.nombre AS producto_nombre,
                'VENTA' AS tipo,
                vi.cantidad,
                'UND' AS unidad_medida,
                v.usuario,
                CONCAT('VENTA:', v.id) AS referencia,
                SUM(vi.cantidad) OVER (PARTITION BY vi.producto_id ORDER BY v.fecha ASC, vi.id ASC) AS saldo
             FROM ventas_items vi
             JOIN ventas v ON v.id = vi.venta_id
             LEFT JOIN productos p ON p.id = vi.producto_id
             ${where}
             ORDER BY v.fecha ASC, vi.id ASC`,
            values
        );
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al listar kardex de productos' });
    }
});

// Reportes Excel
app.get('/api/reportes/inventario', async (req, res) => {
    const fecha = req.query.fecha || new Date().toISOString().slice(0, 10);
    try {
        const insumosRes = await pool.query('SELECT * FROM insumos ORDER BY id');
        const productosRes = await pool.query(
            `SELECT p.*, c.nombre AS categoria_nombre
             FROM productos p
             LEFT JOIN categorias c ON c.id = p.id_categoria
             ORDER BY p.id`
        );

        const wb = XLSX.utils.book_new();
        const insumosData = insumosRes.rows.map(i => ({
            id: i.id,
            nombre: i.nombre,
            stock_actual: i.stock_actual,
            unidad_medida: i.unidad_medida,
            stock_minimo: i.stock_minimo,
            ingresos: 0,
            egresos: 0,
            saldo: i.stock_actual
        }));
        const productosData = productosRes.rows.map(p => ({
            id: p.id,
            nombre: p.nombre,
            categoria: p.categoria_nombre || '',
            precio: p.precio,
            es_preparado: p.es_preparado,
            imagen: p.image_url || ''
        }));

        XLSX.utils.book_append_sheet(wb, XLSX.utils.json_to_sheet(insumosData), 'Insumos');
        XLSX.utils.book_append_sheet(wb, XLSX.utils.json_to_sheet(productosData), 'Productos');

        const buffer = XLSX.write(wb, { type: 'buffer', bookType: 'xlsx' });
        res.setHeader('Content-Disposition', `attachment; filename=inventario_${fecha}.xlsx`);
        res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        res.send(buffer);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al generar reporte de inventario' });
    }
});

app.get('/api/reportes/caja', async (req, res) => {
    const fecha = req.query.fecha || new Date().toISOString().slice(0, 10);
    try {
        const ventasRes = await pool.query(
            `SELECT * FROM ventas WHERE DATE(fecha) = $1 ORDER BY fecha`,
            [fecha]
        );
        const movimientosRes = await pool.query(
            `SELECT * FROM caja_movimientos WHERE DATE(fecha) = $1 ORDER BY fecha`,
            [fecha]
        );

        const ventas = ventasRes.rows;
        const movimientos = movimientosRes.rows;
        const total = ventas.reduce((acc, v) => acc + Number(v.total || 0), 0);
        const metodos = [
            'EFECTIVO',
            'TARJETA',
            'TARJETA_DEBITO',
            'TARJETA_CREDITO',
            'TRANSFERENCIA',
            'DE_UNA',
            'CORTESIA',
            'PLIN',
            'QR',
            'DEPOSITO',
            'PAGO_ONLINE',
            'OTRO'
        ];
        const resumenMetodos = metodos.map((metodo) => ({
            metodo,
            total: ventas
                .filter(v => (v.metodo_pago || '').toUpperCase() === metodo)
                .reduce((acc, v) => acc + Number(v.total || 0), 0)
        }));
        const totalPedidosYa = ventas
            .filter(v => (v.canal || '').toUpperCase() === 'PEDIDOS_YA' || (v.tipo || '').toUpperCase() === 'PEDIDOS_YA')
            .reduce((acc, v) => acc + Number(v.total || 0), 0);
        const totalLocal = total - totalPedidosYa;
        const totalEgresos = movimientos
            .filter(m => String(m.tipo || '').toUpperCase() === 'EGRESO')
            .reduce((acc, m) => acc + Number(m.monto || 0), 0);
        const totalIngresos = movimientos
            .filter(m => String(m.tipo || '').toUpperCase() === 'INGRESO')
            .reduce((acc, m) => acc + Number(m.monto || 0), 0);
        const totalNeto = total + totalIngresos - totalEgresos;

        const wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, XLSX.utils.json_to_sheet(ventas), 'Ventas');
        XLSX.utils.book_append_sheet(wb, XLSX.utils.json_to_sheet(movimientos), 'Movimientos_Caja');
        XLSX.utils.book_append_sheet(wb, XLSX.utils.json_to_sheet([
            { fecha, total, total_local: totalLocal, total_pedidos_ya: totalPedidosYa, total_ingresos: totalIngresos, total_egresos: totalEgresos, total_neto: totalNeto }
        ]), 'Resumen');
        XLSX.utils.book_append_sheet(wb, XLSX.utils.json_to_sheet(resumenMetodos), 'Metodos_Pago');

        const buffer = XLSX.write(wb, { type: 'buffer', bookType: 'xlsx' });
        res.setHeader('Content-Disposition', `attachment; filename=caja_${fecha}.xlsx`);
        res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        res.send(buffer);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al generar reporte de caja' });
    }
});

const sanitizeDate = (value) => String(value || '').slice(0, 10);

async function construirReporte(tipoRaw, desdeRaw, hastaRaw) {
    const tipo = String(tipoRaw || '').trim().toLowerCase();
    const desde = sanitizeDate(desdeRaw);
    const hasta = sanitizeDate(hastaRaw);

    if (!desde || !hasta) {
        throw new Error('Rango de fechas inválido');
    }

    if (tipo === 'inventario') {
        const insumosRes = await pool.query('SELECT id, nombre, stock_actual, unidad_medida, stock_minimo FROM insumos ORDER BY nombre');
        const productosRes = await pool.query(
            `SELECT p.id, p.nombre, p.stock_actual, p.unidad_medida, p.stock_minimo, p.precio,
                    COALESCE(c.nombre, 'Sin categoría') AS categoria
             FROM productos p
             LEFT JOIN categorias c ON c.id = p.id_categoria
             ORDER BY p.nombre`
        );

        return {
            tipo: 'inventario',
            titulo: 'Reporte de Inventario y Existencias',
            desde,
            hasta,
            resumen: {
                totalInsumos: insumosRes.rows.length,
                totalProductos: productosRes.rows.length,
                stockBajoInsumos: insumosRes.rows.filter((i) => Number(i.stock_actual || 0) <= Number(i.stock_minimo || 0)).length,
                stockBajoProductos: productosRes.rows.filter((p) => Number(p.stock_actual || 0) <= Number(p.stock_minimo || 0)).length
            },
            secciones: [
                { titulo: 'Insumos', items: insumosRes.rows },
                { titulo: 'Productos', items: productosRes.rows }
            ]
        };
    }

    if (tipo === 'stock') {
        const lowStockRes = await pool.query(
            `SELECT 'INSUMO' AS tipo, id, nombre, stock_actual, unidad_medida, stock_minimo
             FROM insumos
             WHERE stock_actual <= stock_minimo
             UNION ALL
             SELECT 'PRODUCTO' AS tipo, id, nombre, stock_actual, COALESCE(unidad_medida, 'UND') AS unidad_medida, stock_minimo
             FROM productos
             WHERE stock_actual <= stock_minimo
             ORDER BY tipo, nombre`
        );
        return {
            tipo: 'stock',
            titulo: 'Reporte de Stock Bajo',
            desde,
            hasta,
            resumen: {
                totalItems: lowStockRes.rows.length
            },
            secciones: [
                { titulo: 'Items con stock crítico', items: lowStockRes.rows }
            ]
        };
    }

    if (tipo === 'caja') {
        const ventasRes = await pool.query(
            `SELECT id, fecha, tipo, canal, metodo_pago, total, usuario
             FROM ventas
             WHERE fecha >= $1 AND fecha <= $2 AND UPPER(estado) = 'PAGADA'
             ORDER BY fecha DESC`,
            [desde, hasta]
        );
        const movRes = await pool.query(
            `SELECT id, fecha, tipo, metodo_pago, monto, referencia, usuario
             FROM caja_movimientos
             WHERE fecha >= $1 AND fecha <= $2
             ORDER BY fecha DESC`,
            [desde, hasta]
        );
        const ventas = ventasRes.rows;
        const movimientos = movRes.rows;
        const totalVentas = ventas.reduce((acc, v) => acc + Number(v.total || 0), 0);
        const totalIngresos = movimientos
            .filter((m) => String(m.tipo || '').trim().toUpperCase() === 'INGRESO')
            .reduce((acc, m) => acc + Number(m.monto || 0), 0);
        const totalEgresos = movimientos
            .filter((m) => String(m.tipo || '').trim().toUpperCase() === 'EGRESO')
            .reduce((acc, m) => acc + Number(m.monto || 0), 0);
        return {
            tipo: 'caja',
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
    }

    if (tipo === 'ganancias') {
        const resumenRes = await pool.query(
            `SELECT
                COALESCE(SUM(CASE WHEN UPPER(TRIM(cm.tipo)) = 'VENTA' THEN cm.monto ELSE 0 END), 0) AS total_ventas,
                COALESCE(SUM(CASE WHEN UPPER(TRIM(cm.tipo)) = 'EGRESO' THEN cm.monto ELSE 0 END), 0) AS total_gastos,
                COALESCE(SUM(CASE WHEN UPPER(TRIM(cm.tipo)) = 'INGRESO' THEN cm.monto ELSE 0 END), 0) AS total_ingresos
             FROM caja_movimientos cm
             WHERE cm.fecha >= $1 AND cm.fecha <= $2`,
            [desde, hasta]
        );
        const gastosFacturasRes = await pool.query(
            `SELECT id, fecha, descripcion, monto, categoria, caja_origen, proveedor, factura_url
             FROM gastos_mensuales
             WHERE fecha >= $1 AND fecha <= $2
             ORDER BY fecha DESC`,
            [desde, hasta]
        );
        const totalVentas = Number(resumenRes.rows?.[0]?.total_ventas || 0);
        const totalGastos = Number(resumenRes.rows?.[0]?.total_gastos || 0);
        const totalIngresos = Number(resumenRes.rows?.[0]?.total_ingresos || 0);
        const totalGanancias = totalVentas + totalIngresos - totalGastos;
        const totalGastosFacturas = gastosFacturasRes.rows.reduce((acc, g) => acc + Number(g.monto || 0), 0);
        return {
            tipo: 'ganancias',
            titulo: 'Reporte de Ganancias',
            desde,
            hasta,
            resumen: {
                totalVentas,
                totalIngresos,
                totalEgresosCaja: totalGastos,
                totalGananciasBase: totalGanancias,
                totalGastosFacturas,
                totalGananciaReal: totalGanancias - totalGastosFacturas
            },
            secciones: [
                { titulo: 'Gastos Facturados', items: gastosFacturasRes.rows }
            ]
        };
    }

    if (tipo === 'gastos') {
        const gastosRes = await pool.query(
            `SELECT id, fecha, descripcion, monto, categoria, caja_origen, proveedor, factura_url, usuario
             FROM gastos_mensuales
             WHERE fecha >= $1 AND fecha <= $2
             ORDER BY fecha DESC`,
            [desde, hasta]
        );
        const total = gastosRes.rows.reduce((acc, g) => acc + Number(g.monto || 0), 0);
        return {
            tipo: 'gastos',
            titulo: 'Reporte de Gastos',
            desde,
            hasta,
            resumen: {
                totalGastos: total,
                cantidad: gastosRes.rows.length,
                cajaLocal: gastosRes.rows
                    .filter((g) => String(g.caja_origen || '').toUpperCase() === 'CAJA_LOCAL')
                    .reduce((acc, g) => acc + Number(g.monto || 0), 0),
                cajaChica: gastosRes.rows
                    .filter((g) => String(g.caja_origen || '').toUpperCase() === 'CAJA_CHICA')
                    .reduce((acc, g) => acc + Number(g.monto || 0), 0)
            },
            secciones: [
                { titulo: 'Detalle de gastos', items: gastosRes.rows }
            ]
        };
    }

    if (tipo === 'ventas') {
        const ventasRes = await pool.query(
            `SELECT id, fecha, tipo, canal, metodo_pago, subtotal, impuesto_monto, total, usuario
             FROM ventas
             WHERE fecha >= $1 AND fecha <= $2 AND UPPER(estado) = 'PAGADA'
             ORDER BY fecha DESC`,
            [desde, hasta]
        );
        const totalVentas = ventasRes.rows.reduce((acc, v) => acc + Number(v.total || 0), 0);
        return {
            tipo: 'ventas',
            titulo: 'Reporte de Ventas',
            desde,
            hasta,
            resumen: {
                totalVentas,
                cantidad: ventasRes.rows.length,
                ticketPromedio: ventasRes.rows.length ? totalVentas / ventasRes.rows.length : 0
            },
            secciones: [
                { titulo: 'Ventas pagadas', items: ventasRes.rows }
            ]
        };
    }

    throw new Error('Tipo de reporte no soportado');
}

app.get('/api/reportes/data', async (req, res) => {
    try {
        const { tipo, desde, hasta } = req.query;
        const data = await construirReporte(tipo, desde, hasta);
        res.json(data);
    } catch (err) {
        const msg = String(err?.message || 'Error al construir reporte');
        const status = msg.includes('no soportado') || msg.includes('inválido') ? 400 : 500;
        console.error(err);
        res.status(status).json({ error: msg });
    }
});

app.post('/api/reportes/enviar-email', async (req, res) => {
    const { to, subject, body, fileName, pdfBase64 } = req.body || {};
    if (!to || !subject || !pdfBase64) {
        return res.status(400).json({ error: 'to, subject y pdfBase64 son obligatorios' });
    }

    const smtpHost = process.env.SMTP_HOST;
    const smtpPort = Number(process.env.SMTP_PORT || 587);
    const smtpUser = process.env.SMTP_USER;
    const smtpPass = process.env.SMTP_PASS;
    const smtpFrom = process.env.SMTP_FROM || smtpUser;
    if (!smtpHost || !smtpUser || !smtpPass || !smtpFrom) {
        return res.status(400).json({
            error: 'SMTP no configurado. Define SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_PASS y SMTP_FROM en backend.'
        });
    }

    try {
        const nodemailer = require('nodemailer');
        const transporter = nodemailer.createTransport({
            host: smtpHost,
            port: smtpPort,
            secure: smtpPort === 465,
            auth: {
                user: smtpUser,
                pass: smtpPass
            }
        });

        await transporter.sendMail({
            from: smtpFrom,
            to: String(to),
            subject: String(subject),
            text: String(body || 'Adjunto reporte PDF generado desde ReySoft.'),
            attachments: [
                {
                    filename: String(fileName || 'reporte.pdf'),
                    content: String(pdfBase64),
                    encoding: 'base64',
                    contentType: 'application/pdf'
                }
            ]
        });

        res.json({ success: true });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'No se pudo enviar el correo con el reporte.' });
    }
});

app.get('/api/dashboard/resumen-mes', async (req, res) => {
    try {
        let { desde, hasta } = req.query;
        if (!desde || !hasta) {
            const hoy = new Date();
            const yyyy = hoy.getFullYear();
            const mm = String(hoy.getMonth() + 1).padStart(2, '0');
            const desdeMes = `${yyyy}-${mm}-01`;
            const ultimoDia = new Date(yyyy, hoy.getMonth() + 1, 0).getDate();
            const hastaMes = `${yyyy}-${mm}-${String(ultimoDia).padStart(2, '0')}`;
            desde = desde || desdeMes;
            hasta = hasta || hastaMes;
        }

        const resumenRes = await pool.query(
            `SELECT
                COALESCE(SUM(CASE WHEN UPPER(TRIM(cm.tipo)) = 'VENTA' THEN cm.monto ELSE 0 END), 0) AS total_ventas,
                COALESCE(SUM(CASE WHEN UPPER(TRIM(cm.tipo)) = 'EGRESO' THEN cm.monto ELSE 0 END), 0) AS total_gastos,
                COALESCE(SUM(CASE WHEN UPPER(TRIM(cm.tipo)) = 'INGRESO' THEN cm.monto ELSE 0 END), 0) AS total_ingresos
             FROM caja_movimientos cm
             WHERE cm.fecha >= $1 AND cm.fecha <= $2`,
            [String(desde), String(hasta)]
        );

        const gastosRes = await pool.query(
            `SELECT COALESCE(SUM(gm.monto), 0) AS total_gastos_facturas
             FROM gastos_mensuales gm
             WHERE gm.fecha >= $1 AND gm.fecha <= $2`,
            [String(desde), String(hasta)]
        );

        const usuariosRes = await pool.query(
            `SELECT COALESCE(usuario, 'SIN_USUARIO') AS usuario,
                    COALESCE(SUM(total), 0) AS total
             FROM ventas
             WHERE fecha >= $1 AND fecha <= $2
               AND UPPER(estado) = 'PAGADA'
             GROUP BY COALESCE(usuario, 'SIN_USUARIO')
             ORDER BY total DESC`,
            [String(desde), String(hasta)]
        );

        const resumen = resumenRes.rows[0] || { total_ventas: 0, total_gastos: 0, total_ingresos: 0 };
        const totalVentas = Number(resumen.total_ventas || 0);
        const totalGastos = Number(resumen.total_gastos || 0);
        const totalIngresos = Number(resumen.total_ingresos || 0);
        const totalGanancias = totalVentas + totalIngresos - totalGastos;
        const totalGastosFacturas = Number(gastosRes.rows?.[0]?.total_gastos_facturas || 0);
        const totalGananciaReal = totalGanancias - totalGastosFacturas;

        res.json({
            desde,
            hasta,
            totalVentas,
            totalGastos,
            totalIngresos,
            totalGanancias,
            totalGastosFacturas,
            totalGananciaReal,
            ventasPorUsuario: usuariosRes.rows
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al obtener resumen mensual' });
    }
});

// Dashboard extra analytics
app.get('/api/dashboard/analytics-extra', async (req, res) => {
    try {
        const hoy = new Date();
        const yyyy = hoy.getFullYear();
        const mm = String(hoy.getMonth() + 1).padStart(2, '0');
        const desdeMes = `${yyyy}-${mm}-01`;
        const ultimoDia = new Date(yyyy, hoy.getMonth() + 1, 0).getDate();
        const hastaMes = `${yyyy}-${mm}-${String(ultimoDia).padStart(2, '0')}`;

        // Top 5 productos más vendidos del mes
        const topProductosRes = await pool.query(
            `SELECT vi.nombre, SUM(vi.cantidad) AS cantidad, SUM(vi.subtotal) AS total
             FROM ventas_items vi
             JOIN ventas v ON v.id = vi.venta_id
             WHERE v.fecha >= $1 AND v.fecha <= $2 AND UPPER(v.estado) = 'PAGADA'
             GROUP BY vi.nombre
             ORDER BY cantidad DESC
             LIMIT 5`,
            [desdeMes, hastaMes]
        );

        // Ventas diarias del mes (para gráfico de línea)
        const ventasDiariasRes = await pool.query(
            `SELECT DATE(v.fecha) AS dia, COUNT(*) AS cantidad, COALESCE(SUM(v.total),0) AS total
             FROM ventas v
             WHERE v.fecha >= $1 AND v.fecha <= $2 AND UPPER(v.estado) = 'PAGADA'
             GROUP BY DATE(v.fecha)
             ORDER BY dia ASC`,
            [desdeMes, hastaMes]
        );

        // Productos vendidos hoy (cantidad)
        const fechaHoy = `${yyyy}-${mm}-${String(hoy.getDate()).padStart(2, '0')}`;
        const productosHoyRes = await pool.query(
            `SELECT COALESCE(SUM(vi.cantidad),0) AS total_items
             FROM ventas_items vi
             JOIN ventas v ON v.id = vi.venta_id
             WHERE DATE(v.fecha) = $1 AND UPPER(v.estado) = 'PAGADA'`,
            [fechaHoy]
        );

        // Ventas por hora hoy
        const ventasHoraRes = await pool.query(
            `SELECT EXTRACT(HOUR FROM v.fecha) AS hora, COUNT(*) AS cantidad, COALESCE(SUM(v.total),0) AS total
             FROM ventas v
             WHERE DATE(v.fecha) = $1 AND UPPER(v.estado) = 'PAGADA'
             GROUP BY EXTRACT(HOUR FROM v.fecha)
             ORDER BY hora ASC`,
            [fechaHoy]
        );

        res.json({
            topProductos: topProductosRes.rows,
            ventasDiarias: ventasDiariasRes.rows,
            productosHoy: Number(productosHoyRes.rows[0]?.total_items || 0),
            ventasPorHora: ventasHoraRes.rows
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error analytics extra' });
    }
});

// 3. Ruta de Login
app.post('/api/login', async (req, res) => {
        const { id_usuario, pin, nombre } = req.body;
    try {
                const idValue = String(id_usuario ?? '').trim();
                const pinValue = String(pin ?? '').trim();
                const nombreValue = String(nombre ?? '').trim().toLowerCase();

                // Busca usuario por ID o nombre y PIN según el esquema actual
                const result = await pool.query(
                    `SELECT * FROM usuarios
                     WHERE (CAST(id AS TEXT) = $1 OR LOWER(nombre) = $3)
                         AND (CAST(pin_acceso AS TEXT) = $2)
                         AND (activo IS NULL OR activo = true)`,
                    [idValue, pinValue, nombreValue]
                );
        
                if (result.rows.length > 0) {
                        const { pin_acceso, pin: pin_col, ...safeUser } = result.rows[0];
                        const userId = safeUser.id ?? safeUser.id_usuario;
            const token = jwt.sign(
                            { id: userId, rol: safeUser.rol, nombre: safeUser.nombre },
              JWT_SECRET,
              { expiresIn: JWT_EXPIRES_IN }
            );
            res.json({ success: true, token, usuario: safeUser });
        } else {
            res.json({ success: false, message: 'Pin Incorrecto' });
        }
    } catch (err) {
        console.error(err);
        res.status(500).send('Error servidor');
    }
});

// 4. Ruta de verificación de token (opcional)
app.get('/api/verify', (req, res) => {
    const auth = req.headers.authorization || '';
    const token = auth.startsWith('Bearer ') ? auth.slice(7) : null;
    if (!token) return res.status(401).json({ valid: false });

    try {
        const payload = jwt.verify(token, JWT_SECRET);
        res.json({ valid: true, payload });
    } catch (err) {
        res.status(401).json({ valid: false });
    }
});

// ===================== FACTURACIÓN =====================

// Generar número de factura secuencial
async function generarNumeroFactura(client) {
    const res = await client.query('SELECT prefijo, siguiente FROM facturas_secuencia WHERE id = 1 FOR UPDATE');
    if (!res.rows.length) throw new Error('Secuencia de factura no configurada');
    const { prefijo, siguiente } = res.rows[0];
    const numero = `${prefijo}-${String(siguiente).padStart(9, '0')}`;
    await client.query('UPDATE facturas_secuencia SET siguiente = siguiente + 1 WHERE id = 1');
    return numero;
}

// Crear factura a partir de venta (función reutilizable)
async function crearFacturaDesdeVenta(client, ventaId, opciones = {}) {
    const ventaRes = await client.query(
        `SELECT v.*, c.nombre AS cliente_nombre_rel, c.identificacion AS cliente_iden_rel,
                c.direccion AS cliente_dir_rel, c.telefono AS cliente_tel_rel, c.email AS cliente_email_rel
         FROM ventas v
         LEFT JOIN clientes c ON c.id = v.cliente_id
         WHERE v.id = $1`,
        [ventaId]
    );
    if (!ventaRes.rows.length) throw new Error('Venta no encontrada para facturar');
    const venta = ventaRes.rows[0];

    const itemsRes = await client.query('SELECT * FROM ventas_items WHERE venta_id = $1', [ventaId]);
    const items = itemsRes.rows;

    const numero = await generarNumeroFactura(client);

    const clienteNombre = opciones.cliente_nombre || venta.cliente_nombre_rel || 'Consumidor Final';
    const clienteId = opciones.cliente_identificacion || venta.cliente_iden_rel || '9999999999999';
    const clienteDir = opciones.cliente_direccion || venta.cliente_dir_rel || '';
    const clienteTel = opciones.cliente_telefono || venta.cliente_tel_rel || '';
    const clienteEmail = opciones.cliente_email || venta.cliente_email_rel || '';

    const facturaRes = await client.query(
        `INSERT INTO facturas (numero, venta_id, tipo, fecha, cliente_nombre, cliente_identificacion,
            cliente_direccion, cliente_telefono, cliente_email, subtotal, impuesto_pct,
            impuesto_monto, total, metodo_pago, estado, notas, usuario)
         VALUES ($1, $2, $3, NOW(), $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, 'EMITIDA', $14, $15)
         RETURNING *`,
        [
            numero,
            ventaId,
            opciones.tipo || 'RECIBO',
            clienteNombre,
            clienteId,
            clienteDir,
            clienteTel,
            clienteEmail,
            Number(venta.subtotal || 0),
            Number(venta.impuesto_pct || 0),
            Number(venta.impuesto_monto || 0),
            Number(venta.total || 0),
            venta.metodo_pago || null,
            venta.notas || null,
            venta.usuario || opciones.usuario || null
        ]
    );
    const factura = facturaRes.rows[0];

    if (items.length) {
        const vals = [];
        const phs = [];
        let idx = 1;
        items.forEach((item) => {
            phs.push(`($${idx++}, $${idx++}, $${idx++}, $${idx++}, $${idx++}, $${idx++})`);
            vals.push(factura.id, item.producto_id ?? null, String(item.nombre || ''),
                Number(item.cantidad || 0), Number(item.precio || 0), Number(item.subtotal || 0));
        });
        await client.query(
            `INSERT INTO facturas_items (factura_id, producto_id, nombre, cantidad, precio_unitario, subtotal)
             VALUES ${phs.join(', ')}`, vals
        );
    }
    return factura;
}

// GET facturas con filtros
app.get('/api/facturas', async (req, res) => {
    const { estado, desde, hasta, buscar, limit } = req.query;
    const filters = [];
    const values = [];
    let idx = 1;
    if (estado) { filters.push(`f.estado = $${idx++}`); values.push(String(estado)); }
    if (desde) { filters.push(`f.fecha >= $${idx++}`); values.push(String(desde)); }
    if (hasta) { filters.push(`f.fecha <= $${idx++}`); values.push(String(hasta)); }
    if (buscar) {
        filters.push(`(f.numero ILIKE $${idx} OR f.cliente_nombre ILIKE $${idx} OR f.cliente_identificacion ILIKE $${idx})`);
        values.push(`%${buscar}%`);
        idx++;
    }
    const where = filters.length ? `WHERE ${filters.join(' AND ')}` : '';
    const limitClause = limit ? `LIMIT ${parseInt(limit, 10)}` : 'LIMIT 200';
    try {
        const result = await pool.query(
            `SELECT f.*,
                COALESCE(json_agg(
                    json_build_object('id', fi.id, 'producto_id', fi.producto_id, 'nombre', fi.nombre,
                        'cantidad', fi.cantidad, 'precio_unitario', fi.precio_unitario, 'subtotal', fi.subtotal)
                ) FILTER (WHERE fi.id IS NOT NULL), '[]') AS items
             FROM facturas f
             LEFT JOIN facturas_items fi ON fi.factura_id = f.id
             ${where}
             GROUP BY f.id
             ORDER BY f.fecha DESC
             ${limitClause}`,
            values
        );
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al listar facturas' });
    }
});

// GET factura individual
app.get('/api/facturas/:id', async (req, res) => {
    try {
        const result = await pool.query(
            `SELECT f.*,
                COALESCE(json_agg(
                    json_build_object('id', fi.id, 'producto_id', fi.producto_id, 'nombre', fi.nombre,
                        'cantidad', fi.cantidad, 'precio_unitario', fi.precio_unitario, 'subtotal', fi.subtotal)
                ) FILTER (WHERE fi.id IS NOT NULL), '[]') AS items
             FROM facturas f
             LEFT JOIN facturas_items fi ON fi.factura_id = f.id
             WHERE f.id = $1
             GROUP BY f.id`,
            [Number(req.params.id)]
        );
        if (!result.rows.length) return res.status(404).json({ error: 'Factura no encontrada' });
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al obtener factura' });
    }
});

// POST crear factura manualmente (o desde venta)
app.post('/api/facturas', async (req, res) => {
    const { venta_id, tipo, cliente_nombre, cliente_identificacion, cliente_direccion,
        cliente_telefono, cliente_email, usuario } = req.body;
    const client = await pool.connect();
    try {
        await client.query('BEGIN');
        if (venta_id) {
            const factura = await crearFacturaDesdeVenta(client, Number(venta_id), {
                tipo, cliente_nombre, cliente_identificacion, cliente_direccion,
                cliente_telefono, cliente_email, usuario
            });
            await client.query('COMMIT');
            return res.json(factura);
        }
        // Factura manual sin venta
        const { items, subtotal, impuesto_pct, impuesto_monto, total, metodo_pago, notas } = req.body;
        if (!Array.isArray(items) || !items.length) {
            await client.query('ROLLBACK');
            return res.status(400).json({ error: 'Items requeridos' });
        }
        const numero = await generarNumeroFactura(client);
        const facturaRes = await client.query(
            `INSERT INTO facturas (numero, tipo, fecha, cliente_nombre, cliente_identificacion,
                cliente_direccion, cliente_telefono, cliente_email, subtotal, impuesto_pct,
                impuesto_monto, total, metodo_pago, estado, notas, usuario)
             VALUES ($1, $2, NOW(), $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, 'EMITIDA', $13, $14)
             RETURNING *`,
            [numero, tipo || 'RECIBO', cliente_nombre || 'Consumidor Final',
                cliente_identificacion || '9999999999999', cliente_direccion || '',
                cliente_telefono || '', cliente_email || '',
                Number(subtotal || 0), Number(impuesto_pct || 0), Number(impuesto_monto || 0),
                Number(total || 0), metodo_pago || null, notas || null, usuario || null]
        );
        const factura = facturaRes.rows[0];
        const vals = [];
        const phs = [];
        let idx = 1;
        items.forEach((item) => {
            phs.push(`($${idx++}, $${idx++}, $${idx++}, $${idx++}, $${idx++}, $${idx++})`);
            vals.push(factura.id, item.producto_id ?? null, String(item.nombre || ''),
                Number(item.cantidad || 0), Number(item.precio_unitario || 0), Number(item.subtotal || 0));
        });
        await client.query(
            `INSERT INTO facturas_items (factura_id, producto_id, nombre, cantidad, precio_unitario, subtotal)
             VALUES ${phs.join(', ')}`, vals
        );
        await client.query('COMMIT');
        res.json(factura);
    } catch (err) {
        await client.query('ROLLBACK');
        console.error(err);
        res.status(500).json({ error: 'Error al crear factura' });
    } finally {
        client.release();
    }
});

// PUT editar factura (solo datos de cliente y notas, no items)
app.put('/api/facturas/:id', async (req, res) => {
    const { id } = req.params;
    const { cliente_nombre, cliente_identificacion, cliente_direccion,
        cliente_telefono, cliente_email, notas, tipo } = req.body;
    try {
        const result = await pool.query(
            `UPDATE facturas SET
                cliente_nombre = COALESCE($1, cliente_nombre),
                cliente_identificacion = COALESCE($2, cliente_identificacion),
                cliente_direccion = COALESCE($3, cliente_direccion),
                cliente_telefono = COALESCE($4, cliente_telefono),
                cliente_email = COALESCE($5, cliente_email),
                notas = COALESCE($6, notas),
                tipo = COALESCE($7, tipo)
             WHERE id = $8 AND estado != 'ANULADA'
             RETURNING *`,
            [cliente_nombre, cliente_identificacion, cliente_direccion,
                cliente_telefono, cliente_email, notas, tipo, Number(id)]
        );
        if (!result.rows.length) return res.status(404).json({ error: 'Factura no encontrada o anulada' });
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al actualizar factura' });
    }
});

// POST anular factura
app.post('/api/facturas/:id/anular', async (req, res) => {
    const { id } = req.params;
    const { motivo, usuario } = req.body;
    if (!motivo) return res.status(400).json({ error: 'Motivo de anulación requerido' });
    try {
        const result = await pool.query(
            `UPDATE facturas SET estado = 'ANULADA', anulada_motivo = $1, anulada_fecha = NOW()
             WHERE id = $2 AND estado != 'ANULADA' RETURNING *`,
            [String(motivo), Number(id)]
        );
        if (!result.rows.length) return res.status(404).json({ error: 'Factura no encontrada o ya anulada' });
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al anular factura' });
    }
});

// POST marcar factura como impresa
app.post('/api/facturas/:id/marcar-impresa', async (req, res) => {
    try {
        const result = await pool.query(
            'UPDATE facturas SET impresa = true WHERE id = $1 RETURNING *',
            [Number(req.params.id)]
        );
        if (!result.rows.length) return res.status(404).json({ error: 'Factura no encontrada' });
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al marcar impresa' });
    }
});

// ===================== CONFIG IMPRESORA =====================

app.get('/api/config/impresora', async (_req, res) => {
    try {
        const result = await pool.query('SELECT * FROM config_impresora WHERE id = 1');
        res.json(result.rows[0] || { nombre_impresora: '', tipo: 'TERMICA', ancho_mm: 80, auto_imprimir: false });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al obtener config impresora' });
    }
});

app.put('/api/config/impresora', async (req, res) => {
    const { nombre_impresora, tipo, ancho_mm, auto_imprimir } = req.body;
    try {
        const result = await pool.query(
            `UPDATE config_impresora SET
                nombre_impresora = $1, tipo = $2, ancho_mm = $3, auto_imprimir = $4, updated_at = NOW()
             WHERE id = 1 RETURNING *`,
            [nombre_impresora || '', tipo || 'TERMICA', Number(ancho_mm || 80), Boolean(auto_imprimir)]
        );
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al guardar config impresora' });
    }
});

// GET secuencia de facturas
app.get('/api/config/factura-secuencia', async (_req, res) => {
    try {
        const result = await pool.query('SELECT * FROM facturas_secuencia WHERE id = 1');
        res.json(result.rows[0] || { prefijo: 'REC', siguiente: 1 });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al obtener secuencia' });
    }
});

app.put('/api/config/factura-secuencia', async (req, res) => {
    const { prefijo, siguiente } = req.body;
    try {
        const result = await pool.query(
            'UPDATE facturas_secuencia SET prefijo = $1, siguiente = $2 WHERE id = 1 RETURNING *',
            [prefijo || 'REC', Number(siguiente || 1)]
        );
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Error al actualizar secuencia' });
    }
});

initDb()
    .then(() => {
        app.listen(port, () => {
            console.log(`🚀 Servidor backend corriendo en puerto ${port}`);
        });
    })
    .catch((err) => {
        console.error('❌ Error inicializando la base de datos', err);
        process.exit(1);
    });