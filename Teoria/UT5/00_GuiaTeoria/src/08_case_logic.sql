-- Lógica condicional dentro del UPDATE
-- Ejemplo: Normalizar prefijos internacionales basándose en patrones
UPDATE clientes
SET telefono = CASE 
    WHEN email LIKE '%.local' THEN CONCAT('+34 ', telefono)
    WHEN nombre LIKE 'Admin%' THEN '+00 000000000'
    ELSE telefono 
END
WHERE activo = 1;
