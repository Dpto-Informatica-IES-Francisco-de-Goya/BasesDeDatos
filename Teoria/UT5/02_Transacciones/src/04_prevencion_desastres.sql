-- 04. Prevención de desastres en UPDATE
START TRANSACTION;
UPDATE empleados SET salario = 0; -- ¡Olvidamos el WHERE!
SELECT * FROM empleados; 
ROLLBACK; -- Salvamos los datos
