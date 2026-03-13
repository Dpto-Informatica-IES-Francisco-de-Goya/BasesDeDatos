-- Añadir una columna de NIF después del nombre
ALTER TABLE clientes ADD COLUMN nif VARCHAR(12) AFTER nombre;

-- Eliminar una columna que ya no es necesaria (ejemplo conceptual)
-- ALTER TABLE sys_logs DROP COLUMN metadata_obsoleta;
