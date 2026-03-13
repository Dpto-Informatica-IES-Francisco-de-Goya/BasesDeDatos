-- Purga de registros obsoletos basandose en fechas (Ej. Ley de Proteccion de Datos)
DELETE FROM sys_logs
WHERE created_at < DATE_SUB(NOW(), INTERVAL 5 YEAR);
