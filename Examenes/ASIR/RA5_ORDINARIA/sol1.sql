-- Ejercicio 1

select id,ruta_origen_ciudad,ruta_destino_ciudad from envios;

-- Camino estándar
select 
	e1.id,e1.ruta_origen_ciudad,e1.ruta_destino_ciudad,
    e2.id,e2.ruta_origen_ciudad,e2.ruta_destino_ciudad
    FROM 
		envios e1 JOIN envios e2 ON 
			e1.ruta_origen_ciudad = e2.ruta_origen_ciudad AND
            e1.ruta_destino_ciudad = e2.ruta_destino_ciudad;

START TRANSACTION;
set sql_safe_updates = 0;
DELETE e1 
    FROM 
		envios e1 JOIN envios e2 ON 
			e1.ruta_origen_ciudad = e2.ruta_origen_ciudad AND
            e1.ruta_destino_ciudad = e2.ruta_destino_ciudad
	WHERE e1.id > e2.id;
set sql_safe_updates = 1;
rollback;

-- ALTERNATIVA

-- Tienen que sobrevivir estos:
SELECT 
    MIN(id), count(id), ruta_origen_ciudad, ruta_destino_ciudad
FROM
    envios
GROUP BY ruta_origen_ciudad , ruta_destino_ciudad;

-- Creo una tabla temporal FUERA DE LA TRANSACCIÓN

set sql_safe_updates = 0;
CREATE TABLE ids_a_conservar (id INT);

-- Inserto los ids que deben sobrevivir
START TRANSACTION;
INSERT INTO ids_a_conservar(id) 
	SELECT MIN(id)
		FROM
			envios
		GROUP BY ruta_origen_ciudad , ruta_destino_ciudad;
        
        
select * from ids_a_conservar;
-- Borrado los envios cuyo id no está en la tabla de supervivientes    
DELETE e FROM envios e
WHERE
    e.id NOT IN (select id from ids_a_conservar);
        
-- rollback para poder hacer el resto de ejercicios.
SET sql_safe_updates = 1;
ROLLBACK;

-- OTRAS SOLUCIONES AL DELETE 
START TRANSACTION;
DELETE FROM envios
WHERE id NOT IN (
    SELECT id FROM (
        SELECT min(id)
        FROM envios 
        GROUP BY ruta_origen_ciudad, ruta_destino_ciudad        
    )
);
ROLLBACK;


-- solución magnífica para otros duplicados de la tabla envios

-- CREATE INDEX idx_rutas_en_envios ON envios(ruta_origen_ciudad,ruta_destino_ciudad);
/* CREATE INDEX idx_rutas_en_envios_origen ON envios(ruta_origen_ciudad);
CREATE INDEX idx_rutas_en_envios_destino ON envios(ruta_destino_ciudad);

START TRANSACTION;
set sql_safe_updates = 0;
DELETE e1 
    FROM 
		envios e1 JOIN envios e2 ON 
			e1.ruta_origen_ciudad = e2.ruta_origen_ciudad AND
            e1.ruta_destino_ciudad = e2.ruta_destino_ciudad
	WHERE e1.id > e2.id;
set sql_safe_updates = 1;
rollback;
*/
