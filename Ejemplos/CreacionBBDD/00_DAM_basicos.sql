-- Script de creación del ejercicio 5 de obras musicales
-- Construimos a partir del modelo relacional.

CREATE DATABASE obras_musicales;
USE obras_musicales;
CREATE TABLE obras(
	titulo VARCHAR(50) NOT NULL, -- ojo, que no estaba bien el relacional.
	tipo VARCHAR(25),
    modo VARCHAR(25), -- probablemente sea un error pero necesitamos contexto que no tenemos
	tono ENUM('domayor','domenor','do#mayor','do#menor'), -- y así completas todas las demás
	compositor SMALLINT UNSIGNED,
    CONSTRAINT fk_obra_compositor FOREIGN KEY (compositor) -- campo de esta tabla
        REFERENCES compositor(compositor_id)
        ON DELETE RESTRICT ON UPDATE CASCADE -- Por defecto
);