-- 13. Repeatable Read (Nivel por defecto en InnoDB)
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- Terminal 1:
START TRANSACTION;
SELECT nota FROM alumnos WHERE id = 1; 
-- Terminal 2:
START TRANSACTION;
UPDATE alumnos SET nota = 5.00 WHERE id = 1;
COMMIT;
-- Terminal 1:
SELECT nota FROM alumnos WHERE id = 1; 
COMMIT;
