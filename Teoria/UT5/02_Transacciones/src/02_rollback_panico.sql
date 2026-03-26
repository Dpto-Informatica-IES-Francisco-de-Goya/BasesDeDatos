-- 02. Prueba y descarte (El botón de pánico)
START TRANSACTION;
INSERT INTO alumnos (nombre, estado) VALUES (NULL, 'Error Intencionado');
ROLLBACK;
-- Comprueba que el registro nulo no existe: 
SELECT * FROM alumnos;
