-- Ejercicio 2: Saneamiento de Infraestructura
START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;

-- Eliminar almacenes que tengan un campo capacidad que no sea numérico (y no sea NULL)
DELETE FROM almacenes 
WHERE capacidad_m3 IS NOT NULL 
AND SUBSTRING_INDEX(capacidad_m3, ' ', 1) NOT REGEXP '^[0-9]+$';

-- Borrar duplicados conservando capacidad más alta
-- Usamos IFNULL(..., 0) para que los NULL no rompan la comparación
DELETE a1 FROM almacenes a1
JOIN almacenes a2 ON a1.cod_almacen = a2.cod_almacen
WHERE 
    CAST(IFNULL(SUBSTRING_INDEX(a1.capacidad_m3, ' ', 1), 0) AS UNSIGNED) < CAST(IFNULL(SUBSTRING_INDEX(a2.capacidad_m3, ' ', 1), 0) AS UNSIGNED)
    OR
    (
        CAST(IFNULL(SUBSTRING_INDEX(a1.capacidad_m3, ' ', 1), 0) AS UNSIGNED) = CAST(IFNULL(SUBSTRING_INDEX(a2.capacidad_m3, ' ', 1), 0) AS UNSIGNED)
        AND a1.id > a2.id
    );

COMMIT;
SET SQL_SAFE_UPDATES = 1;

-- Verificación
SELECT cod_almacen, COUNT(*) FROM almacenes GROUP BY cod_almacen HAVING COUNT(*) > 1;
