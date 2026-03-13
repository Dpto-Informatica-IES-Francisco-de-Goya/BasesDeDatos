-- =============================================================================
-- GESTIÓN DE NULLS: IFNULL vs COALESCE
-- =============================================================================

-- 0. Preparación de datos de prueba (Escenarios de nulos)
INSERT INTO clientes (nombre, email, telefono, credito) VALUES
('Sujeto A', NULL, '600-000-001', 10.00),     -- Solo teléfono
('Sujeto B', 'b@test.com', NULL, 20.00),      -- Solo email
('Sujeto C', NULL, NULL, 0.00),               -- Sin datos de contacto
('Sujeto D', 'd@test.com', '600-000-004', 5.00); -- Datos completos

-- 1. IFNULL: El "plan B" binario (solo 2 argumentos)
-- Si el teléfono es NULL, pone 'DESCONOCIDO'.
UPDATE clientes
SET telefono = IFNULL(telefono, 'DESCONOCIDO')
WHERE nombre LIKE 'Sujeto%'; 

-- 2. COALESCE: El "Selector de Prioridades" (N argumentos)
-- Devuelve el primer valor NO NULO de una lista.
-- Escenario: 1. Email (Preferido), 2. Teléfono (Backup), 3. Texto por defecto.
SELECT 
    nombre,
    COALESCE(email, telefono, 'ILOCALIZABLE') AS contacto_urgente
FROM clientes
WHERE nombre LIKE 'Sujeto%';

-- 3. Evitar que una concatenación "rompa" el resultado
-- Problema: 'Sr. ' + NULL = NULL (El NULL es como un agujero negro)
SELECT 
    CONCAT('Expediente: ', COALESCE(nombre, 'ANÓNIMO')) AS info_sujeto
FROM clientes;
