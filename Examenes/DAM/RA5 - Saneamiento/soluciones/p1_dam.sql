-- Ejercicio 1: Gestión Salarial
-- Archivo: p1_dam.sql

-- 1. Añadir columna (Operación DDL: COMMIT implícito)
ALTER TABLE empleados ADD COLUMN salario_neto DECIMAL(10,2);

START TRANSACTION;

-- 2. Asignar 0 por defecto.
UPDATE empleados SET salario_neto = 0 WHERE salario_neto IS NULL;

-- 3. Primer cálculo (15% IRPF)
SAVEPOINT inicial;
UPDATE empleados 
SET salario_neto = CAST(TRIM(REPLACE(REPLACE(salario_base_sucio, ' EUR', ''), ',', '')) AS DECIMAL(10,2)) * 0.85
WHERE salario_base_sucio REGEXP '[0-9]';

-- 4. Corrección (18% IRPF)
ROLLBACK TO inicial;
UPDATE empleados 
SET salario_neto = CAST(TRIM(REPLACE(REPLACE(salario_base_sucio, ' EUR', ''), ',', '')) AS DECIMAL(10,2)) * 0.82
WHERE salario_base_sucio REGEXP '[0-9]';

-- 5. Comprobación.
SELECT salario_neto FROM empleados LIMIT 10;
COMMIT;
