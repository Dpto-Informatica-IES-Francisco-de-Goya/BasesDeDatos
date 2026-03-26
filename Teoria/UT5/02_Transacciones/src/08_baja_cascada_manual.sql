-- 08. Baja en Cascada Manual (Sin ON DELETE CASCADE configurado)
START TRANSACTION;
DELETE FROM historial_conexiones WHERE usuario_id = 5;
DELETE FROM usuarios WHERE id = 5;
COMMIT;
