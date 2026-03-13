-- Ampliar la longitud permitida para el nombre del cliente
ALTER TABLE clientes MODIFY COLUMN nombre VARCHAR(250);

-- Ejemplo de cambio de nombre y tipo (Sintaxis MySQL)
-- ALTER TABLE clientes CHANGE COLUMN nombre nombre_completo VARCHAR(200);
