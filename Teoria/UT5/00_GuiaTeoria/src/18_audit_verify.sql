-- Verificación post-intervención mediante agregación
-- Comprobar si han quedado correos repetidos tras el UPDATE
SELECT email, COUNT(*) as repetidos
FROM clientes
GROUP BY email
HAVING COUNT(*) > 1;

-- Verificar la distribución de datos tras un saneamiento masivo
SELECT activo, COUNT(*) as total
FROM clientes
GROUP BY activo;
