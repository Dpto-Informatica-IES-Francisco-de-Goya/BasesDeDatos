-- Recuperación Ordinaria RA3+RA4 DAM/DAW - Consulta y Modificación
-- Base de datos: logistica_global
-- Cada ejercicio es independiente: se evalúa sobre una copia limpia.

-- ============================================================
-- EJERCICIO 1 [RA3 - CE.b, CE.c]: Consulta - Vehículos inexistentes
-- ============================================================
SELECT 'Ejercicio 1 [RA3]: envíos con vehiculo_id inexistente' AS '';
SELECT id, tracking_number, vehiculo_id
FROM envios
WHERE vehiculo_id IS NOT NULL
  AND vehiculo_id NOT IN (SELECT id FROM vehiculos);

-- ============================================================
-- EJERCICIO 1 [RA4 - CE.d, CE.g]: Modificación - Reasignar + FK
-- ============================================================
SET SQL_SAFE_UPDATES = 0;
START TRANSACTION;

UPDATE envios
SET vehiculo_id = 1
WHERE vehiculo_id NOT IN (SELECT id FROM vehiculos);

COMMIT;
SET SQL_SAFE_UPDATES = 1;

-- Añadir la FK para evitar que vuelva a ocurrir
ALTER TABLE envios
ADD CONSTRAINT fk_envios_vehiculo
FOREIGN KEY (vehiculo_id) REFERENCES vehiculos(id);

-- Verificación
SELECT COUNT(*) AS invalidos_restantes
FROM envios
WHERE vehiculo_id IS NOT NULL
  AND vehiculo_id NOT IN (SELECT id FROM vehiculos);

-- ============================================================
-- EJERCICIO 2 [RA3 - CE.c, CE.e]: Consulta - Identificar duplicados
-- ============================================================
SELECT 'Ejercicio 2 [RA3]: tracking_numbers duplicados' AS '';
SELECT tracking_number,
       COUNT(*)  AS num_duplicados,
       MIN(id)   AS id_a_conservar
FROM envios
WHERE tracking_number IS NOT NULL
GROUP BY tracking_number
HAVING COUNT(*) > 1
ORDER BY num_duplicados DESC;

-- ============================================================
-- EJERCICIO 2 [RA4 - CE.b, CE.d]: Modificación - Eliminar duplicados
-- Nota: self-join sobre 100k filas → timeout. Se usa subconsulta con MIN(id).
--       Se deshacen los cambios para no afectar a los ejercicios siguientes.
-- ============================================================
START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM envios
WHERE tracking_number IS NOT NULL
  AND id NOT IN (
      SELECT min_id FROM (
          SELECT MIN(id) AS min_id
          FROM envios
          WHERE tracking_number IS NOT NULL
          GROUP BY tracking_number
      ) AS ids_a_conservar
  );
SET SQL_SAFE_UPDATES = 1;
ROLLBACK;

-- ============================================================
-- EJERCICIO 3 [RA3 - CE.c, CE.d]: Consulta - Listado a normalizar
-- ============================================================
SELECT 'Ejercicio 3 [RA3]: envíos a insertar en envios_normalizados' AS '';
SELECT
    id,
    CAST(TRIM(REPLACE(ruta_distancia_km, ' km', '')) AS DECIMAL(8,2)) AS distancia_km,
    CASE
        WHEN f_salida REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
            THEN STR_TO_DATE(f_salida, '%d/%m/%Y')
        WHEN f_salida REGEXP '^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}$'
            THEN STR_TO_DATE(f_salida, '%Y-%m-%d')
    END AS f_salida_norm,
    CASE
        WHEN f_entrega_real REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
            THEN STR_TO_DATE(f_entrega_real, '%d/%m/%Y')
        WHEN f_entrega_real REGEXP '^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}$'
            THEN STR_TO_DATE(f_entrega_real, '%Y-%m-%d')
    END AS f_entrega_norm
FROM envios
WHERE (f_salida       REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
    OR f_salida       REGEXP '^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}$')
  AND (f_entrega_real REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
    OR f_entrega_real REGEXP '^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}$')
LIMIT 5;

