-- Actualizar los precios del catálogo cruzándolos con una tabla temporal de nuevas tarifas
UPDATE catalogo c
INNER JOIN importacion_tarifas t ON c.referencia = t.referencia
SET c.precio = t.nuevo_precio, c.fecha_actualizacion = NOW();
