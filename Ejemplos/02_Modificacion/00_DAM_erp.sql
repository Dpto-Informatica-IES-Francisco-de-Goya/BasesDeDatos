use erp_logistica;

-- Estudiamos la BD.
show tables;
select * from categorias;
select * from clientes;
explain clientes;
select * from pedidos;

-- 1) Limpia los espacios en blanco del nombre
SET SQL_SAFE_UPDATES = 0;
UPDATE clientes SET nombre_completo = TRIM(nombre_completo);
SELECT * FROM clientes;
SET SQL_SAFE_UPDATES = 1;


-- ERROR:
SET SQL_SAFE_UPDATES = 0;
-- UPDATE clientes SET nombre_completo = TRIM('nombre_completo');
SET SQL_SAFE_UPDATES = 1;
SELECT * FROM clientes;

-- 2)
-- 2.1) Miro a ver qué está mal
select * from clientes;
-- 2.2) Corrijo
UPDATE clientes SET email = REPLACE (email, '.con','.com');
-- gomez.conrado@gmail.com -> gomez.comrado@gmail.com ¡ERROR! Así que, lo mejoramos.
UPDATE clientes SET email = REPLACE (email, '.con','.com') WHERE email LIKE '%.con';
-- gomez.conrado@gmail.com ->  no lo toca, así que guay.
-- gomez.conrado@gmail.con -> 
SELECT replace('gomez.conrado@gmail.con','.con','.com');
-- gomez.conrado@gmail.con -> gomez.comrado@gmail.com
-- SOLUCIONES:
-- 1) parto el email en el @ y luego concateno de vuelta. [solución muy buena muy general]
-- 2) Solución válida para el ejemplo 2 de clase que tiene pocos datos. 
select email from clientes where email like '%.con';
SET SQL_SAFE_UPDATES = 0;
UPDATE clientes SET email = REPLACE (email, 'email.con','email.com') WHERE email LIKE '%.con';
UPDATE clientes SET email = REPLACE (email, 'outlook.con','outlook.com') WHERE email LIKE '%.con';
SET SQL_SAFE_UPDATES = 1;
-- 3) Comprobamos:
select * from clientes;

SET SQL_SAFE_UPDATES = 0;
UPDATE clientes SET email = REPLACE (email, ',','.');
SET SQL_SAFE_UPDATES = 1;

-- 2.3) Compruebo
select * from clientes;

-- 3) Arreglar los teléfonos
-- 3.1) Comprobamos que está fatal.
-- 3.2) Vamos poco a poco.
-- PLAN A:
SET SQL_SAFE_UPDATES = 0;
UPDATE clientes SET telefono = REPLACE(telefono,' ','');
UPDATE clientes SET telefono = REPLACE(telefono,'-','');
UPDATE clientes SET telefono = REPLACE(telefono,'+34','');
SELECT telefono from clientes where telefono like '0034%';
-- UPDATE clientes SET telefono = REPLACE(telefono,'0034','') WHERE telefono like '0034%';-- Como solo hay un teléfono con el prefijo 0034 que NO CONTIENE 0034 como dígitos válidos, este update es seguro. No obstante, es mejor este otro:
UPDATE clientes SET telefono = SUBSTRING(telefono,5,9)  WHERE telefono like '0034%';
select SUBSTRING('0034650034123',5,9);
SET SQL_SAFE_UPDATES = 1;
-- 0034650034123 -> 65123
select * from clientes;
-- PLAN B: Encadeno
UPDATE clientes SET telefono = 
	substring(
		REPLACE(
			REPLACE(
				REPLACE(telefono,'-','')
			,' ','')
		,'+34','')
	,5,9);


-- PROTECCIÓN ANTE DESASTRES (se va la luz, he puesto el mismo nombre a todos los clientes)
-- 2 formas de protección: Staging y transacciones.
select * from clientes; -- Voy a cargar otra vez la BD para tener los teléfonos "sucios"

