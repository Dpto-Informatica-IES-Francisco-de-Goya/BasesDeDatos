DROP DATABASE IF EXISTS gha_analytics;
CREATE DATABASE gha_analytics CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE gha_analytics;

-- 1. Tabla de Pacientes (Crítica: NIFs sucios, muchos NULLs)
CREATE TABLE pacientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nif VARCHAR(50),
    nombre_completo VARCHAR(200),
    email VARCHAR(150),
    tel_contacto VARCHAR(50),
    f_nacimiento VARCHAR(50),
    num_poliza VARCHAR(50) -- Muchos NULLs para pacientes sin seguro
) ENGINE=InnoDB;

-- 2. Tabla de Médicos (Códigos de colegiado con formatos inconsistentes)
CREATE TABLE medicos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    num_colegiado VARCHAR(50),
    nombre VARCHAR(150),
    especialidad_id INT
) ENGINE=InnoDB;

-- 3. Especialidades
CREATE TABLE especialidades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50)
) ENGINE=InnoDB;

-- 4. Visitas Médicas (Fechas VARCHAR, Costes sucios)
CREATE TABLE visitas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT,
    medico_id INT,
    fecha_visita VARCHAR(100),
    importe_sucio VARCHAR(50),
    descuento_aplicado VARCHAR(20), -- Muchos NULLs
    observaciones TEXT
) ENGINE=InnoDB;

-- 5. Tabla de Staging (Volcado masivo de CSV externo)
CREATE TABLE raw_import_visitas (
    ext_id INT,
    raw_data TEXT, -- Formato: "NIF|Nombre|FechaVisita|Coste"
    raw_phone VARCHAR(50)
);

-- ==========================================
-- CARGA DE DATOS "RADIOACTIVOS"
-- ==========================================

INSERT INTO especialidades (nombre) VALUES ('Medicina General'), ('Pediatría'), ('Cardiología'), ('Traumatología');

INSERT INTO pacientes (nif, nombre_completo, email, tel_contacto, f_nacimiento, num_poliza) VALUES
('12345678A', 'Juan Carlos Ibañez', 'jc.ibanez@mail.com', '+34 600 111 222', '12/05/1980', 'POL-9988'),
('87654321-B', 'Maria Lopez Sanz', 'm.lopez@gmail,con', '611-222-333', '1992.08.15', NULL), -- NIF guion, email coma/con, poliza null
(' 11223344C ', '  LUIS MARTINEZ  ', 'luis@test@es', '0034622444555', '01-01-1975', 'POL-1122'), -- Espacios, doble arroba
('12345678A', 'Juan Carlos Ibañez', 'jc.ibanez@mail.com', '600111222', '12/05/1980', 'POL-9988'), -- Duplicado exacto
('22334455D', 'Ana Ruiz Pardo', NULL, NULL, '20/10/2005', NULL), -- Casi todo NULL
('99999999Z', 'Paciente de Borrado', 'test@delete.com', '123', '2020-01-01', 'FAKE-000'),
('44556677X', 'Sonia  Valverde', 'sonia.v@outlook.com', '+34 655-999-000', '15/03/1988', 'POL-5566'),
('44556677X', 'Sonia Valverde', 'sonia.v@outlook.com', '655999000', '15/03/1988', 'POL-5566'), -- Duplicado con ligeras diferencias
('NULL_NIF', 'Error en Registro', NULL, '912334455', NULL, NULL);

INSERT INTO medicos (num_colegiado, nombre, especialidad_id) VALUES
('COL-28-1234', 'Dr. House', 1),
('28/5566', 'Dra. Quinn', 2),
('COL289900', 'Dr. Strange', 3),
('28-7788', 'Dr. Zivago', 1),
('INV-999', 'Medico Provisional', 99); -- Especialidad inexistente

INSERT INTO visitas (paciente_id, medico_id, fecha_visita, importe_sucio, descuento_aplicado, observaciones) VALUES
(1, 1, '12/03/2026 10:30', '150.50€', '10.00', 'Revisión anual'),
(2, 2, '2026.03.13 09:00', '$80.00', NULL, NULL), -- Importe $, descuento null
(3, 1, '14-03-2026 11:15', ' 120,00 ', '5.50', 'Dolor muscular'),
(1, 1, '12/03/2026 10:30', '150.50€', '10.00', NULL), -- Visita duplicada
(999, 1, '15/03/2026 12:00', '50.00', NULL, 'Paciente inexistente'),
(4, 888, '16/03/2026 13:00', '75.00', '0.00', 'Médico inexistente'),
(5, 3, '17/03/2026 10:00', 'Gratis', NULL, 'Campaña promoción'),
(1, 2, '18/03/2026 11:00', '200.00 EUR', '20.00', 'Urgencia');

INSERT INTO raw_import_visitas VALUES 
(1001, '12345678A|Juan Carlos|12/03/2026|150.50', '600111222'),
(1002, '44556677X|Sonia Valverde|15/03/2026|75.00', NULL),
(1003, '11223344C|LUIS MARTINEZ|2026-03-17|120,00 EUR', '622444555'),
(1004, '55667788Y|Roberto Gomez|18/03/2026|90.00$', '611000999'),
(1005, '99887766K|Elena Nito|2026.03.19| GRATIS ', NULL),
(1006, '12345678A|Juan Carlos|20/03/2026|200.00', '600111222'),
(1007, '87654321B|Maria Lopez|21-03-2026|110.00', '611222333');
