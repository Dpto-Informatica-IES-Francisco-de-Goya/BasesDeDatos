
# Tabla: Clientes
| id_cliente | nombre         | email             | fecha_registro | país     |
|------------|----------------|-------------------|----------------|----------|
| 1          | Ana Torres     | ana@example.com   | 2023-01-10     | España   |
| 2          | Luis Méndez    | luis@example.com  | 2023-02-15     | México   |
| 3          | Carla Gómez    | carla@example.com | 2023-03-20     | Chile    |
| 4          | David Ruiz     | david@example.com | 2023-04-05     | Argentina|
| 5          | Sofía Paredes  | sofia@example.com | 2023-04-25     | Perú     |



# Tabla: Productos
| id_producto | nombre                 | descripcion                      | precio | stock | categoria    |
|-------------|------------------------|----------------------------------|--------|-------|--------------|
| 1           | Laptop Dell Inspiron    | Laptop 15" Intel i5              | 750.00 | 12    | Electrónica  |
| 2           | Smartphone Xiaomi       | Redmi Note 11 Pro               | 320.00 | 30    | Electrónica  |
| 3           | Auriculares Bluetooth   | Inalámbricos con micrófono       | 25.00  | 50    | Accesorios   |
| 4           | Silla Gamer             | Silla ergonómica con soporte lumbar | 180.00 | 5     | Muebles      |
| 5           | Escritorio              | Escritorio de madera para oficina | 210.00 | 7     | Muebles      |



# Tabla: Pedidos
| id_pedido | id_cliente | fecha_pedido        | estado    | total  |
|-----------|------------|---------------------|-----------|--------|
| 101       | 1          | 2023-04-01 10:00:00 | entregado | 1070.00 |
| 102       | 2          | 2023-04-03 15:30:00 | enviado   | 320.00  |
| 103       | 3          | 2023-04-04 09:15:00 | pendiente | 250.00  |
| 104       | 4          | 2023-04-05 14:00:00 | cancelado | 180.00  |
| 105       | 5          | 2023-04-06 11:00:00 | enviado   | 420.00  |



# Tabla: Detalle Pedido
| id_detalle | id_pedido | id_producto | cantidad | precio |
|------------|-----------|-------------|----------|--------|
| 1          | 101       | 1           | 1        | 750.00 |
| 2          | 101       | 2           | 2        | 320.00 |
| 3          | 102       | 2           | 1        | 320.00 |
| 4          | 103       | 3           | 2        | 50.00  |
| 5          | 104       | 4           | 1        | 180.00 |



# Tabla: Pagos
| id_pago | id_pedido | fecha_pago        | metodo_pago | importe |
|---------|-----------|-------------------|-------------|---------|
| 1       | 101       | 2023-04-01 11:00:00 | tarjeta     | 750.00  |
| 2       | 102       | 2023-04-03 16:00:00 | PayPal      | 320.00  |
| 3       | 103       | 2023-04-04 10:00:00 | transferencia| 250.00  |
| 4       | 105       | 2023-04-06 12:00:00 | tarjeta     | 420.00  |
