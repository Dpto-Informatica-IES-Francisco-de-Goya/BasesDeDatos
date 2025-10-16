DROP DATABASE IF EXISTS ejemplos_tipos_join;
CREATE DATABASE ejemplos_tipos_join;
USE ejemplos_tipos_join;

-- Limpieza por si re-ejecutas
DROP TABLE IF EXISTS matriculas;
DROP TABLE IF EXISTS alumnos;
DROP TABLE IF EXISTS cursos;

-- Tablas sin FKs a propósito (queremos "huecos" para demostración)
CREATE TABLE alumnos (
  id_alumno INT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL
);

CREATE TABLE cursos (
  id_curso INT PRIMARY KEY,
  nombre_curso VARCHAR(50) NOT NULL
);

CREATE TABLE matriculas (
  id_matricula INT PRIMARY KEY,
  id_alumno INT,
  id_curso INT
);

-- Datos
INSERT INTO alumnos VALUES
(1,'Ana'),(2,'Bruno'),(3,'Cris'),(4,'Dani'),(5,'Eva');

INSERT INTO cursos VALUES
(101,'BBDD'),(102,'Programación'),(103,'Sistemas'),(104,'Redes');

INSERT INTO matriculas VALUES
(1001,1,101),
(1002,1,102),
(1003,3,101),
(1004,6,103),   -- alumno inexistente
(1005,4,105);   -- curso inexistente
