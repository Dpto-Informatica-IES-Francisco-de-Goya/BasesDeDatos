USE tienda_online;

-- 1) Listar cada id del pedido con el nombre del cliente que lo realizó.
--    Orden: cliente ASC, y a igualdad de cliente por pedido ASC.
SELECT '===== CONSULTA 1 =====' AS '';
SELECT c.nombre AS cliente, p.id_pedido AS pedido
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
ORDER BY cliente ASC, pedido ASC;

-- 2) Listar cada línea de detalle con el nombre del producto y el id del pedido.
--    Columnas EXACTAS y alias:
--      - producto (pr.nombre)
--      - pedido   (dp.id_pedido)
--    Orden: producto ASC, y a igualdad de producto por pedido ASC.
SELECT '===== CONSULTA 2 =====' AS '';
SELECT pr.nombre AS producto, dp.id_pedido AS pedido
FROM productos pr
JOIN detalle_pedido dp ON pr.id_producto = dp.id_producto
ORDER BY producto ASC, pedido ASC;

-- 3) Listar cada pedido con el nombre del cliente y su coste total.
--    Columnas EXACTAS y alias:
--      - cliente      (c.nombre)
--      - pedido       (p.id_pedido)
--      - coste_total  (p.coste_total)
--    Orden: coste_total DESC y, en empates, pedido ASC.
SELECT '===== CONSULTA 3 =====' AS '';
SELECT c.nombre AS cliente, p.id_pedido AS pedido, p.coste_total
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
ORDER BY p.coste_total DESC, p.id_pedido ASC;

-- 4) Listar pedidos realizados a partir del 1 de enero de 2024 (incluido), con nombre del cliente y fecha.
--    Columnas y alias:
--      - pedido        (p.id_pedido)
--      - cliente       (c.nombre)
--      - fecha_pedido  (p.fecha_pedido)
--    Orden: fecha_pedido ASC; en empate, pedido ASC.
SELECT '===== CONSULTA 4 =====' AS '';
SELECT p.id_pedido AS pedido, c.nombre AS cliente, p.fecha_pedido
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
WHERE p.fecha_pedido >= '2024-01-01 00:00:00'
ORDER BY p.fecha_pedido ASC, p.id_pedido ASC;

-- 5) Listar pedidos cuyo estado sea 'cancelado' o 'pendiente', con cliente y coste_total.
--    Columnas y alias:
--      - pedido       (p.id_pedido)
--      - cliente      (c.nombre)
--      - estado       (p.estado)
--      - coste_total  (p.coste_total)
--    Orden: estado ASC (cancelado < pendiente por orden alfabético), y dentro de cada estado coste_total DESC.
SELECT '===== CONSULTA 5 =====' AS '';
SELECT p.id_pedido AS pedido, c.nombre AS cliente, p.estado, p.coste_total
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
WHERE p.estado IN ('cancelado', 'pendiente')
ORDER BY p.estado ASC, p.coste_total DESC;

-- 6) Listar pagos con su pedido y cliente, mostrando el método de pago.
--    Columnas y alias:
--      - pedido       (p.id_pedido)
--      - cliente      (c.nombre)
--      - metodo_pago  (pa.metodo_pago)
--    Importante: solo pedidos con al menos un pago (INNER JOIN).
--    Orden: pedido ASC.
SELECT '===== CONSULTA 6 =====' AS '';
SELECT p.id_pedido AS pedido, c.nombre AS cliente, pa.metodo_pago
FROM pagos pa
JOIN pedidos p ON pa.id_pedido = p.id_pedido
JOIN clientes c ON p.id_cliente = c.id_cliente
ORDER BY p.id_pedido ASC;

-- 7) Listar las líneas del pedido con id 10, incluyendo nombre del producto, cantidad y precio unitario.
--    Columnas y alias:
--      - producto         (pr.nombre)
--      - cantidad         (dp.cantidad)
--      - precio_unitario  (dp.precio_unitario)
--    Orden: producto ASC.
SELECT '===== CONSULTA 7 =====' AS '';
SELECT pr.nombre AS producto, dp.cantidad, dp.precio_unitario
FROM detalle_pedido dp
JOIN productos pr ON dp.id_producto = pr.id_producto
WHERE dp.id_pedido = 10
ORDER BY producto ASC;

-- 8) Listar pedidos con estado 'entregado' con nombre del cliente y fecha del pedido.
--    Columnas y alias:
--      - pedido        (p.id_pedido)
--      - cliente       (c.nombre)
--      - fecha_pedido  (p.fecha_pedido)
--    Orden: fecha_pedido ASC; en empate, pedido ASC.
SELECT '===== CONSULTA 8 =====' AS '';
SELECT p.id_pedido AS pedido, c.nombre AS cliente, p.fecha_pedido
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
WHERE p.estado = 'entregado'
ORDER BY p.fecha_pedido ASC, p.id_pedido ASC;

-- 9) Calcular la suma total pagada por cada pedido que tenga al menos un pago.
--    Columnas y alias:
--      - pedido        (p.id_pedido)
--      - total_pagado  (SUM(pa.total_pagado))
--    Agrupación: por p.id_pedido exclusivamente.
--    Orden: total_pagado DESC; en empate, pedido ASC.
SELECT '===== CONSULTA 9 =====' AS '';
SELECT p.id_pedido AS pedido, SUM(pa.total_pagado) AS total_pagado
FROM pedidos p
JOIN pagos pa ON p.id_pedido = pa.id_pedido
GROUP BY p.id_pedido
ORDER BY total_pagado DESC, pedido ASC;

