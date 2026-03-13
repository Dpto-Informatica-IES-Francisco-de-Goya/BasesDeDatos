-- Listado de categorías con el stock acumulado de todos sus productos
SELECT
	categoria, sum(stock) AS stock_acumulado
FROM productos
GROUP BY categoria;

-- Listar los id_pedidos con estado 'entregado' junto con el nombre del cliente 
-- que ha hecho el pedido y la fecha del pedido.
SELECT clientes.nombre, pedidos.id_pedido, pedidos.fecha_pedido
FROM 
	clientes
		JOIN
	pedidos ON clientes.id_cliente = pedidos.id_cliente
WHERE pedidos.estado = 'entregado';

-- Listado de productos que cuestan más de 200 y se han pedido en pedidos cancelados
SELECT p.nombre
FROM
	productos p
		JOIN
	detalle_pedido dp ON p.id_producto = dp.id_producto
		JOIN
	pedidos pe ON dp.id_pedido = pe.id_pedido
WHERE p.precio > 200 AND pe.estado = 'cancelado';

-- Productos con ≥ 100 unidades vendidas
SELECT 
	p.nombre, SUM(dp.cantidad) AS unidades_vendidas
FROM 
	productos p
		JOIN
	detalle_pedido dp ON p.id_producto = dp.id_producto	
GROUP BY p.nombre
HAVING SUM(dp.cantidad) >= 10;