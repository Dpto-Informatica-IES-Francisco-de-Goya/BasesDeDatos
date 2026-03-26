-- 03. Actualización controlada
START TRANSACTION;
UPDATE pedidos SET estado = 'Enviado' WHERE id = 1;
SELECT * FROM pedidos WHERE id = 1;
COMMIT;
