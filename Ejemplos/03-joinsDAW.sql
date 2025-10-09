USE tienda_online;

SELECT * FROM clientes;

SELECT * FROM productos;

-- Obtén el listado de los pedidos que han solicitado más de 3 productos distintos
SELECT 
    id_pedido, COUNT(id_producto) AS num_prod_distintos
FROM
    detalle_pedido
GROUP BY id_pedido
HAVING COUNT(*) > 3; /* filtro posterior al agrupamiento. Lo normal es que vaya con una función de agregación*/

SELECT * FROM detalle_pedido;

/* ENUNCIADO :
8) Mirando en la tabla detalle_pedido, ¿se ha producido 
algún cambio de precio que pueda verse en esa tabla?*/

-- SOLUCIÓN: NO HA HABIDO NINGÚN CAMBIO DE PRECIO
SELECT 
    id_producto, MAX(precio_unitario), MIN(precio_unitario)
FROM
    detalle_pedido
GROUP BY id_producto
HAVING MAX(precio_unitario) != MIN(precio_unitario);

/* CARGAMOS EL SCHEMA Y LA PARTE 1*/

SELECT year(fecha_registro),month(fecha_registro),count(*)
FROM clientes
GROUP BY year(fecha_registro),month(fecha_registro);

-- Pedidos de Ana Torres
SELECT * 
FROM clientes, pedidos
WHERE clientes.id_cliente = pedidos.id_cliente
	AND clientes.nombre = 'Ana Torres';


-- ids de productos comprados por Ana Torres
SELECT * 
FROM clientes, pedidos,detalle_pedido
WHERE clientes.id_cliente = pedidos.id_cliente
	AND pedidos.id_pedido = detalle_pedido.id_pedido
	AND clientes.nombre = 'Ana Torres';

-- Lo mismo
SELECT * 
FROM clientes
	JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente
    JOIN detalle_pedido ON pedidos.id_pedido = detalle_pedido.id_pedido
WHERE clientes.nombre = 'Ana Torres';

-- Obtén los pedidos de 2023 que se han pagado por tarjeta
/* 
1) Tablas necesarias. 
	pedidos.fecha_pedido   pagos.metodo_pago
2) Columnas que relacionan (ON). Si no se relacionan directamente, buscar tablas intermedias.
	id_pedido relaciona pedidos con pagos
3) Filtros (where)
	year(fecha_registro) = 2023 AND pagos.metodo_pago = 'tarjeta'
4) ¿Agrupaciones? Si las hay, agregaciones.
5) Filtro post-agregado (HAVING)
6) ¿Ordenación?
	Estaría bien ordenar por fecha
*/

SELECT 
    *
FROM
    pedidos
		JOIN
	pagos ON pedidos.id_pedido = pagos.id_pedido
WHERE
    YEAR(pedidos.fecha_pedido) = 2023
        AND pagos.metodo_pago = 'tarjeta'
ORDER BY fecha_pedido ASC;



-- Obtén los pedidos pendientes que se han pagado por tarjeta
/*
1) Tablas necesarias. 
	PAGOS,PEDIDOS
2) Columnas que relacionan (ON)
	pagos.id_pedido =  pedidos.id_pedido
3) Filtros (where)
	estado = 'pendiente'
    metodo_pago = 'tarjeta'
4) ¿Agrupaciones? Si las hay, agregaciones.
5) Filtro post-agregado (HAVING)
6) ¿Ordenación?*/
SELECT *
FROM 
	pedidos
		JOIN 
	pagos ON pedidos.id_pedido = pagos.id_pedido
WHERE metodo_pago = 'tarjeta' AND estado = 'pendiente';

