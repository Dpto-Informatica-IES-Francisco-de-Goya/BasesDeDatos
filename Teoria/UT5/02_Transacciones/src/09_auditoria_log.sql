-- 09. Actualización con registro de auditoría (Log)
START TRANSACTION;
UPDATE almacen SET stock = stock + 50 WHERE id = 1;
INSERT INTO auditoria_precios (producto_id, fecha, accion) VALUES (1, NOW(), 'Reposición de 50 unidades de Switch');
COMMIT;
