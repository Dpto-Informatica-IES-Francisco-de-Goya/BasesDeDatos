-- Ejercicio 4: Indicadores de Velocidad
ALTER TABLE envios ADD COLUMN velocidad_media DECIMAL(10,2) AFTER ruta_distancia_km;

START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;

-- Normalizar distancia para el cálculo
-- ruta_distancia_km ej: '1421 km'
UPDATE envios SET ruta_distancia_km = TRIM(REPLACE(ruta_distancia_km, ' km', ''));

-- Usaremos solo los que tienen año de 4 dígitos para evitar ambigüedad como pide el ejercicio 6 también
-- Pero aquí calculamos velocidad.
-- Normalizamos a fecha real para poder usar TIMESTAMPDIFF
UPDATE envios 
SET 
    velocidad_media = CAST(ruta_distancia_km AS DECIMAL(10,2)) / 
    NULLIF(TIMESTAMPDIFF(HOUR, 
        CASE 
            WHEN f_salida LIKE '%/%/____' THEN STR_TO_DATE(f_salida, '%d/%m/%Y')
            WHEN f_salida LIKE '____-%-%' THEN STR_TO_DATE(f_salida, '%Y-%m-%d')
            ELSE NULL 
        END,
        CASE 
            WHEN f_entrega_real LIKE '%/%/____' THEN STR_TO_DATE(f_entrega_real, '%d/%m/%Y')
            WHEN f_entrega_real LIKE '____-%-%' THEN STR_TO_DATE(f_entrega_real, '%Y-%m-%d')
            ELSE NULL 
        END
    ), 0)
WHERE (f_salida LIKE '%/%/____' OR f_salida LIKE '____-%-%')
  AND (f_entrega_real LIKE '%/%/____' OR f_entrega_real LIKE '____-%-%');

COMMIT;
SET SQL_SAFE_UPDATES = 1;

-- Verificación: envíos con velocidad > 120 (anómalos para camiones)
SELECT id, f_salida, f_entrega_real, ruta_distancia_km, velocidad_media 
FROM envios 
WHERE velocidad_media > 120 LIMIT 5;
