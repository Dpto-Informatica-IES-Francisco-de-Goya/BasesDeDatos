-- Ejercicio 5: Normalización de Gestión (Bonus)
-- Archivo: p5_dam.sql

-- 1. Crear tabla de tipos de gestión
CREATE TABLE tipos_gestion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100)
);


-- 2. Vincular tabla almacenes
ALTER TABLE almacenes ADD COLUMN tipo_gestion_id INT;


START TRANSACTION;
-- 3. Trasladar valores únicos con limpieza (Bonus)
INSERT INTO tipos_gestion (nombre)
SELECT DISTINCT TRIM(UPPER(tipo_gestion))
FROM almacenes;

UPDATE almacenes a 
JOIN tipos_gestion tg ON TRIM(UPPER(a.tipo_gestion)) = tg.nombre
SET a.tipo_gestion_id = tg.id;

COMMIT;

-- 4. Eliminar columna original
ALTER TABLE almacenes DROP COLUMN tipo_gestion;

-- 5. Añadir la FK
ALTER TABLE almacenes ADD CONSTRAINT fk_almacen_gestion 
FOREIGN KEY (tipo_gestion_id) REFERENCES tipos_gestion(id);

