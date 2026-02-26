-- 18) Productos NUNCA vendidos.
SELECT '== 18) Productos NUNCA vendidos ==' AS titulo;
SELECT DISTINCT
  pr.nombre AS producto
FROM productos AS pr
LEFT JOIN detalle_pedido AS dp ON dp.id_producto = pr.id_producto
WHERE dp.id_producto IS NULL
ORDER BY producto ASC;

-- 20) Pedidos sin pagos, con cliente y coste_total.
SELECT '== 20) Pedidos sin pagos, con cliente y coste_total ==' AS titulo;
SELECT
  p.id_pedido AS pedido,
  c.nombre    AS cliente,
  p.coste_total AS coste_total
FROM pedidos AS p
JOIN clientes AS c ON c.id_cliente = p.id_cliente
LEFT JOIN pagos AS pa ON pa.id_pedido = p.id_pedido
WHERE pa.id_pedido IS NULL
ORDER BY coste_total DESC, pedido ASC;

-- 28) Pedidos con pagos parciales (suma pagos < coste_total y ≥ 1 pago).
SELECT '== 28) Pedidos con pagos parciales ==' AS titulo;
SELECT
  p.id_pedido AS pedido,
  c.nombre    AS cliente,
  SUM(pa.total_pagado) AS total_pagado,
  p.coste_total AS coste_total
FROM pedidos AS p
JOIN clientes AS c ON c.id_cliente = p.id_cliente
LEFT JOIN pagos AS pa ON pa.id_pedido = p.id_pedido
GROUP BY p.id_pedido, c.nombre, p.coste_total
HAVING SUM(pa.total_pagado) IS NOT NULL
   AND SUM(pa.total_pagado) < p.coste_total
ORDER BY total_pagado ASC, pedido ASC;


-- 29) Nº de productos distintos comprados por cliente.
SELECT '== 29) Nº de productos distintos comprados por cliente ==' AS titulo;
SELECT
  c.nombre AS cliente,
  COUNT(DISTINCT dp.id_producto) AS productos_distintos
FROM clientes AS c
LEFT JOIN pedidos AS p ON p.id_cliente = c.id_cliente
LEFT JOIN detalle_pedido AS dp ON dp.id_pedido = p.id_pedido
GROUP BY c.id_cliente, c.nombre
ORDER BY productos_distintos DESC, cliente ASC;



-- 35) Clientes 2025 SIN pedidos aún.
SELECT '== 35) Clientes 2025 sin pedidos ==' AS titulo;
SELECT
  c.nombre AS cliente,
  c.fecha_registro AS fecha_registro
FROM clientes AS c
LEFT JOIN pedidos AS p ON p.id_cliente = c.id_cliente
WHERE c.fecha_registro >= '2025-01-01' AND c.fecha_registro < '2026-01-01'
  AND p.id_pedido IS NULL
ORDER BY fecha_registro ASC, cliente ASC;

