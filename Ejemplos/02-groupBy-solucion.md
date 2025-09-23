-- 35_agregaciones_solo_group_by.sql
USE tienda_online;

-- =======================
-- CLIENTES
-- =======================

-- 1) Número total de clientes
SELECT COUNT(*) AS total_clientes FROM clientes;

-- 2) Número de clientes por país
SELECT pais, COUNT(*) AS clientes_por_pais
FROM clientes
GROUP BY pais
ORDER BY clientes_por_pais DESC;

-- 3) Número de clientes registrados por año
SELECT YEAR(fecha_registro) AS anio, COUNT(*) AS clientes_en_anio
FROM clientes
GROUP BY YEAR(fecha_registro)
ORDER BY anio;

-- 4) Número de clientes registrados por mes (todas las fechas)
SELECT YEAR(fecha_registro) AS anio, MONTH(fecha_registro) AS mes, COUNT(*) AS clientes_en_mes
FROM clientes
GROUP BY YEAR(fecha_registro), MONTH(fecha_registro)
ORDER BY anio, mes;

-- 5) Fecha de primer y último cliente registrado
SELECT MIN(fecha_registro) AS primer_registro, MAX(fecha_registro) AS ultimo_registro
FROM clientes;

-- 6) Número de países distintos con clientes
SELECT COUNT(DISTINCT pais) AS paises_distintos
FROM clientes;

-- 7) Conteo de clientes con email y sin email
SELECT IF(email IS NULL, 'SIN EMAIL', 'CON EMAIL') AS tipo_email, COUNT(*) AS cantidad
FROM clientes
GROUP BY tipo_email;

-- 8) Distribución de clientes por primera letra del nombre
SELECT LEFT(nombre, 1) AS inicial, COUNT(*) AS num_clientes
FROM clientes
GROUP BY inicial
ORDER BY inicial;

-- =======================
-- PRODUCTOS
-- =======================

-- 9) Número total de productos
SELECT COUNT(*) AS total_productos FROM productos;

-- 10) Número de productos por categoría
SELECT categoria, COUNT(*) AS productos_por_categoria
FROM productos
GROUP BY categoria;

-- 11) Precio promedio de productos
SELECT ROUND(AVG(precio),2) AS precio_promedio FROM productos;

-- 12) Precio mínimo y máximo de productos
SELECT MIN(precio) AS precio_minimo, MAX(precio) AS precio_maximo
FROM productos;

-- 13) Stock total de productos
SELECT SUM(stock) AS stock_total FROM productos;

-- 14) Stock total por categoría
SELECT categoria, SUM(stock) AS stock_categoria
FROM productos
GROUP BY categoria;

-- 15) Valor de inventario total (stock * precio)
SELECT ROUND(SUM(stock * precio), 2) AS valor_inventario
FROM productos;

-- 16) Valor de inventario por categoría
SELECT categoria, ROUND(SUM(stock * precio), 2) AS valor_inventario_categoria
FROM productos
GROUP BY categoria
ORDER BY valor_inventario_categoria DESC;


-- =======================
-- PEDIDOS
-- =======================

-- 18) Número total de pedidos
SELECT COUNT(*) AS total_pedidos FROM pedidos;

-- 19) Número de pedidos por estado
SELECT estado, COUNT(*) AS pedidos_por_estado
FROM pedidos
GROUP BY estado;

-- 20) Total facturado (suma de la columna total)
SELECT ROUND(SUM(total), 2) AS total_facturado FROM pedidos;

-- 21) Promedio del total de pedidos
SELECT ROUND(AVG(total), 2) AS ticket_medio_global FROM pedidos;

-- 22) Pedido de mayor y menor importe
SELECT MIN(total) AS pedido_minimo, MAX(total) AS pedido_maximo
FROM pedidos;

-- 23) Número de pedidos por año
SELECT YEAR(fecha_pedido) AS anio, COUNT(*) AS pedidos_en_anio
FROM pedidos
GROUP BY YEAR(fecha_pedido)
ORDER BY anio;

-- 24) Total facturado por año
SELECT YEAR(fecha_pedido) AS anio, ROUND(SUM(total),2) AS ventas_anuales
FROM pedidos
GROUP BY YEAR(fecha_pedido)
ORDER BY anio;

-- 25) Número de pedidos por mes de todos los años
SELECT YEAR(fecha_pedido) AS anio, MONTH(fecha_pedido) AS mes, COUNT(*) AS pedidos_mes
FROM pedidos
GROUP BY YEAR(fecha_pedido), MONTH(fecha_pedido)
ORDER BY anio, mes;

-- 26) Total facturado por estado
SELECT estado, ROUND(SUM(total), 2) AS total_por_estado
FROM pedidos
GROUP BY estado;

-- 27) Promedio del total por estado
SELECT estado, ROUND(AVG(total), 2) AS promedio_por_estado
FROM pedidos
GROUP BY estado;



-- =======================
-- DETALLE_PEDIDO
-- =======================

-- 29) Número de líneas de detalle registradas
SELECT COUNT(*) AS lineas_detalle FROM detalle_pedido;

-- 30) Total de unidades vendidas (suma de cantidad)
SELECT SUM(cantidad) AS unidades_vendidas FROM detalle_pedido;

-- 31) Precio promedio de las líneas de detalle
SELECT ROUND(AVG(precio_unitario), 2) AS precio_promedio_unitario FROM detalle_pedido;

-- 32) Cantidad promedio por línea
SELECT ROUND(AVG(cantidad), 2) AS cantidad_promedio FROM detalle_pedido;

-- 33) Número de líneas por producto
SELECT id_producto, COUNT(*) AS lineas_por_producto
FROM detalle_pedido
GROUP BY id_producto
ORDER BY lineas_por_producto DESC;

-- 34) Unidades totales por producto
SELECT id_producto, SUM(cantidad) AS unidades_por_producto
FROM detalle_pedido
GROUP BY id_producto
ORDER BY unidades_por_producto DESC;

-- 35) Ingreso total por producto (cantidad * precio_unitario)
SELECT id_producto, ROUND(SUM(cantidad * precio_unitario), 2) AS ingreso_producto
FROM detalle_pedido
GROUP BY id_producto
ORDER BY ingreso_producto DESC;
