DROP DATABASE IF EXISTS obras_musicales; -- OJO BORRA LOS DATOS.
CREATE DATABASE obras_musicales;
USE obras_musicales;

CREATE TABLE compositor(
	id_compositor SMALLINT UNSIGNED AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    año_nacimiento SMALLINT,
    nacionalidad VARCHAR(50),
    CONSTRAINT pk_compositor PRIMARY KEY (id_compositor),
    CONSTRAINT uq_nombre UNIQUE (nombre),
    CONSTRAINT chk_nombre_not_null CHECK (nombre IS NOT NULL)
);

CREATE TABLE interprete(
	id_interprete SMALLINT UNSIGNED AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    año_nacimiento YEAR,
    tipo VARCHAR(50),
    CONSTRAINT pk_interprete PRIMARY KEY (id_interprete)
);

CREATE TABLE director(
	id_director SMALLINT UNSIGNED AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    año_nacimiento YEAR,
    nacionalidad VARCHAR(50),
    CONSTRAINT pk_director PRIMARY KEY (id_director)
);

-- forma "mala"
/*CREATE TABLE obra(
	id_obra SMALLINT UNSIGNED PRIMARY KEY,
	titulo VARCHAR(100),
    tipo VARCHAR(100),
    modo VARCHAR(100),
    tono ENUM ('domayor','domenor','do#mayor','y así sucesivamente'),
    compositor INT UNSIGNED FOREIGN KEY REFERENCES compositor(id_compositor)
);*/
-- forma "buena"
CREATE TABLE obra(
	id_obra SMALLINT UNSIGNED AUTO_INCREMENT,
	titulo VARCHAR(100) UNIQUE,
    tipo VARCHAR(100),
    modo VARCHAR(100),
    tono ENUM ('domayor','domenor','do#mayor','y así sucesivamente'),
    compositor SMALLINT UNSIGNED,
	-- CONSTRAINT nombre_de_la_restricción TIPO (atributo)
    CONSTRAINT pk_obra PRIMARY KEY (id_obra),
    CONSTRAINT fk_obra_compositor FOREIGN KEY (compositor)
		REFERENCES compositor(id_compositor)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE version(
	id_version MEDIUMINT UNSIGNED AUTO_INCREMENT, -- OJO SERÍA UN ERROR PONERLO COMO SMALLINT
    id_obra SMALLINT UNSIGNED NOT NULL,
    id_interprete SMALLINT UNSIGNED NOT NULL,
    id_director SMALLINT UNSIGNED,
    CONSTRAINT pk_version PRIMARY KEY (id_version),
    CONSTRAINT fk_version_obra FOREIGN KEY (id_obra)
		REFERENCES obra(id_obra) 
		ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_version_interprete FOREIGN KEY (id_interprete)
		REFERENCES interprete(id_interprete)
        ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_version_director FOREIGN KEY (id_director)
		REFERENCES director(id_director)
		ON DELETE RESTRICT ON UPDATE CASCADE
);

/*¿¿¿ CLAVES COMPUESTAS ??? */

-- El modelo relacion NO DICE ESTO. Solo incluyo este ejemplo 
-- para que veas como se declaran claves primarias compuestas.

/*CREATE TABLE version_con_clave_compuesta(
	id_obra SMALLINT UNSIGNED NOT NULL,
    id_interprete SMALLINT UNSIGNED NOT NULL,
    id_director SMALLINT UNSIGNED,
    CONSTRAINT pk_version PRIMARY KEY (id_obra,id_interprete,id_director),
    CONSTRAINT fk_version_obra FOREIGN KEY (id_obra)
		REFERENCES obra(id_obra) 
		ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_version_interprete FOREIGN KEY (id_interprete)
		REFERENCES interprete(id_interprete)
        ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_version_director FOREIGN KEY (id_director)
		REFERENCES director(id_director)
		ON DELETE RESTRICT ON UPDATE CASCADE
);*/

-- -- PARTE DE INSERCIÓN DE DATOS

INSERT INTO compositor
(`id_compositor`,
`nombre`,
`año_nacimiento`,
`nacionalidad`)
VALUES
(1,'Beethoven',1770,'Alemán');

select * from compositor;

-- tiene que fallar y falla.
INSERT INTO compositor
(`id_compositor`,
`año_nacimiento`,
`nacionalidad`)
VALUES
(1,1770,'Alemán');

INSERT INTO compositor
(`nombre`,
`año_nacimiento`,
`nacionalidad`)
VALUES
('Mozart',1756,'Alemán');

select * from compositor;
