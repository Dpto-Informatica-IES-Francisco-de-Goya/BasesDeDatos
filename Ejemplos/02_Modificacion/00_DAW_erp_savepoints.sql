use erp_logistica;

show tables;

select * from clientes;
select * from pedidos;
select * from productos;
select * from logs_sistema;
select * from categorias;

-- 1) Buscar los problemas que hay.
-- 2) Corregirlos
-- 3) Comprobarlo.

-- EJERCICIO 1
-- 1) Buscar los problemas que hay.
select nombre_completo from clientes;
-- 2) Corregirlos
SET SQL_SAFE_UPDATES = 0;
UPDATE clientes SET nombre_completo = TRIM(nombre_completo);
SET SQL_SAFE_UPDATES = 1;
-- 3) Comprobarlo.
select nombre_completo from clientes;

-- ¿Por qué el modo seguro?
START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;
UPDATE clientes SET nombre_completo = TRIM('nombre_completo');
SET SQL_SAFE_UPDATES = 1;
select nombre_completo from clientes;
ROLLBACK;
-- EJERCICIO 2:
-- 1) Miramos los errores
select * from clientes;
select * from clientes where email like '%.con';
SET SQL_SAFE_UPDATES = 0;
-- plan a:
UPDATE clientes 
	SET email = REPLACE(email,'.con','.com')
    WHERE email like '%.con';
-- Este replace, EN ESTE CASO CONCRETO CON LOS ERRORES CONCRETOS
-- DE ESTA BBDD, está bien. Pero, NO EN GENERAL. PODRÍA 
-- HABER CASOS COMO
-- gomez.conrado@gmail.con -> gomez.comrado@gmail.com

-- plan b:
UPDATE clientes 
	SET email = REPLACE(email,'email.con','email.com')
    WHERE email like '%.con';
UPDATE clientes 
	SET email = REPLACE(email,'outlook.con','outlook.com')
    WHERE email like '%.con';

SET SQL_SAFE_UPDATES = 1;

-- 3) Comprobamos
select * from clientes;
select * from clientes where email like '%.con';

-- Ejercicio 3: estandarización de teléfonos CON SAVEPOINT.
-- CAMBIOS TEMPORALES: staging (tablas o columnas intermedias)y transacciones.

-- TRANSACCIONES:
START transaction; -- A PARTIR DE AHORA, TODOS LOS CAMBIOS SON TEMPORALES, hasta el commit o el rollback.
SET SQL_SAFE_UPDATES = 0;
UPDATE clientes SET telefono = replace(telefono,' ',''); -- temporal
UPDATE clientes SET telefono = replace(telefono,'-',''); -- temporal
select * from clientes;
SAVEPOINT guardando_la_partida; -- marco como definitivos los cambios realizados.

UPDATE clientes SET telefono = replace(telefono,'+34','');
UPDATE clientes SET telefono = replace(telefono,'0034',''); -- 600345123 -> 65123
rollback to guardando_la_partida;
select * from clientes;


UPDATE clientes SET telefono = replace(telefono,'+34','');
UPDATE clientes SET telefono = substring(telefono,5,9) where telefono like '0034%'; -- 600345123 -> 65123
select * from clientes;
commit;