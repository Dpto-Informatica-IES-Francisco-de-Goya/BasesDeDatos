-- Point-in-Time Recovery: 03_pitr_binlog.sql
-- Objetivo: Ver la ubicación de los logs binarios para recuperación incremental.

-- Comprobar si el Binary Log está activo (Vital para PITR)
SHOW VARIABLES LIKE 'log_bin';

-- Listar archivos de log binario actuales
SHOW BINARY LOGS;

-- Ver eventos en el log binario actual (Solo para depuración)
-- SHOW BINLOG EVENTS;

-- TIP DE ADMINISTRADOR:
-- El comando para restaurar desde un log binario no es SQL, es CLI:
-- mysqlbinlog /var/lib/mysql/binlog.000001 | mysql -u admin -p
