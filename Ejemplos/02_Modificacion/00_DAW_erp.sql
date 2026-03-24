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
SET SQL_SAFE_UPDATES = 0;
UPDATE clientes SET nombre_completo = TRIM('nombre_completo');
SET SQL_SAFE_UPDATES = 1;
select nombre_completo from clientes;

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

-- Ejercicio 3: estandarización de teléfonos
-- CAMBIOS TEMPORALES: staging (tablas o columnas intermedias)y transacciones.

-- TRANSACCIONES:
START transaction; -- A PARTIR DE AHORA, TODOS LOS CAMBIOS SON TEMPORALES, hasta el commit o el rollback.
SET SQL_SAFE_UPDATES = 0;
UPDATE clientes SET telefono = replace(telefono,' ',''); -- temporal
UPDATE clientes SET telefono = replace(telefono,'-',''); -- temporal
select * from clientes;
COMMIT; -- marco como definitivos los cambios realizados.

start transaction;
UPDATE clientes SET telefono = replace(telefono,'+34','');
UPDATE clientes SET telefono = replace(telefono,'0034','');
rollback;
select * from clientes;

start transaction;
UPDATE clientes SET telefono = replace(telefono,'+34','');
UPDATE clientes SET telefono = SUBSTRING(telefono,5,9) WHERE telefono like '0034%'; -- este where es el que me protege de reventar el 600345123
SELECT SUBSTRING('0034651234523',5,9);
select * from clientes;
commit;
SET SQL_SAFE_UPDATES = 1;

--  ¿transacción dentro otra?
-- existen savepoints.

-- Ejemplo 4: estados
select * from pedidos;
SET SQL_SAFE_UPDATES = 0;
update pedidos set estado = upper(estado);
SET SQL_SAFE_UPDATES = 1;
select * from pedidos;

-- Ejemplos del 5 al 8 -> arreglar los precios
select * from productos;
-- vamos a por cambios temporales. En este caso, vamos a aprender staging.
-- creamos una columna "precio_procesado" que vamos rellenando.
-- IMPORTANTE: del mismo tipo de dato
EXPLAIN productos;
ALTER TABLE productos
	ADD COLUMN precio_procesado VARCHAR(50);
SET SQL_SAFE_UPDATES = 0;
SELECT * FROM productos;
UPDATE productos SET precio_procesado = REPLACE(precio_sucio,' ','');
UPDATE productos SET precio_procesado = REPLACE(REPLACE(precio_procesado, '$',''),'€','');
UPDATE productos SET precio_procesado = REPLACE(precio_procesado,'EUR','');
UPDATE productos SET precio_procesado = 0 WHERE precio_procesado REGEXP('[a-zA-Z]');
UPDATE productos SET precio_procesado = REPLACE(precio_procesado,',','.');
SELECT * FROM productos;
-- actualizo la columna inicial
UPDATE productos SET precio_sucio = precio_procesado;
SELECT * FROM productos;
-- elimino la columna temporal.
ALTER TABLE productos
	DROP column precio_procesado;
SET SQL_SAFE_UPDATES = 1;
