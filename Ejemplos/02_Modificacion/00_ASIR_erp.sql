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
/* CREATE TABLE `productos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `precio_sucio` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `precio_oferta` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `categoria_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
);*/ 

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

-- Ejercicio 9: Cast de Precios
explain productos;
select * from productos;
START transaction;
-- SET SQL_SAFE_UPDATES = 0; -- INNECESARIO.
ALTER TABLE productos
	CHANGE column precio_sucio precio DECIMAL(10,2);
explain productos;
ROLLBACK; -- NO HA FUNCIONADO.
explain productos;
-- ¿DISTINGUES DDL DE DML?

-- Ejercicio 10: ERROR: 
show tables;
select * from pedidos;

SELECT STR_TO_DATE('3-5-2027','%d-%m-%Y');
SELECT STR_TO_DATE('3-5-2027','%m-%d-%Y');
SELECT STR_TO_DATE('3-5-27','%m-%d-%y'); -- 27 es 2027
SELECT STR_TO_DATE('3-5-70','%m-%d-%y'); -- 1970
SELECT STR_TO_DATE('3-5-69','%m-%d-%y'); -- 2069

SET SQL_SAFE_UPDATES = 0;
UPDATE pedidos 
	SET fecha_texto = STR_TO_DATE(fecha_texto,'%d/%m/%Y')
	/*WHERE fecha_texto LIKE '__/__/____' 
		OR fecha_texto LIKE '_/_/____'
        OR fecha_texto LIKE '_/__/____'
        OR fecha_texto LIKE '__/_/____'; */
	WHERE fecha_texto LIKE '%/%/____' ; -- este filtro es fundamental.
UPDATE pedidos 
	SET fecha_texto = STR_TO_DATE(fecha_texto,'%d-%m-%Y')
	WHERE fecha_texto LIKE '%-%-____' ; -- este filtro es fundamental.
UPDATE pedidos 
	SET fecha_texto = STR_TO_DATE(fecha_texto,'%Y.%m.%d')
	WHERE fecha_texto LIKE '____.%.%' ; -- este filtro es fundamental.
SET SQL_SAFE_UPDATES = 1;

-- comprobamos "cutre"
select * from pedidos;
-- comprobamos bien
select count(*) from pedidos where fecha_texto like '____-__-__';

-- ¿Cuantas hay mal?
SELECT 
	(select count(*) from pedidos) - 
	(select count(*) from pedidos where fecha_texto like '____-__-__');
SELECT * FROM pedidos;

-- CAMBIAR EL TIPO DE DATO:
ALTER TABLE pedidos
	CHANGE COLUMN fecha_texto fecha DATE;
explain pedidos;


-- 11) PRODUCTOS HUÉRFANOS
SELECT 
    *
FROM
    productos;
select * from categorias;

-- no está protegido por el SAFE_UPDATES.
-- PERO es una """chapuza""" hacerlo así
UPDATE productos 
	SET categoria_id = 4 WHERE id = 4;


-- ¿Cómo se hace de forma general?
-- 1) ¿Qué productos están huérfanos?
-- trampa: select * from productos where categoria_id > 6;

-- OPCION 1: LEFT JOIN
SELECT *
FROM productos p
	LEFT JOIN categorias c ON p.categoria_id = c.id
    WHERE c.id IS NULL;

-- OPCION 2:
SELECT *
FROM productos
WHERE categoria_id NOT IN
			(SELECT 
				id
			FROM
				categorias);
-- UPDATE
SET SQL_SAFE_UPDATES = 0;
UPDATE productos 
	SET categoria_id = 4
    WHERE 
		categoria_id 
			NOT IN 
		(SELECT id FROM categorias);
        
/* FALLA:
UPDATE productos 
	SET categoria_id = 4
    WHERE 
		id 
			IN 
		(SELECT p.id FROM productos p
			LEFT JOIN categorias c ON p.categoria_id = c.id
			WHERE c.id IS NULL);*/
SET SQL_SAFE_UPDATES = 1;

-- 12) CLIENTES HUÉRFANOS
-- ES IGUAL QUE EL ANTERIOR

/* 13) Deduplicación de clientes: 
Elimina duplicados manteniendo el ID más bajo. 
Importante: Reasigna primero los pedidos de los 
clientes que vas a borrar para no perder el histórico.*/

-- listado de clientes duplicados
SELECT 
    COUNT(id), email
FROM
    clientes
GROUP BY email
HAVING count(id) > 1;

SELECT 
    id, email
FROM
    clientes
WHERE
    email IN (SELECT 
            email
        FROM
            clientes
        GROUP BY email
        HAVING COUNT(id) > 1);
        
select * from pedidos;
-- solución trampa
SET SQL_SAFE_UPDATES = 0;
UPDATE pedidos
	SET cliente_id = 3
		WHERE cliente_id IN (4,5);
DELETE FROM clientes WHERE id IN (4,5);
select * from clientes;
SET SQL_SAFE_UPDATES = 1;

-- solución MALA porque solo funciona si hay un único cliente repetido. Si solo hay 
-- uno repetido, entonces vale, funciona.
/*UPDATE pedidos 
	SET cliente_id = (SELECT 
							min(id)
						FROM
							clientes
						WHERE
							email IN (SELECT 
									email
								FROM
									clientes
								GROUP BY email
								HAVING COUNT(id) > 1))  
    WHERE cliente_id IN (SELECT 
							id
						FROM
							clientes
						WHERE
							email IN (SELECT 
									email
								FROM
									clientes
								GROUP BY email
								HAVING COUNT(id) > 1));*/

