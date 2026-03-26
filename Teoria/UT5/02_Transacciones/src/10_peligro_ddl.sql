-- 10. Cierre implícito traicionero (El peligro del DDL) 
-- Las sentencias DDL provocan un COMMIT automático.
START TRANSACTION;
UPDATE almacen SET stock = stock - 1 WHERE id = 1;
-- Alguien decide crear una tabla temporal o truncar otra en medio:
TRUNCATE TABLE modulos; 
ROLLBACK; 
-- Resultado: El ROLLBACK no tiene efecto sobre el UPDATE. 
-- El TRUNCATE forzó un COMMIT implícito previo.
