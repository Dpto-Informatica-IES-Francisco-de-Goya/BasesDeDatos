

# CLIENTES

## 1) Número total de clientes
```sql
select count(*) from clientes;
```
## 2) Número de clientes por país
```sql
select pais,count(nombre) from clientes group by pais;
```
## 3) Número de clientes registrados por año
```sql
select year(fecha_registro) AS year,
        count(fecha_registro) as num_clientes 
from clientes 
group by year(fecha_registro);
```

## 4) Número de clientes registrados por mes (todas las fechas)
```sql
select month(fecha_registro),
    count(id_cliente) 
from clientes 
group by month(fecha_registro) 
order by month(fecha_registro) asc;
```
*Ojo: también funciona esta otra consulta que no es SQL Standard por el **orden de ejecución de las palabras reservadas de SQL***
```sql
select month(fecha_registro) as mes,
    count(id_cliente) 
from clientes 
group by mes
order by mes;
```

## 5) Fecha de primer y último cliente registrado
```sql
select min(fecha_registro),max(fecha_registro) from clientes;
```

## 6) Número de países distintos con clientes
```sql
select count(distinct pais) as total_de_paises from clientes;
```

## 7) Conteo de clientes con email y sin email

```sql
select if(email is null, 'SIN EMAIL','CON EMAIL'),count(email) from clientes group by if(email is null,'SIN EMAIL','CON EMAIL');
 select if(email is null, 'SIN EMAIL','CON EMAIL') as si_o_no,count(email) as cuantos from clientes group
by si_o_no;
```
## 8) Distribución de clientes por primera letra del nombre
```sql
select substring(nombre,1,1) as letra, 
        count   (id_cliente) as conteo
     from clientes
     group by substring(nombre,1,1)
     order by substring(nombre,1,1) asc;
```

# PRODUCTOS

## 9) Número total de productos
```sql
select count(*) from productos;
```
## 10) Número de productos por categoría
```sql
select categoria,count(*) as Cantidad from productos group by categoria;
```
## 11) Precio promedio de productos
```sql
select avg(precio) as Promedio from productos;
```
## 12) Precio mínimo y máximo de productos
```sql
select min(precio) as mas_barato ,max(precio) as mas_caro from productos;
```
## 13) Stock total de productos
```sql
select sum(stock) as total_de_unidades from productos;
```
## 14) Stock total por categoría
```sql
select categoria,sum(stock)
from productos
group by categoria;
```
## 15) Valor de inventario total (stock * precio)
```sql
select sum(stock*precio) as valor_total_inventario from productos;
```
## 16) Valor de inventario por categoría
```sql
select categoria,sum(stock*precio) as valor_total_inventario from productos group by categoria;
```

## Bonus track
```sql
select year(fecha_registro) as y, 
        month(fecha_registro) as m, 
        count(*) as num_clientes 
from clientes 
group by year(fecha_registro),month(fecha_registro)
order by year(fecha_registro),month(fecha_registro);
```

# PEDIDOS

## 18) Número total de pedidos
```sql

```
## 19) Número de pedidos por estado
```sql

```
## 20) Total facturado (suma de la columna total)
```sql

```
## 21) Promedio de los costes totales de los pedidos
```sql

```
## 22) Pedido de mayor y menor importe
```sql

```
## 23) Número de pedidos por año
```sql

```
## 24) Total facturado por año
```sql

```
## 25) Número de pedidos por mes de todos los años
```sql

```
## 26) Total facturado por estado
```sql
select estado,sum(coste_total) AS total_facturado 
from pedidos
group by estado;
```
## 27) Promedio del total por estado
```sql
select estado,avg(coste_total) AS total_facturado 
from pedidos
group by estado;
```

**Observa** cómo la consulta 26 y la 27 tienen *la misma agrupación* pero *distinta agregación*.

# DETALLE_PEDIDO


## 29) Número de líneas de detalle registradas
```sql

```
## 30) Total de unidades vendidas (suma de cantidad)
```sql

```
## 31) Precio promedio de las líneas de detalle
```sql

```
## 32) Cantidad promedio por línea
```sql

```
## 33) Número de líneas por producto
```sql

```
## 34) Unidades totales por producto
```sql

```
## 35) Ingreso total por producto (cantidad * precio_unitario)

```sql

```



# Otros ejemplos

## 1) ¿Cuántos clientes se han registrado por año y mes?
```sql
select year(fecha_registro) as año,
        month(fecha_registro) as mes,
        count(nombre) as num_clientes
from clientes
group by year(fecha_registro),
        month(fecha_registro);
```

