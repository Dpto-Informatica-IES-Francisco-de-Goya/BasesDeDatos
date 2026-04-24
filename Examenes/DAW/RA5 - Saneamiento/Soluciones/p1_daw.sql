-- Ejercicio 1:

select * from clientes;


ALTER TABLE clientes 
	ADD COLUMN credito_num DECIMAL(10,2) DEFAULT 0;

START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;
select * from clientes;
SAVEPOINT vamos_a_empezar;
UPDATE clientes
	SET credito_num = TRIM(
		REPLACE(
			REPLACE(
				REPLACE(limite_credito_sucio, 
                ' USD', 
                '')
			,'€', 
            ''), 
		',', 
        '')
	) * CASE 
			WHEN limite_credito_sucio like '%USD' THEN 0.92
            ELSE 1.0
		END
WHERE limite_credito_sucio REGEXP '[0-9]';
-- SAVEPOINT extraido_valor_numerico;

select * from clientes;
ROLLBACK TO vamos_a_empezar;
select * from clientes;


UPDATE clientes
	SET credito_num = TRIM(
		REPLACE(
			REPLACE(
				REPLACE(limite_credito_sucio, 
                ' USD', 
                '')
			,'€', 
            ''), 
		',', 
        '')
	) * CASE 
			WHEN limite_credito_sucio like '%USD' THEN 0.90
            ELSE 1.0
		END
WHERE limite_credito_sucio REGEXP '[0-9]';
select * from clientes;

SET SQL_SAFE_UPDATES = 0;
COMMIT;