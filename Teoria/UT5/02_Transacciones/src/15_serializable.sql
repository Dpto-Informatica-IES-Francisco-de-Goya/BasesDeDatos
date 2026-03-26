-- 15. Aislamiento SERIALIZABLE (Evitando Lecturas Fantasma)
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- Terminal 1:
START TRANSACTION;
SELECT * FROM alumnos WHERE nota > 8;
-- Terminal 2:
START TRANSACTION;
INSERT INTO alumnos (nombre, nota) VALUES ('Nuevo Genio', 9.5);
-- Resultado: Terminal 2 se queda bloqueada esperando que T1 libere el rango.
