USE gha_analytics;

-- ==========================================
-- ESCENARIO 2: SANEAMIENTO PROFUNDO
-- ==========================================

-- 1. Gestión de NULLs y corrección de emails
-- Corregir errores tipográficos conocidos
UPDATE pacientes SET email = REPLACE(email, ',', '.') WHERE email LIKE '%,%';

-- Asignar email corporativo provisional a pacientes sin correo (COALESCE)
UPDATE pacientes 
SET email = COALESCE(email, CONCAT(LOWER(REPLACE(nombre_completo, ' ', '.')), '@gha-clinica.local'));

-- Marcar pacientes sin póliza explícitamente
UPDATE pacientes SET num_poliza = IFNULL(num_poliza, 'SIN_SEGURO_PRIVADO');

-- 2. Limpieza Financiera (Importes)
-- Eliminación de símbolos de moneda y normalización de separadores
UPDATE visitas 
SET importe_sucio = REPLACE(REPLACE(REPLACE(REPLACE(importe_sucio, '€', ''), '$', ''), 'EUR', ''), ',', '.');

-- Limpieza de espacios y tratamiento de gratuidad
UPDATE visitas SET importe_sucio = TRIM(importe_sucio);
UPDATE visitas SET importe_sucio = '0.00' WHERE importe_sucio = 'Gratis';

-- Cambio de estructura a tipo numérico real
ALTER TABLE visitas CHANGE importe_sucio importe_total DECIMAL(10,2);

-- 3. Saneamiento de Fechas (VARCHAR -> DATETIME)
-- Unificamos los formatos detectados al estándar SQL (YYYY-MM-DD HH:MM:SS)

-- Formato DD/MM/YYYY HH:MM
UPDATE visitas 
SET fecha_visita = STR_TO_DATE(fecha_visita, '%d/%m/%Y %H:%i') 
WHERE fecha_visita LIKE '%/%';

-- Formato YYYY.MM.DD HH:MM
UPDATE visitas 
SET fecha_visita = REPLACE(fecha_visita, '.', '-') 
WHERE fecha_visita LIKE '%.%.%';

-- Formato DD-MM-YYYY HH:MM
UPDATE visitas 
SET fecha_visita = STR_TO_DATE(fecha_visita, '%d-%m-%Y %H:%i') 
WHERE fecha_visita LIKE '%-%' AND LENGTH(SUBSTRING_INDEX(fecha_visita, '-', 1)) < 4;

-- Una vez normalizado el texto, cambiamos el tipo de la columna
ALTER TABLE visitas MODIFY fecha_visita DATETIME;

-- 4. Deduplicación de Visitas
-- Eliminamos visitas duplicadas (mismo paciente, médico y hora), manteniendo el ID más alto
DELETE v1 FROM visitas v1
INNER JOIN visitas v2 ON v1.paciente_id = v2.paciente_id 
    AND v1.medico_id = v2.medico_id 
    AND v1.fecha_visita = v2.fecha_visita
WHERE v1.id < v2.id;

-- 5. Auditoría Final (Optimización)
-- Comprobar si existen pacientes sin visitas (potencial purga)
-- SELECT * FROM pacientes WHERE id NOT IN (SELECT paciente_id FROM visitas);
