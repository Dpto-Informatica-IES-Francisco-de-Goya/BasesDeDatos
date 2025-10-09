select * from clientes;
select * from pedidos;
select * from pedidos,clientes
WHERE pedidos.id_cliente = clientes.id_cliente;

SELECT * FROM clientes,pedidos,detalle_pedido
WHERE clientes.id_cliente = pedidos.id_cliente 
	AND pedidos.id_pedido = detalle_pedido.id_pedido;
    
SELECT * FROM clientes,pedidos,detalle_pedido
WHERE clientes.id_cliente = pedidos.id_cliente 
	AND pedidos.id_pedido = detalle_pedido.id_pedido
    AND precio_unitario > 300;
SELECT * FROM 
	clientes
	JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente 
    JOIN detalle_pedido ON pedidos.id_pedido = detalle_pedido.id_pedido 
WHERE precio_unitario > 300;
    
-- Obtén los pedidos de 2023  que se han pagado por tarjeta
/* 
1) Tablas necesarias: pedidos, pagos 
2) Columnas que relacionan (ON): id_pedido
3) Filtros (where): Sí, year(fecha_pedido) = 2023 AND metodo_pago = 'tarjeta'
*/
SELECT * FROM
    pedidos
        JOIN
    pagos ON pagos.id_pedido = pedidos.id_pedido
WHERE
    YEAR(fecha_pedido) = 2023
        AND metodo_pago = 'tarjeta'
        AND fecha_pago IS NOT NULL;

-- DEBERES:    
-- Obtén los pedidos pendientes que se han pagado por tarjeta
/*1) Tablas necesarias. 
	PAGOS.metodo_pago,PEDIDOS.estado
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
WHERE pedidos.estado = 'pendiente' AND pagos.metodo_pago = 'tarjeta';

-- Tbm funciona así pero no es recomendable.
SELECT 
    *
FROM
    pedidos,
    pagos
WHERE
    pedidos.estado = 'pendiente'
        AND pagos.metodo_pago = 'tarjeta'
        AND pedidos.id_pedido = pagos.id_pedido;


-- ids de productos comprados por Ana Torres

/*1) Tablas necesarias. 
	detalle_pedido, clientes
2) Columnas que relacionan (ON). Si no hay columnas compartidas, tengo que incorporar tabla/s intermedia/s
	como tabla intermedia necesito pedidos.
    
    clientes -> pedidos con id_cliente
    pedidos -> detalle_pedido con id_pedido
    
3) Filtros (where)
	nombre = 'Ana Torres'
4) ¿Agrupaciones? Si las hay, agregaciones.
5) Filtro post-agregado (HAVING)
6) ¿Ordenación?*/

SELECT * 
FROM 
	clientes
		JOIN 
	pedidos ON clientes.id_cliente = pedidos.id_cliente
		JOIN
	detalle_pedido ON pedidos.id_pedido = detalle_pedido.id_pedido
WHERE clientes.nombre = 'Ana Torres';


-- Número de pedidos por país de origen del cliente
SELECT clientes.pais,count(pedidos.id_pedido) AS Num_pedidos
FROM 
	clientes
		JOIN
	pedidos ON clientes.id_cliente = pedidos.id_cliente
GROUP BY clientes.pais;

-- Numero de productos por país de origen del cliente
SELECT clientes.pais,count(detalle_pedido.id_producto) AS Num_producto
FROM 
	clientes
		JOIN
	pedidos ON clientes.id_cliente = pedidos.id_cliente
		JOIN
	detalle_pedido ON detalle_pedido.id_pedido = pedidos.id_pedido
GROUP BY clientes.pais;

-- Deberes para el viernes
-- Nombre de los productos que ha comprado Ana Torres
-- Por categoría del producto, cuantos pedidos se han hecho














