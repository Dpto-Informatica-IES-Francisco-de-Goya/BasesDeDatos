-- Importación de datos: 02_import_csv.sql
-- Objetivo: Importar empleados desde un archivo CSV externo (Staging).

-- Preparar tabla de staging sin claves foráneas para mayor velocidad
CREATE TEMPORARY TABLE staging_empleados (
    nombre VARCHAR(100),
    email VARCHAR(100),
    depto VARCHAR(50),
    salario DECIMAL(10, 2),
    fecha_contratacion DATE
);

-- Carga masiva desde CSV
LOAD DATA INFILE '/var/lib/mysql-files/nuevos_empleados.csv'
INTO TABLE staging_empleados
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Ignorar cabecera

-- Pasar a producción los que no existan
INSERT IGNORE INTO empresa_segura.empleados (nombre, email, departamento, salario, fecha_contratacion)
SELECT * FROM staging_empleados;
