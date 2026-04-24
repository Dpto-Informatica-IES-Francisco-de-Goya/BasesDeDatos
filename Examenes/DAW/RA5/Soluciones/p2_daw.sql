
SELECT SUBSTRING_INDEX(capacidad_m3,' ',1) FROM almacenes WHERE  SUBSTRING_INDEX(capacidad_m3,' ',1) REGEXP '[^0-9]';

START transaction;
DELETE FROM almacenes a1 WHERE capacidad_m3 IN ('Infinita','Reino');

DELETE a1 FROM almacenes a1
	JOIN almacenes a2 ON a1.cod_almacen = a2.cod_almacen
WHERE 
	SUBSTRING_INDEX(a1.capacidad_m3,' ',1)*1.0 < SUBSTRING_INDEX(a2.capacidad_m3,' ',1)*1.0
    OR ( 
		SUBSTRING_INDEX(a1.capacidad_m3,' ',1)*1.0 = SUBSTRING_INDEX(a2.capacidad_m3,' ',1)*1.0
			AND
		a1.id > a2.id
	);
COMMIT;
	
    
select a1.id,a1.cod_almacen,a1.capacidad_m3, a2.id,a2.cod_almacen,a2.capacidad_m3 FROM almacenes a1
	JOIN almacenes a2 ON a1.cod_almacen = a2.cod_almacen
    WHERE a1.id != a2.id;