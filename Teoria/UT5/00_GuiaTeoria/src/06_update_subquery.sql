-- Bloquear a los clientes cuyas cuentas bancarias asociadas esten marcadas como fraudulentas
UPDATE clientes
SET activo = 0 
WHERE id IN (
    SELECT id_cliente FROM cuentas_bancarias WHERE fraude = 1
);