-- Staging: crear una tabla o columna temporal, rellenarla con los datos limpios y luego sustituir la columna inicial.
select * from clientes;
explain clientes; -- mira el tipo de dato de teléfono para poner el mismo en la tabla/columna temporal.
ALTER TABLE clientes
	ADD COLUMN telefono_en_proceso VARCHAR(20); -- CON EL MISMO TIPO DE DATO.
    
-- voy actualizando
SET SQL_SAFE_UPDATES = 0;
UPDATE clientes SET telefono_en_proceso = REPLACE(telefono,' ','');
UPDATE clientes SET telefono_en_proceso = REPLACE(telefono_en_proceso,'-','');
UPDATE clientes SET telefono_en_proceso = REPLACE(telefono_en_proceso,'+34','');
SELECT telefono_en_proceso from clientes where telefono_en_proceso like '0034%';
UPDATE clientes SET telefono_en_proceso = SUBSTRING(telefono_en_proceso,5,9)  WHERE telefono_en_proceso like '0034%';
-- YA TENGO LOS CAMBIOS "A SUCIO". COMPROBAMOS Y PASAMOS A LIMPIO.
select * from clientes;
-- PASO A LIMPIO:
UPDATE clientes SET telefono = telefono_en_proceso;
ALTER TABLE clientes
	DROP COLUMN telefono_en_proceso; -- eliminamos la tabla
SET SQL_SAFE_UPDATES = 1;
select * from clientes;

-- PROTECCIÓN 2: TRANSACCIONES
-- EJEMPLO 1
START TRANSACTION; -- A partir de ahora, todos los cambios son TEMPORALES hasta que se deshagan (rollback) o se confirmen (commit)
-- vuelvo a cargar los teléfonos
select * from clientes;
-- Empiezo a corregir cosas.
SET SQL_SAFE_UPDATES = 0;
UPDATE clientes SET telefono = REPLACE(telefono,' ','');
select * from clientes;
SET SQL_SAFE_UPDATES = 1;
select * from clientes;
-- CIERRA Y VUELVE A ABRIR

-- EJEMPLO 2
SET SQL_SAFE_UPDATES = 0;
UPDATE clientes SET telefono = REPLACE(telefono,' ',''); -- DEFINITIVO
select * from clientes;
START TRANSACTION; -- A partir de ahora, todos los cambios son TEMPORALES hasta que se deshagan (rollback) o se confirmen (commit)
UPDATE clientes SET telefono = REPLACE(telefono,'-',''); -- TEMPORAL
UPDATE clientes SET telefono = REPLACE(telefono,'+34',''); -- TEMPORAL
UPDATE clientes SET telefono = REPLACE(telefono,'0034','?'); -- ERROR: TEMPORAL
-- 600345123 -> 65123. Error grave hacer este replace así tal cual
SET SQL_SAFE_UPDATES = 1;
select * from clientes;
ROLLBACK;
select * from clientes; -- NO HAY ESPACIOS, PERO SÍ GUIONE

-- EJEMPLO 3: TENEMOS GUIONES, PERO NO ESPACIOS.
START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;
UPDATE clientes SET telefono = REPLACE(telefono,'-',''); -- TEMPORAL
UPDATE clientes SET telefono = REPLACE(telefono,'+34',''); -- TEMPORAL
UPDATE clientes SET telefono = SUBSTRING(telefono,5,9)  WHERE telefono like '0034%';-- TEMPORAL
select * from clientes;
COMMIT; -- LOS MARCAMOS COMO DEFINITIVOS.
select * from clientes;
SET SQL_SAFE_UPDATES = 1;


-- Seguimos limpiando. 25/03
select * from clientes;
SET SQL_SAFE_UPDATES = 0;
update clientes set email = replace(email,',','.');
SET SQL_SAFE_UPDATES = 1;
select * from clientes;

-- Estados en mayúsculas
select * from pedidos;
SET SQL_SAFE_UPDATES = 0;
update pedidos set estado = upper(estado);
SET SQL_SAFE_UPDATES = 1;

