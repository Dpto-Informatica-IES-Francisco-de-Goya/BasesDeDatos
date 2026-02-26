
CREATE DATABASE obras_musicales;
USE obras_musicales;

CREATE TABLE compositor(
	id_compositor SMALLINT UNSIGNED,
    año_nacimiento YEAR,
    nacionalidad VARCHAR(50),
    CONSTRAINT pk_compositor PRIMARY KEY (id_compositor)
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
	id_obra SMALLINT UNSIGNED,
	titulo VARCHAR(100),
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