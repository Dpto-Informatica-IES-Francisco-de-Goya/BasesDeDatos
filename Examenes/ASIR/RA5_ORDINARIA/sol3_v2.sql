DROP TABLE envios_normalizados;
CREATE TABLE envios_normalizados (
	id_envio INT PRIMARY KEY,
    distancia_km DECIMAL(8,2),
    f_salida DATE,
    f_entrega_real DATE,
    dias_transito INT
);

ALTER TABLE envios_normalizados ADD CONSTRAINT fk_envios_normalizados_envios
FOREIGN KEY (id_envio) REFERENCES envios(id) ON DELETE RESTRICT ON UPDATE CASCADE;

start transaction;
set sql_safe_updates = 0;
INSERT INTO envios_normalizados
SELECT 
    id,
	REPLACE(ruta_distancia_km,' km',''),
    CASE
        -- WHEN condicion THEN valor_a_asignar
        WHEN f_salida like '__/__/____' THEN str_to_date(f_salida,'%d/%m/%Y')
        WHEN f_salida like '__-__-____' THEN str_to_date(f_salida,'%d-%m-%Y')
        WHEN f_salida like '____/__/__' THEN str_to_date(f_salida,'%Y/%m/%d')
        WHEN f_salida like '____-__-__' THEN str_to_date(f_salida,'%Y-%m-%d')
        WHEN f_salida like '__.__.____' THEN str_to_date(f_salida,'%d.%m.%Y')
        WHEN f_salida like '____.__.__' THEN str_to_date(f_salida,'%Y.%m.%d')        
    END,
    CASE
        -- WHEN condicion THEN valor_a_asignar
        WHEN f_entrega_real like '__/__/____' THEN str_to_date(f_entrega_real,'%d/%m/%Y')
        WHEN f_entrega_real like '__-__-____' THEN str_to_date(f_entrega_real,'%d-%m-%Y')
        WHEN f_entrega_real like '____/__/__' THEN str_to_date(f_entrega_real,'%Y/%m/%d')
        WHEN f_entrega_real like '____-__-__' THEN str_to_date(f_entrega_real,'%Y-%m-%d')
        WHEN f_entrega_real like '__.__.____' THEN str_to_date(f_entrega_real,'%d.%m.%Y')
        WHEN f_entrega_real like '____.__.__' THEN str_to_date(f_entrega_real,'%Y.%m.%d')        
    END,
    DATEDIFF(
					CASE
						WHEN f_entrega_real like '__/__/____' THEN str_to_date(f_entrega_real,'%d/%m/%Y')
						WHEN f_entrega_real like '__-__-____' THEN str_to_date(f_entrega_real,'%d-%m-%Y')
						WHEN f_entrega_real like '____/__/__' THEN str_to_date(f_entrega_real,'%Y/%m/%d')
						WHEN f_entrega_real like '____-__-__' THEN str_to_date(f_entrega_real,'%Y-%m-%d')
						WHEN f_entrega_real like '__.__.____' THEN str_to_date(f_entrega_real,'%d.%m.%Y')
						WHEN f_entrega_real like '____.__.__' THEN str_to_date(f_entrega_real,'%Y.%m.%d')        
					END,
					CASE
						WHEN f_salida like '__/__/____' THEN str_to_date(f_salida,'%d/%m/%Y')
						WHEN f_salida like '__-__-____' THEN str_to_date(f_salida,'%d-%m-%Y')
						WHEN f_salida like '____/__/__' THEN str_to_date(f_salida,'%Y/%m/%d')
						WHEN f_salida like '____-__-__' THEN str_to_date(f_salida,'%Y-%m-%d')
						WHEN f_salida like '__.__.____' THEN str_to_date(f_salida,'%d.%m.%Y')
						WHEN f_salida like '____.__.__' THEN str_to_date(f_salida,'%Y.%m.%d')        
					END		
				
                )
 
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
set sql_safe_updates = 1;    
commit;
