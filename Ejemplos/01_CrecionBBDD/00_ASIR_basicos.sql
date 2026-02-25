-- CREAR UNA BASE DE DATOS

DROP DATABASE IF EXISTS discosEjercicio5Relacional;
CREATE DATABASE discosEjercicio5Relacional;
USE discosEjercicio5Relacional;

CREATE TABLE compositor (
	-- nombre tipo restricciones  ,
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    -- nombre VARCHAR(40) UNIQUE NOT NULL,
    -- nombre VARCHAR(40) NOT NULL,
    nombre VARCHAR(40),
    año_nacimiento DECIMAL(5,0),
    nacionalidad VARCHAR(4), -- CÓDIGO DE PAIS: ES,FR,IT...
    -- PRIMARY KEY(id) -- sin coma
    
    -- LISTADO DE RESTRICCIONES
    CONSTRAINT notnull_name CHECK (nombre IS NOT NULL),    
    CONSTRAINT uq_nombre UNIQUE (nombre),
    CONSTRAINT pk_compositor PRIMARY KEY (id)
);

CREATE TABLE obra(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    titulo VARCHAR(50) NOT NULL,
    tipo VARCHAR(50) ,
    tonalidad ENUM('DoMayor','Domenor','Do#Mayor','Do#menor',
    'ReMayor','ReMenor','Re#Mayor'), -- y me aburro, pero hay que terminarlo.
    modo VARCHAR(50),
    id_compositor TINYINT UNSIGNED,
    CONSTRAINT pk_obra PRIMARY KEY(id),
    -- PRIMARY KEY(id),
    CONSTRAINT fk_obra_compositor FOREIGN KEY (id_compositor)
		REFERENCES compositor(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

ALTER TABLE obra ADD CONSTRAINT chk_tipo_notnull CHECK (tipo IS NOT NULL);

CREATE TABLE director (
	-- nombre tipo restricciones  ,
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(40) UNIQUE NOT NULL,
    año_nacimiento DECIMAL(5,0),
    nacionalidad VARCHAR(4), -- CÓDIGO DE PAIS: ES,FR,IT...
    -- PRIMARY KEY(id) -- sin coma
    CONSTRAINT pk_compositor PRIMARY KEY (id)
);

CREATE TABLE interprete (
	-- nombre tipo restricciones  ,
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(40) UNIQUE NOT NULL,
    tipo VARCHAR(40),
    nacionalidad VARCHAR(4), -- CÓDIGO DE PAIS: ES,FR,IT...
    -- PRIMARY KEY(id) -- sin coma
    CONSTRAINT pk_compositor PRIMARY KEY (id)
);


CREATE TABLE version(
	id_version TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_obra TINYINT UNSIGNED NOT NULL,
    id_director TINYINT UNSIGNED,
    id_interprete TINYINT UNSIGNED NOT NULL,
    CONSTRAINT pk_version PRIMARY KEY (id_version),
	CONSTRAINT fk_version_obra FOREIGN KEY (id_obra)
		REFERENCES obra(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_version_director FOREIGN KEY (id_director)
		REFERENCES director(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_version_interprete FOREIGN KEY (id_interprete)
		REFERENCES interprete(id) ON DELETE RESTRICT ON UPDATE CASCADE   
);





