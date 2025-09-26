

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

```
## 27) Promedio del total por estado
```sql

```

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

