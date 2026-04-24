-- Ejercicio 3: Integridad de Proveedores (Clientes en envíos)
START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;

-- Reasignar envíos con cliente inexistente al cliente genérico id=1
UPDATE envios 
SET cliente_id = 1 
WHERE cliente_id NOT IN (SELECT id FROM clientes);

COMMIT;
SET SQL_SAFE_UPDATES = 1;

-- Definir la FOREIGN KEY
ALTER TABLE envios 
ADD CONSTRAINT fk_envios_cliente 
FOREIGN KEY (cliente_id) REFERENCES clientes(id);

-- Verificación
SELECT count(*) as invalidos FROM envios WHERE cliente_id NOT IN (SELECT id FROM clientes);
