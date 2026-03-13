-- Intenta esto primero para ver el Error 1175
UPDATE clientes SET email = REPLACE(email, ',', '.') WHERE email LIKE '%@%,%';

-- Solución forense:
SET SQL_SAFE_UPDATES = 0;

UPDATE clientes 
SET email = REPLACE(email, ',', '.') 
WHERE email LIKE '%@%,%'; 

SET SQL_SAFE_UPDATES = 1;
