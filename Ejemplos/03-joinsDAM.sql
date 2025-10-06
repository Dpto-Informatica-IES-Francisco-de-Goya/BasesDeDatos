SELECT * 
FROM clientes,pedidos,detalle_pedido
WHERE clientes.id_cliente = pedidos.id_cliente 
	AND pedidos.id_pedido = detalle_pedido.id_pedido 
    AND nombre like 'Ana Torres';

SELECT nombre,email, pedidos.id_pedido,detalle_pedido.id_producto,precio_unitario
FROM clientes
JOIN  pedidos ON clientes.id_cliente = pedidos.id_cliente
JOIN detalle_pedido ON pedidos.id_pedido = detalle_pedido.id_pedido
WHERE nombre like 'Ana Torres';

-- Obtén los pedidos de 2023 que se han pagado por tarjeta
/* PISTAS:
- Tablas: necesito las tablas 'pedidos' (porque necesito la fecha de pedido)
y 'pagos' porque necesito el método de pago.
- Filtros: el método de pago y el año
- No hay agrupaciones
- Podría ordenar por fecha
*/
SELECT 
    *
FROM
    pedidos
        JOIN
    pagos ON pedidos.id_pedido = pagos.id_pedido
WHERE
    pagos.metodo_pago = 'tarjeta'
        AND YEAR(pedidos.fecha_pedido) = 2023
ORDER BY fecha_pedido;

-- Obtén los pedidos pendientes que se han pagado por tarjeta
SELECT 
    *
FROM
    pedidos
        JOIN
    pagos ON pedidos.id_pedido = pagos.id_pedido
WHERE
    pagos.metodo_pago = 'tarjeta'
        AND pedidos.estado = 'pendiente'
ORDER BY fecha_pedido;

-- Obtén los nombres de los productos que se han comprado juntos más de 3 veces en algún pedido
SELECT 
    productos.nombre, detalle_pedido.cantidad, detalle_pedido.id_pedido
FROM
    productos
        JOIN
    detalle_pedido ON productos.id_producto = detalle_pedido.id_producto
WHERE 
	detalle_pedido.cantidad > 0;

-- Obtén los productos que se han comprado juntos más de 3 veces en algún pedido de 2024
SELECT 
    productos.nombre, detalle_pedido.cantidad, detalle_pedido.id_pedido
FROM
    productos
        JOIN
    detalle_pedido ON productos.id_producto = detalle_pedido.id_producto
		JOIN 
	pedidos ON detalle_pedido.id_pedido = pedidos.id_pedido
WHERE 
	detalle_pedido.cantidad > 0 AND
    YEAR(pedidos.fecha_pedido) = 2024;

-- Obtén los nombres de los productos que ha pedido Ana Torres
SELECT 
    nombre
FROM
    clientes
        JOIN
    pedidos ON clientes.id_cliente = pedidos.id_cliente
        JOIN
    detalle_pedido ON pedidos.id_pedido = detalle_pedido.id_pedido
        JOIN
    productos ON detalle_pedido.id_producto = productos.id_producto
WHERE
    clientes.nombre = 'Ana Torres';

-- PARA CORREGIR EN CLASE EL MIÉRCOLES. ALTAMENTE RECOMENDABLE HACERLOS EN CASA
-- ¿Cuántos pedidos se han comprado por clientes de Argentina?
-- ¿Cuántos productos se han comprado por clientes de Argentina?
-- ¿Cuántos productos se han comprado por pais de origen del cliente?