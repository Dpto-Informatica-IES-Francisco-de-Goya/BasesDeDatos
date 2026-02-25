-- Ejercicio 1: Auditoría de Sintaxis y Refactorización
/* Contexto: Un desarrollador junior ha entregado el siguiente 
script que funciona, pero incumple todos los estándares de buenas 
prácticas de administración de bases de datos.*/

CREATE DATABASE ejercicio1;

-- lo que existe
CREATE TABLE vehiculos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    matricula VARCHAR(10) UNIQUE,
    tipo VARCHAR(50),
    precio FLOAT, 
    fecha_compra TIMESTAMP
);

-- lo que tendría que ser
DROP TABLE vehiculos;
CREATE TABLE vehiculos (
    -- id SMALLINT UNSIGNED AUTO_INCREMENT, 
    id MEDIUMINT UNSIGNED AUTO_INCREMENT, 
    matricula VARCHAR(10) UNIQUE NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL, 
    fecha_compra DATE,
    CONSTRAINT pk_id PRIMARY KEY (id), -- ya incluye not null y unique.
    CONSTRAINT chk_matricula_alfanumerica CHECK (matricula REGEXP '^[A-Z0-9]{6,10}$'),
	CONSTRAINT chk_precio_no_negativo CHECK (precio >= 0)
    -- ^: Indica comienzo de la cadena.
    -- $: indica final de la cadena.
    -- [A-Z0-9]: indica los caracteres permitidos.
    -- {6,10}: indica la longitud.
);



