-- Ejercicio 1: Gestión de Costes de Flota
ALTER TABLE mantenimientos_flota ADD COLUMN coste_eur DECIMAL(10,2) AFTER coste_reparacion;

START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;

-- Limpieza de la columna coste_reparacion (ej: '450 Euros')
UPDATE mantenimientos_flota 
SET coste_reparacion = TRIM(REPLACE(coste_reparacion, ' Euros', ''));

SAVEPOINT antes_de_iva;

-- Aplicamos 21% de IVA
UPDATE mantenimientos_flota SET coste_eur = ROUND(CAST(coste_reparacion AS DECIMAL(10,2)) * 1.21, 2);

-- Deshacemos hasta el savepoint
ROLLBACK TO SAVEPOINT antes_de_iva;

-- Aplicamos 10% de IVA
UPDATE mantenimientos_flota SET coste_eur = ROUND(CAST(coste_reparacion AS DECIMAL(10,2)) * 1.10, 2);

COMMIT;
SET SQL_SAFE_UPDATES = 1;

-- Verificación
SELECT coste_reparacion, coste_eur FROM mantenimientos_flota LIMIT 5;
