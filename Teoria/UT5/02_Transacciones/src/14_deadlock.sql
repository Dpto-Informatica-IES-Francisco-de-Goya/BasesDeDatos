-- 14. El temido Abrazo Mortal (Deadlock)
-- Terminal 1:
START TRANSACTION; 
UPDATE almacen SET stock = 100 WHERE id = 1;
-- Terminal 2:
START TRANSACTION; 
UPDATE almacen SET stock = 200 WHERE id = 2;
-- Terminal 1 (Espera a B):
UPDATE almacen SET stock = 300 WHERE id = 2; 
-- Terminal 2 (Provoca Deadlock):
UPDATE almacen SET stock = 400 WHERE id = 1; 
