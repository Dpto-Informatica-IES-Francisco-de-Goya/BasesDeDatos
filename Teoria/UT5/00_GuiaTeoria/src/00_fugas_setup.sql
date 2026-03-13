DROP DATABASE IF EXISTS FugaTech_Forensic;
CREATE DATABASE FugaTech_Forensic CHARACTER SET utf8mb4;
USE FugaTech_Forensic;

-- 1. Tabla de Producción (Clientes)
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100),
    telefono VARCHAR(50),
    credito DECIMAL(10,2) DEFAULT 0.00,
    activo BOOLEAN DEFAULT 1
);

-- 2. Tabla de Ventas (Para integridad referencial)
CREATE TABLE ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    fecha DATETIME DEFAULT NOW(),
    total DECIMAL(10,2),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id) ON DELETE RESTRICT
);

-- 3. Cuentas Bancarias (Para ejemplos de subconsultas)
CREATE TABLE cuentas_bancarias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    iban VARCHAR(34),
    fraude BOOLEAN DEFAULT 0,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);

-- 4. Catalogo e Importación (Para ejemplos de JOIN en UPDATE)
CREATE TABLE catalogo (
    referencia VARCHAR(50) PRIMARY KEY,
    nombre VARCHAR(100),
    precio DECIMAL(10,2),
    fecha_actualizacion DATETIME
);

CREATE TABLE importacion_tarifas (
    referencia VARCHAR(50) PRIMARY KEY,
    nuevo_precio DECIMAL(10,2)
);

-- 5. Tabla "Sucia" (Staging - Importación de Excel/CSV chapucero)
CREATE TABLE import_raw (
    raw_id INT,
    raw_data_str VARCHAR(255), -- Datos mezclados: "Nombre, Email"
    raw_phone VARCHAR(50)
);

-- 6. Logs (Para borrado masivo)
CREATE TABLE sys_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    msg TEXT,
    created_at DATETIME
);

-- --- INSERCIÓN DE DATOS "ROTOS" Y SUCIOS ---

INSERT INTO clientes (nombre, email, telefono, credito) VALUES
('Juan  Gomez', 'juan.gomez@empresa.local', '+34 600-111-222', 100.00),
('Maria Lopez', 'maria.lopez@gmail,com', '600 222 333', 50.50),
('Carlos Ruiz', 'carlos.ruiz@hotmail.com', '0034600333444', 0.00),
('Admin Sys', 'admin@fugatech.com', NULL, 9999.99);

INSERT INTO ventas (id_cliente, total) VALUES (1, 500.00), (2, 120.00);

INSERT INTO cuentas_bancarias (id_cliente, iban, fraude) VALUES (3, 'ES12345678', 1);

INSERT INTO catalogo VALUES ('REF-001', 'Switch Cisco', 200.00, '2020-01-01');
INSERT INTO importacion_tarifas VALUES ('REF-001', 250.00);

INSERT INTO import_raw VALUES 
(101, '  PEDRO MARTINEZ , pedro@mail.com', '+34 666-666-666'),
(102, 'Ana sanz, ana@test.com', '666777888');

INSERT INTO sys_logs (msg, created_at) VALUES 
('Error 404', '2020-01-01 10:00:00'),
('Login OK', '2021-05-05 12:00:00'),
('Warning', NOW());