-- Ejercicios del 4 al 8
select * from productos;
START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;
UPDATE productos SET precio_sucio = replace(precio_sucio,'€','');
UPDATE productos SET precio_sucio = replace(precio_sucio,'$','');
select * from productos;
SAVEPOINT guardar_partida;
UPDATE productos SET precio_sucio = replace(precio_sucio,' ','');
UPDATE productos SET precio_sucio = replace(precio_sucio,'EUR','');
select * from productos;
-- ¿Qué puede pasar? 
ROLLBACK TO guardar_partida;
select * from productos;
UPDATE productos SET precio_sucio = replace(precio_sucio,' ','');
UPDATE productos SET precio_sucio = replace(precio_sucio,'EUR','');
select * from productos;
SAVEPOINT sinSimbolosNiEspacios_ListoParaQuitarLasComas;
UPDATE productos SET precio_sucio = REPLACE(precio_sucio,',','.');
SAVEPOINT vamos_a_quitar_el_gratis;
select * from productos;
UPDATE productos SET precio_sucio = 0.00;
rollback to vamos_a_quitar_el_gratis;
select * from productos;
-- UPDATE productos SET precio_sucio = 0.00 WHERE precio_sucio like 'Gratis'; -- CUTRE
UPDATE productos SET precio_sucio = 0.00 WHERE precio_sucio REGEXP '[a-zA-Z]+'; -- CUTRE
select * from productos;
-- ALTER TABLE productos CHANGE precio_sucio precio DECIMAL(10,2);
COMMIT; -- marcamos los cambios como definitivos

-- Bloque 2
-- 9 Cast de precios
select avg(precio_sucio) from productos;
START TRANSACTION;
ALTER TABLE productos
	MODIFY COLUMN precio_sucio DECIMAL(10,2);

ALTER TABLE productos
	RENAME COLUMN precio_sucio TO precio;
select * from productos;
explain productos;
-- TODO CORRECTO

/* OTRA OPCIÓN: ALTER TABLE productos CHANGE COLUMN precio_sucio precio DECIMAL(10,2);*/
ROLLBACK; -- las transacciones no funcionan en DDL.
select * from productos;
explain productos;

-- 10
SELECT * FROM pedidos;
START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;
UPDATE pedidos SET fecha_texto = STR_TO_DATE(fecha_texto,'%d/%m/%Y') WHERE fecha_texto LIKE '%/%/____';

UPDATE pedidos 
	SET fecha_texto = STR_TO_DATE(fecha_texto,'%d-%m-%Y')
	WHERE fecha_texto LIKE '%-%-____' ; -- este filtro es fundamental.
UPDATE pedidos 
	SET fecha_texto = STR_TO_DATE(fecha_texto,'%Y.%m.%d')
	WHERE fecha_texto LIKE '____.%.%' ; -- este filtro es fundamental.

SELECT * FROM pedidos;
ROLLBACK; -- ESTO RECORRE LA TABLA 3 VECES Y, SI LA TABLA ES GIGANTE, TARDARÁ MUCHÍSIMO.
-- EN UN ÚNICO UPDATE
START TRANSACTION;
UPDATE pedidos
	SET fecha_texto = CASE 
		WHEN fecha_texto LIKE '%/%/____' THEN STR_TO_DATE(fecha_texto,'%d/%m/%Y')
        WHEN fecha_texto LIKE '%-%-____' THEN STR_TO_DATE(fecha_texto,'%d-%m-%Y')
        WHEN fecha_texto LIKE '____.%.%' THEN STR_TO_DATE(fecha_texto,'%Y.%m.%d')
        ELSE fecha_texto END;
