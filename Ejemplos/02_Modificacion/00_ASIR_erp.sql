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
