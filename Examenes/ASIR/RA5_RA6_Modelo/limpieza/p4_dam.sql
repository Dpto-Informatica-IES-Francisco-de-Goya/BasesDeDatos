-- Ejercicio 6 (Extra): Normalización de Gestión (Retrasos)
-- Solo para envíos con año unívoco (4 dígitos)
ALTER TABLE envios ADD COLUMN dias_retraso INT AFTER f_entrega_real;

START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;

UPDATE envios 
SET dias_retraso = DATEDIFF(
    CASE 
        WHEN f_entrega_real LIKE '%/%/____' THEN STR_TO_DATE(f_entrega_real, '%d/%m/%Y')
        WHEN f_entrega_real LIKE '____-%-%' THEN STR_TO_DATE(f_entrega_real, '%Y-%m-%d')
        ELSE NULL 
    END,
    CASE 
        WHEN f_llegada_prevista LIKE '%/%/____' THEN STR_TO_DATE(f_llegada_prevista, '%d/%m/%Y')
        WHEN f_llegada_prevista LIKE '____-%-%' THEN STR_TO_DATE(f_llegada_prevista, '%Y-%m-%d')
        ELSE NULL 
    END
)
WHERE (f_entrega_real LIKE '%/%/____' OR f_entrega_real LIKE '____-%-%')
  AND (f_llegada_prevista LIKE '%/%/____' OR f_llegada_prevista LIKE '____-%-%');

COMMIT;
SET SQL_SAFE_UPDATES = 1;

-- Verificación
SELECT f_llegada_prevista, f_entrega_real, dias_retraso 
FROM envios 
WHERE dias_retraso IS NOT NULL AND dias_retraso > 0 LIMIT 5;