select * from pedidos;
rollback;
START TRANSACTION;
select * from pedidos;
UPDATE pedidos 
SET 
    fecha_texto = CASE
        WHEN fecha_texto LIKE '%/%/____' THEN STR_TO_DATE(fecha_texto, '%d/%m/%Y')
        WHEN fecha_texto LIKE '%-%-____' THEN STR_TO_DATE(fecha_texto, '%d-%m-%Y')
        WHEN fecha_texto LIKE '____.%.%' THEN STR_TO_DATE(fecha_texto, '%Y.%m.%d')
        ELSE fecha_texto
    END
WHERE -- NO ES IMPRESCINDIBLE PARA EL FUNCIONAMIENTO PERO NO PONERLO ES SUBÓPTIMO EN TÉRMINOS DE RENDIMIENTO.
    fecha_texto LIKE '%/%/____'
        OR fecha_texto LIKE '%-%-____'
        OR fecha_texto LIKE '____.%.%';

ALTER TABLE pedidos
	CHANGE fecha_texto fecha DATE;
ROLLBACK; -- PARA NOTA: ¿Qué pasa con este rollback? Haz: 1) Transaccion. 2) Update del case. 3) Alter table. 4) Rollback. ¿Qué le pasa al rollback?
select * from pedidos;



-- Bloque 3: Integridad y Deduplicación
-- 1. Productos huérfanos:
select * from productos;
select * from categorias;

-- Encontramos los problemas
SELECT * from productos p LEFT JOIN categorias c ON p.categoria_id = c.id WHERE c.id is null; -- 2 resultados
START transaction;
UPDATE productos p LEFT JOIN categorias c ON p.categoria_id = c.id 
	SET p.categoria_id = 4 
    WHERE c.id is null;
-- comprobamos
SELECT * from productos p LEFT JOIN categorias c ON p.categoria_id = c.id WHERE c.id is null; -- 0 resultados
ROLLBACK;

-- CON SUBCONSULTAS 1
-- 1) Encontrar problemas. Productos huérfanos
SELECT * FROM productos WHERE categoria_id NOT IN (select id from categorias);
-- 2) ACTUALIZO EN TRANSACCIÓN
START TRANSACTION;
UPDATE productos 
	SET categoria_id = 4
	WHERE categoria_id NOT IN (select id from categorias);
-- 3) COMPROBAMOS
SELECT * FROM productos WHERE categoria_id NOT IN (select id from categorias);
-- 4) TERMINADO. 
ROLLBACK;


-- CON SUBCONSULTAS 2. Me molesta el 4.
select * from categorias;
-- 1) Encontrar problemas. Productos huérfanos
SELECT * FROM productos WHERE categoria_id NOT IN (select id from categorias);
-- 2) ACTUALIZO EN TRANSACCIÓN
START TRANSACTION;
UPDATE productos 
	SET categoria_id = (select id from categorias where nombre like 'General')
	WHERE categoria_id NOT IN (select id from categorias);
-- 3) COMPROBAMOS
SELECT * FROM productos WHERE categoria_id NOT IN (select id from categorias);
-- 4) TERMINADO. 
COMMIT;

-- Deduplicación de clientes: Elimina duplicados manteniendo el ID más bajo. Importante:
-- Reasigna primero los pedidos de los clientes que vas a borrar para no perder el histórico.

SELECT * FROM clientes;
START TRANSACTION;
DELETE FROM clientes WHERE id = 4;
SELECT * FROM pedidos;
ROLLBACK;

-- VAMOS A POR LOS CLIENTES DUPLICADOS
SELECT email,count(*) FROM clientes GROUP BY email HAVING count(*) > 1;
SELECT id,email FROM clientes WHERE email LIKE (SELECT email FROM clientes GROUP BY email HAVING count(*) > 1); 
START transaction;
-- TRAMPOSAMENTE:

