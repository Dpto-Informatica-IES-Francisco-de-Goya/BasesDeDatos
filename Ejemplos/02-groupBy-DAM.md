
# CLIENTES



## 1) Número total de clientes
select count(*) from clientes;
## 2) Número de clientes por país
select pais,count(nombre) from clientes group by pais;
## 3) Número de clientes registrados por año
select year(fecha_registro),count(*) from clientes group by year(fecha_registro);
## 4) Número de clientes registrados por mes (todas las fechas)
select month(fecha_registro) as Mes,        count(*) as num_clientes from clientes group by month(fecha_registro) order by month(fecha_registro) asc;


## 5) Fecha de primer y último cliente registrado
select min(fecha_registro) as primer_registro ,max(fecha_registro) as ultimo_registro from clientes;
## 6) Número de países distintos con clientes
select count(distinct pais) as num_paises from clientes;
## 7) Conteo de clientes con email y sin email

## 8) Distribución de clientes por primera letra del nombre
select substring(nombre,1,1) as Letra,        count(id_cliente) as Numero_clientes from clientes group by Letra order by Letra;


# PRODUCTOS

## 9) Número total de productos
select count(*) as total_productos from productos;
## 10) Número de productos por categoría
## 11) Precio promedio de productos
## 12) Precio mínimo y máximo de productos
## 13) Stock total de productos
## 14) Stock total por categoría
## 15) Valor de inventario total (stock * precio)
## 16) Valor de inventario por categoría



# PEDIDOS



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
## 31) Precio promedio de las líneas de detalle
## 32) Cantidad promedio por línea
## 33) Número de líneas por producto
## 34) Unidades totales por producto
## 35) Ingreso total por producto (cantidad * precio_unitario)
