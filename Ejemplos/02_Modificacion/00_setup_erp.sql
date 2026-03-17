DROP DATABASE IF EXISTS erp_logistica;
CREATE DATABASE erp_logistica CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE erp_logistica;

CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(150),
    email VARCHAR(100),
    telefono VARCHAR(20),
    direccion VARCHAR(200) -- Nueva columna para NULLs
) ENGINE=InnoDB;

CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    precio_sucio VARCHAR(50),
    precio_oferta VARCHAR(50), -- Nueva columna para NULLs
    categoria_id INT
) ENGINE=InnoDB;

CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    fecha_texto VARCHAR(20),
    estado VARCHAR(20),
    notas_seguimiento TEXT -- Nueva columna para NULLs
) ENGINE=InnoDB;

CREATE TABLE logs_sistema (
    id INT AUTO_INCREMENT PRIMARY KEY,
    evento VARCHAR(255),
    fecha_log TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ==========================================
-- 0. LOGS INICIALES
-- ==========================================
INSERT INTO logs_sistema (evento) VALUES 
('Inicio de despliegue de base de datos'),
('Importación de datos heredados finalizada'),
('Error de conexión detectado (ignorar)'),
('Limpieza de caché manual iniciada');

-- ==========================================
-- 1. CATEGORÍAS
-- ==========================================
INSERT INTO categorias (nombre) VALUES 
('Electrónica'), 
('Hogar'), 
('Descatalogados'), 
('General'),
('Oficina'),
('Deportes');

-- ==========================================
-- 2. CLIENTES (Duplicados, espacios, correos mal, NULLs)
-- ==========================================
INSERT INTO clientes (nombre_completo, email, telefono, direccion) VALUES
('  Juan Perez  ', 'juan.perez@email.com', '+34 600-111-222', 'Calle Mayor 1'),
('Ana  Gomez', 'ana.gomez@email.con', '611 222 333', NULL),
('Luis Martinez  ', 'luis.m@email.com', '622-444-555', 'Avda Constitución 5'),
('Luis Martinez', 'luis.m@email.com', '622444555', NULL), -- Duplicado
('Luis Martinez', 'luis.m@email.com', '622444555', 'Avda Constitución 5'), -- Triplicado
('Maria Garcia', 'maria.g@gmail,com', '912-333-444', NULL),
('Carlos Ruiz', 'carlos@ruiz@test.es', '0034600777888', 'Plaza España 10'),
('Sonia Montero ', 'sonia.m@outlook.con', '  655999000', NULL),
('Pedro Picapiedra', 'pedro@roca.local', '12345', 'Cueva 1'),
('Cliente Ficticio', 'ficticio@borrar.es', '000000000', 'Dirección de Borrado'),
('Empresa Logistica S.A.', 'contacto@logistica.com.es', '+34 918 88 77 66', NULL),
('  Admin de Pruebas  ', 'admin@erp.local', '999-999-999', 'Sede Central'),
('Sin Datos', NULL, NULL, NULL); -- Registro casi vacío

-- ==========================================
-- 3. PRODUCTOS (Monedas, comas, categorías inexistentes, NULLs)
-- ==========================================
INSERT INTO productos (nombre, precio_sucio, precio_oferta, categoria_id) VALUES
('Portátil Pro', '1200.50€', '1100.00', 1),
('Ratón Óptico', '$15.00', NULL, 1),
('Lámpara Led', ' 25.00 € ', '20.00', 2),
('Silla Ergonomica', '150,00', NULL, 99), 
('Producto Obsoleto', '10.00€', '5.00', 3),
('Monitor 4K', '350.99 EUR', NULL, 1),
('Mesa Escritorio', '89,95 $', '75.00', 5),
('Teclado Mecánico', ' 120.00 ', NULL, 1),
('Cinta de Correr', '450,00 €', '400.00', 6),
('Balón Futbol', '19.99', NULL, 6),
('Cafetera Capsulas', ' 59,00€', '45.00', 2),
('Router WiFi 6', ' 75.50$', NULL, 1),
('Smartphone X', '899.00€', '850.00', 1),
('Cargador USB-C', '12,50', NULL, 999), 
('Articulo Raro', 'Gratis', NULL, 4); 

-- ==========================================
-- 4. PEDIDOS (Fechas locas, estados mezclados, clientes inexistentes, NULLs)
-- ==========================================
INSERT INTO pedidos (cliente_id, fecha_texto, estado, notas_seguimiento) VALUES
(1, '31/12/2022', 'completado', 'Entregado en mano'),
(2, '15-01-2023', 'Pendiente', NULL),
(3, '2023.03.10', 'ENVIADO', 'En tránsito'),
(1, '31/12/2022', 'completado', NULL), -- Pedido duplicado
(1, '31/12/2022', 'completado', 'Duplicado corregido'), -- Pedido triplicado
(999, '01/05/2023', 'pendiente', NULL), -- Cliente inexistente
(4, '20/06/2023', 'enviado', 'Urgente'),
(5, '2023-07-15', 'CANCELADO', NULL),
(6, '12/08/2023', 'pendiente', 'Pendiente de stock'),
(7, '01-09-2023', 'Enviado', NULL),
(8, '2023.10.20', 'completado', 'Sin incidencias'),
(1, '05/11/2023', 'PENDIENTE', NULL),
(8888, '25/12/2023', 'nuevo', 'Regalo de navidad'), -- Cliente inexistente
(2, '01/01/2024', 'PROCESANDO', NULL),
(11, '15/02/2024', 'enviado', 'Segunda entrega');
