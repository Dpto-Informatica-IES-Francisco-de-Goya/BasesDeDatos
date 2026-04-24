
SELECT * FROM envios WHERE cliente_id NOT IN (select id from clientes);
SELECT * from envios e	LEFT JOIN clientes c ON e.cliente_id = c.id 
	WHERE c.id IS NULL AND
		e.cliente_id IS NOT NULL;

START TRANSACTION;
UPDATE envios e
	LEFT JOIN clientes c ON e.cliente_id = c.id
SET e.cliente_id = 1
WHERE c.id IS NULL AND
		e.cliente_id IS NOT NULL;
rollback;
START TRANSACTION;
UPDATE envios e
SET e.cliente_id = 1
WHERE e.cliente_id not in (select id from clientes);


ALTER TABLE envios 
ADD CONSTRAINT fk_envio_cliente 
FOREIGN KEY (cliente_id) REFERENCES clientes(id);
