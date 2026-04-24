SELECT * FROM envios;

ALTER TABLE envios ADD COLUMN horas_transito DECIMAL(10,2);
select f_salida FROM envios where f_salida LIKE '%.%';
select f_salida FROM envios;

START TRANSACTION;
SELECT f_salida FROM envios;
UPDATE envios SET
	f_salida = CASE
		WHEN f_salida LIKE '%/%/____' THEN STR_TO_DATE(f_salida,'%d/%m/%Y')
        WHEN f_salida LIKE '%-%-____' THEN STR_TO_DATE(f_salida,'%d-%m-%Y')
        WHEN f_salida LIKE '____-%-%' THEN STR_TO_DATE(f_salida,'%Y-%m-%d')
        WHEN f_salida LIKE '____/%/%' THEN STR_TO_DATE(f_salida,'%Y/%m/%d')
        WHEN f_salida LIKE '____.%.%' THEN STR_TO_DATE(f_salida,'%Y.%m.%d')
        ELSE NULL
	END,
	f_entrega_real = CASE
		WHEN f_entrega_real LIKE '%/%/____' THEN STR_TO_DATE(f_entrega_real,'%d/%m/%Y')
        WHEN f_entrega_real LIKE '%-%-____' THEN STR_TO_DATE(f_entrega_real,'%d-%m-%Y')
        WHEN f_entrega_real LIKE '____-%-%' THEN STR_TO_DATE(f_entrega_real,'%Y-%m-%d')
        WHEN f_entrega_real LIKE '____/%/%' THEN STR_TO_DATE(f_entrega_real,'%Y/%m/%d')
        WHEN f_entrega_real LIKE '____.%.%' THEN STR_TO_DATE(f_entrega_real,'%Y.%m.%d')
        ELSE NULL
	END;

UPDATE envios SET horas_transito = TIMESTAMPDIFF(HOUR,f_salida,f_entrega_real);
select distinct f_salida,f_entrega_real,horas_transito from envios;

COMMIT;
ALTER TABLE envios MODIFY f_salida DATE;
