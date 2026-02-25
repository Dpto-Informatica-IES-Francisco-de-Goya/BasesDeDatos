use tienda_online;

-- consultas_17_41_soluciones.sql
--        mysql -u TU_USUARIO -p -D TU_BBDD < consultas_17_41_soluciones.sql
-- El archivo de resultados se generará como: resultados_consultas_17_41.txt

TEE resultados_consultas_17_41.txt;

-- Cabecera informativa
SELECT '== EJECUCIÓN CONSULTAS 17–41 ==' AS info, NOW() AS fecha_hora;

-- 17) Contar líneas y unidades por pedido.
SELECT '== 17) Contar líneas y unidades por pedido ==' AS titulo;
SELECT 
  p.id_pedido AS pedido,
  COUNT(*) AS lineas,
  SUM(dp.cantidad) AS unidades
FROM pedidos AS p
JOIN detalle_pedido AS dp ON dp.id_pedido = p.id_pedido
GROUP BY p.id_pedido
ORDER BY lineas DESC, pedido ASC;


-- 19) Clientes sin ningún pedido.
SELECT '== 19) Clientes sin ningún pedido ==' AS titulo;
SELECT DISTINCT
  c.nombre AS cliente
FROM clientes AS c
LEFT JOIN pedidos AS p ON p.id_cliente = c.id_cliente
WHERE p.id_cliente IS NULL
ORDER BY cliente ASC;



-- 21) Nº de pedidos distintos pagados por método de pago.
SELECT '== 21) Nº de pedidos distintos pagados por método de pago ==' AS titulo;
SELECT
  pa.metodo_pago AS metodo_pago,
  COUNT(DISTINCT pa.id_pedido) AS pedidos_pagados
FROM pagos AS pa
GROUP BY pa.metodo_pago
ORDER BY pedidos_pagados DESC, metodo_pago ASC;

-- 22) Total pagado acumulado por cliente (todos sus pagos).
SELECT '== 22) Total pagado acumulado por cliente ==' AS titulo;
SELECT
  c.nombre AS cliente,
  SUM(pa.total_pagado) AS total_pagado
FROM clientes AS c
JOIN pedidos  AS p  ON p.id_cliente  = c.id_cliente
JOIN pagos    AS pa ON pa.id_pedido  = p.id_pedido
GROUP BY c.id_cliente, c.nombre
ORDER BY total_pagado DESC, cliente ASC;

-- 23) Clientes con ticket medio (AVG coste_total) ≥ 500 €.
SELECT '== 23) Clientes con ticket medio >= 500 € ==' AS titulo;
SELECT
  c.nombre AS cliente,
  AVG(p.coste_total) AS ticket_medio,
  COUNT(p.id_pedido) AS pedidos
FROM clientes AS c
JOIN pedidos  AS p ON p.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nombre
HAVING AVG(p.coste_total) >= 500
ORDER BY ticket_medio DESC, cliente ASC;

-- 24) Productos con ≥ 100 unidades vendidas.
SELECT '== 24) Productos con >= 100 uds vendidas ==' AS titulo;
SELECT
  pr.nombre AS producto,
  SUM(dp.cantidad) AS uds_vendidas
FROM productos AS pr
JOIN detalle_pedido AS dp ON dp.id_producto = pr.id_producto
GROUP BY pr.id_producto, pr.nombre
HAVING SUM(dp.cantidad) >= 100
ORDER BY uds_vendidas DESC, producto ASC;

-- 25) Precio unitario medio de venta por producto.
SELECT '== 25) Precio unitario medio de venta por producto ==' AS titulo;
SELECT
  pr.nombre AS producto,
  AVG(dp.precio_unitario) AS precio_medio
FROM productos AS pr
JOIN detalle_pedido AS dp ON dp.id_producto = pr.id_producto
GROUP BY pr.id_producto, pr.nombre
ORDER BY precio_medio DESC, producto ASC;

-- 26) Pedidos de marzo de 2024 con cliente y fecha.
SELECT '== 26) Pedidos de marzo de 2024 ==' AS titulo;
SELECT
  p.id_pedido    AS pedido,
  c.nombre       AS cliente,
  p.fecha_pedido AS fecha_pedido
FROM pedidos AS p
JOIN clientes AS c ON c.id_cliente = p.id_cliente
WHERE p.fecha_pedido >= '2024-03-01' AND p.fecha_pedido < '2024-04-01'
ORDER BY fecha_pedido ASC, pedido ASC;

-- 27) Importe total y nº de pedidos por estado.
SELECT '== 27) Importe total y nº de pedidos por estado ==' AS titulo;
SELECT
  p.estado              AS estado,
  COUNT(*)              AS pedidos,
  SUM(p.coste_total)    AS total_coste
FROM pedidos AS p
GROUP BY p.estado
ORDER BY total_coste DESC, estado ASC;



-- 30) Pedidos con variedad de productos (DISTINCT id_producto) ≥ 5.
SELECT '== 30) Pedidos con >= 5 productos distintos ==' AS titulo;
SELECT
  p.id_pedido AS pedido,
  c.nombre    AS cliente,
  COUNT(DISTINCT dp.id_producto) AS productos_distintos
FROM pedidos AS p
JOIN clientes AS c ON c.id_cliente = p.id_cliente
JOIN detalle_pedido AS dp ON dp.id_pedido = p.id_pedido
GROUP BY p.id_pedido, c.nombre
HAVING COUNT(DISTINCT dp.id_producto) >= 5
ORDER BY productos_distintos DESC, pedido ASC;

-- 31) Precio medio por producto en pedidos 'entregado'.
SELECT '== 31) Precio medio por producto en pedidos entregados ==' AS titulo;
SELECT
  pr.nombre AS producto,
  AVG(dp.precio_unitario) AS precio_medio
