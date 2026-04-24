-- Ejercicio 5: Normalización de Gestión (Ciudades)
-- 1. Crea la tabla ciudades
CREATE TABLE ciudades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;

-- 2. Traslada los valores únicos (origen y destino)
INSERT IGNORE INTO ciudades (nombre)
SELECT DISTINCT TRIM(UPPER(ruta_origen_ciudad)) FROM envios WHERE ruta_origen_ciudad IS NOT NULL;

INSERT IGNORE INTO ciudades (nombre)
SELECT DISTINCT TRIM(UPPER(ruta_destino_ciudad)) FROM envios WHERE ruta_destino_ciudad IS NOT NULL;

-- 3. Vincula los envíos
ALTER TABLE envios ADD COLUMN ciudad_origen_id INT AFTER ruta_origen_ciudad;
ALTER TABLE envios ADD COLUMN ciudad_destino_id INT AFTER ruta_destino_ciudad;

UPDATE envios e JOIN ciudades c ON TRIM(UPPER(e.ruta_origen_ciudad)) = c.nombre SET e.ciudad_origen_id = c.id;
UPDATE envios e JOIN ciudades c ON TRIM(UPPER(e.ruta_destino_ciudad)) = c.nombre SET e.ciudad_destino_id = c.id;

-- Opcional: eliminar columnas originales si se desea una normalización completa, 
-- aunque el enunciado solo pide vincular.
-- ALTER TABLE envios DROP COLUMN ruta_origen_ciudad, DROP COLUMN ruta_destino_ciudad;

COMMIT;
SET SQL_SAFE_UPDATES = 1;

-- Verificación
SELECT e.id, co.nombre as origen, cd.nombre as destino 
FROM envios e
JOIN ciudades co ON e.ciudad_origen_id = co.id
JOIN ciudades cd ON e.ciudad_destino_id = cd.id
LIMIT 5;
