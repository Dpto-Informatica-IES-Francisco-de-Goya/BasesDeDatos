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
    
-- Obtén los pedidos pendientes que se han pagado por tarjeta
-- ids de productos comprados por Ana Torres

/*1) Tablas necesarias. 
	PAGOS,PEDIDOS
2) Columnas que relacionan (ON)
	pagos.id_pedido =  pedidos.id_pedido
3) Filtros (where)
	estado = 'pendiente'
    metodo_pago = 'tarjeta'
4) ¿Agrupaciones? Si las hay, agregaciones.
5) Filtro post-agregado (HAVING)
6) ¿Ordenación?*/