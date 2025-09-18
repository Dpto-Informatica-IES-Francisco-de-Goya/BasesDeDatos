# Ejemplos resueltos en la BBDD tiendaonline_completa.

## 1) Selección básica de datos y renombrado de columnas

- Listado simple de nombres y correos de todos los clientes.

```sql
select nombre,email from clientes;
```

- Catálogo: nombre y precio de todos los productos.
```sql
select nombre,precio from productos;
```
- Pedidos con su fecha y estado.
```sql
select estado,fecha_pedido from pedidos;
```

- Pagos: método y monto registrados.
```sql
select metodo_pago,total_pagado from pagos;
```
- Detalle de líneas: producto y cantidad por cada detalle_pedido.
```sql
select id_producto,cantidad from detalle_pedido;
```

- Clientes con fecha de registro (orden natural de inserción).
```sql
select id_cliente,nombre,email,fecha_registro from clientes;
```
*Ojo: orden natural de inserción es la ordenación por defecto.*

- Productos con su categoría asociada (solo columnas principales).
```sql
select categoria,id_producto,nombre,stock,precio from productos;
```
- IDs de pedidos y su total.
```sql

```
- IDs de pagos con su fecha de pago.
```sql

```
- Relación básica: id_pedido e id_producto de detalle_pedido.
```sql

```

## 2) Filtros con WHERE (comparadores, lógicos, BETWEEN, IN, LIKE, NULL)

- Productos con precio > 200.
```sql
    select * from productos WHERE precio > 200;
```

- Pedidos con estado = 'pendiente' y total > 500.
```sql
    select * from pedidos where estado = "pendiente" AND coste_total > 500;
```
- Clientes registrados en 2024.
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