-- SOLUCIÓN BUENA BUENÍSIMA. CLÁSICO DE ELIMINAR DUPLICADOS.
select * from pedidos;
select 
	p.id as pedido_id,
    p.cliente_id,
	c1.id as c1_id, 
    c1.email,
    c2.id as c2_id,
    c2.email
    FROM pedidos p 
	JOIN clientes c1 ON p.cliente_id = c1.id
	JOIN clientes c2 ON c1.email = c2.email;
    
-- Reasignación de pedidos.
SET SQL_SAFE_UPDATES = 0;
START TRANSACTION;
UPDATE pedidos p 
	JOIN clientes c1 ON p.cliente_id = c1.id
	JOIN clientes c2 ON c1.email = c2.email 
SET p.cliente_id = c2.id WHERE c1.id > c2.id;

-- COMPROBAMOS:
select 
	p.id as pedido_id,
    p.cliente_id,
	c1.id as c1_id, 
    c1.email,
    c2.id as c2_id,
    c2.email
    FROM pedidos p 
	JOIN clientes c1 ON p.cliente_id = c1.id
	JOIN clientes c2 ON c1.email = c2.email;
    
-- TODO OK.
SELECT * FROM clientes;
-- Eliminación de duplicados.
DELETE c1 FROM clientes c1 INNER JOIN clientes c2
	ON c1.email = c2.email WHERE c1.id > c2.id;
-- ROLLBACK;
SET SQL_SAFE_UPDATES = 1;
COMMIT;


-- 2. Blindaje: Añade las restricciones de FOREIGN KEY a productos y pedidos.

ALTER TABLE pedidos
ADD CONSTRAINT fk_pedidos_clientes foreign key (cliente_id) REFERENCES clientes(id)
ON UPDATE cascade ON DELETE RESTRICT;
SELECT * FROM pedidos WHERE cliente_id NOT IN (select id from clientes);
-- este constraint ha fallado porque hay pedidos que los han hecho clientes que no existen.
-- CONCLUSIÓN: No se puede aplicar un constraint sin antes haber limpiado los datos. Limpia los datos (2.3.2) y funcionará

ALTER TABLE productos
ADD CONSTRAINT fk_productos_categorias FOREIGN KEY(categoria_id) REFERENCES categorias(id)
ON DELETE RESTRICT ON UPDATE CASCADE;
-- COMPROBAMOS: Saca el diagrama database->reverse

-- 2.5.2. Consolidación de Precios: Crea precio_final y públalo usando COALESCE entre precio_oferta y precio.
select * from productos;
ALTER TABLE productos
ADD COLUMN precio_final DECIMAL(10,2)
AFTER precio_oferta;
select * from productos;
SET SQL_SAFE_UPDATES = 0;
UPDATE productos
-- SET precio_final = 1ª opción: precio_oferta. Si es nulo, entonces 2ª opción: precio. Si es nulo, 3ª opción: 99999999.99
-- SET precio_final = CASE WHEN ... THEN
SET precio_final = COALESCE(precio_oferta, precio, 99999999.99);
SET SQL_SAFE_UPDATES = 1;
select * from productos;


-- CASE WHEN THEN.

SELECT * FROM pedidos;


start transaction;
SET SQL_SAFE_UPDATES = 0;
UPDATE pedidos 
	SET fecha_texto = STR_TO_DATE(fecha_texto,'%d/%m/%Y')
	WHERE fecha_texto LIKE '%/%/____' ; -- este filtro es fundamental.
UPDATE pedidos 
	SET fecha_texto = STR_TO_DATE(fecha_texto,'%d-%m-%Y')
	WHERE fecha_texto LIKE '%-%-____' ; -- este filtro es fundamental.
UPDATE pedidos 
	SET fecha_texto = STR_TO_DATE(fecha_texto,'%Y.%m.%d')
	WHERE fecha_texto LIKE '____.%.%' ; -- este filtro es fundamental.
SET SQL_SAFE_UPDATES = 1;
select * from pedidos;
ROLLBACK; -- ESTA SOLUCIÓN ES INEFICIENTE


start transaction;
SET SQL_SAFE_UPDATES = 0;
UPDATE pedidos 
	SET fecha_texto = CASE
			WHEN fecha_texto LIKE '%/%/____' THEN STR_TO_DATE(fecha_texto,'%d/%m/%Y')
            WHEN fecha_texto LIKE '%-%-____' THEN STR_TO_DATE(fecha_texto,'%d-%m-%Y')
            WHEN fecha_texto LIKE '____.%.%' THEN STR_TO_DATE(fecha_texto,'%Y.%m.%d')
            ELSE fecha_texto
    END;
SET SQL_SAFE_UPDATES = 1;
ROLLBACK; -- ESTA SOLUCIÓN ES INEFICIENTE

start transaction;
SET SQL_SAFE_UPDATES = 0;
UPDATE pedidos 
	SET fecha_texto = CASE
			WHEN fecha_texto LIKE '%/%/____' THEN STR_TO_DATE(fecha_texto,'%d/%m/%Y')
            WHEN fecha_texto LIKE '%-%-____' THEN STR_TO_DATE(fecha_texto,'%d-%m-%Y')
            WHEN fecha_texto LIKE '____.%.%' THEN STR_TO_DATE(fecha_texto,'%Y.%m.%d')
            ELSE fecha_texto
		END
	WHERE fecha_texto LIKE '%/%/____' OR fecha_texto LIKE '%-%-____' OR fecha_texto LIKE '____.%.%';
SET SQL_SAFE_UPDATES = 1;
COMMIT; -- ESTA SOLUCIÓN ES EFICIENTE
