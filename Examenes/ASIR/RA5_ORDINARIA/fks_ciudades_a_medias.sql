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
-- 3) Crear columna en almacenes 'ciudad_id' con restricción de FK

-- 4) Rellenar esa columna

-- 5) Eliminar columna antigua
