-- 01. Alta segura de un registro
START TRANSACTION;
INSERT INTO alumnos (nombre, estado) VALUES ('Elena', 'Activo');
SELECT * FROM alumnos WHERE nombre = 'Elena';
COMMIT;