-- Obtén los nombres de los productos que ha pedido Ana Torres
/*
1) Tablas necesarias. 
	productos,clientes
    OJO!!! TABLAS INTERMEDIAS: pedidos, detalle_pedido
2) Columnas que relacionan (ON)
	clientes con pedidos -> id_cliente
    pedidos con detalle_pedido -> id_pedido
    detalle_pedido con producos -> id_producto
3) Filtros (where)
	nombre = 'Ana Torres'
4) ¿Agrupaciones? Si las hay, agregaciones.
5) Filtro post-agregado (HAVING)
6) ¿Ordenación?*/
SELECT productos.nombre 
FROM clientes
		JOIN
	pedidos ON clientes.id_cliente = pedidos.id_cliente
		JOIN
	detalle_pedido ON pedidos.id_pedido = detalle_pedido.id_pedido
		JOIN 
	productos ON detalle_pedido.id_producto = productos.id_producto
WHERE clientes.nombre = 'Ana Torres';


-- PARTE 2 (deberes para el jueves las 2 primeras)
-- ¿Cuántos pedidos se han comprado por clientes de Argentina?
/*
1) Tablas necesarias: clientes, pedidos
2) Columnas que relacionan (ON): id_cliente
3) Filtros (where)
4) ¿Agrupaciones? Si las hay, agregaciones. COUNT pero sin group by
5) Filtro post-agregado (HAVING)
6) ¿Ordenación?*/

SELECT COUNT(*)
FROM 
	clientes
		JOIN
	pedidos ON clientes.id_cliente = pedidos.id_cliente
WHERE pais = 'Argentina';
	
-- ¿Cuántos productos se han comprado por clientes de Argentina?
/*
1) Tablas necesarias: pedidos, clientes, detalle_pedido
2) Columnas que relacionan (ON) id_cliente relaciona pedidos con clientes. id_pedido relaciona pedidos con detalle_pedido
3) Filtros (where): pais Argentina
4) ¿Agrupaciones? Si las hay, agregaciones. COUNT como antes
5) Filtro post-agregado (HAVING)
6) ¿Ordenación?*/
SELECT *
FROM 
	clientes
		JOIN
	pedidos ON clientes.id_cliente = pedidos.id_cliente
		JOIN
	detalle_pedido ON pedidos.id_pedido = detalle_pedido.id_pedido
WHERE pais = 'Argentina';
	
-- Para hacer en directo el jueves.
-- ¿Cuántos productos se han comprado por pais de origen del cliente?
/*
1) Tablas necesarias: pedidos, clientes, detalle_pedido
2) Columnas que relacionan (ON) id_cliente relaciona pedidos con clientes. id_pedido relaciona pedidos con detalle_pedido
3) Filtros (where): NO APLICA
4) ¿Agrupaciones? Si las hay, agregaciones. Agrupo por pais y cuento como función de agregación
5) Filtro post-agregado (HAVING)
6) ¿Ordenación?*/

SELECT clientes.pais, count(*) AS num_productos
FROM 
	clientes
		JOIN
	pedidos ON clientes.id_cliente = pedidos.id_cliente
		JOIN
	detalle_pedido ON pedidos.id_pedido = detalle_pedido.id_pedido
GROUP BY clientes.pais;


-- Cuáles son los paises en los que se han comprado más de 40 productos
/*
1) Tablas necesarias: pedidos, clientes, detalle_pedido
2) Columnas que relacionan (ON) id_cliente relaciona pedidos con clientes. id_pedido relaciona pedidos con detalle_pedido
3) Filtros (where): NO APLICA
4) ¿Agrupaciones? Si las hay, agregaciones. Agrupo por pais y cuento como función de agregación
5) Filtro post-agregado (HAVING)
6) ¿Ordenación?*/

SELECT clientes.pais, count(*) AS num_productos
FROM 
	clientes
		JOIN
	pedidos ON clientes.id_cliente = pedidos.id_cliente
		JOIN
	detalle_pedido ON pedidos.id_pedido = detalle_pedido.id_pedido
GROUP BY clientes.pais
HAVING count(*) > 40;
