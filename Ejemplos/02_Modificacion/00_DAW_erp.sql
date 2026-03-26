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

-- vamos con el 2.2.1: modificación de tipo y nombre de columna
start transaction;
ALTER TABLE productos
--   | CHANGE [COLUMN] old_col_name new_col_name column_definition
CHANGE precio_sucio precio DECIMAL(10,2);
ROLLBACK;
EXPLAIN productos;

-- 2.2.2,3 y 4 - Fechas
-- 1) Comprobamos:
SELECT * from pedidos;
-- 2) Modificamos a yyyy-mm-dd.
start transaction;
SET SQL_SAFE_UPDATES = 0;
UPDATE pedidos
set fecha_texto = str_to_date(fecha_texto,'%d/%m/%Y')
WHERE fecha_texto like '%/%/____';
SELECT * from pedidos;
UPDATE pedidos
set fecha_texto = str_to_date(fecha_texto,'%d-%m-%Y')
WHERE fecha_texto like '%-%-____';
SELECT * from pedidos;
UPDATE pedidos
SET fecha_texto = str_to_date(fecha_texto,'%Y.%m.%d')
WHERE fecha_texto like '____.%.%';
SELECT * from pedidos;
ROLLBACK;

-- ALTER TABLE pedidos CHANGE COLUMN fecha_texto fecha DATE;
START TRANSACTION;
UPDATE pedidos
SET fecha_texto = CASE
	-- WHEN condicion THEN valor_a_asignar
    WHEN fecha_texto like '____.%.%' THEN str_to_date(fecha_texto,'%Y.%m.%d')
    WHEN fecha_texto like '%-%-____' THEN str_to_date(fecha_texto,'%d-%m-%Y')
    WHEN fecha_texto like '%/%/____' THEN str_to_date(fecha_texto,'%d/%m/%Y')
    ELSE fecha_texto END;
rollback;
-- ALTER TABLE pedidos CHANGE COLUMN fecha_texto fecha DATE;
START TRANSACTION;
UPDATE pedidos
SET fecha_texto = CASE
	-- WHEN condicion THEN valor_a_asignar
    WHEN fecha_texto like '____.%.%' THEN str_to_date(fecha_texto,'%Y.%m.%d')
    WHEN fecha_texto like '%-%-____' THEN str_to_date(fecha_texto,'%d-%m-%Y')
    WHEN fecha_texto like '%/%/____' THEN str_to_date(fecha_texto,'%d/%m/%Y')
    ELSE fecha_texto END
WHERE -- PARA OPTIMIZAR
		fecha_texto like '____.%.%'  OR
        fecha_texto like '%-%-____' OR 
        fecha_texto like '%/%/____';
select * from pedidos;
ALTER TABLE pedidos CHANGE COLUMN fecha_texto fecha DATE; -- HA HECHO COMMIT IMPLÍCITO.
EXPLAIN pedidos;
SET SQL_SAFE_UPDATES = 1;

-- BLOQUE 3:
-- Productos huérfanos: Asigna productos con categoria_id inexistente a la categoría ’General’
select * from productos;
select * from categorias;

-- 1) ¿Qué hay mal? Productos con categorías que no existen
SELECT * 
FROM 
	productos p  
		LEFT JOIN 
	categorias c ON p.categoria_id = c.id
WHERE c.id IS NULL;
    
-- los 2 que no tienen
SELECT * 
FROM productos
WHERE categoria_id NOT IN (select id from categorias);

-- 2) Corrijo
START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;
UPDATE productos
-- SET categoria_id = 4
SET categoria_id = (select id from categorias where nombre = 'General')
WHERE categoria_id NOT IN (select id from categorias);
SET SQL_SAFE_UPDATES = 1;
COMMIT;


 -- 3) Compruebo: la siguiente query debe dar 0
SELECT count(*) 
FROM productos
WHERE categoria_id NOT IN (select id from categorias);

