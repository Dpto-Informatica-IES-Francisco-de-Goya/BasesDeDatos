USE tienda_online;
SELECT * FROM clientes;


# PRODUCTOS
## 9) Número total de productos
SELECT count(*) FROM productos;

## 10) Número de productos por categoría
SELECT 
    categoria, COUNT(id_producto) AS num_productos
FROM
    productos
GROUP BY categoria;
## 11) Precio promedio de productos
## 12) Precio mínimo y máximo de productos
## 13) Stock total de productos
## 14) Stock total por categoría
SELECT 
    categoria, sum(stock) AS stock_total
FROM
    productos
GROUP BY categoria;
## 15) Valor de inventario total (stock * precio)
SELECT 
    sum(stock*precio) AS stock_total
FROM
    productos;
## 16) Valor de inventario por categoría
SELECT 
    categoria, sum(stock*precio) AS stock_total
FROM
    productos
GROUP BY categoria;


## 29) Número de líneas de detalle registradas
## 30) Total de unidades vendidas (suma de cantidad)
## 31) Precio promedio de los productos de detalle
## 32) Cantidad promedio por producto
SELECT id_producto,avg(cantidad)
FROM detalle_pedido
GROUP BY id_producto;

## 33) Número de pedidos que han comprado cada producto
SELECT id_producto,count(id_pedido) as num_pedidos
FROM detalle_pedido	
GROUP BY id_producto;

## 33b) Número de pedidos que han comprado cada producto, cuando se hayan comprado más de 20.
SELECT id_producto,count(id_pedido) as num_pedidos
FROM detalle_pedido
GROUP BY id_producto
HAVING count(id_pedido) > 20;

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
