-- Crear la base de datos
DROP DATABASE IF EXISTS Universidad;
CREATE DATABASE Universidad;

-- Usar la base de datos recién creada
USE Universidad;

-- Tabla de estudiantes
CREATE TABLE Estudiantes (
    dni VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(50),
    fecha_nacimiento DATE,
    carrera VARCHAR(50)
);

-- Tabla de profesores
CREATE TABLE Profesores (
    dni VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(50),
    especialidad VARCHAR(50)
);

-- Tabla de asignaturas
CREATE TABLE Asignaturas (
    id_asignatura INT PRIMARY KEY AUTO_INCREMENT,
    nombre_asignatura VARCHAR(50),
    dni_profesor VARCHAR(10),
    FOREIGN KEY (dni_profesor) REFERENCES Profesores(dni)
);

-- Tabla de inscripciones (relación entre estudiantes y asignaturas)
CREATE TABLE Inscripciones (
    id_inscripcion INT PRIMARY KEY AUTO_INCREMENT,
    dni_estudiante VARCHAR(10),
    id_asignatura INT,
    FOREIGN KEY (dni_estudiante) REFERENCES Estudiantes(dni),
    FOREIGN KEY (id_asignatura) REFERENCES Asignaturas(id_asignatura)
);

-- Tabla de calificaciones
CREATE TABLE Calificaciones (
    id_calificacion INT PRIMARY KEY AUTO_INCREMENT,
    id_inscripcion INT,
    nota DECIMAL(4,2),
    fecha_evaluacion DATE,
    FOREIGN KEY (id_inscripcion) REFERENCES Inscripciones(id_inscripcion)
);