FROM pedidos AS p
JOIN detalle_pedido AS dp ON dp.id_pedido   = p.id_pedido
JOIN productos      AS pr ON pr.id_producto = dp.id_producto
WHERE p.estado = 'entregado'
GROUP BY pr.id_producto, pr.nombre
ORDER BY precio_medio DESC, producto ASC;

-- 32) Clientes de 'España' con pagos por 'tarjeta': nº de pedidos y total pagado.
SELECT '== 32) Clientes de España con pagos por tarjeta ==' AS titulo;
SELECT
  c.nombre AS cliente,
  COUNT(DISTINCT p.id_pedido) AS pedidos_pagados,
  SUM(pa.total_pagado)        AS total_pagado
FROM clientes AS c
JOIN pedidos AS p ON p.id_cliente = c.id_cliente
JOIN pagos   AS pa ON pa.id_pedido = p.id_pedido
WHERE c.pais = 'España'
  AND pa.metodo_pago = 'tarjeta'
GROUP BY c.id_cliente, c.nombre
ORDER BY total_pagado DESC, cliente ASC;

-- 33) Importe de líneas vs. coste_total por pedido.
SELECT '== 33) Importe de líneas vs coste_total por pedido ==' AS titulo;
SELECT
  p.id_pedido AS pedido,
  SUM(dp.cantidad * dp.precio_unitario) AS importe_lineas,
  p.coste_total AS coste_total
FROM pedidos AS p
JOIN detalle_pedido AS dp ON dp.id_pedido = p.id_pedido
GROUP BY p.id_pedido, p.coste_total
ORDER BY importe_lineas DESC, pedido ASC;

-- 34) Líneas con precio_unitario > 1000 € (productos premium).
SELECT '== 34) Líneas con precio_unitario > 1000 € ==' AS titulo;
SELECT DISTINCT
  pr.nombre AS producto,
  dp.precio_unitario AS precio_unitario
FROM detalle_pedido AS dp
JOIN productos AS pr ON pr.id_producto = dp.id_producto
WHERE dp.precio_unitario > 1000
ORDER BY precio_unitario DESC, producto ASC;

-- 36) Pedidos por país y estado.
SELECT '== 36) Pedidos por país y estado ==' AS titulo;
SELECT
  c.pais  AS pais,
  p.estado AS estado,
  COUNT(*) AS pedidos
FROM clientes AS c
JOIN pedidos  AS p ON p.id_cliente = c.id_cliente
GROUP BY c.pais, p.estado
ORDER BY pais ASC, estado ASC;

-- 37) Ingresos por producto en clientes de 'España' ≥ 20.000 €.
SELECT '== 37) Ingresos por producto (España) >= 20000 € ==' AS titulo;
SELECT
  pr.nombre AS producto,
  SUM(dp.cantidad * dp.precio_unitario) AS ingresos
FROM clientes AS c
JOIN pedidos  AS p  ON p.id_cliente  = c.id_cliente
JOIN detalle_pedido AS dp ON dp.id_pedido = p.id_pedido
JOIN productos AS pr ON pr.id_producto = dp.id_producto
WHERE c.pais = 'España'
GROUP BY pr.id_producto, pr.nombre
HAVING SUM(dp.cantidad * dp.precio_unitario) >= 20000
ORDER BY ingresos DESC, producto ASC;

-- 38) Clientes con pedidos en 2024: nº de pedidos y suma de costes.
SELECT '== 38) Clientes con pedidos en 2024 ==' AS titulo;
SELECT
  c.nombre AS cliente,
  COUNT(p.id_pedido) AS pedidos_2024,
  SUM(p.coste_total) AS total_2024
FROM clientes AS c
JOIN pedidos AS p ON p.id_cliente = c.id_cliente
WHERE p.fecha_pedido >= '2024-01-01' AND p.fecha_pedido < '2025-01-01'
GROUP BY c.id_cliente, c.nombre
ORDER BY total_2024 DESC, cliente ASC;

-- 39) Nº de pagos por pedido con su fecha.
SELECT '== 39) Nº de pagos por pedido con su fecha ==' AS titulo;
SELECT
  p.id_pedido    AS pedido,
  p.fecha_pedido AS fecha_pedido,
  COUNT(pa.total_pagado) AS pagos
FROM pedidos AS p
LEFT JOIN pagos AS pa ON pa.id_pedido = p.id_pedido
GROUP BY p.id_pedido, p.fecha_pedido
ORDER BY pagos DESC, pedido ASC;

-- 40) Clientes con total de pagos ≥ 50.000 €.
SELECT '== 40) Clientes con total de pagos >= 50000 € ==' AS titulo;
SELECT
  c.nombre AS cliente,
  SUM(pa.total_pagado) AS total_pagado
FROM clientes AS c
JOIN pedidos AS p ON p.id_cliente = c.id_cliente
JOIN pagos   AS pa ON pa.id_pedido = p.id_pedido
GROUP BY c.id_cliente, c.nombre
HAVING SUM(pa.total_pagado) >= 50000
ORDER BY total_pagado DESC, cliente ASC;

-- 41) Detalles con precio_unitario fuera de [50, 500], mostrando pedido y producto.
SELECT '== 41) Detalles con precio_unitario fuera de [50, 500] ==' AS titulo;
SELECT
  dp.id_pedido AS pedido,
  pr.nombre    AS producto,
  dp.precio_unitario AS precio_unitario
FROM detalle_pedido AS dp
JOIN productos AS pr ON pr.id_producto = dp.id_producto
WHERE dp.precio_unitario < 50 OR dp.precio_unitario > 500
ORDER BY precio_unitario DESC, producto ASC, pedido ASC;

-- Fin de la captura
NOTEE;
