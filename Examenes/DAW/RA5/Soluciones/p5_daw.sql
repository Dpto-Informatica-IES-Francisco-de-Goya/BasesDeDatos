CREATE TABLE tipos_gestion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100)
);
SELECT DISTINCT TRIM(UPPER(tipo_gestion)) FROM almacenes;

START TRANSACTION;

INSERT INTO tipos_gestion(nombre)
SELECT DISTINCT TRIM(UPPER(tipo_gestion)) FROM almacenes;
commit;

ALTER TABLE almacenes ADD COLUMN tipo_gestion_id INT;

START TRANSACTION;
UPDATE almacenes JOIN tipos_gestion ON tipos_gestion.nombre = TRIM(UPPER(almacenes.nombre))
SET almacenes.tipo_gestion_id = tipos_gestion.id;
COMMIT;

ALTER TABLE almacenes ADD CONSTRAINT fk_almacenes_tipos_gestion 
FOREIGN KEY (tipo_gestion_id) REFERENCES tipos_gestion(id)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE almacenes DROP COLUMN tipo_gestion;
