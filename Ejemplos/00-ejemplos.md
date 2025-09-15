# Ejemplos resueltos en la BBDD tiendaonline_completa.

## 1) Selección básica de datos y renombrado de columnas

- Listado simple de nombres y correos de todos los clientes.
- Catálogo: nombre y precio de todos los productos.
- Pedidos con su fecha y estado.
- Pagos: método y monto registrados.
- Detalle de líneas: producto y cantidad por cada detalle_pedido.
- Clientes con fecha de registro (orden natural de inserción).
- Productos con su categoría asociada (solo columnas principales).
- IDs de pedidos y su total.
- IDs de pagos con su fecha de pago.
- Relación básica: id_pedido e id_producto de detalle_pedido.

## 2) Filtros con WHERE (comparadores, lógicos, BETWEEN, IN, LIKE, NULL)

- Clientes registrados en 2024.
- Productos con precio > 200.
- Pedidos con estado = 'pendiente' y total > 500.
- Pagos cuyo método IN ('tarjeta','paypal').
- Productos con stock entre 300 y 400.
- Clientes de país IN ('España','México','Argentina').
- Productos cuyo nombre contenga Silla.
- Pedidos con fecha_pedido en abril de 2023.
- Pagos con fecha_pago IS NULL (simularía no pagados si existieran).
- Detalles donde cantidad sea 3 o más pero el precio_unitario menor que 50.
- 
## 3) Ordenación, límite y duplicados (ORDER BY, LIMIT, DISTINCT)

- Top 10 productos más caros.
- Últimos 20 pedidos por fecha_pedido DESC.
- Clientes más recientes por fecha_registro.
- Primeros 5 productos con menor stock.
- DISTINCT de categorías de productos disponibles.
- Países distintos de los clientes registrados.
- Pagos ordenados por monto DESC (mayor a menor).
- Pedidos ordenados por total ASC.
- Primeros 10 clientes por orden alfabético del nombre.
- Top 5 productos más baratos en la categoría “Accesorios”.