## 2) ¿Cuántos clientes españoles se han registrado por año y mes?
```sql
select year(fecha_registro) as año,
        month(fecha_registro) as mes,
        count(nombre) as num_clientes
from clientes
where pais = 'España'
group by year(fecha_registro),
        month(fecha_registro);
```

## 3) Ordenas las consultas anteriores
```sql
select year(fecha_registro) as año,
        month(fecha_registro) as mes,
        count(nombre) as num_clientes
from clientes
where pais = 'España'
group by year(fecha_registro),
        month(fecha_registro)
order by year(fecha_registro) asc,
        month(fecha_registro) asc;
```


## 4) Precio promedio agrupando por categoría e inicial del nombre con más de 3 unidades de stock
*Sin corregir en clase pero muchos lo han sacado*
```sql
SELECT categoria,
    left(nombre,1) AS inicial_nombre,
    avg(precio) AS precio_medio,
    count(*) AS cuantos
FROM productos
WHERE stock > 3
GROUP BY categoria, 
        left(nombre,1)
ORDER BY categoria,
    left(nombre,1);
```






## 7) Obtén el listado de los pedidos que han solicitado más de 10 productos


## 8) Mirando en la tabla detalle_pedido, ¿se ha producido algún cambio de precio que pueda verse en esa tabla?

```sql
SELECT 
    nombre, YEAR(fecha_registro)
FROM
    clientes;
```

## 5) ¿Cuántos clientes cuyo nombre empieza por 'A' se han registrado cada año?

```sql
SELECT 
    YEAR(fecha_registro) AS año, COUNT(*) AS num_clientes
FROM
    clientes
WHERE
    nombre LIKE 'A%'
GROUP BY YEAR(fecha_registro)
ORDER BY YEAR(fecha_registro);
```

-- Otra forma de resolverlo:

```sql
select year(fecha_registro) as año,
		count(*) as num_clientes
from clientes
where left(nombre,1) = 'A'
group by year(fecha_registro)
order by year(fecha_registro);
```


## 6a) ¿Cuántos productos distintos se han pedido en cada pedido?
```sql
SELECT id_pedido,count(*) AS num_prod_distintos
FROM detalle_pedido 
GROUP BY id_pedido;
```

## 6b) ¿Cuántas productos en total (es decir, cuantas unidades)  se han pedido en cada pedido?

```sql
SELECT 
    id_pedido, SUM(cantidad) AS total_unidades_pedidas
FROM
    detalle_pedido
GROUP BY id_pedido;
```



## 7a) Obtén el listado de los pedidos que han solicitado más de 10 productos distintos
```sql
SELECT id_pedido,count(*) AS num_prod_distintos
FROM detalle_pedido 
GROUP BY id_pedido
HAVING count(*) > 10;
```

 HAVING es lo mismo que WHERE para filtrar las columnas agregadas por el groupby.
 No tiene resultados


## 7b) Obtén el listado de los pedidos que han solicitado más de 10 productos en total
```sql
SELECT 
    id_pedido, SUM(cantidad) AS total_unidades_pedidas
FROM
    detalle_pedido
GROUP BY id_pedido
HAVING SUM(cantidad) > 10;
```

## 8) Mirando en la tabla detalle_pedido,  ¿se ha producido algún cambio de precio que pueda verse en esa tabla?



```sql
SELECT 
    id_producto, MAX(precio_unitario), MIN(precio_unitario)
FROM
    detalle_pedido
GROUP BY id_producto
HAVING
    MAX(precio_unitario) != MIN(precio_unitario);
```

```sql
SELECT 
    id_producto, MAX(precio_unitario), MIN(precio_unitario)
FROM
    detalle_pedido
GROUP BY id_producto
HAVING
    MAX(precio_unitario) != MIN(precio_unitario);
```

```sql
SELECT 
    id_producto, COUNT(DISTINCT precio_unitario) AS num_precios
FROM
    detalle_pedido
GROUP BY id_producto
HAVING num_precios > 1;
```

### Precuela de lo siguiente
Esta consulta resuelve parte. Si hubiera habido algún cambio de precio, se verían 2 filas repetidas.
```sql
SELECT DISTINCT
        id_producto, precio_unitario
    FROM
        detalle_pedido;
```

Podemos utilizar el resultado de esa consulta como si fuera una tabla en la claúsula `from` de una consulta nueva, es decir, podemos meter una consulta dentro de otra.
Esto tiene aglunas reglas y formas concretas de hacerse, pero es bastante lógico. Sería algo así:

```sql
SELECT 
    COUNT(id_producto), COUNT(DISTINCT id_producto)
FROM
    (SELECT DISTINCT
        id_producto, precio_unitario
    FROM
        detalle_pedido
    ORDER BY id_producto) AS NUEVA_TABLA;
```