-- ============================================================
-- EJERCICIO 3 [RA4 - CE.b, CE.c, CE.e]: Modificación - Crear tabla e insertar
-- Nota: CREATE TABLE es DDL (commit implícito). Se elimina al final para no
--       bloquear el Ejercicio 5 mediante el FK envios_normalizados → envios.
-- ============================================================
CREATE TABLE envios_normalizados (
    id_envio       INT          NOT NULL,
    distancia_km   DECIMAL(8,2),
    f_salida       DATE,
    f_entrega_real DATE,
    dias_transito  INT,
    CONSTRAINT pk_env_norm PRIMARY KEY (id_envio),
    CONSTRAINT fk_env_norm FOREIGN KEY (id_envio) REFERENCES envios(id)
);

INSERT INTO envios_normalizados (id_envio, distancia_km, f_salida, f_entrega_real, dias_transito)
SELECT
    id,
    CAST(TRIM(REPLACE(ruta_distancia_km, ' km', '')) AS DECIMAL(8,2)),
    CASE
        WHEN f_salida REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
            THEN STR_TO_DATE(f_salida,       '%d/%m/%Y')
        WHEN f_salida REGEXP '^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}$'
            THEN STR_TO_DATE(f_salida,       '%Y-%m-%d')
    END,
    CASE
        WHEN f_entrega_real REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
            THEN STR_TO_DATE(f_entrega_real, '%d/%m/%Y')
        WHEN f_entrega_real REGEXP '^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}$'
            THEN STR_TO_DATE(f_entrega_real, '%Y-%m-%d')
    END,
    DATEDIFF(
        CASE
            WHEN f_entrega_real REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
                THEN STR_TO_DATE(f_entrega_real, '%d/%m/%Y')
            WHEN f_entrega_real REGEXP '^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}$'
                THEN STR_TO_DATE(f_entrega_real, '%Y-%m-%d')
        END,
        CASE
            WHEN f_salida REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
                THEN STR_TO_DATE(f_salida,       '%d/%m/%Y')
            WHEN f_salida REGEXP '^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}$'
                THEN STR_TO_DATE(f_salida,       '%Y-%m-%d')
        END
    )
FROM envios
WHERE (f_salida       REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
    OR f_salida       REGEXP '^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}$')
  AND (f_entrega_real REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
    OR f_entrega_real REGEXP '^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}$');

DROP TABLE IF EXISTS envios_normalizados;

-- ============================================================
-- EJERCICIO 4 [RA3 - CE.c, CE.f]: Consulta - Integridad referencial (LEFT JOIN x3)
-- Envíos cuyo cliente o vehículo no existe en sus tablas respectivas.
-- ============================================================
SELECT 'Ejercicio 4 [RA3]: envíos con cliente o vehículo inexistente' AS '';
SELECT e.id,
       e.tracking_number,
       e.cliente_id,
       c.razon_social,
       e.vehiculo_id,
       v.matricula
FROM envios e
LEFT JOIN clientes  c ON e.cliente_id  = c.id
LEFT JOIN vehiculos v ON e.vehiculo_id = v.id
WHERE c.id IS NULL
   OR v.id IS NULL
ORDER BY e.id;

-- ============================================================
-- EJERCICIO 5 [RA4 - CE.e, CE.f]: Modificación - Transacciones y Puntos de Guardado
-- ============================================================
START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;
-- Paso 1: saneamiento — eliminar el símbolo '€' para poder operar numéricamente
UPDATE envios
SET importe_envio = TRIM(REPLACE(importe_envio, '€', ''))
WHERE importe_envio LIKE '%€';

-- Paso 2: incremento del 5% sobre el valor ya limpio
UPDATE envios
SET importe_envio = ROUND(CAST(importe_envio AS DECIMAL(10,2)) * 1.05, 2)
WHERE importe_envio REGEXP '^[0-9]+(\\.[0-9]+)?$';

SAVEPOINT antes_borrado;

DELETE FROM envios
WHERE importe_envio REGEXP '^[0-9]+(\\.[0-9]+)?$'
  AND CAST(importe_envio AS DECIMAL(10,2)) > 500;

ROLLBACK TO antes_borrado;
SET SQL_SAFE_UPDATES = 1;
COMMIT;