-- 2. Clientes huérfanos: Reasigna pedidos con cliente_id inexistente al ’Cliente Ficticio’. (PARA QUE PRACTIQUES TÚ)

-- CASO TÍPICO.
-- 3. Deduplicación de clientes: Elimina duplicados manteniendo el ID más bajo. 
-- Importante: Reasigna primero los pedidos de los clientes que vas a borrar para no perder el histórico.
-- 1) ANALIZAMOS
select * from clientes;
start transaction;
DELETE FROM clientes
WHERE id = 4 or id = 5; -- TRAMPA
rollback;

select * from pedidos;


-- buscamos duplicados. IDEA FELIZ: JOIN de una tabla con ella misma.
SELECT p.id as id_pedido,p.cliente_id, c1.id,c1.email, c2.id, c2.email
FROM 
	pedidos p 
		JOIN 
	clientes c1 ON p.cliente_id = c1.id 
		JOIN 
	clientes c2 ON c1.email = c2.email
WHERE c2.id < c1.id;

SET SQL_SAFE_UPDATES = 0;
UPDATE pedidos p 
		JOIN 
	clientes c1 ON p.cliente_id = c1.id 
		JOIN 
	clientes c2 ON c1.email = c2.email
SET p.cliente_id = c2.id
WHERE c2.id < c1.id;
SELECT * FROM clientes;
DELETE c1
FROM clientes c1 
		JOIN 
	clientes c2 ON c1.email = c2.email
WHERE c2.id < c1.id;
SELECT * FROM clientes;
SET SQL_SAFE_UPDATES = 1;
SELECT * FROM clientes;
SELECT * FROM pedidos;

-- 2. Blindaje: Añade las restricciones de FOREIGN KEY a productos y pedidos.
ALTER TABLE pedidos
ADD CONSTRAINT fk_pedidos_clientes FOREIGN KEY (cliente_id) REFERENCES clientes(id) 
	ON DELETE RESTRICT ON UPDATE CASCADE;
    -- DA ERROR ¿POR QUÉ?
SELECT * FROM pedidos;
-- no funciona porque hay pedidos que han hecho clientes inexistentes. Resuelve el 2.3.2 y funcionará.

ALTER table productos
ADD CONSTRAINT fk_productos_categorias foreign key (categoria_id) references productos(id)
	ON DELETE RESTRICT ON UPDATE CASCADE; -- vaya liada...

ALTER TABLE productos
DROP CONSTRAINT fk_productos_categorias;

ALTER table productos
ADD CONSTRAINT fk_productos_categorias foreign key (categoria_id) references categorias(id)
	ON DELETE RESTRICT ON UPDATE CASCADE; 
    
    
    
-- GESTIÓN DE NULLS
-- COALESCE (primera_opcion , segunda_opcion_si_la_primera_es_nula, tercera_opcion_si_la_segunda_es_nula, ...)
SELECT * FROM productos;
ALTER TABLE productos
ADD COLUMN precio_final DECIMAL(10,2) 
AFTER precio_oferta;
SELECT * FROM productos;
START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;
UPDATE productos
SET precio_final = COALESCE(precio_oferta,precio,99999999);
-- SET precio_final = CASE WHEN precio_oferta is null then precio_oferta when precio_oferta is null and precio is not null then precio when precio_oferta is null and precio is null then 999999999 ....
SET SQL_SAFE_UPDATES = 1;


-- Archivado de Datos: Antes de realizar limpiezas masivas, vuelca los clientes sin pedidos en una tabla clientes_historico.
-- ¿Clientes sin pedidos?
SELECT * from clientes where id not in (select cliente_id from pedidos);

CREATE TABLE `historico_clientes` ( -- igual que la tabla original.
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre_completo` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO historico_clientes
SELECT * from clientes where id not in (select cliente_id from pedidos);

SELECT * FROM historico_clientes;


INSERT INTO historico_clientes
SELECT * from clientes where id not in (select cliente_id from pedidos);
-- ON DUPLICATE KEY UPDATE | IGNORE
