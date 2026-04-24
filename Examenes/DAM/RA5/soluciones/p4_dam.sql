-- Ejercicio 4: Auditoría de Retrasos
-- Archivo: p4_dam.sql

-- 1. Añadir columna (DDL fuera de transacción)
ALTER TABLE envios ADD COLUMN dias_retraso INT;

START TRANSACTION;

-- 2. Normalizar fechas (Actualizamos TODO, lo no unívoco queda NULL)
-- Usamos una lógica más robusta con REGEXP para detectar el año de 4 dígitos
UPDATE envios SET 
    f_llegada_prevista = CASE 
        WHEN f_llegada_prevista REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$' THEN STR_TO_DATE(f_llegada_prevista, '%d/%m/%Y')
        WHEN f_llegada_prevista REGEXP '^[0-9]{1,2}-[0-9]{1,2}-[0-9]{4}$' THEN STR_TO_DATE(f_llegada_prevista, '%d-%m-%Y')
        WHEN f_llegada_prevista REGEXP '^[0-9]{4}/[0-9]{1,2}/[0-9]{1,2}$' THEN STR_TO_DATE(f_llegada_prevista, '%Y/%m/%d')
        WHEN f_llegada_prevista REGEXP '^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}$' THEN STR_TO_DATE(f_llegada_prevista, '%Y-%m-%d')
        ELSE NULL
    END,
    f_entrega_real = CASE 
        WHEN f_entrega_real REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$' THEN STR_TO_DATE(f_entrega_real, '%d/%m/%Y')
        WHEN f_entrega_real REGEXP '^[0-9]{1,2}-[0-9]{1,2}-[0-9]{4}$' THEN STR_TO_DATE(f_entrega_real, '%d-%m-%Y')
        WHEN f_entrega_real REGEXP '^[0-9]{4}/[0-9]{1,2}/[0-9]{1,2}$' THEN STR_TO_DATE(f_entrega_real, '%Y/%m/%d')
        WHEN f_entrega_real REGEXP '^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}$' THEN STR_TO_DATE(f_entrega_real, '%Y-%m-%d')
        ELSE NULL
    END;

-- 3. Calcular retraso
UPDATE envios SET dias_retraso = DATEDIFF(f_entrega_real, f_llegada_prevista)
WHERE f_entrega_real IS NOT NULL AND f_llegada_prevista IS NOT NULL;

COMMIT;

-- 4. Convertir estructuralmente f_entrega_real
ALTER TABLE envios MODIFY f_entrega_real DATE;

