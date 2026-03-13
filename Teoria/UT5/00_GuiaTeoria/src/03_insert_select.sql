-- 1. Creamos la tabla de destino (Estructura optimizada para marketing)
-- Nota: No tiene por qué ser idéntica a la tabla origen.
CREATE TABLE IF NOT EXISTS clientes_vip (
    cliente_id INT PRIMARY KEY,
    nombre_completo VARCHAR(150),
    email_contacto VARCHAR(100),
    potencial_compra DECIMAL(10,2),
    fecha_inclusion DATETIME DEFAULT NOW()
);

-- 2. Limpieza previa (para que el ejemplo sea repetible)
TRUNCATE TABLE clientes_vip;

-- 3. INSERT INTO ... SELECT
-- Extraemos datos de 'clientes', los transformamos y los insertamos en 'clientes_vip'
INSERT INTO clientes_vip (cliente_id, nombre_completo, email_contacto, potencial_compra)
SELECT 
    id, 
    TRIM(nombre), -- Saneamiento: quitamos espacios
    LOWER(REPLACE(email, ',', '.')), -- Saneamiento: arreglamos comas en emails
    credito * 1.20 -- Transformación: calculamos potencial (un 20% más)
FROM clientes
WHERE activo = 1 
  AND credito > 50; -- Solo clientes con crédito significativo

-- 5. Verificación
SELECT * FROM clientes_vip;
