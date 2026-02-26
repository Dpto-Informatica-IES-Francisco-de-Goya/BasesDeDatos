# Previos a ejecutar estas consultas

Navegamos a la carpeta y abrimos ahí mysql porque vamos a cargar los archivos (si no se van a cargar los archivos, este paso no es necesario).
```bash
$ cd BasesDeDatos/dbs/tiendaonline
```

Abrimos mysql
```bash
$ mysql -u admin -p
```

Cargamos los archivos de mysql solo una vez
```sql
mysql> source tiendaonline-schema.sql;
mysql> source tiendaonline-data-parte1.sql;
mysql> source tiendaonline-data-parte2.sql;
```


# Consultar información

Para consultar las bases de datos que ya existen.
```sql
mysql> show databases;
```

Para indicar con qué base de datos vamos a trabajar.
```sql
mysql> use [bbdd];
```


```sql
mysql> show tables;
```



¡Ya estamos listos para empezar con las consultas!

# Ejemplos resueltos en la BBDD tiendaonline_completa.

## 1) Selección básica de datos y renombrado de columnas

- Listado simple de nombres y correos de todos los clientes:
```sql
mysql> select nombre,email from clientes;
```

- Catálogo: nombre y precio de todos los productos.
```sql
mysql> select nombre,precio from productos;
```

- Pedidos con su fecha y estado.
Truqui!! Para ver las columnas que tiene una tabla puedo hacer:
```sql
mysql> select * from pedidos limit 1;
```
`limit 1` va a sacar solo 1 registro. Así, fácilmente, puedo ver todas las columnas que hay.


```sql
mysql> select fecha_pedido,estado from pedidos;
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
mysql> select id_cliente,nombre,email,fecha_registro from clientes;
```

**¡OJO 1!** El ordenado por defecto es el orden natural de inserción.

**¡Ojo 2!** Damos id_cliente,nombre,email porque ante la duda, mejor sacar información de más.

- Productos con su categoría asociada (solo columnas principales).
```sql
mysql> select categoria,id_producto,nombre,precio,stock from productos;
```
**¡OJO!** Puedes elegir en qué orden salen las columnas de la tabla resultante.

- IDs de pedidos y su total.
```sql
select id_pedido,coste_total from pedidos;
```

- IDs de pagos con su fecha de pago.
```sql
select id_pago,fecha_pago from pagos;
```

- Relación básica: id_pedido e id_producto de detalle_pedido.

## 2) Filtros con WHERE (comparadores, lógicos, BETWEEN, IN, LIKE, NULL)

- Clientes registrados en 2024.
```sql
select * from clientes where year(fecha_registro) = 2024;
select * from clientes where fecha_registro > '2023-12-31' and fecha_registro < '2025-01-01';
```

- Productos con precio > 200.
```sql
mysql> select * from productos where precio >= 200;
```

- Pedidos con estado = 'pendiente' y total > 500.
```sql
mysql> select * from pedidos where estado = 'pendiente' and coste_total > 500;
```

- Pagos cuyo método IN ('tarjeta','paypal').
```sql
select * from pagos where metodo_pago  IN ('tarjeta','paypal');
select * from pagos where metodo_pago = 'tarjeta' or metodo_pago = 'paypal';

```
- Productos con stock entre 300 y 400.
```sql
select * from productos where stock between 300 and 400;
select * from productos where stock >= 300 and stock <= 400;
```

- Clientes de país IN ('España','México','Argentina').
```sql
select * from clientes where    pais     IN ('Espana','Mexico','argentina');
```

- Productos cuyo nombre contenga Silla.
```sql
select * from productos where nombre like '%silla%';
```
*OJO: muchos más ejemplos del %*


- Pedidos con fecha_pedido en abril de 2023.
```sql
select * from pedidos where year(fecha_pedido) = 2023 and month(fecha_pedido) = 4;
select * from pedidos where fecha_pedido like '2023-04%';
```

- Pagos con fecha_pago IS NULL (simularía no pagados si existieran).

```sql
ysql> select * from pagos where fecha_pago = NULL;
Empty set (0,01 sec)

mysql> select * from pagos where fecha_pago is NULL;
+---------+-----------+------------+-------------+--------------+
| id_pago | id_pedido | fecha_pago | metodo_pago | total_pagado |
+---------+-----------+------------+-------------+--------------+
|       3 |         3 | NULL       | tarjeta     |         0.00 |
+---------+-----------+------------+-------------+--------------+
1 row in set (0,00 sec)
```


- Detalles donde cantidad sea 3 o más pero el precio_unitario menor que 50.
```sql
mysql> select * from detalle_pedido WHERE cantidad >= 3 and precio_unitario < 50;
```

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
select * from clientes order by fecha_registro desc limit 15;
```
*15 a ojo*


Si queremos filtrar los clientes del último año, combinamos el order con el where.
```sql
select * from clientes where year(fecha_registro)=2025 order by fecha_registro desc;

```

- Primeros 5 productos con menor stock.
```sql
select * from productos order by stock asc limit 5;
```
```sql
select * from productos order by stock asc,nombre asc limit 5;
```

- DISTINCT de categorías de productos disponibles.
```sql
select distinct categoria from productos;
```

- Países distintos de los clientes registrados.
```sql
select distinct pais from clientes;
```
**Todo lo que ponga en el order tiene que aparecer en el select. Si no, da error**

¿Qué pasa si pongo un distinct para 2 columnas? Elimina las **filas** duplicadas. En este caso, no elimina nada.

```sql
select distinct pais,fecha_registro from clientes order by fecha_registro;

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
select * 
from productos 
where categoria = 'Accesorios' 
order by precio asc 
limit 5;
```

