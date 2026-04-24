select salario_base_sucio from empleados WHERE salario_base_sucio noT like '%EUR%';

ALTER TABLE empleados 
	ADD COLUMN salario_neto DECIMAL(10,2) AFTER salario_base_sucio;

START transaction;
SET sql_safe_updates = 0;
UPDATE empleados
	SET salario_base_sucio = (CASE 
		WHEN salario_base_sucio like '% EUR%' THEN REPLACE(salario_base_sucio,' EUR','')
        ELSE salario_base_sucio = '0'
        END);
SAVEPOINT salario_sucio_limpio;
UPDATE empleados
	SET salario_neto = ROUND(salario_base_sucio * 0.85,2);
rollback TO salario_sucio_limpio;
UPDATE empleados
	SET salario_neto = ROUND(salario_base_sucio * 0.82,2);
COMMIT;
SELECT salario_base_sucio,salario_neto from empleados;