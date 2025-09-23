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
```sql
select * from clientes where year(fecha_registro) = 2024;
```

**Ojo:** pendiente iba entre comillas porque es una palabra. 2024 va sin comillas porque es un número. 

- Pagos cuyo método IN ('tarjeta','paypal').
```sql
select * from pagos where metodo_pago IN ('tarjeta','paypal');
select * from pagos where metodo_pago='tarjeta' or metodo_pago = 'paypal';
```


- Productos con stock entre 300 y 400.


**Estas 2 consultas son equivalentes**

```sql
select * from productos where stock => 300 and stock <= 400
select * from productos where stock between 300 and 400;

```
- Clientes de país IN ('España','México','Argentina').
```sql
select * from clientes where pais IN ('España','México','Argentina');
```

- Productos cuyo nombre contenga Silla.
```sql
select * from productos where nombre like '%silla%';
```

**Más ejemplos de % y _**
```sql
mysql> select * from productos where nombre like '_lla%';
Empty set (0,00 sec)

mysql> select * from productos where nombre like '__lla%';
+-------------+------------------+--------------------------------------+--------+-------+-----------+
| id_producto | nombre           | descripcion                          | precio | stock | categoria |
+-------------+------------------+--------------------------------------+--------+-------+-----------+
|           4 | Silla Gamer      | Silla ergonómica con soporte lumbar  | 180.00 |  1005 | Muebles   |
|          21 | Silla de Oficina | Ergonómica malla                     | 129.00 |   320 | Muebles   |
|          28 | Silla Gamer Pro  | Reclinable 160°                      | 229.00 |   310 | Muebles   |
+-------------+------------------+--------------------------------------+--------+-------+-----------+
3 rows in set (0,01 sec)

mysql> select * from productos where nombre like 'S_lla%';
+-------------+------------------+--------------------------------------+--------+-------+-----------+
| id_producto | nombre           | descripcion                          | precio | stock | categoria |
+-------------+------------------+--------------------------------------+--------+-------+-----------+
|           4 | Silla Gamer      | Silla ergonómica con soporte lumbar  | 180.00 |  1005 | Muebles   |
|          21 | Silla de Oficina | Ergonómica malla                     | 129.00 |   320 | Muebles   |
|          28 | Silla Gamer Pro  | Reclinable 160°                      | 229.00 |   310 | Muebles   |
+-------------+------------------+--------------------------------------+--------+-------+-----------+
3 rows in set (0,00 sec)
```

- Pedidos con fecha_pedido en abril de 2023.

```sql
mysql> select * from pedidos where fecha_pedido < '2023-05-01' and fecha_pedido > '2023-03-31';
+-----------+------------+---------------------+-----------+-------------+
| id_pedido | id_cliente | fecha_pedido        | estado    | coste_total |
+-----------+------------+---------------------+-----------+-------------+
|         1 |          1 | 2023-04-01 10:00:00 | entregado |     1070.00 |
|         2 |          2 | 2023-04-03 15:30:00 | enviado   |      320.00 |
|         3 |          1 | 2023-04-05 12:45:00 | pendiente |       25.00 |
|         4 |          3 | 2023-04-10 09:10:00 | cancelado |      180.00 |
|         5 |          4 | 2023-04-11 13:00:00 | entregado |      210.00 |
+-----------+------------+---------------------+-----------+-------------+
5 rows in set (0,00 sec)

mysql> select * from pedidos where year(fecha_pedido)=2023 AND month(fecha_pedido)=04;
+-----------+------------+---------------------+-----------+-------------+
| id_pedido | id_cliente | fecha_pedido        | estado    | coste_total |
+-----------+------------+---------------------+-----------+-------------+
|         1 |          1 | 2023-04-01 10:00:00 | entregado |     1070.00 |
|         2 |          2 | 2023-04-03 15:30:00 | enviado   |      320.00 |
|         3 |          1 | 2023-04-05 12:45:00 | pendiente |       25.00 |
|         4 |          3 | 2023-04-10 09:10:00 | cancelado |      180.00 |
|         5 |          4 | 2023-04-11 13:00:00 | entregado |      210.00 |
+-----------+------------+---------------------+-----------+-------------+
5 rows in set (0,00 sec)

mysql> select * from pedidos where fecha_pedido like '2023-04%';
+-----------+------------+---------------------+-----------+-------------+
| id_pedido | id_cliente | fecha_pedido        | estado    | coste_total |
+-----------+------------+---------------------+-----------+-------------+
|         1 |          1 | 2023-04-01 10:00:00 | entregado |     1070.00 |
|         2 |          2 | 2023-04-03 15:30:00 | enviado   |      320.00 |
|         3 |          1 | 2023-04-05 12:45:00 | pendiente |       25.00 |
|         4 |          3 | 2023-04-10 09:10:00 | cancelado |      180.00 |
|         5 |          4 | 2023-04-11 13:00:00 | entregado |      210.00 |
+-----------+------------+---------------------+-----------+-------------+
5 rows in set (0,00 sec)
```
- Listado de los clientes con más de 9 caracteres
```sql
mysql> select nombre from clientes where length(nombre) > 9;

```


```sql
--- Para quitar espacios.
mysql> select nombre,length(replace(nombre,' ','')) from clientes;
mysql> select nombre from clientes where length( replace(nombre,' ','') ) > 9;

```


```sql
--- cortesía de Juan Andrés
--- Seleccionar solo el nombre (hasta el primer espacio)
select SUBSTRING_INDEX(nombre,' ',1) from clientes;
select reverse(SUBSTRING_INDEX(reverse(nombre),' ',1)) from clientes;
```

- Pagos con fecha_pago IS NULL (simularía no pagados si existieran).
```sql
select * from pagos where fecha_pago is null;
```
**Null se compara con "is" no con un "="**

- Detalles donde cantidad sea 3 o más pero el precio_unitario menor que 50.
```sql
select * from detalle_pedido where cantidad >=3 and precio_unitario < 50;
```

- Productos que no sean de electrónica
```sql
select * from productos where categoria not like "Electrónica";
select * from productos where categoria != "Electrónica";

```

## 3) Ordenación, límite y duplicados (ORDER BY, LIMIT, DISTINCT)

- Top 10 productos más caros.
```sql
select * from productos order by precio desc limit 10';

```

- Últimos 20 pedidos por fecha_pedido DESC.
```sql
select * from pedidos order by fecha_pedido desc limit 20;
```

- Clientes más recientes por fecha_registro.
```sql
select *  from clientes order by fecha_registro desc;
```
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
```sql
select * from pagos order by total_pagado desc;
```
- Pedidos ordenados por total ASC.
```sql
select * from pedidos order by coste_total asc;
```
- Primeros 10 clientes por orden alfabético del nombre.
```sql
select * from clientes order by nombre asc limit 10;
```
- Top 5 productos más baratos en la categoría “Accesorios”.
```sql
select * from productos where categoria='Accesorios' order by precio asc limit 5;
```
