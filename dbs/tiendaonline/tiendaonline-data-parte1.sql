USE tienda_online;
INSERT INTO clientes (nombre, email, fecha_registro, pais) VALUES
('Ana Torres', 'ana@example.com', '2023-01-10', 'España'),
('Luis Méndez', 'luis@example.com', '2023-02-15', 'México'),
('Carla Gómez', 'carla@example.com', '2023-03-20', 'Chile'),
('David Ruiz', 'david@example.com', '2023-04-05', 'Argentina'),
('Sofía Paredes', 'sofia@example.com', '2023-04-25', 'Perú');
INSERT INTO productos (nombre, descripcion, precio, stock, categoria) VALUES
('Laptop Dell Inspiron', 'Laptop 15" Intel i5', 750.00, 12, 'Electrónica'),
('Smartphone Xiaomi', 'Redmi Note 11 Pro', 320.00, 30, 'Electrónica'),
('Auriculares Bluetooth', 'Inalámbricos con micrófono', 25.00, 50, 'Accesorios'),
('Silla Gamer', 'Silla ergonómica con soporte lumbar', 180.00, 5, 'Muebles'),
('Escritorio', 'Escritorio de madera para oficina', 210.00, 7, 'Muebles');

INSERT INTO pedidos (id_cliente, fecha_pedido, estado, coste_total) VALUES
(1, '2023-04-01 10:00:00', 'entregado', 1070.00),
(2, '2023-04-03 15:30:00', 'enviado', 320.00),
(1, '2023-04-05 12:45:00', 'pendiente', 25.00),
(3, '2023-04-10 09:10:00', 'cancelado', 180.00),
(4, '2023-04-11 13:00:00', 'entregado', 210.00);


INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 1, 750.00),   -- Laptop
(1, 2, 1, 320.00),   -- Smartphone
(2, 2, 1, 320.00),   -- Smartphone
(3, 3, 1, 25.00),    -- Auriculares
(4, 4, 1, 180.00),   -- Silla Gamer
(5, 5, 1, 210.00);   -- Escritorio
INSERT INTO pagos (id_pedido, fecha_pago, metodo_pago, total_pagado) VALUES
(1, '2023-04-01 12:00:00', 'tarjeta', 1070.00),
(2, '2023-04-04 10:00:00', 'paypal', 320.00),
(3, NULL, 'tarjeta', 0.00), -- No pagado aún
(5, '2023-04-12 09:30:00', 'transferencia', 210.00);
