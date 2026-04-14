-- =============================================================================
-- 00_setup.sql
-- Script de configuración del entorno de pruebas para Transacciones
-- =============================================================================

DROP DATABASE IF EXISTS fp_transacciones;
CREATE DATABASE fp_transacciones;
USE fp_transacciones;

-- -----------------------------------------------------------------------------
-- 1. Limpieza de tablas (Orden respetando restricciones de integridad)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS auditoria_precios;
DROP TABLE IF EXISTS historial_conexiones;
DROP TABLE IF EXISTS factura_detalle;
DROP TABLE IF EXISTS facturas;
DROP TABLE IF EXISTS empleados;
DROP TABLE IF EXISTS departamentos;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS almacen;
DROP TABLE IF EXISTS alumnos;
DROP TABLE IF EXISTS modulos;
DROP TABLE IF EXISTS usuarios;

-- -----------------------------------------------------------------------------
-- 2. Creación de Tablas Maestras y Entidades
-- -----------------------------------------------------------------------------

CREATE TABLE alumnos (
    id     INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'Activo',
    nota   DECIMAL(4,2),
    CONSTRAINT chk_nota CHECK (nota BETWEEN 0 AND 10)
);

CREATE TABLE almacen (
    id       INT PRIMARY KEY,
    producto VARCHAR(50) NOT NULL UNIQUE,
    stock    INT NOT NULL DEFAULT 0,
    CONSTRAINT chk_stock_positivo CHECK (stock >= 0)
);

CREATE TABLE pedidos (
    id     INT PRIMARY KEY,
    estado VARCHAR(20) NOT NULL DEFAULT 'Pendiente'
);

CREATE TABLE departamentos (
    id     INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE usuarios (
    id     INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE modulos (
    codigo VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- -----------------------------------------------------------------------------
-- 3. Creación de Tablas con Claves Foráneas y Detalles
-- -----------------------------------------------------------------------------

CREATE TABLE empleados (
    id              INT PRIMARY KEY,
    nombre          VARCHAR(50) NOT NULL,
    salario         DECIMAL(8,2) NOT NULL,
    departamento_id INT NOT NULL,
    CONSTRAINT fk_empleado_departamento 
        FOREIGN KEY (departamento_id) REFERENCES departamentos(id),
    CONSTRAINT chk_salario_positivo 
        CHECK (salario > 0)
);

CREATE TABLE facturas (
    id     INT AUTO_INCREMENT PRIMARY KEY,
    fecha  DATE NOT NULL,
    pagado BOOLEAN NOT NULL DEFAULT 0
);

CREATE TABLE factura_detalle (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    factura_id INT NOT NULL,
    producto   VARCHAR(50) NOT NULL,
    CONSTRAINT fk_detalle_factura 
        FOREIGN KEY (factura_id) REFERENCES facturas(id)
);

CREATE TABLE historial_conexiones (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    CONSTRAINT fk_historial_usuario 
        FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE auditoria_precios (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    fecha       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    accion      VARCHAR(100) NOT NULL,
    CONSTRAINT fk_auditoria_producto 
        FOREIGN KEY (producto_id) REFERENCES almacen(id)
);

-- -----------------------------------------------------------------------------
-- 4. Inserción de Datos Iniciales
-- -----------------------------------------------------------------------------

INSERT INTO alumnos (nombre, estado, nota) 
VALUES 
    ('Ana', 'Activo', 8.5), 
    ('Luis', 'Inactivo', 4.0);

INSERT INTO almacen (id, producto, stock) 
VALUES 
    (1, 'Switch Cisco', 50), 
    (2, 'Router Mikrotik', 30);

INSERT INTO pedidos (id, estado) 
VALUES (1, 'Pendiente');

INSERT INTO departamentos (id, nombre) 
VALUES 
    (10, 'Contabilidad'), 
    (20, 'Sistemas');

INSERT INTO empleados (id, nombre, salario, departamento_id) 
VALUES 
    (1, 'Carlos', 2000, 10), 
    (2, 'Marta', 2200, 20);

INSERT INTO usuarios (id, nombre) 
VALUES (5, 'admin');

INSERT INTO historial_conexiones (usuario_id) 
VALUES (5), (5);
