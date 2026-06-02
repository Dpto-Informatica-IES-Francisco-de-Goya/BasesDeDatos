
-- Almacen destino que no existe en almacenes
select * from envios where almacen_destino_id not in (select id from almacenes);

START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;
UPDATE envios 
SET almacen_destino_id = 1 WHERE almacen_destino_id not in (select id from almacenes);
SET SQL_SAFE_UPDATES = 1;
COMMIT;

ALTER TABLE envios ADD CONSTRAINT fk_envios_almacenes FOREIGN KEY (almacen_destino_id)
REFERENCES almacenes(id) ON DELETE RESTRICT ON UPDATE CASCADE;

