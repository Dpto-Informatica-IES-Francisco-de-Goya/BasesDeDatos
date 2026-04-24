SELECT * FROM envios WHERE vehiculo_id NOT IN (select id from vehiculos);

START TRANSACTION;
UPDATE envios 
	SET vehiculo_id = 1
    WHERE vehiculo_id NOT IN (select id from vehiculos);
SELECT * FROM envios WHERE vehiculo_id NOT IN (select id from vehiculos);
COMMIT; -- Va antes del alter table.

ALTER TABLE envios
	ADD CONSTRAINT fk_envios_vehiculo
    foreign key (vehiculo_id)
    REFERENCES vehiculos(id)
    ON DELETE RESTRICT ON UPDATE CASCADE;