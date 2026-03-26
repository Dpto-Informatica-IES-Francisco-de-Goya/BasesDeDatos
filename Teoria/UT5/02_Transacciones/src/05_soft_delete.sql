-- 05. Simulación de borrado (Soft-delete manual)
START TRANSACTION;
DELETE FROM alumnos WHERE estado = 'Inactivo';
SELECT * FROM alumnos; -- Aquí ya no sale Luis
ROLLBACK;
