
ALTER TABLE envios ADD COLUMN velocidad_media_kmh DECIMAL(10,2);

START TRANSACTION;
-- 2. Limpieza de distancia y normalización de fechas
UPDATE envios SET 
    ruta_distancia_km = TRIM(REPLACE(ruta_distancia_km, ' km', '')),
    f_salida = CASE 
        WHEN f_salida LIKE '%/%/____' THEN STR_TO_DATE(f_salida, '%d/%m/%Y')
        WHEN f_salida LIKE '%-%-____' THEN STR_TO_DATE(f_salida, '%d-%m-%Y')
        WHEN f_salida LIKE '____/%/%' THEN STR_TO_DATE(f_salida, '%Y/%m/%d')
        WHEN f_salida LIKE '____-%-%' THEN STR_TO_DATE(f_salida, '%Y-%m-%d')
        ELSE NULL
    END,
    f_entrega_real = CASE 
        WHEN f_entrega_real LIKE '%/%/____' THEN STR_TO_DATE(f_entrega_real, '%d/%m/%Y')
        WHEN f_entrega_real LIKE '%-%-____' THEN STR_TO_DATE(f_entrega_real, '%d-%m-%Y')
        WHEN f_entrega_real LIKE '____/%/%' THEN STR_TO_DATE(f_entrega_real, '%Y/%m/%d')
        WHEN f_entrega_real LIKE '____-%-%' THEN STR_TO_DATE(f_entrega_real, '%Y-%m-%d')
        ELSE NULL
    END;
    
    -- 3. Calcular velocidad media
UPDATE envios SET 
    velocidad_media_kmh = CAST(ruta_distancia_km AS DECIMAL) / 
		TIMESTAMPDIFF(HOUR, f_salida, f_entrega_real)
WHERE f_salida IS NOT NULL and f_entrega_real IS NOT NULL;

-- 4. Convertir f_llegada_prevista estructuralmente
UPDATE envios SET 
    f_llegada_prevista = CASE 
        WHEN f_llegada_prevista LIKE '%/%/____' THEN STR_TO_DATE(f_llegada_prevista, '%d/%m/%Y')
        WHEN f_llegada_prevista LIKE '%-%-____' THEN STR_TO_DATE(f_llegada_prevista, '%d-%m-%Y')
        WHEN f_llegada_prevista LIKE '____/%/%' THEN STR_TO_DATE(f_llegada_prevista, '%Y/%m/%d')
        WHEN f_llegada_prevista LIKE '____-%-%' THEN STR_TO_DATE(f_llegada_prevista, '%Y-%m-%d')
        ELSE NULL
    END;
COMMIT;

ALTER TABLE envios MODIFY f_llegada_prevista DATE;

    
