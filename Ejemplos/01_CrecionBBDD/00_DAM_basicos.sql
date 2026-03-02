-- Script de creación del ejercicio 5 de obras musicales
-- Construimos a partir del modelo relacional.

DROP DATABASE IF EXISTS obras_musicales;
CREATE DATABASE obras_musicales;
USE obras_musicales;

-- DROP TABLE IF EXISTS compositor;
CREATE TABLE compositor (
    id_compositor SMALLINT UNSIGNED AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
	año_nacimiento SMALLINT,
    nacionalidad CHAR(4), -- Como código de pais: ES,FR,IT... ESTO ES UNA CHAPUZA.
    CONSTRAINT pk_compositor PRIMARY KEY (id_compositor)
);

CREATE TABLE director (
    id_director SMALLINT UNSIGNED AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL, 
    -- nombre VARCHAR(50) NOT NULL UNIQUE, 
    -- unique no está en el modelo relacional, pero hemos pensado que hay que ponerlo
    año_nacimiento SMALLINT,
    nacionalidad CHAR(4), -- Como código de pais: ES,FR,IT... ESTO ES UNA CHAPUZA.
    CONSTRAINT pk_director PRIMARY KEY (id_director),
    CONSTRAINT uq_director_nombre UNIQUE(nombre), -- También se puede poner así. De una forma o la otra.
    CONSTRAINT chk_nombre_not_null CHECK (nombre IS NOT NULL) 
);
CREATE TABLE interprete (
    id_interprete SMALLINT UNSIGNED AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    año_nacimiento SMALLINT,
    tipo VARCHAR(45), -- Como código de pais: ES,FR,IT... ESTO ES UNA CHAPUZA.
    CONSTRAINT pk_interprete PRIMARY KEY (id_interprete)
);

CREATE TABLE obra (
	id_obra SMALLINT UNSIGNED AUTO_INCREMENT,
	titulo VARCHAR(50) NOT NULL, -- ojo, que no estaba bien el relacional.
	tipo VARCHAR(25),
    modo VARCHAR(25), -- probablemente sea un error pero necesitamos contexto que no tenemos
	tono ENUM('domayor','domenor','do#mayor','do#menor'), -- y así completas todas las demás
	id_compositor SMALLINT UNSIGNED,
    CONSTRAINT pk_obra PRIMARY KEY (id_obra),
    CONSTRAINT fk_obra_compositor FOREIGN KEY (id_compositor) -- campo de esta tabla
        REFERENCES compositor(id_compositor)
        ON DELETE SET NULL ON UPDATE CASCADE -- SET NULL porque... 
);

CREATE TABLE version (
	id_version MEDIUMINT UNSIGNED AUTO_INCREMENT, -- Como lleva un constraint de PK, no hace falta indicar NOT NULL ni UNIQUE.
    id_obra  SMALLINT UNSIGNED NOT NULL,
    id_interprete  SMALLINT UNSIGNED NOT NULL,
    id_director  SMALLINT UNSIGNED,
    -- id_version  SMALLINT UNSIGNED -- ERROR DE DISEÑO
    CONSTRAINT pk_version PRIMARY KEY(id_version),
    CONSTRAINT fk_version_obra FOREIGN KEY (id_obra)
		REFERENCES obra(id_obra)
        ON DELETE RESTRICT ON UPDATE CASCADE, -- Por defecto. 
	CONSTRAINT fk_version_interprete FOREIGN KEY (id_interprete)
		REFERENCES interprete(id_interprete)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_version_director FOREIGN KEY (id_director)
		REFERENCES director(id_director) 
        -- Las dos opciones PUEDEN ser válidas dependiendo del contexto.
		ON DELETE RESTRICT ON UPDATE CASCADE
        -- ON DELETE SET NULL ON UPDATE CASCADE
);



-- POSIBILIDAD REAL, INCOMPATIBLE CON EL MODELO RELACIONAL.
-- Además, tiene un error de diseño. 
/*CREATE TABLE version (
    id_obra  SMALLINT UNSIGNED NOT NULL,
    id_interprete  SMALLINT UNSIGNED NOT NULL,
    id_director  SMALLINT UNSIGNED,
    -- id_version  SMALLINT UNSIGNED -- ERROR DE DISEÑO
    CONSTRAINT pk_version PRIMARY KEY(id_obra,id_interprete,id_director),
    CONSTRAINT fk_version_obra FOREIGN KEY (id_obra)
		REFERENCES obra(id_obra)
        ON DELETE RESTRICT ON UPDATE CASCADE, -- Por defecto. 
	CONSTRAINT fk_version_interprete FOREIGN KEY (id_interprete)
		REFERENCES interprete(id_interprete)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_version_director FOREIGN KEY (id_director)
		REFERENCES director(id_director) 
        -- Las dos opciones PUEDEN ser válidas dependiendo del contexto.
		ON DELETE RESTRICT ON UPDATE CASCADE
        -- ON DELETE SET NULL ON UPDATE CASCADE
);
*/