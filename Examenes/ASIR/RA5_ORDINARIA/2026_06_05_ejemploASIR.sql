/***** EJEMPLO DE ELIMINACIÓN DE VEHÍCULOS ANTIGUOS CON MATRICULA REPETIDA **/
-- Eliminar los vehiculos con matricula repetida, quedándote con el que tenga un año de fabricación más reciente. Añade después una restricción de UNIQUE (3 ptos)

-- ¿Hay duplicados?
SELECT matricula,count(id) FROM vehiculos GROUP BY matricula HAVING count(id) > 1;

START TRANSACTION; SET SQL_SAFE_UPDATES = 0;
-- OJO CON LAS MATRÍCULAS. Hay que sanearlas para que 1234ABC sea la misma que 1234-ABC o 1234 ABC. Se sanean así:
UPDATE vehiculos SET  matricula = TRIM(REPLACE(REPLACE(matricula, ' ', ''),'-',''));
-- Podrías limpiar la columna para simplificar el resto de columnas:
-- UPDATE vehiculos SET año_fabricacion = substring_index(v1.año_fabricacion,' ',-1);

-- Saco los duplicados que me interesa eliminar.
SELECT 
	v1.id,v1.matricula,substring_index(v1.año_fabricacion,' ',-1),
    v2.id,v2.matricula,substring_index(v2.año_fabricacion,' ',-1)
FROM vehiculos v1 JOIN vehiculos v2 ON v1.matricula = v2.matricula
WHERE substring_index(v1.año_fabricacion,' ',-1) > substring_index(v2.año_fabricacion,' ',-1);
    
-- Eliminamos
DELETE v2
FROM vehiculos v1 JOIN vehiculos v2 ON v1.matricula = v2.matricula
WHERE substring_index(v1.año_fabricacion,' ',-1) > substring_index(v2.año_fabricacion,' ',-1);
    
-- comprobamos
SELECT  
	v1.id,v1.matricula,substring_index(v1.año_fabricacion,' ',-1), 
	v2.id,v2.matricula,substring_index(v2.año_fabricacion,' ',-1)
FROM vehiculos v1 JOIN vehiculos v2 ON v1.matricula = v2.matricula
WHERE substring_index(v1.año_fabricacion,' ',-1) > substring_index(v2.año_fabricacion,' ',-1);

COMMIT; -- O, comentas: el alter table hace un commit implícito, por lo que no hace falta hacer commit.
-- Como matrícula debería ser UNIQUE, vamos a añadirle esa restricción
ALTER TABLE vehiculos
ADD CONSTRAINT uq_vehiculos_matricula
UNIQUE (matricula);

SET SQL_SAFE_UPDATES = 1;

