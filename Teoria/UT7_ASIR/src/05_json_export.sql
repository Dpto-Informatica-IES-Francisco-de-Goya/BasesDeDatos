-- Exportación JSON: 05_json_export.sql
-- Objetivo: Exportar datos en formato JSON para una API externa (CE.e/CE.h)

-- MySQL permite generar JSON directamente desde la consulta
SELECT 
    JSON_ARRAYAGG(
        JSON_OBJECT(
            'id', id,
            'nombre', nombre,
            'departamento', departamento,
            'email', email
        )
    )
INTO OUTFILE '/var/lib/mysql-files/empleados_api.json'
FROM empresa_segura.empleados;
