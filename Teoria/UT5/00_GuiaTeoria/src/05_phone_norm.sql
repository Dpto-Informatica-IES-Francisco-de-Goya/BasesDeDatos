-- Supongamos telefonos importados como "+34 600 123 456" o "0034 600-123-456"
UPDATE clientes
SET telefono = REPLACE(REPLACE(REPLACE(telefono, '+34', ''), '0034', ''), '-', '')
WHERE telefono LIKE '+34%' OR telefono LIKE '0034%' OR telefono LIKE '%-%';

-- Segundo pase: limpiar posibles espacios generados
UPDATE clientes SET telefono = TRIM(telefono);
