-- Ejercicio 3: Integridad de Plantilla
-- Archivo: p3_dam.sql

START TRANSACTION;

-- 1. Reasignar empleados huérfanos al almacén con id=1 (Sede Central)
UPDATE empleados e 
LEFT JOIN almacenes a ON e.almacen_id = a.id 
SET e.almacen_id = 1 
WHERE e.almacen_id NOT IN (SELECT id FROM almacenes);

COMMIT;

-- 2. Definir la FOREIGN KEY para evitar que vuelva a ocurrir
ALTER TABLE empleados 
ADD CONSTRAINT fk_empleado_almacen 
FOREIGN KEY (almacen_id) REFERENCES almacenes(id);