-- SACO EL 3:
SELECT min(id) FROM clientes WHERE email LIKE (SELECT email FROM clientes GROUP BY email HAVING count(*) > 1); 
-- SACO EL 4 y el 5:
SELECT id FROM clientes WHERE email LIKE (SELECT email FROM clientes GROUP BY email HAVING count(*) > 1); 
-- Esto solo funciona para un cliente. En este caso, funciona pero es TRAMPA. 
UPDATE pedidos
	SET cliente_id = (SELECT min(id) FROM clientes WHERE email LIKE (SELECT email FROM clientes GROUP BY email HAVING count(*) > 1))
    WHERE cliente_id IN (SELECT id FROM clientes WHERE email LIKE (SELECT email FROM clientes GROUP BY email HAVING count(*) > 1));

-- ¿CÓMO ELIMINO DUPLICADOS BIEN? ¡IDEA FELIZ! JOIN CONTIGO MISMO

SELECT c.id,email,p.id as pedido_id,p.cliente_id FROM clientes c JOIN pedidos p ON c.id = p.cliente_id;

SELECT 
    c1.id, c1.email, p.id AS pedido_id, p.cliente_id, c2.email,c2.id
FROM
    clientes c1
        JOIN
    pedidos p ON c1.id = p.cliente_id
		JOIN
	clientes c2 ON c1.email = c2.email
WHERE c2.id < c1.id
ORDER BY pedido_id;

START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;
UPDATE 
	pedidos p 
		JOIN 
	clientes c1 ON p.cliente_id = c1.id
		JOIN
	clientes c2 ON c1.email = c2.email
SET p.cliente_id = c2.id
WHERE 
	c2.id < c1.id;
SELECT * FROM pedidos;
-- ahroa que ya no hay pedidos de los clientes duplicados, eliminamos esos clientes.
DELETE c2
FROM clientes c1 JOIN clientes c2 ON c1.email = c2.email
WHERE c2.id > c1.id;
select * from clientes;
SET SQL_SAFE_UPDATES = 1;

COMMIT;

-- EL RESTO DEL BLOQUE 3 ES MUY PARECIDO A ESTOS EJEMPLOS.

-- BLOQUE 4: 
-- 2) BLINDAJE
-- Blindaje: Añade las restricciones de FOREIGN KEY a productos y pedidos.
SELECT * FROM pedidos;
SELECT * FROM clientes;
-- FALLA POR LOS PEDIDOS DE CLIENTES INEXISTENTES. VAMOS A ASIGNAR ESOS PEDIDOS A UN CLIENTE FICTICIO
ALTER TABLE pedidos
	ADD CONSTRAINT fk_pedidos_clientes FOREIGN KEY(cliente_id)
		REFERENCES clientes(id) ON DELETE RESTRICT ON UPDATE CASCADE;
-- 1) Insertar cliente ficticio
START TRANSACTION;

INSERT INTO `erp_logistica`.`clientes`
(id,`nombre_completo`)
VALUES
(99999,
'Cliente ficticio'
);

-- 2) Actualizar la tabla con ese id de cliente
SET SQL_SAFE_UPDATES = 0;
UPDATE pedidos
SET cliente_id = 99999 -- cliente ficticio
WHERE cliente_id NOT IN  (select id from clientes);
SET SQL_SAFE_UPDATES = 1;
-- 3) alter table.
SELECT * FROM clientes;
ALTER TABLE pedidos
	ADD CONSTRAINT fk_pedidos_clientes FOREIGN KEY(cliente_id)
		REFERENCES clientes(id) ON DELETE RESTRICT ON UPDATE CASCADE;


-- BLOQUE 5: 
-- COALESCE: Consolidación de Precios: Crea precio_final y públalo usando COALESCE entre precio_oferta y precio.
select * from productos;
-- primero creamos la columna
ALTER TABLE productos ADD COLUMN precio_final DECIMAL(10,2);
start transaction;
set SQL_SAFE_UPDATES = 0;
UPDATE productos
-- SET precio_final = precio_oferta si puedo. Si es null, entonces cojo precio. Si ese es null, 0
SET precio_final = COALESCE(precio_oferta, precio, 0);
set SQL_SAFE_UPDATES = 1;
COMMIT;

