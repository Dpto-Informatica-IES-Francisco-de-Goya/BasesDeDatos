-- Script de Inicialización: 00_backup_setup.sql
-- Objetivo: Crear un entorno con datos para practicar copias y transferencias.

DROP DATABASE IF EXISTS empresa_segura;
CREATE DATABASE empresa_segura;
USE empresa_segura;

-- Tabla de Empleados (Datos sensibles)
CREATE TABLE empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    departamento VARCHAR(50),
    salario DECIMAL(10, 2),
    fecha_contratacion DATE
);

-- Tabla de Logs de Acceso (Muchos registros, ideal para exportación)
CREATE TABLE logs_acceso (
    id INT AUTO_INCREMENT PRIMARY KEY,
    empleado_id INT,
    fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    ip_origen VARCHAR(45),
    accion VARCHAR(255),
    FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);

-- Insertar datos de prueba
INSERT INTO empleados (nombre, email, departamento, salario, fecha_contratacion) VALUES
('Ana García', 'ana.garcia@empresa.es', 'IT', 35000.00, '2023-01-15'),
('Carlos López', 'carlos.lopez@empresa.es', 'RRHH', 28000.00, '2022-06-10'),
('Elena Sanz', 'elena.sanz@empresa.es', 'Ventas', 31000.00, '2023-03-20'),
('David Vera', 'david.vera@empresa.es', 'IT', 33000.00, '2021-11-05');

INSERT INTO logs_acceso (empleado_id, ip_origen, accion) VALUES
(1, '192.168.1.50', 'Login exitoso'),
(2, '192.168.1.62', 'Consulta nómina'),
(1, '192.168.1.50', 'Backup manual iniciado'),
(3, '10.0.0.5', 'Cambio de contraseña');
