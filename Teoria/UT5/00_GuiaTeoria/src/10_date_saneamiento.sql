-- Conversión de tipos y saneamiento de fechas
-- Ejemplo: Convertir texto '01/01/2020' a tipo DATETIME
UPDATE sys_logs
SET created_at = STR_TO_DATE('12/03/2026 10:30:00', '%d/%m/%Y %H:%i:%s')
WHERE id = 1;

-- Uso de CAST para asegurar tipos numéricos en importaciones de cadenas
UPDATE clientes
SET credito = CAST('150.50' AS DECIMAL(10,2))
WHERE nombre = 'Carlos Ruiz';
