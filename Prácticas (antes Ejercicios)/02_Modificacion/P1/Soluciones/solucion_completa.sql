USE gha_analytics;

-- =============================================================================
-- PRÁCTICA AVANZADA: SANEAMIENTO Y REESTRUCTURACIÓN (GHA ANALYTICS)
-- Script de Solución Unificado
-- =============================================================================

SET SQL_SAFE_UPDATES = 0; -- Desactivar safe updates para limpieza masiva
SET FOREIGN_KEY_CHECKS = 0; -- Desactivar FKs temporalmente para saneamiento estructural

-- ==========================================
-- ESCENARIO 1: BLINDAJE ESTRUCTURAL
-- ==========================================

-- 1. Normalización de Identidad (Pacientes)
-- -----------------------------------------------------------------------------

-- Limpieza agresiva de NIFs antes de deduplicar
UPDATE pacientes 
SET nif = UPPER(REPLACE(REPLACE(TRIM(nif), ' ', ''), '-', ''))
WHERE nif IS NOT NULL;

-- Eliminar registros "basura" que no son NIFs válidos (para permitir UNIQUE)
DELETE FROM pacientes 
WHERE nif NOT REGEXP '^[0-9]{8}[A-Z]$';

-- Deduplicación exacta: Mismo NIF y nombre (mantenemos el ID más bajo)
DELETE p1 FROM pacientes p1
INNER JOIN pacientes p2 ON p1.nif = p2.nif AND p1.nombre_completo = p2.nombre_completo
WHERE p1.id > p2.id;

-- Deduplicación por NIF (si el nombre varía ligeramente pero es el mismo NIF, mantenemos el primero)
DELETE p1 FROM pacientes p1
INNER JOIN pacientes p2 ON p1.nif = p2.nif
WHERE p1.id > p2.id;

-- Aplicar restricciones estructurales
ALTER TABLE pacientes MODIFY nif VARCHAR(9) NOT NULL;
ALTER TABLE pacientes ADD CONSTRAINT uq_paciente_nif UNIQUE (nif);

-- 2. Consistencia de Colegiados (Médicos)
-- -----------------------------------------------------------------------------

-- Estandarizar formatos: 28/5566, COL289900, 28-7788 -> COL-28-XXXX
UPDATE medicos 
SET num_colegiado = CASE 
    WHEN num_colegiado REGEXP '^COL-[0-9]{2}-[0-9]+$' THEN num_colegiado
    WHEN num_colegiado LIKE '%/%' THEN CONCAT('COL-', REPLACE(num_colegiado, '/', '-'))
    WHEN num_colegiado LIKE 'COL28%' THEN CONCAT('COL-28-', SUBSTRING(num_colegiado, 6))
    WHEN num_colegiado REGEXP '^[0-9]{2}-[0-9]+$' THEN CONCAT('COL-', num_colegiado)
    ELSE num_colegiado
END;

-- Eliminar médicos con códigos imposibles de salvar
DELETE FROM medicos WHERE num_colegiado NOT REGEXP '^COL-[0-9]{2}-[0-9]+$';

-- Añadir restricción CHECK
ALTER TABLE medicos ADD CONSTRAINT chk_formato_colegiado 
    CHECK (num_colegiado REGEXP '^COL-[0-9]{2}-[0-9]+$');

-- 3. Integridad Referencial
-- -----------------------------------------------------------------------------

-- Reasignar especialidades huérfanas
UPDATE medicos 
SET especialidad_id = (SELECT id FROM especialidades WHERE nombre = 'Medicina General')
WHERE especialidad_id NOT IN (SELECT id FROM especialidades);

-- Limpiar visitas de entidades inexistentes
DELETE FROM visitas WHERE paciente_id NOT IN (SELECT id FROM pacientes);
DELETE FROM visitas WHERE medico_id NOT IN (SELECT id FROM medicos);

-- Activar e implementar Foreign Keys
SET FOREIGN_KEY_CHECKS = 1;

ALTER TABLE medicos ADD CONSTRAINT fk_medico_especialidad 
    FOREIGN KEY (especialidad_id) REFERENCES especialidades(id);

ALTER TABLE visitas ADD CONSTRAINT fk_visita_paciente 
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE CASCADE;

ALTER TABLE visitas ADD CONSTRAINT fk_visita_medico 
    FOREIGN KEY (medico_id) REFERENCES medicos(id) ON DELETE CASCADE;


-- ==========================================
-- ESCENARIO 2: SANEAMIENTO PROFUNDO
-- ==========================================

-- 1. Gestión de NULLs y Datos de Contacto
-- -----------------------------------------------------------------------------

-- Emails: Corregir errores de puntuación y formatos inválidos
UPDATE pacientes SET email = REPLACE(email, ',', '.') WHERE email LIKE '%,%';

