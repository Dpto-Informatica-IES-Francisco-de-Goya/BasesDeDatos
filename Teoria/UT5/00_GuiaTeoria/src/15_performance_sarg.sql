-- Rendimiento y SARGability (Search ARgument ABLE)
-- MAL: Evita funciones en la columna del WHERE (Invalida índices)
SELECT * FROM clientes WHERE UPPER(email) = 'JUAN@MAIL.COM';

-- BIEN: Compara contra la columna directamente (SARGable)
SELECT * FROM clientes WHERE email = 'juan@mail.com';

-- MAL: TRIM() en el WHERE obliga a un Full Table Scan al motor
UPDATE clientes SET activo = 0 WHERE TRIM(nombre) = 'Juan Gomez';
