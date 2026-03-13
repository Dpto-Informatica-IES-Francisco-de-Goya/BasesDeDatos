-- Tecnica de UPSERT aplicada a la tabla de clientes.
-- Si el cliente con ID 1 no existe, se crea con los datos proporcionados.
-- Si el ID 1 ya existe, se actualiza su credito (anadiendo 100) y se marca como activo.

INSERT INTO clientes (id, nombre, email, telefono, credito, activo)
VALUES (1, 'Juan Gomez', 'juan.gomez@empresa.local', '+34 600-111-222', 100.00, 1)
ON DUPLICATE KEY UPDATE 
    credito = credito + 100.00, 
    activo = 1;
