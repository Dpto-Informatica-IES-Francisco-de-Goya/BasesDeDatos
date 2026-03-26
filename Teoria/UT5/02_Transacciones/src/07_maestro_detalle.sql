-- 07. Alta Maestro-Detalle (Uso de LAST_INSERT_ID)
START TRANSACTION;
INSERT INTO facturas (fecha) VALUES (CURDATE());
SET @factura_id = LAST_INSERT_ID();
INSERT INTO factura_detalle (factura_id, producto) VALUES (@factura_id, 'Monitor 24"'), (@factura_id, 'Teclado Mecánico');
COMMIT;
