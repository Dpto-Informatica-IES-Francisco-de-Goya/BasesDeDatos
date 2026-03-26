-- 11. Transacciones "Anidadas" (El riesgo de un nuevo START TRANSACTION)
START TRANSACTION;
UPDATE alumnos SET nota = 10.00 WHERE id = 1;
-- Un script mal diseñado intenta abrir otra transacción interna:
START TRANSACTION; -- ¡CUIDADO! Esto provoca un COMMIT implícito de la anterior.
UPDATE alumnos SET estado = 'Matrícula de Honor' WHERE id = 1;
ROLLBACK;
-- Solo el segundo cambio se deshace. El 10.00 se guardó.
