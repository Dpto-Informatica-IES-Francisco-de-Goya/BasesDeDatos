USE erp_logistica;

select * from categorias;
select * from clientes;
select * from pedidos;
select * from productos;

-- Ejercicio 1: 
-- 1) Ver qué está mal.
select count(nombre_completo) from clientes where nombre_completo like ' %';
select nombre_completo from clientes where nombre_completo like ' %';
-- 2) Intentar arreglarlo.
SET SQL_SAFE_UPDATES = 0;
update clientes set nombre_completo = TRIM(nombre_completo);
SET SQL_SAFE_UPDATES = 1;
-- 3) Comprobar que está bien.
select nombre_completo from clientes where nombre_completo like ' %';
select nombre_completo from clientes;

-- Ejercicio 2: de .con a .com
-- 1) Ver qué está mal.
select email from clientes;
-- 2) Intentar arreglarlo.

SET SQL_SAFE_UPDATES = 0;
update clientes set email = replace(email,'.con','.com') where email like '%@%.con';
-- update clientes set email = replace('.con','.com',email);
SET SQL_SAFE_UPDATES = 1;
-- 3) Comprobar que está bien.
select email from clientes;


-- Ejercicio 3: los teléfonos
-- 1) Ver qué está mal.
SELECT telefono from clientes;
-- 2) Arreglamos
-- update clientes set telefono = REPLACE(telefono,' ','');
-- update clientes set telefono = REPLACE(telefono,'-','');
SET SQL_SAFE_UPDATES = 0;
update clientes set telefono = REPLACE(REPLACE(telefono,' ',''),'-','');
update clientes set telefono = substring(telefono,5,9) where telefono like '0034%';
update clientes set telefono = substring(telefono,4,9) where telefono like '+34%';
-- otra forma: update clientes set telefono = replace(telefono,'+34','') where telefono like '+34%';
SET SQL_SAFE_UPDATES = 1;

-- pruebas de cómo funcionan.
select replace('003460034','0034','');
select substring('0034600777888',5,9);

-- 3) COMPROBAMOS
SELECT telefono from clientes;

-- Ejercicio 4:
-- 1) Ver qué está mal
-- 2) Arreglarlo
-- 3) Comprobar


-- Ejercicio 4:
-- 1) Ver qué está mal
select * from pedidos;
-- 2) Arreglarlo
SET SQL_SAFE_UPDATES = 0;
update pedidos set estado = UPPER(estado);
SET SQL_SAFE_UPDATES = 1;
-- 3) Comprobar
select * from pedidos;

-- Ejercicio 5: arregla los precios de productos
select * from productos;
SET SQL_SAFE_UPDATES = 0;
-- Se pueden hacer por separado.
update productos set precio_sucio = 
	replace(
		replace(
			replace(
				replace(
					replace(precio_sucio,'$','')
				,'€','')
			,'EUR','')
		,' ','')
	,',','.');
SET SQL_SAFE_UPDATES = 1;
select * from productos;

-- PLAN B: vamos haciendo cambios temporales, para confirmarlos como definitivos cuando tengamos todos.
-- Así, nos protegemos de cortes de luz inesperados y de nuetra propia ignorancia.

-- 2 FORMAS DE CAMBIOS TEMPORALES: Staging y transacciones.




-- 2.1) STAGING: columna o tabla temporal. En este caso, vamos a crear una columna temporal en la que ir guardando las modificaciones de precio_sucio.

-- 0: VER TIPOS DE DATOS
-- 0.1: Send to SQL Editor -> Create statment
CREATE TABLE `productos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `precio_sucio` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `precio_oferta` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `categoria_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
);

-- 0.2 
explain productos;

-- 1) Añadimos una columna.
ALTER TABLE productos
	ADD COLUMN precio_en_proceso VARCHAR(50);
explain productos; -- comprobamos que se ha añadido
select * from productos; -- vemos que está vacía.

-- 2) Rellenamos la columna vacía.
SET SQL_SAFE_UPDATES = 0;
update productos set precio_en_proceso = replace(precio_sucio,'$','');
select * from productos; -- vemos que está vacía.
-- 15 afectadas, 15 matcheadas y 15 modificadas.

update productos set precio_en_proceso = replace(precio_en_proceso,'€','');
-- 6 afectadas, 15 matcheadas y 6 modificadas.
select * from productos;

update productos set precio_en_proceso = replace(precio_en_proceso,'EUR','');
update productos set precio_en_proceso = replace(precio_en_proceso,' ','');
update productos set precio_en_proceso = replace(precio_en_proceso,',','.');
update productos set precio_en_proceso = replace(precio_en_proceso,'Gratis','0.00');
select * from productos;

update productos set precio_sucio = precio_en_proceso;
select * from productos;

alter table productos
	drop column precio_en_proceso;

select * from productos;
SET SQL_SAFE_UPDATES = 1;

-- 2.2) TRANSACCIONES:

select * from productos;
START TRANSACTION; -- Todos los cambios de modificación (DML) son temporales  (hasta el commit) o reversibles (hasta el rollback).
SET SQL_SAFE_UPDATES = 0;
update productos set precio_sucio = replace(precio_sucio,'$','');
update productos set precio_sucio = replace(precio_sucio,'€','');
select * from productos;
SAVEPOINT guardando_partida; -- sigo en la transaccción, por lo que todo es temporal. Si se va la luz, lo pierdo.
-- ROLLBACK;
-- COMMIT; -- convierte en definitivos todos los cambios temporales DML que se hayan hecho desde el "start transaction"
select * from productos;
-- SE VA LA LUZ
update productos set precio_sucio = replace(precio_sucio,'EUR','');
update productos set precio_sucio = replace(precio_sucio,' ','');
update productos set precio_sucio = replace(precio_sucio,',','.');
select * from productos;
-- NOOOOOOO. Me he equivocado, quiero CTRL-Z. Pero no desde el princpio. Vamos a "cargar la partida guardada"
-- ROLLBACK TO guardando_partida;
select * from productos;
update productos set precio_sucio = replace(precio_sucio,'Gratis','0.00');
commit;
-- ROLLBACK;

