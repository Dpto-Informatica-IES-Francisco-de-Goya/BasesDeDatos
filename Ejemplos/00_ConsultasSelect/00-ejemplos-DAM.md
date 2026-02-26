# Ejemplos resueltos en la BBDD tiendaonline_completa.

## 1) Selección básica de datos y renombrado de columnas

- Listado simple de nombres y correos de todos los clientes.
```sql
mysql> select nombre,correo from clientes;
```

- Catálogo: nombre y precio de todos los productos.
```sql
mysql> select nombre,precio from productos;
```

- Pedidos con su fecha y estado.
```sql
mysql> select id_pedido,fecha_pedido,estado from pedidos;

```

- Pagos: método y monto registrados.
```sql
mysql> select metodo_pago,total_pagado from pagos;
```

- Detalle de líneas: producto y cantidad por cada detalle_pedido.
```sql
mysql> select id_producto,cantidad from detalle_pedido;
```

- Clientes con fecha de registro (orden natural de inserción).
```sql
select id_cliente,nombre,fecha_registro from clientes;
```
*Ojo: aquí entendemos por "clientes" id y nombre, pero según a quien le estemos dando esta información nos interesará darle un acosa u otra.*

*Ojo 2: orden natural de inserción es el orden por defecto de una consulta (salvo índices)*


- Productos con su categoría asociada (solo columnas principales).
```sql
select categoria,id_producto, nombre,precio,stock from productos;
```

- IDs de pedidos y su total.
- IDs de pagos con su fecha de pago.
- Relación básica: id_pedido e id_producto de detalle_pedido.

## 2) Filtros con WHERE (comparadores, lógicos, BETWEEN, IN, LIKE, NULL)

- Clientes registrados en 2024.

Ejemplos de funciones de obtención de día, mes y año de una fecha:
```sql
select id_cliente,fecha_registro,year(fecha_registro),month(fecha_registro),day(fecha_registro) from clientes;
```

2 soluciones de la consulta:
```sql
select * from clientes where fecha_registro > '2023-12-31' and fecha_registro < '2025-01-01';
select * from clientes where year(fecha_registro) = 2024;
```

- Productos con precio > 200
```sql
select * from productos where precio > 200;
```
- Pedidos con estado = 'pendiente' y total > 500.
```sql
select * from pedidos where estado = 'pendiente' and coste_total > 500;
```

- Pagos cuyo método IN ('tarjeta','paypal')

2 soluciones equivalentes:

```sql
select * from pagos where metodo_pago = 'tarjeta' or metodo_pago = 'paypal';
select * from pagos where metodo_pago IN ('tarjeta','paypal');
```
- Productos con stock entre 300 y 400.

2 soluciones equivalentes
```sql
select * from productos where stock >= 300 and stock <= 400;
select * from productos where stock between 300 and 400;
```

*Ojo: el between incluye el primero y el último*

- Clientes de país IN ('España','México','Argentina') (es decir, clientes de España o México o Argentina)
```sql
select * from clientes where pais IN ('espana','Mexico','argentina');
```

- Productos cuyo nombre contenga Silla.

```sql
select * from productos where nombre LIKE '%silla%';
```

*También hemos hecho ejemplos de _*

- Pedidos con fecha_pedido en abril de 2023.
```sql
select * from pedidos where fecha_pedido like '2023-04-%';
select * from pedidos where year(fecha_pedido) = 2023 and month(fecha_pedido) = 4;
```

- Pagos con fecha_pago IS NULL (simularía no pagados si existieran).
```sql
mysql> select * from pagos where fecha_pago is null;
+---------+-----------+------------+-------------+--------------+
| id_pago | id_pedido | fecha_pago | metodo_pago | total_pagado |
+---------+-----------+------------+-------------+--------------+
|       3 |         3 | NULL       | tarjeta     |         0.00 |
+---------+-----------+------------+-------------+--------------+
1 row in set (0,00 sec)

mysql> select * from pagos where fecha_pago = null;
Empty set (0,00 sec)
```

**OJO: null se compara con _is_ porque no se pueden comparar cosas que no existen.**

- Detalles donde cantidad sea 3 o más pero el precio_unitario menor que 50.
```sql
select * from detalle_pedido where cantidad >= 3 and       precio_unitario < 50;
```

- 
## 3) Ordenación, límite y duplicados (ORDER BY, LIMIT, DISTINCT)

- Top 10 productos más caros.
```sql
  select * from productos order by precio desc limit 10;
```

- Últimos 20 pedidos por fecha_pedido DESC.
```sql
    select * from pedidos order by fecha_pedido desc limit 20;
```
- Clientes más recientes por fecha_registro.
```sql
select  * from clientes order by fecha_registro desc limit 20;
```
*Limit 20 es arbitrario. Algo que tenga sentido. Ponemos 20 porque Andrés ha dicho 20*

- Primeros 5 productos con menor stock.
```sql 
    select * from productos order by stock asc limit 5;
```
- DISTINCT de categorías de productos disponibles.
```sql
   select distinct categoria from productos;
```
- Países distintos de los clientes registrados.
```sql
    select distinct pais from clientes;
```
- Pagos ordenados por monto DESC (mayor a menor).


- Pedidos ordenados por total ASC.

- Primeros 10 clientes por orden alfabético del nombre.
```sql
    select * from clientes order by nombre limit 10;
```
- Top 5 productos más baratos en la categoría “Accesorios”.
```sql
select * from productos where categoria='Accesorios' order by precio asc limit 5;
```
