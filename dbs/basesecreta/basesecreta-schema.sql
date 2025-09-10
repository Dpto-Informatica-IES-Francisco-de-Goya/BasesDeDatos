CREATE DATABASE IF NOT EXISTS BaseSecreta;
USE BaseSecreta;
-- Tabla de Bases Secretas
CREATE TABLE Bases_Secretas (
Base_ID INT AUTO_INCREMENT PRIMARY KEY,
Nombre_Base VARCHAR(100) NOT NULL,
Ubicacion VARCHAR(100) NOT NULL
);
-- Tabla de Científicos
CREATE TABLE Cientificos (
Cientifico_ID INT AUTO_INCREMENT PRIMARY KEY,
Nombre_Cientifico VARCHAR(100) NOT NULL,
Rango VARCHAR(50),
Base_ID INT,
FOREIGN KEY (Base_ID) REFERENCES Bases_Secretas(Base_ID) ON DELETE SET NULL
);
-- Tabla de Documentos con clave primaria compuesta
CREATE TABLE Documentos (
Documento_ID INT,
Cientifico_ID INT,
Tipo_Documento VARCHAR(50) NOT NULL,
Contenido_Cifrado TEXT NOT NULL,
PRIMARY KEY (Documento_ID, Cientifico_ID),
FOREIGN KEY (Cientifico_ID) REFERENCES Cientificos(Cientifico_ID) ON DELETE CASCADE
);
-- Tabla de Prisioneros
CREATE TABLE Prisioneros (
Prisionero_ID INT AUTO_INCREMENT PRIMARY KEY,
Nombre_Prisionero VARCHAR(100) NOT NULL,
Estado VARCHAR(50),
Documento_ID INT,
Cientifico_ID INT,
FOREIGN KEY (Documento_ID, Cientifico_ID) REFERENCES Documentos(Documento_ID, Cientifico_ID) ON DELETE CASCADE
);
-- Tabla de Recursos
CREATE TABLE Recursos (
Recurso_ID INT AUTO_INCREMENT PRIMARY KEY,
Tipo_Recurso VARCHAR(50) NOT NULL,
Cantidad INT NOT NULL,
Documento_ID INT,
Cientifico_ID INT,
FOREIGN KEY (Documento_ID, Cientifico_ID) REFERENCES Documentos(Documento_ID, Cientifico_ID) ON DELETE CASCADE
);
-- Tabla de Operaciones Militares
CREATE TABLE Operaciones (
Operacion_ID INT AUTO_INCREMENT PRIMARY KEY,
Nombre_Operacion VARCHAR(100) NOT NULL,
Objetivo VARCHAR(100) NOT NULL,
Documento_ID INT,
Cientifico_ID INT,
FOREIGN KEY (Documento_ID, Cientifico_ID) REFERENCES Documentos(Documento_ID, Cientifico_ID) ON DELETE CASCADE
);