-- Identificar emails con múltiples @ o formatos basura (los ponemos a NULL para el COALESCE)
UPDATE pacientes SET email = NULL WHERE email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$';

-- COALESCE: Asignar email corporativo a los que no tienen
UPDATE pacientes 
SET email = COALESCE(email, CONCAT(LOWER(REPLACE(TRIM(nombre_completo), ' ', '.')), '@gha-clinica.local'));

-- Normalizar teléfonos: Quitar prefijos internacionales y caracteres no numéricos
UPDATE pacientes 
SET tel_contacto = REGEXP_REPLACE(tel_contacto, '[^0-9]', '')
WHERE tel_contacto IS NOT NULL;

-- 2. Limpieza Financiera y Conversión de Tipos
-- -----------------------------------------------------------------------------

-- Limpiar importe_sucio
UPDATE visitas 
SET importe_sucio = REPLACE(REPLACE(REPLACE(REPLACE(importe_sucio, '€', ''), '$', ''), 'EUR', ''), ',', '.');

UPDATE visitas SET importe_sucio = '0.00' WHERE TRIM(importe_sucio) = 'Gratis' OR importe_sucio IS NULL;

-- Convertir columna a DECIMAL
ALTER TABLE visitas CHANGE importe_sucio importe_total DECIMAL(10,2);

-- Normalizar descuentos y convertir a DECIMAL
UPDATE visitas SET descuento_aplicado = '0.00' WHERE descuento_aplicado IS NULL;
ALTER TABLE visitas MODIFY descuento_aplicado DECIMAL(10,2);

-- 3. Saneamiento de Fechas (VARCHAR -> DATE/DATETIME)
-- -----------------------------------------------------------------------------

-- Saneamiento de f_nacimiento (Pacientes)
UPDATE pacientes SET f_nacimiento = STR_TO_DATE(f_nacimiento, '%d/%m/%Y') WHERE f_nacimiento LIKE '%/%';
UPDATE pacientes SET f_nacimiento = REPLACE(f_nacimiento, '.', '-') WHERE f_nacimiento LIKE '%.%.%';
ALTER TABLE pacientes MODIFY f_nacimiento DATE;

-- Saneamiento de fecha_visita (Visitas)
-- Formato DD/MM/YYYY HH:MM
UPDATE visitas SET fecha_visita = STR_TO_DATE(fecha_visita, '%d/%m/%Y %H:%i') WHERE fecha_visita LIKE '%/%';
-- Formato YYYY.MM.DD HH:MM
UPDATE visitas SET fecha_visita = REPLACE(fecha_visita, '.', '-') WHERE fecha_visita LIKE '%.%.%';
-- Formato DD-MM-YYYY HH:MM
UPDATE visitas SET fecha_visita = STR_TO_DATE(fecha_visita, '%d-%m-%Y %H:%i') 
WHERE fecha_visita LIKE '%-%' AND LENGTH(SUBSTRING_INDEX(fecha_visita, '-', 1)) < 4;

ALTER TABLE visitas MODIFY fecha_visita DATETIME;

-- 4. Deduplicación de Visitas
-- -----------------------------------------------------------------------------

DELETE v1 FROM visitas v1
INNER JOIN visitas v2 ON v1.paciente_id = v2.paciente_id 
    AND v1.medico_id = v2.medico_id 
    AND v1.fecha_visita = v2.fecha_visita
WHERE v1.id > v2.id;

-- 5. Extra: Procesamiento de Tabla de Staging (raw_import_visitas)
-- -----------------------------------------------------------------------------
-- Ejemplo de cómo parsear datos delimitados por tubería (|) e insertarlos en visitas
-- Asumimos médico con ID 1 para la carga inicial

INSERT INTO visitas (paciente_id, medico_id, fecha_visita, importe_total, observaciones)
SELECT 
    p.id, 
    1, -- Médico asignado por defecto para importaciones
    STR_TO_DATE(SUBSTRING_INDEX(SUBSTRING_INDEX(raw_data, '|', 3), '|', -1), '%d/%m/%Y'),
    CAST(SUBSTRING_INDEX(raw_data, '|', -1) AS DECIMAL(10,2)),
    CONCAT('Importado de staging (ExtID: ', ext_id, ')')
FROM raw_import_visitas r
JOIN pacientes p ON p.nif = SUBSTRING_INDEX(raw_data, '|', 1);

-- 6. Optimización (Índices SARGables)
-- -----------------------------------------------------------------------------

-- Crear índices para búsquedas frecuentes
CREATE INDEX idx_visita_fecha ON visitas(fecha_visita);
CREATE INDEX idx_paciente_nombre ON pacientes(nombre_completo);

-- Finalización
SELECT 'Saneamiento completado con éxito' AS Status;
