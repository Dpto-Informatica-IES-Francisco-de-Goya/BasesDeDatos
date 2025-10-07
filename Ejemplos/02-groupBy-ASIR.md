# PREVIO

## ¿Cómo se piensa?

1) Tabla - From
2) ¿Filtro? Where
3) Agrupo por ...
4) Todo lo del group by, al select
5) Agrego (count,min,max,sum,avg...)
6) ¿Tengo que ordenar? Normalmente sí, interesa ordenar por la columna por la que se agrupa.

## Número de productos distintos por categoria

```sql
select categoria,count(nombre) from productos group by categoria;
```

Puedes agregar todo lo que te interese.
```sql
select categoria,
        min(precio),
        max(precio),
        count(precio),
        sum(precio),
        round(avg(precio),2) 
from productos 
group by categoria;
```
Stock total por categoría
```sql
select categoria,sum(stock) 
from productos
group by categoria;
```


# CLIENTES
## 1) Número total de clientes

```sql
select count(nombre) as num_clientes from clientes;
```

## 2) Número de clientes por país
```sql
select pais,count(*) as num_clientes from clientes group by pais;

```
## 3) Número de clientes registrados por año
```sql
select year(fecha_registro) as año, count(*) as num_clientes 
from clientes 
group by year(fecha_registro);
```
## 4) Número de clientes registrados por mes (todas las fechas)
```sql
select month(fecha_registro) as mes, count(*) as num_clientes 
from clientes 
group by month(fecha_registro);
```

## BONUS TRACK
## BT) Número de clientes registrados por año y mes
```sql
select year(fecha_registro) as año,
       month(fecha_registro) as mes, 
       count(*) as num_clientes 
from clientes 
group by year(fecha_registro), 
        month(fecha_registro)
order by year(fecha_registro) asc, 
        month(fecha_registro) asc;
```

## 5) Fecha de primer y último cliente registrado
```sql

```
## 6) Número de países distintos con clientes
```sql

```
## 7) Conteo de clientes con email y sin email
```sql

```
## 8) Distribución de clientes por primera letra del nombre
```sql
select substring(nombre,1,1) as Primera_letra,       count(*) as num_clientes from clientes group by substring(nombre,1,1) order by substring(nombre,1,1) asc;
```

# PRODUCTOS
## 9) Número total de productos
```sql

```
## 10) Número de productos por categoría
## 11) Precio promedio de productos
## 12) Precio mínimo y máximo de productos
## 13) Stock total de productos
## 14) Stock total por categoría
## 15) Valor de inventario total (stock * precio)
## 16) Valor de inventario por categoría

# PEDIDOS (para practicar)

## 18) Número total de pedidos
## 19) Número de pedidos por estado
## 20) Total facturado (suma de la columna total)
## 21) Promedio del total de pedidos
## 22) Pedido de mayor y menor importe
## 23) Número de pedidos por año
## 24) Total facturado por año
## 25) Número de pedidos por mes de todos los años
## 26) Total facturado por estado
## 27) Promedio del total por estado

# DETALLE_PEDIDO
## 29) Número de líneas de detalle registradas
## 30) Total de unidades vendidas (suma de cantidad)
## 31) Precio promedio de los productos de detalle
## 32) Cantidad promedio por producto
## 33) Número de pedidos que han comprado cada producto
## 34) Unidades totales por producto
## 35) Ingreso total por producto (cantidad * precio_unitario)

# Otros ejemplos

## 1) ¿Cuántos clientes se han registrado por año y mes?
## 2) ¿Cuántos clientes españoles se han registrado por año y mes?
## 3) Ordenas las consultas anteriores
## 4) Precio promedio agrupando por categoría e inicial del nombre con más de 3 unidades de stock
## 5) ¿Cuántos clientes cuyo nombre empieza por 'A' se han registrado cada año?
## 6) ¿Cuántos productos se han pedido en cada pedido?
## 7) Obtén el listado de los pedidos que han solicitado más de 10 productos

