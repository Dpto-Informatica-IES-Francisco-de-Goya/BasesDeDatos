# Modelo

# Previos

En este examen podrás utilizar el CheatSheet de MySQL que has estado utilizando en clase.

Este examen evalúa los CE a,b del RA3. Supone un 85% de dichos criterios de evaluación.

## Instrucciones de entrega

Deberás entregar un documento PDF que se llame "ex-ra3ab-apellidos-nombre.pdf" sustituyendo apellidos y nombre por tus apellidos y tu nombre.

El PDF contendrá el enunciado de la consulta a resolver, el código de las consultas que hayas ejecutado y una captura de pantalla donde se vean los resultados obtenidos.

Hay 10 apartados, calificándose con un punto cada uno.

*Todas las consultas deberán limitarse a 10 resultados como máximo en caso de que no se especifique otro límite y la consulta no saque menos de 10 resultados*

# Consultas a resolver

## 1) Carga la Base de Datos tienda_online

*Nota: si no sabes cargar la base de datos, puedes pedir ayuda y se te calificará esta pregunta con un 0*.

---

## 2) Listado simple

Obtén un listado de 7 nombres e emails de clientes.

## 3) GBs

Obtén los nombres y las descripciones de los productos que, en su descripción, contengan `GB`.

## 4) Gangas

Obtén el top-3 de productos más baratos.

## 5) Emails

Se ha encontrado que hubo un error con los clientes registrados entre el 6/05/2023 y el 29/12/2024. Obtén el email de todos los clientes que **no** se registraron entre esas fechas.

## 6) Nombres comunes

¿Cuántos clientes hay que se llamen "María"?

## 7) ¿Cuántos pedidos distintos han solicitado 4 unidades de algún producto?

## 8) Obtén un listado de los nombres de producto precedidos por su categoría, para aquellos productos con más de 500 de stock

Es decir, deberás obtener, en una única columna, algo de este estilo.

+-----------------------------------------+
| Muebles - Escritorio                             |
| Electrónica - Monitor LG 24"                |
| Accesorios - Teclado Mecánico            |
| Accesorios - Ratón Inalámbrico           |
| Electrónica - Impresora HP DeskJet     |
| ...					                       |
+-----------------------------------------+

## 9) Listado de nombres ordenado por longitud

Obtén el listado de los 9 nombres con apellido de clientes más cortos.

*Nota: en la función LENGTH las tildes cuentan como caracter doble. Puedes utilizar la función CHAR_LENGTH que cuenta el número real de caracteres*

## 10) Pagos nocturnos

Para control antifraude, obtén el listado de pagos que se han realizado de noche (entre las 01:00 y las 04:00).

El listado debe presentarse ordenado mostrando primero los más recientes.

---

# Resultados

Como esto es un modelo de examen, te dejo los resultados que **a mi me han salido** al resolver estas consultas. Podría haber alguna errata o alguna ambigüedad que hayamos interpretado de forma diferente. No debería, pero es un disclaimer.

2)

```jsx
+------------------+------------------------------+
| nombre           | email                        |
+------------------+------------------------------+
| Ana Torres       | ana@example.com              |
| Luis Méndez      | luis@example.com             |
| Carla Gómez      | carla@example.com            |
| David Ruiz       | david@example.com            |
| Sofía Paredes    | sofia@example.com            |
| Marta Gil        | marta.gil6@example.com       |
| Gonzalo Jiménez  | gonzalo.jimenez7@example.com |
+------------------+------------------------------+
7 rows in set (0,00 sec)

```

3)

```jsx
+---------------------------+----------------------+
| nombre                    | descripcion          |
+---------------------------+----------------------+
| Tablet Samsung            | Galaxy Tab A8 64GB   |
| Memoria RAM 16GB          | DDR4 3200MHz (2x8GB) |
| Tarjeta Gráfica RTX 3060  | 12GB GDDR6           |
+---------------------------+----------------------+
3 rows in set (0,00 sec)

```

4)

```jsx
+-------------+-----------------------+----------------------------+--------+-------+------------+
| id_producto | nombre                | descripcion                | precio | stock | categoria  |
+-------------+-----------------------+----------------------------+--------+-------+------------+
|          30 | Organizador de cables | Pack 10 unidades           |   9.99 |   800 | Accesorios |
|          24 | Cable HDMI 2.1        | 2 metros                   |  11.99 |   500 | Accesorios |
|          20 | Regleta 6 tomas       | Protección sobretensiones  |  19.50 |   400 | Hogar      |
+-------------+-----------------------+----------------------------+--------+-------+------------+
3 rows in set (0,00 sec)

```

5) 

```jsx
+-------------------------------+
| email                         |
+-------------------------------+
| maria.alonso16@example.com    |
| maria.garcia17@example.com    |
| nicolas.serrano24@example.com |
| jose.fernandez30@example.com  |
| sofia.alonso33@example.com    |
| paula.ramirez37@example.com   |
+-------------------------------+
6 rows in set (0,00 sec)
```

6) 

```jsx
+-----+
| num |
+-----+
|   2 |
+-----+
1 row in set (0,09 sec)
```

7) 

```jsx
+-----------------------+
| num_pedidos_distintos |
+-----------------------+
|                    80 |
+-----------------------+
1 row in set (0,00 sec)

```

8)

```jsx
+-------------------------------------+
| nombre_con_prefijo                  |
+-------------------------------------+
| Electrónica - Laptop Dell Inspiron  |
| Electrónica - Smartphone Xiaomi     |
| Accesorios - Auriculares Bluetooth  |
| Muebles - Silla Gamer               |
| Muebles - Escritorio                |
| Accesorios - Organizador de cables  |
+-------------------------------------+
6 rows in set (0,00 sec)

```

9)

```sql
# Utilizando LENGTH
+--------------+
| nombre       |
+--------------+
| Hugo Gil     |
| Marta Gil    |
| Ana Torres   |
| David Ruiz   |
| Laura Ruiz   |
| Irene Ramos  |
| Luis Méndez  |
| Carla Gómez  |
| Marta Alonso |
+--------------+
9 rows in set (0,00 sec)

# Utilizando CHAR_LENGTH (que no está en el CheatSheet y que no tendrías porqué conocer)
+--------------+
| nombre       |
+--------------+
| Hugo Gil     |
| Marta Gil    |
| Ana Torres   |
| David Ruiz   |
| Laura Ruiz   |
| Luis Méndez  |
| Carla Gómez  |
| Irene Ramos  |
| Elena López  |
+--------------+
9 rows in set (0,01 sec)

```

10)

```sql
+---------+-----------+---------------------+-------------+--------------+
| id_pago | id_pedido | fecha_pago          | metodo_pago | total_pagado |
+---------+-----------+---------------------+-------------+--------------+
|     118 |       144 | 2025-05-24 02:03:02 | paypal      |       928.40 |
|      47 |        58 | 2025-05-19 01:57:07 | tarjeta     |       934.80 |
|      48 |        59 | 2025-03-05 01:52:27 | paypal      |       347.44 |
|      10 |        12 | 2025-01-07 01:09:18 | paypal      |      1175.67 |
|       9 |        10 | 2024-11-24 03:35:05 | tarjeta     |       698.97 |
|      96 |       120 | 2024-01-21 01:24:47 | paypal      |      1743.98 |
+---------+-----------+---------------------+-------------+--------------+
6 rows in set (0,00 sec)
```