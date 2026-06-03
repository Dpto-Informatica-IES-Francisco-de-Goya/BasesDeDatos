-- Recuperación Ordinaria RA2 DAM/DAW - Creación de BBDD
-- Base de datos: clinica_vet

DROP DATABASE IF EXISTS clinica_vet;
CREATE DATABASE clinica_vet CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE clinica_vet;


/** Rúbrica:
 * PKs -> 0.5/0.5
 * FKs -> 0.5/1
 * Reflexiva -> 0.25/0.5
 * Uniques -> 0.5/0.5
 * Not null -> 0.15/0.25
 * Tipos de dato int -> 0/0.5
 * Tablas y columnas -> 0.750.75
 * Nombre constraints -> 0.5/0.5
 * Set -> 0/0.25
 * Enum -> 0.25/.25
 * Regex -> 0/0.5 
 * Check >= 0.5/0.5
 * Ejecuta o no -> 0/1
 * 
 * Nota: 3.45 / 7
 */ 


-- 1. Propietarios 
-- (Estimación: 50.000 -> SMALLINT)
CREATE TABLE propietarios (
    id_propietario SMALLINT UNSIGNED AUTO_INCREMENT,
    nombre         VARCHAR(100) NOT NULL,
    telefono       VARCHAR(15)  NOT NULL,
    email          VARCHAR(100),
    CONSTRAINT pk_propietarios PRIMARY KEY (id_propietario),
    CONSTRAINT uq_telefono     UNIQUE (telefono)
);

-- 2. Mascotas 
-- (Estimación: 150.000 -> MEDIUMINT)
CREATE TABLE mascotas (
    id_mascota       MEDIUMINT UNSIGNED AUTO_INCREMENT,
    nombre           VARCHAR(50) NOT NULL,
    especie          ENUM('PERRO', 'GATO', 'CONEJO', 'AVE') NOT NULL,
    fecha_nacimiento DATE,
    id_propietario   SMALLINT UNSIGNED NOT NULL,
    CONSTRAINT pk_mascotas             PRIMARY KEY (id_mascota),
    CONSTRAINT fk_mascota_propietario  FOREIGN KEY (id_propietario)
        REFERENCES propietarios(id_propietario) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 3. Veterinarios 
-- (Estimación: 100 -> TINYINT)
CREATE TABLE veterinarios (
    id_veterinario TINYINT UNSIGNED AUTO_INCREMENT,
    nombre         VARCHAR(100) NOT NULL,
    num_colegiado  CHAR(8)  NOT NULL,
    especialidad   ENUM('GENERAL', 'CIRUGIA', 'DERMATOLOGIA', 'ODONTOLOGIA') DEFAULT 'GENERAL',
    responsable TINYINT UNSIGNED,
    CONSTRAINT pk_veterinarios    PRIMARY KEY (id_veterinario),
    CONSTRAINT fk_jefe_veterinarios FOREIGN KEY (responsable) REFERENCES veterinarios(id_veterinario) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_num_colegiado   UNIQUE (num_colegiado),
    CONSTRAINT chk_num_colegiado  CHECK (num_colegiado REGEXP '^[A-Z]{2}-[0-9]{5}$') -- 
);

-- 4. Consultas 
-- (Estimación: 10.000.000 -> FKs deben coincidir)
CREATE TABLE consultas (
    id_mascota     MEDIUMINT UNSIGNED NOT NULL,
    id_veterinario TINYINT UNSIGNED   NOT NULL,
    fecha_consulta DATE NOT NULL,
    motivo         VARCHAR(255)       NOT NULL,
    precio         DECIMAL(6,2),
    CONSTRAINT pk_consultas              PRIMARY KEY (id_mascota, id_veterinario, fecha_consulta),
    CONSTRAINT fk_consulta_mascota       FOREIGN KEY (id_mascota)
        REFERENCES mascotas(id_mascota) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_consulta_veterinario   FOREIGN KEY (id_veterinario)
        REFERENCES veterinarios(id_veterinario) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_precio                CHECK (precio >= 0)
);

-- Tarea 1 
CREATE VIEW v_historial AS
    SELECT  p.nombre  AS propietario,
            m.nombre  AS mascota,
            v.nombre  AS veterinario,
            c.fecha_consulta,
            c.precio
    FROM consultas c
    JOIN mascotas     m ON c.id_mascota     = m.id_mascota
    JOIN propietarios p ON m.id_propietario = p.id_propietario
    JOIN veterinarios v ON c.id_veterinario = v.id_veterinario;

-- Tarea 2 
CREATE USER IF NOT EXISTS 'recepcion'@'localhost' IDENTIFIED BY 'Clinica2026';
GRANT SELECT ON clinica_vet.v_historial TO 'recepcion'@'localhost';
GRANT INSERT ON clinica_vet.consultas   TO 'recepcion'@'localhost';
FLUSH PRIVILEGES;

