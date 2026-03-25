-- DISCLAIMER: Aquí tienes unas posibles soluciones de lo "técnico". 
-- Esto debería ir acompañado de un uso más granular de SQL_SAFE_UPDATES, 
-- de comprobaciones y de transacciones como hemos hecho en clase.

SET SQL_SAFE_UPDATES = 0;
USE erp_logistica;

-- 1. Espacios residuales
UPDATE clientes SET nombre_completo = TRIM(nombre_completo);

-- 2. Corrección de dominios (.con -> .com)
UPDATE clientes SET email = REPLACE(email, '.con', '.com');

-- 3. Estandarización de teléfonos (Eliminar guiones y espacios)
UPDATE clientes SET telefono = REPLACE(REPLACE(telefono, '-', ''), ' ', '');
USE erp_logistica;

-- 4. Normalización de estados a MAYÚSCULAS
UPDATE pedidos SET estado = UPPER(estado);

-- 5, 6, 7 y 8. Limpieza de precios (Símbolos, comas, espacios)
-- Se eliminan símbolos de moneda y se cambia coma por punto
UPDATE productos 
SET precio_sucio = REPLACE(REPLACE(REPLACE(REPLACE(precio_sucio, '€', ''), '$', ''), 'EUR', ''), ',', '.');

-- Se eliminan espacios en blanco
UPDATE productos SET precio_sucio = TRIM(precio_sucio);

-- Tratamiento preventivo: Valores no numéricos (como 'Gratis') se ponen a 0.00
UPDATE productos SET precio_sucio = '0.00' WHERE precio_sucio REGEXP '[a-zA-Z]';
USE erp_logistica;

-- 9. Cast de Precios: Cambio de nombre y tipo
ALTER TABLE productos CHANGE precio_sucio precio DECIMAL(10,2);
USE erp_logistica;

-- 10 y 11. Estandarización de Fechas (Barras, Guiones y Puntos)
-- Transformamos los distintos formatos de texto al estándar YYYY-MM-DD

-- Caso 1: DD/MM/YYYY
UPDATE pedidos 
SET fecha_texto = STR_TO_DATE(fecha_texto, '%d/%m/%Y') 
WHERE fecha_texto LIKE '%/%';

-- Caso 2: DD-MM-YYYY (Evitando las que ya están como YYYY-MM-DD)
UPDATE pedidos 
SET fecha_texto = STR_TO_DATE(fecha_texto, '%d-%m-%Y') 
WHERE fecha_texto LIKE '%-%' AND LENGTH(SUBSTRING_INDEX(fecha_texto, '-', 1)) < 4;

-- Caso 3: YYYY.MM.DD
UPDATE pedidos 
SET fecha_texto = REPLACE(fecha_texto, '.', '-') 
WHERE fecha_texto LIKE '%.%.%';

-- BUENA PRÁCTICA: Todo en un único UPDATE para no tener que recorrer la tabla 
-- completa varias veces. En este caso da igual, pero podría tardar en recorrerse
-- la tabla completa varios minutos.
UPDATE pedidos SET 
    fecha_texto = CASE
        WHEN fecha_texto LIKE '%/%/____' THEN STR_TO_DATE(fecha_texto, '%d/%m/%Y')
        WHEN fecha_texto LIKE '%-%-____' THEN STR_TO_DATE(fecha_texto, '%d-%m-%Y')
        WHEN fecha_texto LIKE '____.%.%' THEN STR_TO_DATE(fecha_texto, '%Y.%m.%d')
        ELSE fecha_texto
    END
WHERE -- NO ES IMPRESCINDIBLE PARA EL FUNCIONAMIENTO PERO NO PONERLO ES SUBÓPTIMO EN TÉRMINOS DE RENDIMIENTO.
    fecha_texto LIKE '%/%/____'
        OR fecha_texto LIKE '%-%-____'
        OR fecha_texto LIKE '____.%.%';

-- 12. Cast de Fechas: Cambio de nombre y tipo
ALTER TABLE pedidos CHANGE fecha_texto fecha DATE;
USE erp_logistica;

-- 13. Productos huérfanos: Asignar a categoría 'General' buscando dinámicamente su ID
UPDATE productos 
SET categoria_id = (SELECT id FROM categorias WHERE nombre = 'General')
WHERE categoria_id NOT IN (SELECT id FROM categorias);

-- 14. Clientes huérfanos en pedidos: Reasignar al 'Cliente Ficticio'
UPDATE pedidos 
SET cliente_id = (SELECT id FROM clientes WHERE nombre_completo = 'Cliente Ficticio')
WHERE cliente_id NOT IN (SELECT id FROM clientes);
USE erp_logistica;

-- 15. Deduplicación de clientes
-- Paso 1: Reasignar pedidos de los clientes que van a ser borrados al ID que se va a mantener (el más bajo)
UPDATE pedidos p
JOIN clientes c1 ON p.cliente_id = c1.id
JOIN clientes c2 ON c1.nombre_completo = c2.nombre_completo 
    AND c1.email = c2.email 
    AND c1.telefono = c2.telefono
SET p.cliente_id = c2.id
WHERE c1.id > c2.id;

