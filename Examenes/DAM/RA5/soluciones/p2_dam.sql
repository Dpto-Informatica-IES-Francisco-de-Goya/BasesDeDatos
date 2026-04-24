-- Ejercicio 2: Saneamiento de Infraestructura
-- Archivo: p2_dam.sql
START TRANSACTION;

DELETE a1 FROM almacenes a1
INNER JOIN almacenes a2 ON a1.cod_almacen = a2.cod_almacen
WHERE 
    -- Conservar el nombre_sucursal mas largo
    CHAR_LENGTH(IFNULL(a1.nombre_sucursal, '')) < CHAR_LENGTH(IFNULL(a2.nombre_sucursal, ''))
    OR 
    -- En caso de empate en longitud, conservar el ID mas bajo (borrar el mas alto)
    (CHAR_LENGTH(IFNULL(a1.nombre_sucursal, '')) = CHAR_LENGTH(IFNULL(a2.nombre_sucursal, '')) 
     AND a1.id > a2.id);

COMMIT;
