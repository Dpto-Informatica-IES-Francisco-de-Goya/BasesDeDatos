USE gha_analytics;

-- ==========================================
-- ESCENARIO 1: BLINDAJE ESTRUCTURAL
-- ==========================================

-- 1. Normalización de Pacientes
-- Eliminar duplicados exactos (ID más bajo se queda)
DELETE p1 FROM pacientes p1
INNER JOIN pacientes p2 ON p1.nif = p2.nif AND p1.nombre_completo = p2.nombre_completo
WHERE p1.id > p2.id;

-- Limpiar NIFs (espacios y guiones)
UPDATE pacientes SET nif = REPLACE(REPLACE(TRIM(nif), ' ', ''), '-', '');

-- Validar formato NIF (8 números + 1 letra). 
-- Los registros 'radioactivos' que no cumplen se eliminan para permitir el UNIQUE posterior.
DELETE FROM pacientes WHERE nif NOT REGEXP '^[0-9]{8}[A-Z]$';

-- Aplicar restricciones de diseño obligatorias
ALTER TABLE pacientes MODIFY nif VARCHAR(9) NOT NULL;
ALTER TABLE pacientes ADD CONSTRAINT uq_paciente_nif UNIQUE (nif);

-- 2. Consistencia de Médicos
-- Estandarizar formato COL-XX-YYYY
UPDATE medicos 
SET num_colegiado = CASE 
    WHEN num_colegiado LIKE 'COL-%-%' THEN num_colegiado
    WHEN num_colegiado LIKE '%/%' THEN CONCAT('COL-', REPLACE(num_colegiado, '/', '-'))
    WHEN num_colegiado LIKE 'COL28%' THEN CONCAT('COL-28-', SUBSTRING(num_colegiado, 6))
    WHEN num_colegiado REGEXP '^[0-9]+' THEN CONCAT('COL-28-', num_colegiado)
    ELSE num_colegiado
END;

-- Eliminar basura persistente para poder aplicar el CHECK
DELETE FROM medicos WHERE num_colegiado NOT REGEXP '^COL-[0-9]{2}-[0-9]+$';

ALTER TABLE medicos ADD CONSTRAINT chk_formato_colegiado CHECK (num_colegiado REGEXP '^COL-[0-9]{2}-[0-9]+$');

-- 3. Integridad Referencial
-- Médicos huérfanos a Medicina General
UPDATE medicos 
SET especialidad_id = (SELECT id FROM especialidades WHERE nombre = 'Medicina General')
WHERE especialidad_id NOT IN (SELECT id FROM especialidades);

ALTER TABLE medicos ADD CONSTRAINT fk_medico_especialidad FOREIGN KEY (especialidad_id) REFERENCES especialidades(id);

-- Limpiar visitas con médicos o pacientes inexistentes antes de la FK
DELETE FROM visitas WHERE paciente_id NOT IN (SELECT id FROM pacientes);
DELETE FROM visitas WHERE medico_id NOT IN (SELECT id FROM medicos);

ALTER TABLE visitas ADD CONSTRAINT fk_visita_paciente FOREIGN KEY (paciente_id) REFERENCES pacientes(id);
ALTER TABLE visitas ADD CONSTRAINT fk_visita_medico FOREIGN KEY (medico_id) REFERENCES medicos(id);
