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

```sql
mysql> source tiendaonline-data-parte2.sql;
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
- IDs de pagos con su fecha de pago.
- Relación básica: id_pedido e id_producto de detalle_pedido.

## 2) Filtros con WHERE (comparadores, lógicos, BETWEEN, IN, LIKE, NULL)

- Clientes registrados en 2024.
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

```
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
