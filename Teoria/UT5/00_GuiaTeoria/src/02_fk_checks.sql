-- 1. Suspendemos la validación de claves foráneas
SET FOREIGN_KEY_CHECKS = 0;

-- 2. Realizamos vaciados (TRUNCATE) o inserciones masivas sin importar el orden
TRUNCATE TABLE ventas;
TRUNCATE TABLE clientes;

-- 3. Volvemos a activar la validación (¡Obligatorio!)
SET FOREIGN_KEY_CHECKS = 1;
