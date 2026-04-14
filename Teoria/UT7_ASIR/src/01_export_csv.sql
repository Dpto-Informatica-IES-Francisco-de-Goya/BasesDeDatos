-- Exportación de datos: 01_export_csv.sql
-- Objetivo: Exportar los logs de acceso a un CSV para auditoría externa.

-- MUY IMPORTANTE: MySQL requiere permisos en la carpeta destino (secure-file-priv)
-- Puedes consultar la carpeta permitida con: SHOW VARIABLES LIKE 'secure_file_priv';

SELECT 'id', 'empleado_id', 'fecha_hora', 'ip_origen', 'accion'
UNION
SELECT * FROM empresa_segura.logs_acceso
INTO OUTFILE '/var/lib/mysql-files/logs_auditoria.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- TIP: Si no puedes usar INTO OUTFILE por permisos, puedes usar la terminal:
-- mysql -u usuario -p -e "SELECT * FROM db.tabla" > salida.txt