-- Paso 2: Ahora sí, eliminar duplicados manteniendo solo el ID más bajo
DELETE c1 FROM clientes c1
INNER JOIN clientes c2 
ON c1.nombre_completo = c2.nombre_completo 
AND c1.email = c2.email 
AND c1.telefono = c2.telefono
WHERE c1.id > c2.id;

-- 16. Deduplicación de pedidos (Manteniendo el ID más alto)
DELETE p1 FROM pedidos p1
INNER JOIN pedidos p2 
ON p1.cliente_id = p2.cliente_id 
AND p1.fecha = p2.fecha 
AND p1.estado = p2.estado
WHERE p1.id < p2.id;

-- 17. Limpieza de inactivos: Eliminar clientes que nunca han realizado un pedido
DELETE FROM clientes 
WHERE id NOT IN (SELECT DISTINCT cliente_id FROM pedidos);
USE erp_logistica;

-- 18. Depreciación de catálogo: Reasignar todos los productos de 'Descatalogados' a 'General'
UPDATE productos 
SET categoria_id = (SELECT id FROM categorias WHERE nombre = 'General')
WHERE categoria_id = (SELECT id FROM categorias WHERE nombre = 'Descatalogados');

-- Eliminar la categoría 'Descatalogados' tras vaciarla
DELETE FROM categorias WHERE nombre = 'Descatalogados';
USE erp_logistica;

-- 19. Actualización financiera: Aplicar incremento del 5% al precio de todos los productos de 'Electrónica'
UPDATE productos 
SET precio = precio * 1.05 
WHERE categoria_id = (SELECT id FROM categorias WHERE nombre = 'Electrónica');

-- 20. Blindaje de la base de datos: Añadir restricciones de clave foránea (FOREIGN KEY)
-- Esto asegura que no se vuelvan a introducir datos huérfanos. 
-- Solo puede hacerse DESPUÉS DE HABER LIMPIADO LAS TABLAS

ALTER TABLE productos 
ADD CONSTRAINT fk_productos_categorias 
FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE RESTRICT;

ALTER TABLE pedidos 
ADD CONSTRAINT fk_pedidos_clientes 
FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE RESTRICT;
USE erp_logistica;

-- 21. Normalización de Direcciones (IFNULL)
UPDATE clientes 
SET direccion = IFNULL(direccion, 'SIN DIRECCIÓN REGISTRADA');

-- 22. Consolidación de Precios (COALESCE)
-- Paso A: Crear la columna
ALTER TABLE productos ADD COLUMN precio_final DECIMAL(10,2);

-- Paso B: Poblar con COALESCE (oferta -> precio -> 0.00)
-- Nota: La columna 'precio' ya fue transformada anteriormente.
UPDATE productos 
SET precio_final = COALESCE(CAST(precio_oferta AS DECIMAL(10,2)), precio, 0.00);

-- 23. Saneamiento de Notas de Seguimiento
UPDATE pedidos 
SET notas_seguimiento = IFNULL(notas_seguimiento, 'Sin observaciones adicionales');

-- 24. Consolidación de Identidad (Combinación de funciones)
UPDATE clientes 
SET nombre_completo = COALESCE(nombre_completo, email, CONCAT('CLIENTE_ID_', id))
WHERE nombre_completo IS NULL OR nombre_completo = 'Sin Datos';
USE erp_logistica;

-- ==========================================
-- BLOQUE 6: AUDITORÍA Y OPERACIONES AVANZADAS
-- ==========================================

-- 25. Gestión de Seguridad: Desactivar modo de actualizaciones seguras
SET SQL_SAFE_UPDATES = 0;

-- 26. Archivado de Datos (INSERT INTO ... SELECT)
-- Creamos la tabla de histórico con la misma estructura que clientes
CREATE TABLE clientes_historico LIKE clientes;

-- Insertamos los clientes que no tienen pedidos
INSERT INTO clientes_historico
SELECT * FROM clientes 
WHERE id NOT IN (SELECT DISTINCT cliente_id FROM pedidos);

-- 27. Upsert de Productos (INSERT ... ON DUPLICATE KEY UPDATE)
-- Insertar o actualizar precio si ya existe (ID=1)
INSERT INTO productos (id, nombre, precio, categoria_id)
VALUES (1, 'Portátil Pro Plus', 1210.50, 1)
ON DUPLICATE KEY UPDATE precio = precio + 10;

-- 28. Categorización Dinámica (CASE)
UPDATE pedidos 
SET estado = CASE 
    WHEN YEAR(fecha) < 2023 THEN 'ARCHIVADO'
    WHEN YEAR(fecha) = 2023 THEN estado 
    WHEN YEAR(fecha) = 2024 THEN 'RECIENTE'
    ELSE estado 
END;

-- 29. Auditoría de Consistencia (Count y validación)
-- Esta consulta nos permite ver si quedan pedidos huérfanos tras el blindaje
SELECT c.nombre_completo, COUNT(p.id) as total_pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id;

-- 30. Limpieza Radical (TRUNCATE) ¿Funciona con transacciones?
TRUNCATE TABLE logs_sistema;

-- Volver a activar la seguridad (Buena práctica)
SET SQL_SAFE_UPDATES = 1;