-- 10) Contar el número de pedidos realizados por cada cliente.
--     Columnas y alias:
--       - cliente        (c.nombre)
--       - total_pedidos  (COUNT(p.id_pedido))
--     Agrupación: por c.id_cliente y c.nombre (ambos campos, para evitar ambigüedad).
--     Orden: total_pedidos DESC; en empate, cliente ASC.
SELECT '===== CONSULTA 10 =====' AS '';
SELECT c.nombre AS cliente, COUNT(p.id_pedido) AS total_pedidos
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre
ORDER BY total_pedidos DESC, cliente ASC;

-- 11) Listar los clientes que poseen MÁS DE 3 pedidos (estrictamente > 3).
--     Columnas y alias:
--       - cliente        (c.nombre)
--       - total_pedidos  (COUNT(p.id_pedido))
--     Agrupación: por c.id_cliente y c.nombre.
--     Orden: total_pedidos DESC; en empate, cliente ASC.
SELECT '===== CONSULTA 11 =====' AS '';
SELECT c.nombre AS cliente, COUNT(p.id_pedido) AS total_pedidos
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre
HAVING COUNT(p.id_pedido) > 3
ORDER BY total_pedidos DESC, cliente ASC;

-- 12) Calcular los ingresos totales por cada producto (cantidad * precio_unitario) considerando SOLO líneas existentes.
--     Columnas y alias:
--       - producto  (pr.nombre)
--       - ingresos  (SUM(dp.cantidad * dp.precio_unitario))
--     Agrupación: por pr.id_producto y pr.nombre.
--     Orden: ingresos DESC; en empate, producto ASC.
SELECT '===== CONSULTA 12 =====' AS '';
SELECT pr.nombre AS producto,
       SUM(dp.cantidad * dp.precio_unitario) AS ingresos
FROM productos pr
JOIN detalle_pedido dp ON pr.id_producto = dp.id_producto
GROUP BY pr.id_producto, pr.nombre
ORDER BY ingresos DESC, producto ASC;

-- 13) Listar los productos cuyo ingreso total (cantidad * precio_unitario) sea superior a 10.000,00 euros.
--     Columnas y alias:
--       - producto  (pr.nombre)
--       - ingresos  (SUM(dp.cantidad * dp.precio_unitario))
--     Agrupación: por pr.id_producto y pr.nombre.
--     Orden: ingresos DESC; en empate, producto ASC.
SELECT '===== CONSULTA 13 =====' AS '';
SELECT pr.nombre AS producto,
       SUM(dp.cantidad * dp.precio_unitario) AS ingresos
FROM productos pr
JOIN detalle_pedido dp ON pr.id_producto = dp.id_producto
GROUP BY pr.id_producto, pr.nombre
HAVING SUM(dp.cantidad * dp.precio_unitario) > 10000
ORDER BY ingresos DESC, producto ASC;

-- 14) Listar los pedidos cuyo estado sea 'entregado' O 'enviado' y cuyo cliente tenga país 'España' O 'México'.
--     Columnas y alias:
--       - pedido   (p.id_pedido)
--       - cliente  (c.nombre)
--       - pais     (c.pais)
--       - estado   (p.estado)
--     Orden: pais ASC, luego estado ASC y finalmente pedido ASC.
SELECT '===== CONSULTA 14 =====' AS '';
SELECT p.id_pedido AS pedido, c.nombre AS cliente, c.pais, p.estado
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
WHERE p.estado IN ('entregado', 'enviado')
  AND c.pais IN ('España', 'México')
ORDER BY c.pais ASC, p.estado ASC, p.id_pedido ASC;

-- 15) Listar productos con precio_unitario > 200 en líneas pertenecientes a pedidos CANCELADOS.
--     Columnas y alias (sin duplicados en misma consulta):
--       - producto        (pr.nombre)
--       - precio_unitario (dp.precio_unitario)
--       - estado          (p.estado)
--     Selección DISTINCT para evitar filas repetidas por combinaciones idénticas.
--     Orden: precio_unitario DESC; en empate, producto ASC.
SELECT '===== CONSULTA 15 =====' AS '';
SELECT DISTINCT pr.nombre AS producto, dp.precio_unitario, p.estado
FROM detalle_pedido dp
JOIN productos pr ON dp.id_producto = pr.id_producto
JOIN pedidos p ON dp.id_pedido = p.id_pedido
WHERE dp.precio_unitario > 200
  AND p.estado = 'cancelado'
ORDER BY dp.precio_unitario DESC, producto ASC;

-- 16) Listar clientes registrados en 2024 que tengan al menos un pedido en estado 'pendiente' O 'enviado' (no entregado ni cancelado).
--     Columnas y alias (sin duplicados por cliente-estado):
--       - cliente        (c.nombre)
--       - fecha_registro (c.fecha_registro)
--       - estado         (p.estado)
--     DISTINCT para evitar múltiples filas idénticas por mismo cliente y estado.
--     Orden: cliente ASC, y en empate por estado ASC.
SELECT '===== CONSULTA 16 =====' AS '';
SELECT DISTINCT c.nombre AS cliente, c.fecha_registro, p.estado
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE YEAR(c.fecha_registro) = 2024
  AND p.estado IN ('pendiente', 'enviado')
ORDER BY c.nombre ASC, p.estado ASC;
