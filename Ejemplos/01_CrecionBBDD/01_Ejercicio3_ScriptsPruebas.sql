USE gestion_proyectos;

-- ========================================================================
-- FASE 1: DATOS VÁLIDOS (Línea base)
-- ========================================================================
-- Insertamos departamentos
INSERT INTO departamentos (codigo_dpto, nombre, presupuesto) VALUES 
('DP001', 'Desarrollo Web', 50000.00),
('DP002', 'Sistemas y Redes', 35000.00);

-- Insertamos empleados (incluyendo prueba del valor por defecto en salario y estado)
INSERT INTO empleados (dni, salario, estado) VALUES 
('11111111A', 1500.00, 'ACTIVO'),
('22222222B', 2000.00, 'INACTIVO');

-- Prueba de DEFAULT en empleados: No pasamos salario ni estado. 
-- Debería insertar: Salario 1200.00, Estado 'ACTIVO'
INSERT INTO empleados (dni) VALUES ('33333333C'); 

-- Insertamos proyectos (incluyendo prueba de fecha_fin a NULL)
INSERT INTO proyectos (nombre, id_departamento, fecha_inicio, fecha_fin) VALUES 
('Migración Proxmox', 2, '2026-03-01', '2026-12-31'),
('Frontend Portal', 1, '2026-04-01', NULL);

-- Asignaciones válidas (probando el DEFAULT de horas_asignadas = 0)
INSERT INTO asignaciones (id_empleado, id_proyecto) VALUES (1, 1);
INSERT INTO asignaciones (id_empleado, id_proyecto, horas_asignadas) VALUES (2, 2, 40);


-- ========================================================================
-- FASE 2: CASOS LÍMITE Y VIOLACIÓN DE RESTRICCIONES (Deben dar ERROR)
-- ========================================================================

-- --- 2.1. Tabla: departamentos ---

-- ERROR: Violación de CHECK (presupuesto negativo)
INSERT INTO departamentos (codigo_dpto, nombre, presupuesto) VALUES ('DP003', 'Marketing', -500.00);

-- ERROR: Violación de UNIQUE (código de departamento ya existe)
INSERT INTO departamentos (codigo_dpto, nombre, presupuesto) VALUES ('DP001', 'Ventas', 10000.00);

-- ERROR: Violación de NOT NULL (nombre vacío)
INSERT INTO departamentos (codigo_dpto, nombre, presupuesto) VALUES ('DP004', NULL, 5000.00);

-- ATENCIÓN (Depende del sql_mode): Truncado o Error (código > 5 caracteres)
INSERT INTO departamentos (codigo_dpto, nombre, presupuesto) VALUES ('DP0005', 'RRHH', 5000.00);


-- --- 2.2. Tabla: empleados ---

-- ERROR: Violación de UNIQUE (DNI duplicado)
INSERT INTO empleados (dni, salario) VALUES ('11111111A', 1300.00);

-- ERROR: Violación de ENUM (estado no permitido)
INSERT INTO empleados (dni, salario, estado) VALUES ('44444444D', 1400.00, 'VACACIONES');


-- --- 2.3. Tabla: proyectos ---

-- ERROR: Violación de CHECK (fecha_fin anterior a fecha_inicio)
INSERT INTO proyectos (nombre, id_departamento, fecha_inicio, fecha_fin) VALUES 
('Auditoría', 2, '2026-05-01', '2026-04-30');

-- ERROR: Violación de CHECK (fecha_fin igual a fecha_inicio)
INSERT INTO proyectos (nombre, id_departamento, fecha_inicio, fecha_fin) VALUES 
('Despliegue Rápido', 1, '2026-06-01', '2026-06-01');

-- ERROR: Violación de Clave Foránea (FK - Departamento inexistente)
INSERT INTO proyectos (nombre, id_departamento, fecha_inicio) VALUES 
('Proyecto Fantasma', 99, '2026-06-01');


-- --- 2.4. Tabla: asignaciones ---

-- ERROR: Violación de Clave Primaria (Registro duplicado id_empleado + id_proyecto)
INSERT INTO asignaciones (id_empleado, id_proyecto, horas_asignadas) VALUES (1, 1, 20);

-- ERROR: Violación de Clave Foránea (Empleado inexistente)
INSERT INTO asignaciones (id_empleado, id_proyecto) VALUES (99, 1);


-- ========================================================================
-- FASE 3: PRUEBAS DE BORRADO (CASCADE vs RESTRICT)
-- ========================================================================

-- ERROR: Violación de FK por defecto (RESTRICT). 
-- No se puede borrar el departamento 2 porque tiene el proyecto 1 asociado.
DELETE FROM departamentos WHERE id_departamento = 2;

-- ÉXITO: Borrado en Cascada (ON DELETE CASCADE).
-- Al borrar el empleado 1, se borrará automáticamente su registro en la tabla 'asignaciones'.
DELETE FROM empleados WHERE id_empleado = 1;

-- Comprobación final de la cascada (la asignación 1,1 ya no debe existir)
-- Comprobación automática de la cascada
SELECT 
    IF(COUNT(*) = 0, 
       '✅ ÉXITO: Borrado en cascada verificado. La asignación ha desaparecido.', 
       '❌ ERROR: Fallo en la cascada. El registro huérfano sigue existiendo.'
    ) AS 'Resultado_Test_Cascada'
FROM asignaciones 
WHERE id_empleado = 1;