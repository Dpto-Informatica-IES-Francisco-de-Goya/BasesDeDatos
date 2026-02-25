-- CREAR UNA BASE DE DATOS

DROP DATABASE discosEjercicio5Relacional;
CREATE DATABASE discosEjercicio5Relacional;
USE discosEjercicio5Relacional;
-- DROP TABLE compositor;
CREATE TABLE compositor (
	-- nombre tipo restricciones  ,
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(40) UNIQUE NOT NULL,
    año_nacimiento DECIMAL(5,0),
    nacionalidad VARCHAR(4), -- CÓDIGO DE PAIS: ES,FR,IT...
    -- PRIMARY KEY(id) -- sin coma
    CONSTRAINT pk_compositor PRIMARY KEY (id)
);


CREATE TABLE obra(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    titulo VARCHAR(50) NOT NULL,
    tipo VARCHAR(50),
    tonalidad ENUM('DoMayor','Domenor','Do#Mayor','Do#menor','Re'), -- y me aburro, pero hay que terminarlo.
    modo VARCHAR(50),
    id_compositor TINYINT UNSIGNED,
    -- CONSTRAINT pk_obra PRIMARY KEY(id),
    PRIMARY KEY(id),
    CONSTRAINT fk_obra_compositor FOREIGN KEY (id_compositor)
		REFERENCES compositor(id) ON DELETE RESTRICT ON UPDATE CASCADE
);