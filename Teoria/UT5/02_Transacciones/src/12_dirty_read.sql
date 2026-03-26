-- 12. Demostración de Lectura Sucia (Dirty Read)
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- Terminal 1:
START TRANSACTION;
UPDATE alumnos SET nota = 0.00 WHERE id = 1; 
-- Terminal 2 (Paralela):
SELECT nota FROM alumnos WHERE id = 1; 
-- Terminal 1:
ROLLBACK;
