-- Impedir que el crédito del cliente sea negativo mediante una restricción de validación
ALTER TABLE clientes ADD CONSTRAINT chk_credito_positivo CHECK (credito >= 0);

-- Validación compleja: Asegurar que el NIF tenga 8 números y una letra (formato básico)
ALTER TABLE clientes ADD CONSTRAINT chk_nif_formato CHECK (nif REGEXP '^[0-9]{8}[A-Z]$');
