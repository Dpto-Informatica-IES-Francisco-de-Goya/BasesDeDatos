DROP DATABASE IF EXISTS gestion_proyectos;
CREATE DATABASE gestion_proyectos;
USE gestion_proyectos;

/*Este script de solución contiene errores lógicos que se muestran en 
el script de corrección, otros que no se comprueban en el script de 
corrección porque está incompleto y otros errores que son solo 
de buenas prácticas vistas en clase.*/

-- Tabla: empleados
CREATE TABLE empleados (
    id_empleado INT AUTO_INCREMENT,
     dni VARCHAR(9) NOT NULL,
    -- dni VARCHAR(9) UNIQUE NOT NULL,
    salario DECIMAL(10,2),
    estado ENUM('ACTIVO', 'INACTIVO') DEFAULT 'ACTIVO',
    PRIMARY KEY (id_empleado)
);


-- Tabla: departamentos
CREATE TABLE departamentos (
    id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    codigo_dpto CHAR(5) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    presupuesto DECIMAL(10,2) NOT NULL CHECK (presupuesto > 0) -- ERROR 3: El CHECK está invertido (dice que debe ser negativo).
);

-- Tabla: proyectos
CREATE TABLE proyectos (
    id_proyecto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    id_departamento INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE, 
    -- CONSTRAINT fk_depto FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento),
    CONSTRAINT chk_fechas CHECK (fecha_fin > fecha_inicio)
);

-- Tabla: asignaciones
CREATE TABLE asignaciones (
    id_empleado INT,
    id_proyecto INT,
    horas_asignadas INT DEFAULT 0,
    CONSTRAINT pk_asignaciones PRIMARY KEY (id_empleado,id_proyecto),
    CONSTRAINT fk_asignacion_empleado FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado) ON DELETE CASCADE,
    CONSTRAINT fk_asignacion_proyecto FOREIGN KEY (id_proyecto) REFERENCES proyectos(id_proyecto) ON DELETE CASCADE
    
);