
# Tabla: Clientes
| id_cliente | nombre         | email             | fecha_registro | país     |
|------------|----------------|-------------------|----------------|----------|
| 1          | Ana Torres     | ana@example.com   | 2023-01-10     | España   |
| 2          | Luis Méndez    | luis@example.com  | 2023-02-15     | México   |
| 3          | Carla Gómez    | carla@example.com | 2023-03-20     | Chile    |
| 4          | David Ruiz     | david@example.com | 2023-04-05     | Argentina|
| 5          | Sofía Paredes  | sofia@example.com | 2023-04-25     | Perú     |

# Tabla: Pedidos

| id_pedido | id_cliente | fecha_pedido        | estado    | coste_total |
|-----------|------------|---------------------|-----------|-------------|
|         1 |          1 | 2023-04-01 10:00:00 | entregado |     1070.00 |
|         2 |          2 | 2023-04-03 15:30:00 | enviado   |      320.00 |
|         3 |          1 | 2023-04-05 12:45:00 | pendiente |       25.00 |
|         4 |          3 | 2023-04-10 09:10:00 | cancelado |      180.00 |
|         5 |          4 | 2023-04-11 13:00:00 | entregado |      210.00 |



# Tabla: Detalle Pedido

| id_detalle | id_pedido | id_producto | cantidad | precio_unitario |
|------------|-----------|-------------|----------|-----------------|
|          1 |         1 |           1 |        1 |          750.00 |
|          2 |         1 |           2 |        1 |          320.00 |
|          3 |         2 |           2 |        1 |          320.00 |
|          4 |         3 |           3 |        1 |           25.00 |
|          5 |         4 |           4 |        1 |          180.00 |
|          6 |         5 |           5 |        1 |          210.00 |

# Tabla: Productos

| id_producto | nombre                | descripcion                          | precio | stock | categoria    |
|-------------|-----------------------|--------------------------------------|--------|-------|--------------|
|           1 | Laptop Dell Inspiron  | Laptop 15" Intel i5                  | 750.00 |    12 | Electrónica  |
|           2 | Smartphone Xiaomi     | Redmi Note 11 Pro                    | 320.00 |    30 | Electrónica  |
|           3 | Auriculares Bluetooth | Inalámbricos con micrófono           |  25.00 |    50 | Accesorios   |
|           4 | Silla Gamer           | Silla ergonómica con soporte lumbar  | 180.00 |     5 | Muebles      |
|           5 | Escritorio            | Escritorio de madera para oficina    | 210.00 |     7 | Muebles      |



# Tabla: Pagos

| id_detalle | id_pedido | id_producto | cantidad | precio_unitario |
|------------|-----------|-------------|----------|-----------------|
|          1 |         1 |           1 |        1 |          750.00 |
|          2 |         1 |           2 |        1 |          320.00 |
|          3 |         2 |           2 |        1 |          320.00 |
|          4 |         3 |           3 |        1 |           25.00 |
|          5 |         4 |           4 |        1 |          180.00 |
|          6 |         5 |           5 |        1 |          210.00 |
