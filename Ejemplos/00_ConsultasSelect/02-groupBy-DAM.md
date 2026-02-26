
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
select year(fecha_registro),count(*) from clientes group by year(fecha_registro);
```
## 4) Número de clientes registrados por mes (todas las fechas)
```sql
select month(fecha_registro) as Mes,        count(*) as num_clientes from clientes group by month(fecha_registro) order by month(fecha_registro) asc;
```
## 5) Fecha de primer y último cliente registrado
```sql
select min(fecha_registro) as primer_registro ,max(fecha_registro) as ultimo_registro from clientes;
```
## 6) Número de países distintos con clientes
```sql
select count(distinct pais) as num_paises from clientes;
```
## 7) Conteo de clientes con email y sin email

## 8) Distribución de clientes por primera letra del nombre
select substring(nombre,1,1) as Letra,        count(id_cliente) as Numero_clientes from clientes group by Letra order by Letra;


# PRODUCTOS

## 9) Número total de productos
select count(*) as total_productos from productos;
## 10) Número de productos por categoría
```sql
select categoria,count(*) as num_productos from productos group by categoria order by count(*) desc;
```

```sql
select categoria,sum(stock) as stock from productos group by categoria order by count(*) desc;
 by count(*) desc;
```

## 11) Precio promedio de productos
```sql
select round(avg(precio),2) as precio_medio from productos;
```

*Precio medio por categoría:*
```sql
select categoria,round(avg(precio),2) as precio_medio from productos group by catego
ria;
```

## 12) Precio mínimo y máximo de productos
```sql
select min(precio) as precio_minimo,max(precio) as precio_maximo from productos;
```

Si quiero agrupar por categoria:
```sql
select categoria, min(precio),max(precio) from productos group by categoria;
```

## 13) Stock total de productos
```sql
select sum(stock) from productos;
```
## 14) Stock total por categoría
```sql
select categoria,sum(stock) as stock_total from productos group by categoria order by sum(stock) desc;
```

## 15) Valor de inventario total (stock * precio)
```sql
select sum(stock*precio) as inventario_total from productos;
```
## 16) Valor de inventario por categoría
```sql
select categoria,sum(stock*precio) as valor_total from productos group by categoria;
```


# PEDIDOS


## 18) Número total de pedidos
## 19) Número de pedidos por estado
## 20) Total facturado (suma de la columna total)
## 21) Promedio de los costes totales de los pedidos
## 22) Pedido de mayor y menor importe
## 23) Número de pedidos por año
## 24) Total facturado por año
## 25) Número de pedidos por mes de todos los años
## 26) Total facturado por estado
## 27) Promedio del total por estado

# DETALLE_PEDIDO

## 29) Número de líneas de detalle registradas
## 30) Total de unidades vendidas (suma de cantidad)
## 31) Precio promedio de las líneas de detalle
## 32) Cantidad promedio por línea
## 33) Número de líneas por producto
## 34) Unidades totales por producto
## 35) Ingreso total por producto (cantidad * precio_unitario)


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


## 5) ¿Cuántos clientes cuyo nombre empieza por 'A' se han registrado cada año?
 SELECT year(fecha_registro) as año, count(*) AS num_clientes
 FROM clientes
 WHERE nombre like 'A%'
 GROUP BY year(fecha_registro );


## 6a) ¿Cuántos productos se han pedido en total en cada pedido?
select id_pedido,count(id_producto) from detalle_pedido group by id_pedido;
## 6b) ¿Cuántos productos distintos se han pedido en total en cada pedido?
select id_pedido,sum(id_producto) from detalle_pedido group by id_pedido;

## 7a) Obtén el listado de los pedidos que han solicitado más de 10 productos en total
select id_pedido,sum(cantidad) from detalle_pedido group by id_pedido having sum(cantidad) > 10;
## 7b) Obtén el listado de los pedidos que han solicitado más de 10 productos distintos
select id_pedido,count(id_producto) from detalle_pedido group by id_pedido having count(id_producto) > 10;



