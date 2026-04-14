-- Importación JSON: 06_json_import.sql
-- Objetivo: Importar un archivo JSON externo usando JSON_TABLE (MySQL 8.0+)

-- 1. Leemos el archivo a una variable (requiere privilegios de FILE)
SET @json_data = LOAD_FILE('/var/lib/mysql-files/empleados_externos.json');

-- 2. "Trituramos" el JSON para convertirlo en tabla relacional e insertar
INSERT INTO empresa_segura.empleados (nombre, email, departamento, salario)
SELECT * FROM JSON_TABLE(
    @json_data,
    "$[*]" -- Ruta de la raiz (array de objetos)
    COLUMNS(
        nombre VARCHAR(100) PATH "$.nombre_completo",
        email VARCHAR(100) PATH "$.correo",
        departamento VARCHAR(50) PATH "$.area",
        salario DECIMAL(10,2) PATH "$.sueldo"
    )
) AS jt;
