-- El script comienza borrando, si existe, la base de datos.
DROP DATABASE IF EXISTS city_zoo;
CREATE DATABASE city_zoo;
USE city_zoo;

-- =========================================================================
-- 1. TABLA: personal
-- =========================================================================
CREATE TABLE personal (
    id_empleado TINYINT UNSIGNED AUTO_INCREMENT,
    cod_interno CHAR(6) NOT NULL,
    puesto ENUM('VETERINARIO', 'CUIDADOR') NOT NULL,
    num_colegiado VARCHAR(100) DEFAULT NULL,
    zona VARCHAR(100) DEFAULT NULL,
    id_supervisor TINYINT UNSIGNED DEFAULT NULL,

    -- Restricciones de Clave
    CONSTRAINT pk_personal PRIMARY KEY (id_empleado),
    CONSTRAINT uq_personal_cod_interno UNIQUE (cod_interno),
    CONSTRAINT uq_personal_num_colegiado UNIQUE (num_colegiado),
    
    -- Validaciones de formato y negocio
    CONSTRAINT chk_personal_cod_formato CHECK (CHAR_LENGTH(cod_interno) = 6),
    -- Especialización encubierta
    CONSTRAINT chk_personal_especializacion CHECK (
        (puesto = 'VETERINARIO' AND num_colegiado IS NOT NULL AND zona IS NULL) OR 
        (puesto = 'CUIDADOR' AND zona IS NOT NULL AND num_colegiado IS NULL)
    )
);

-- Nota: La relación reflexiva (id_supervisor) se implementa al final con un ALTER TABLE.

-- =========================================================================
-- 2. TABLA: habitats
-- =========================================================================
CREATE TABLE habitats (
    id_habitat TINYINT UNSIGNED AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    clima ENUM('TROPICAL', 'ARIDO', 'POLAR', 'TEMPLADO') DEFAULT 'TEMPLADO',
    area_m2 INT UNSIGNED NOT NULL,

    -- Restricciones de Clave
    CONSTRAINT pk_habitats PRIMARY KEY (id_habitat),
    CONSTRAINT uq_habitats_nombre UNIQUE (nombre),
    
    -- Validaciones de formato y negocio
    CONSTRAINT chk_habitats_area CHECK (area_m2 > 50)
);

-- =========================================================================
-- 3. TABLA: animales
-- =========================================================================
CREATE TABLE animales (
    id_animal SMALLINT UNSIGNED AUTO_INCREMENT,
    chip VARCHAR(15) NOT NULL,
    alias VARCHAR(100) NOT NULL,
    -- Tipo SET para selección múltiple de características 
    etiquetas SET('PELIGROSO', 'NOCTURNO', 'CRIA', 'CUARENTENA'),
    id_habitat TINYINT UNSIGNED NOT NULL,

    -- Restricciones de Clave y Foráneas
    CONSTRAINT pk_animales PRIMARY KEY (id_animal),
    CONSTRAINT uq_animales_chip UNIQUE (chip),
    CONSTRAINT fk_animales_habitats FOREIGN KEY (id_habitat) 
        REFERENCES habitats(id_habitat) ON DELETE RESTRICT ON UPDATE CASCADE,
    
    -- Validaciones de formato y negocio
    CONSTRAINT chk_animales_chip_valido CHECK (CHAR_LENGTH(chip) = 15 AND chip REGEXP '^[0-9]{15}$')
);

-- =========================================================================
-- 4. TABLA: protocolos_medicos
-- =========================================================================
-- Tabla N:M que registra protocolos aplicados por veterinarios a animales
CREATE TABLE protocolos_medicos (
    id_empleado TINYINT UNSIGNED,
    id_animal SMALLINT UNSIGNED,
    fecha_aplicacion DATE NOT NULL,
    observaciones VARCHAR(100) DEFAULT NULL,

    -- Clave primaria compuesta para permitir atención en días distintos
    CONSTRAINT pk_protocolos_medicos PRIMARY KEY (id_empleado, id_animal, fecha_aplicacion),
    
    -- Restricciones Foráneas con ON DELETE CASCADE según requisitos 
    CONSTRAINT fk_protocolos_personal FOREIGN KEY (id_empleado) 
        REFERENCES personal(id_empleado) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_protocolos_animales FOREIGN KEY (id_animal) 
        REFERENCES animales(id_animal) ON DELETE CASCADE ON UPDATE CASCADE
        
);

-- =========================================================================
-- 5. ALTER TABLES (Relaciones Reflexivas)
-- =========================================================================
-- Implementación de la FK de la relación reflexiva
ALTER TABLE personal
ADD CONSTRAINT fk_personal_personal FOREIGN KEY (id_supervisor) 
    REFERENCES personal(id_empleado) ON DELETE RESTRICT ON UPDATE CASCADE;