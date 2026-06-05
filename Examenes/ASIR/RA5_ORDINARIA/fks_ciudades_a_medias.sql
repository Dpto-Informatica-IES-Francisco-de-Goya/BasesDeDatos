-- CREA UNA TABLA CIUDADES Y VINCULA EL ALMACÉN CON UNA FK A ESA TABLA.


-- 1) Crear la tabla
DROP TABLE ciudades;
CREATE TABLE ciudades ( id INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(100) UNIQUE);

-- 2) Insertarle datos limpios CON DISTINCT.
SELECT 
	DISTINCT CASE 
		WHEN ciudad_ubicacion = 'Barna' THEN 'Barcelona'
		WHEN ciudad_ubicacion = 'VLC' THEN 'Valencia'
        ELSE ciudad_ubicacion END
FROM almacenes;


-- Otra opción sería limpiar los nombres de ciudad en la tabla almacenes
INSERT INTO ciudades (nombre)
SELECT 
	DISTINCT CASE 
		WHEN ciudad_ubicacion = 'Barna' THEN 'Barcelona'
		WHEN ciudad_ubicacion = 'VLC' THEN 'Valencia'
        ELSE ciudad_ubicacion END AS nombre
FROM almacenes;

SELECT * FROM ciudades;
-- 3) Crear columna en almacenes 'ciudad_id'
ALTER TABLE almacenes ADD COLUMN ciudad_id INT;

-- Añadir la restricción de FK para asegurar la integridad referencial
ALTER TABLE almacenes 
ADD CONSTRAINT fk_almacenes_ciudades 
FOREIGN KEY (ciudad_id) REFERENCES ciudades(id);


-- 4) Rellenar esa columna asociando los nombres (ya limpios) con su ID correspondientes
UPDATE almacenes a
JOIN ciudades c ON c.nombre = (
    CASE 
        WHEN a.ciudad_ubicacion = 'Barna' THEN 'Barcelona'
        WHEN a.ciudad_ubicacion = 'VLC' THEN 'Valencia'
        ELSE a.ciudad_ubicacion 
    END
)
SET a.ciudad_id = c.id;


-- 5) Eliminar columna antigua
ALTER TABLE almacenes DROP COLUMN ciudad_ubicacion;

-- Comprobación final
SELECT * FROM almacenes;