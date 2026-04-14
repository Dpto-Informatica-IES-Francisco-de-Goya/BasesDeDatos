-- Gestión de Logs y Errores: 04_logs_errors.sql
-- Objetivo: Localizar los logs del sistema para diagnosticar problemas de backup.

-- Ver ubicación del archivo de errores
SHOW VARIABLES LIKE 'log_error';

-- Activar el Log General temporalmente para depurar qué está haciendo el cliente
-- SET GLOBAL general_log = 'ON';
-- SHOW VARIABLES LIKE 'general_log_file';

-- Consultar si hay procesos lentos que bloquean los backups
-- SHOW FULL PROCESSLIST;
