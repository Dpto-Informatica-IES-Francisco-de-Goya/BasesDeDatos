-- Forzar la unicidad de los correos electrónicos para evitar duplicados en el futuro
ALTER TABLE clientes ADD CONSTRAINT uq_email UNIQUE (email);

-- Convertir una columna en obligatoria (NOT NULL)
-- ¡Atención! Primero saneamos los nulos existentes para evitar errores de restricción
UPDATE clientes SET nif = '00000000T' WHERE nif IS NULL;

ALTER TABLE clientes MODIFY nif VARCHAR(12) NOT NULL;
