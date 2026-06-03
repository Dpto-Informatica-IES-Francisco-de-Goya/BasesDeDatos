-- Recuperación Ordinaria RA4 DAM/DAW - Tratamiento de Datos
-- Base de datos: logistica_global
-- Independencia total: cada script sobre una copia limpia.

-- ============================================================
-- PREGUNTA 1: Saneamiento con Lógica Condicional
-- Existen envíos con vehiculo_id que no corresponde a ningún vehículo real.
-- ============================================================
SET SQL_SAFE_UPDATES = 0;
START TRANSACTION;

-- Reasignar envíos con vehículo inexistente al vehículo de sustitución id=1
UPDATE envios
SET vehiculo_id = 1
WHERE vehiculo_id NOT IN (SELECT id FROM vehiculos);

COMMIT;
SET SQL_SAFE_UPDATES = 1;

-- Definir la FOREIGN KEY para evitar que vuelva a ocurrir
ALTER TABLE envios
ADD CONSTRAINT fk_envios_vehiculo
FOREIGN KEY (vehiculo_id) REFERENCES vehiculos(id);

-- Verificación
SELECT COUNT(*) AS invalidos_restantes
FROM envios
WHERE vehiculo_id IS NOT NULL
  AND vehiculo_id NOT IN (SELECT id FROM vehiculos);

/** RÚBRICA:
 * Update correcto: 1/1
 * Añadida FK: 1/1
 * Commit antes del alter table 0/0.5
 * 
Nota: 
 * */


-- ============================================================
-- PREGUNTA 2: Eliminación de Duplicados
-- Nota: un self-join sobre 100.000 filas tiene coste O(n²) y provoca timeout.
-- Solución eficiente: subconsulta que extrae los IDs a conservar (MIN por tracking_number),
-- envuelta en otra subconsulta para evitar la restricción de MySQL de no poder
-- SELECT y DELETE la misma tabla a la vez.
-- ============================================================
START TRANSACTION;

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

/** RÚBRICA:
 * Delete correcto: 1/1
 * No da timeout: 0/1
 * Rollback: 0/0.5
 * 
Nota: 
 * */


-- Se deshacen los cambios para no alterar los datos que usan los demás ejercicios
ROLLBACK;

-- ============================================================
-- PREGUNTA 3: Migración y Normalización de Datos
-- ============================================================
CREATE TABLE envios_normalizados (
    id_envio      INT          NOT NULL,
    distancia_km  DECIMAL(8,2),
    f_salida      DATE,
    f_entrega_real DATE,
    dias_transito INT,
    CONSTRAINT pk_env_norm   PRIMARY KEY (id_envio),
    CONSTRAINT fk_env_norm   FOREIGN KEY (id_envio) REFERENCES envios(id)
);

-- Solo envíos cuyas fechas tienen año de 4 dígitos (formato unívoco)
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

-- CREATE TABLE es DDL (commit implícito): no se puede deshacer con ROLLBACK.
-- Se elimina la tabla para que el Ejercicio 4 pueda borrar filas de envios sin
-- que el FK de envios_normalizados lo impida.
DROP TABLE IF EXISTS envios_normalizados;


/** RÚBRICA:
 * Create table: 0.5/0.5
 * str_to_date bien utilizado: 1/1
 * datediff bien hecho: 0.5/0.5
 * funciona: 0.5/0.5
 * drop table 0.5/0.5
 * 
Nota: 
 * */

-- ============================================================
-- PREGUNTA 4: Transacciones y Puntos de Guardado
-- ============================================================
START TRANSACTION;

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

COMMIT;

/** RÚBRICA:
 * importe_envio saneado: 0.5/0.5
 * Incremento: 0.5/0.5
 * Delete: 0.5/0.5
 * Savepoint y rollbacks: 1/1 
Nota: 0
 * */

