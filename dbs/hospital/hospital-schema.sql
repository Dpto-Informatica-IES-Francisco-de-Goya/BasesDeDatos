-- Crear la base de datos del hospital
DROP DATABASE Hospital;
CREATE DATABASE Hospital;

-- Usar la base de datos recién creada
USE Hospital;

-- Tabla de médicos
CREATE TABLE Medicos (
    dni VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(50),
    numero_colegiado VARCHAR(20)
);

-- Tabla de pacientes
CREATE TABLE Pacientes (
    dni VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(50),
    num_tarjeta_seguridad_social VARCHAR(20)
);

-- Tabla de análisis
CREATE TABLE Analisis (
    id_analisis INT PRIMARY KEY AUTO_INCREMENT,
    dni_paciente VARCHAR(10),
    fecha_analisis DATE,
    parametro_analizado VARCHAR(50),
    valor_analisis DECIMAL(10,2),
    dni_medico_solicitante VARCHAR(10),
    FOREIGN KEY (dni_paciente) REFERENCES Pacientes(dni),
    FOREIGN KEY (dni_medico_solicitante) REFERENCES Medicos(dni)
);

-- Tabla de relación entre médicos y pacientes (Atención Médica)
CREATE TABLE AtencionMedica (
    id_atencion INT PRIMARY KEY AUTO_INCREMENT,
    dni_paciente VARCHAR(10),
    dni_medico VARCHAR(10),
    FOREIGN KEY (dni_paciente) REFERENCES Pacientes(dni),
    FOREIGN KEY (dni_medico) REFERENCES Medicos(dni)
);
