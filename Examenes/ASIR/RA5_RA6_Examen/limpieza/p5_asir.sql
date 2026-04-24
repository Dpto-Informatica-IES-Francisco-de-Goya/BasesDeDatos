
CREATE TABLE tipos_gestion(
	id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100));
    
START TRANSACTION;
select distinct tipo_gestion from almacenes;
INSERT INTO tipos_gestion(nombre)
	SELECT DISTINCT UPPER(TRIM(tipo_gestion)) FROM almacenes;
SELECT * FROM tipos_gestion;
COMMIT;
SELECT * FROM almacenes;
ALTER TABLE almacenes ADD COLUMN tipo_gestion_id INT AFTER tipo_gestion;

START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;
UPDATE almacenes 
			JOIN 
        tipos_gestion 
			ON UPPER(TRIM(almacenes.tipo_gestion)) = tipos_gestion.nombre
	SET almacenes.tipo_gestion_id = tipos_gestion.id;
SET SQL_SAFE_UPDATES = 1;

-- NO hay commit porque lo hace el alter table.

ALTER TABLE almacenes ADD CONSTRAINT fk_almacenes_tipos_gestion
	FOREIGN KEY (tipo_gestion_id) REFERENCES tipos_gestion(id) 
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE almacenes DROP COLUMN tipo_gestion;