DROP DATABASE IF EXISTS Departamentos;

CREATE SCHEMA Departamentos;

USE Departamentos;

CREATE TABLE Departamento(
 Codigo VARCHAR(5) PRIMARY KEY,
 Presupuesto NUMERIC(10, 2) NOT NULL,
 Habitacion VARCHAR(3) NOT NULL
);


CREATE TABLE Ordenador(
 Id INT PRIMARY KEY AUTO_INCREMENT,
 Memoria INT NOT NULL,
 Procesador VARCHAR(20) NOT NULL,
 CodigoDepartamento VARCHAR(5) NOT NULL,
 CONSTRAINT fk_Ordenador_Departamento
 FOREIGN KEY (CodigoDepartamento)
 REFERENCES Departamento(Codigo)
 ON DELETE CASCADE 
 ON UPDATE CASCADE
);

CREATE TABLE Profesor(
 Dni CHAR(9) PRIMARY KEY,
 Nombre VARCHAR(29) NOT NULL,
 Categoria CHAR(2) NOT NULL,
 Antiguedad INT NOT NULL,
 CodigoDepartamento VARCHAR(5) NULL,
 CONSTRAINT fk_Profesor_Departamento
 FOREIGN KEY (CodigoDepartamento)
 REFERENCES Departamento(Codigo)
 ON DELETE CASCADE 
 ON UPDATE CASCADE 
);
