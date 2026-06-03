-- Recuperación Ordinaria RA3 ASIR - Diseño Físico
-- Base de datos: clinica_vet

DROP DATABASE IF EXISTS clinica_vet;
CREATE DATABASE clinica_vet;
USE clinica_vet;

-- El orden de creación es crítico: primero las tablas sin dependencias (propietarios, veterinarios),
-- luego las que referencian a otras (mascotas → propietarios, consultas → mascotas y veterinarios).

-- 1. Propietarios [RA3-CE.b, CE.c] (Estimación: 50.000 -> SMALLINT)
CREATE TABLE propietarios (
    id_propietario SMALLINT UNSIGNED AUTO_INCREMENT,
    nombre         VARCHAR(100) NOT NULL,
    telefono       VARCHAR(15)  NOT NULL,
    email          VARCHAR(100),
    CONSTRAINT pk_propietarios PRIMARY KEY (id_propietario),
    CONSTRAINT uq_telefono     UNIQUE (telefono)
);

-- 2. Mascotas [RA3-CE.b, CE.d, CE.h] (Estimación: 150.000 -> MEDIUMINT)
CREATE TABLE mascotas (
    id_mascota       MEDIUMINT UNSIGNED AUTO_INCREMENT,
    nombre           VARCHAR(50) NOT NULL,
    especie          ENUM('PERRO', 'GATO', 'CONEJO', 'AVE') NOT NULL,
    fecha_nacimiento DATE,
    id_propietario   SMALLINT UNSIGNED NOT NULL,
    CONSTRAINT pk_mascotas          PRIMARY KEY (id_mascota),
    CONSTRAINT fk_mascota_propietario FOREIGN KEY (id_propietario)
        REFERENCES propietarios(id_propietario)
);

-- 3. Veterinarios [RA3-CE.b, CE.c, CE.h] (Estimación: 100 -> TINYINT)
CREATE TABLE veterinarios (
    id_veterinario TINYINT UNSIGNED AUTO_INCREMENT,
    nombre         VARCHAR(100) NOT NULL,
    num_colegiado  VARCHAR(10)  NOT NULL,
    especialidad   ENUM('GENERAL', 'CIRUGIA', 'DERMATOLOGIA', 'ODONTOLOGIA') DEFAULT 'GENERAL',
    CONSTRAINT pk_veterinarios    PRIMARY KEY (id_veterinario),
    CONSTRAINT uq_num_colegiado   UNIQUE (num_colegiado),
    CONSTRAINT chk_num_colegiado  CHECK (num_colegiado REGEXP '^[A-Z]{2}-[0-9]{5}$') -- [RA3-CE.e]
);

-- 4. Consultas [RA3-CE.b, CE.d, CE.e] (Estimación: 10.000.000 -> FKs deben coincidir)
CREATE TABLE consultas (
    id_mascota      MEDIUMINT UNSIGNED NOT NULL,
    id_veterinario  TINYINT UNSIGNED   NOT NULL,
    fecha_consulta  DATE NOT NULL,
    motivo          VARCHAR(255)       NOT NULL,
    precio          DECIMAL(6,2),
    CONSTRAINT pk_consultas          PRIMARY KEY (id_mascota, id_veterinario, fecha_consulta),
    CONSTRAINT fk_consulta_mascota   FOREIGN KEY (id_mascota)
        REFERENCES mascotas(id_mascota) ON DELETE CASCADE,
    CONSTRAINT fk_consulta_veterinario FOREIGN KEY (id_veterinario)
        REFERENCES veterinarios(id_veterinario) ON DELETE CASCADE,
    CONSTRAINT chk_precio            CHECK (precio >= 0)
);

-- Tarea 1 [RA3-CE.h]: Añadir columna observaciones a mascotas
ALTER TABLE mascotas ADD COLUMN observaciones TEXT;

-- Tarea 2 [RA3-CE.f]: Inserts de prueba para verificar restricciones y FKs
INSERT INTO propietarios (nombre, telefono, email)
    VALUES ('Ana García', '600123456', 'ana@correo.es');

INSERT INTO veterinarios (nombre, num_colegiado, especialidad)
    VALUES ('Dr. Pérez', 'CV-00001', 'GENERAL');

INSERT INTO mascotas (nombre, especie, fecha_nacimiento, id_propietario)
    VALUES ('Toby', 'PERRO', '2020-03-15', 1);

INSERT INTO consultas (id_mascota, id_veterinario, fecha_consulta, motivo, precio)
    VALUES (1, 1, '2026-05-10', 'Revisión anual', 45.00);

-- Tarea 3 [RA3-CE.i]:
-- El orden de creación importa porque las claves ajenas exigen que la tabla referenciada
-- exista antes de crearla. No podemos crear 'mascotas' antes que 'propietarios',
-- ni 'consultas' antes que 'mascotas' y 'veterinarios'.
-- Del mismo modo, para el borrado (DROP) hay que invertir el orden.
