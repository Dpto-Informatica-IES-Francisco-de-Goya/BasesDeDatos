SELECT * from almacenes;


SELECT 
	a1.id,a1.cod_almacen,a1.ciudad_ubicacion,
    a2.id,a2.cod_almacen,a2.ciudad_ubicacion
FROM almacenes a1 JOIN almacenes a2 ON a1.cod_almacen = a2.cod_almacen;

START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;
DELETE a1 FROM almacenes a1
	JOIN almacenes a2 ON a1.cod_almacen = a2.cod_almacen
    WHERE 
		LENGTH(IFNULL(a1.ciudad_ubicacion,'')) < LENGTH(IFNULL(a2.ciudad_ubicacion,''))
        OR
        (
			LENGTH(IFNULL(a1.ciudad_ubicacion,'')) = LENGTH(IFNULL(a2.ciudad_ubicacion,''))
            AND
            a1.id > a2.id
		);
-- ROLLBACK;
SET SQL_SAFE_UPDATES = 1;
COMMIT;