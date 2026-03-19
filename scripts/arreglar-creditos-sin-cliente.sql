-- Arreglar ventas a crédito antiguas sin cliente_id
-- Objetivo: usar el campo legacy ventas.cliente_nombre para:
--  1) Crear clientes faltantes
--  2) Enlazar ventas.cliente_id a clientes.id
--
-- IMPORTANTE:
--  - Este script NO toca ventas que ya tengan cliente_id.
--  - Excluye "Consumidor Final".
--  - Usa comparación por nombre normalizado (trim + minúsculas + espacios colapsados).
--
-- Recomendación:
--  - Ejecutar primero en una copia/backup.
--  - Luego revisar manualmente clientes duplicados por variaciones de nombre.

BEGIN;

-- 1) Diagnóstico inicial
SELECT
  COUNT(*) AS creditos_sin_cliente
FROM ventas v
WHERE v.metodo_pago = 'CREDITO'
  AND v.cliente_id IS NULL
  AND v.cliente_nombre IS NOT NULL
  AND LENGTH(TRIM(v.cliente_nombre)) > 0
  AND LOWER(TRIM(v.cliente_nombre)) <> 'consumidor final';

-- 2) Crear clientes faltantes basados en ventas.cliente_nombre
WITH nombres AS (
  SELECT DISTINCT
    TRIM(regexp_replace(v.cliente_nombre, E'\\s+', ' ', 'g')) AS nombre
  FROM ventas v
  WHERE v.metodo_pago = 'CREDITO'
    AND v.cliente_id IS NULL
    AND v.cliente_nombre IS NOT NULL
    AND LENGTH(TRIM(v.cliente_nombre)) > 0
    AND LOWER(TRIM(v.cliente_nombre)) <> 'consumidor final'
), ins AS (
  INSERT INTO clientes (nombre, identificacion, telefono, email, direccion, notas)
  SELECT
    n.nombre,
    NULL,
    NULL,
    NULL,
    NULL,
    'Creado automáticamente por migración: ventas.cliente_nombre (créditos antiguos)'
  FROM nombres n
  WHERE NOT EXISTS (
    SELECT 1
    FROM clientes c
    WHERE LOWER(TRIM(regexp_replace(c.nombre, E'\\s+', ' ', 'g'))) = LOWER(n.nombre)
  )
  RETURNING id
)
SELECT COUNT(*) AS clientes_creados
FROM ins;

-- 3) Enlazar ventas.cliente_id por coincidencia de nombre normalizado
WITH map AS (
  SELECT
    LOWER(TRIM(regexp_replace(c.nombre, E'\\s+', ' ', 'g'))) AS norm,
    MIN(c.id) AS cliente_id
  FROM clientes c
  GROUP BY 1
), upd AS (
  UPDATE ventas v
  SET cliente_id = map.cliente_id
  FROM map
  WHERE v.metodo_pago = 'CREDITO'
    AND v.cliente_id IS NULL
    AND v.cliente_nombre IS NOT NULL
    AND LENGTH(TRIM(v.cliente_nombre)) > 0
    AND LOWER(TRIM(v.cliente_nombre)) <> 'consumidor final'
    AND LOWER(TRIM(regexp_replace(v.cliente_nombre, E'\\s+', ' ', 'g'))) = map.norm
  RETURNING v.id
)
SELECT COUNT(*) AS ventas_actualizadas
FROM upd;

-- 4) Diagnóstico final
SELECT
  COUNT(*) AS creditos_sin_cliente_restantes
FROM ventas v
WHERE v.metodo_pago = 'CREDITO'
  AND v.cliente_id IS NULL
  AND v.cliente_nombre IS NOT NULL
  AND LENGTH(TRIM(v.cliente_nombre)) > 0
  AND LOWER(TRIM(v.cliente_nombre)) <> 'consumidor final';

COMMIT;
