-- 06. Transferencia de valores (Stock entre almacenes)
START TRANSACTION;
UPDATE almacen SET stock = stock - 10 WHERE id = 1;
UPDATE almacen SET stock = stock + 10 WHERE id = 2;
COMMIT;
