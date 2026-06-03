
CREATE TABLE envios_normalizados (
	id_envio INT PRIMARY KEY,
    distancia_km DECIMAL(8,2),
    f_salida DATE,
    f_entrega_real DATE,
    dias_transito INT
);

ALTER TABLE envios_normalizados ADD CONSTRAINT fk_envios_normalizados_envios
FOREIGN KEY (id_envio) REFERENCES envios(id) ON DELETE RESTRICT ON UPDATE CASCADE;

explain envios;
select ruta_distancia_km from envios;
DROP TABLE fechas_limpias_con_distancia;
CREATE TABLE fechas_limpias_con_distancia (
	id INT,
    f_salida VARCHAR(15),
    f_entrega_real VARCHAR(15),
    distancia_km DECIMAL(8,2)
);

INSERT INTO fechas_limpias_con_distancia
SELECT id, f_salida,f_entrega_real, REPLACE(ruta_distancia_km,' km','')
FROM envios
WHERE 
	(f_salida REGEXP '^[0-9][0-9][0-9][0-9]' 
		OR 
	f_salida REGEXP '[0-9][0-9][0-9][0-9]$' )
		AND 
    (f_entrega_real REGEXP '^[0-9][0-9][0-9][0-9]' 
		OR 
	f_entrega_real REGEXP '[0-9][0-9][0-9][0-9]$')
	;
    
select * from fechas_limpias_con_distancia;
SET SQL_SAFE_UPDATES = 0;
UPDATE fechas_limpias_con_distancia
SET 
	f_salida = CASE
		-- WHEN condicion THEN valor_a_asignar
        WHEN f_salida like '__/__/____' THEN str_to_date(f_salida,'%d/%m/%Y')
        WHEN f_salida like '__-__-____' THEN str_to_date(f_salida,'%d-%m-%Y')
        WHEN f_salida like '____/__/__' THEN str_to_date(f_salida,'%Y/%m/%d')
        WHEN f_salida like '____-__-__' THEN str_to_date(f_salida,'%Y-%m-%d')
        WHEN f_salida like '__.__.____' THEN str_to_date(f_salida,'%d.%m.%Y')
        WHEN f_salida like '____.__.__' THEN str_to_date(f_salida,'%Y.%m.%d')        
    END,
    f_entrega_real = CASE
		-- WHEN condicion THEN valor_a_asignar
        WHEN f_entrega_real like '__/__/____' THEN str_to_date(f_entrega_real,'%d/%m/%Y')
        WHEN f_entrega_real like '__-__-____' THEN str_to_date(f_entrega_real,'%d-%m-%Y')
        WHEN f_entrega_real like '____/__/__' THEN str_to_date(f_entrega_real,'%Y/%m/%d')
        WHEN f_entrega_real like '____-__-__' THEN str_to_date(f_entrega_real,'%Y-%m-%d')
        WHEN f_entrega_real like '__.__.____' THEN str_to_date(f_entrega_real,'%d.%m.%Y')
        WHEN f_entrega_real like '____.__.__' THEN str_to_date(f_entrega_real,'%Y.%m.%d')        
    END,
    distancia_km = REPLACE (distancia_km,' km','');
select * from fechas_limpias_con_distancia;

INSERT INTO envios_normalizados 
SELECT 
	id,
    distancia_km ,
    f_salida ,
    f_entrega_real,
    DATEDIFF(f_entrega_real,f_salida)    
FROM fechas_limpias_con_distancia;

SELECT * FROM envios_normalizados;
