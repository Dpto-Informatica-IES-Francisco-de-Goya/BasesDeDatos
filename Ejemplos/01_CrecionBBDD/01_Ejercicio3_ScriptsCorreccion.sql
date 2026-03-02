USE gestion_proyectos;

-- Forzamos el modo estricto para que los truncamientos (ej. CHAR > 5) y ENUMs inválidos lancen error y no simples warnings
SET SESSION sql_mode = 'STRICT_ALL_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DELIMITER //

DROP PROCEDURE IF EXISTS TestRestriccionesCompletas //

CREATE PROCEDURE TestRestriccionesCompletas()
BEGIN
    -- ========================================================================
    -- FASE 0: PREPARACIÓN DEL ENTORNO (Datos base para probar UNIQUE y FK)
    -- ========================================================================
    -- Vaciamos tablas previas por si el script se lanza varias veces
    DELETE FROM asignaciones;
    DELETE FROM proyectos;
    DELETE FROM empleados;
    DELETE FROM departamentos;

    -- Insertamos 1 registro válido por tabla
    INSERT INTO departamentos (id_departamento, codigo_dpto, nombre, presupuesto) 
    VALUES (1, 'DP001', 'Sistemas', 10000.00);
    
    INSERT INTO empleados (id_empleado, dni, salario, estado) 
    VALUES (1, '12345678A', 1500.00, 'ACTIVO');
    
    INSERT INTO proyectos (id_proyecto, nombre, id_departamento, fecha_inicio, fecha_fin) 
    VALUES (1, 'Migración Linux', 1, '2026-01-01', '2026-12-31');

    -- ========================================================================
    -- FASE 1: TESTS DE DEPARTAMENTOS
    -- ========================================================================
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT '✅ ÉXITO [Dept]: UNIQUE bloqueó código duplicado.' AS 'Resultado';
        INSERT INTO departamentos (codigo_dpto, nombre, presupuesto) VALUES ('DP001', 'Redes', 5000.00);
        SELECT '❌ ERROR [Dept]: Se permitió duplicar codigo_dpto.' AS 'Resultado';
    END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT '✅ ÉXITO [Dept]: NOT NULL bloqueó código nulo.' AS 'Resultado';
        INSERT INTO departamentos (codigo_dpto, nombre, presupuesto) VALUES (NULL, 'Redes', 5000.00);
        SELECT '❌ ERROR [Dept]: Se permitió insertar codigo_dpto NULL.' AS 'Resultado';
    END;

BEGIN
    -- Capturamos específicamente el error 1265 o cualquier condición de error
    DECLARE EXIT HANDLER FOR 1265 SELECT '✅ ÉXITO [Emp]: ENUM bloqueó estado inválido.' AS 'Resultado';
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT '✅ ÉXITO [Emp]: ENUM bloqueó estado inválido.' AS 'Resultado';
    
    INSERT INTO empleados (dni, estado) VALUES ('87654321B', 'JUBILADO');
    SELECT '❌ ERROR [Emp]: Se permitió un estado fuera del ENUM.' AS 'Resultado';
END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT '✅ ÉXITO [Dept]: NOT NULL bloqueó nombre nulo.' AS 'Resultado';
        INSERT INTO departamentos (codigo_dpto, nombre, presupuesto) VALUES ('DP002', NULL, 5000.00);
        SELECT '❌ ERROR [Dept]: Se permitió insertar nombre NULL.' AS 'Resultado';
    END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT '✅ ÉXITO [Dept]: CHECK bloqueó presupuesto negativo.' AS 'Resultado';
        INSERT INTO departamentos (codigo_dpto, nombre, presupuesto) VALUES ('DP002', 'Redes', -100.00);
        SELECT '❌ ERROR [Dept]: Se permitió presupuesto negativo.' AS 'Resultado';
    END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT '✅ ÉXITO [Dept]: NOT NULL bloqueó presupuesto nulo.' AS 'Resultado';
        INSERT INTO departamentos (codigo_dpto, nombre, presupuesto) VALUES ('DP002', 'Redes', NULL);
        SELECT '❌ ERROR [Dept]: Se permitió presupuesto NULL.' AS 'Resultado';
    END;

    -- ========================================================================
    -- FASE 2: TESTS DE EMPLEADOS
    -- ========================================================================
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT '✅ ÉXITO [Emp]: UNIQUE bloqueó DNI duplicado.' AS 'Resultado';
        INSERT INTO empleados (dni) VALUES ('12345678A');
        SELECT '❌ ERROR [Emp]: Se permitió DNI duplicado.' AS 'Resultado';
    END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT '✅ ÉXITO [Emp]: NOT NULL bloqueó DNI nulo.' AS 'Resultado';
        INSERT INTO empleados (dni) VALUES (NULL);
        SELECT '❌ ERROR [Emp]: Se permitió DNI NULL.' AS 'Resultado';
    END;

    BEGIN
        -- Este handler captura el error de truncamiento específicamente
        DECLARE EXIT HANDLER FOR 1265 
            SELECT '✅ ÉXITO [Emp]: ENUM bloqueó estado inválido.' AS 'Resultado';
        -- Por si acaso, mantenemos el de SQLEXCEPTION
        DECLARE EXIT HANDLER FOR SQLEXCEPTION 
            SELECT '✅ ÉXITO [Emp]: ENUM bloqueó estado inválido.' AS 'Resultado';

        INSERT INTO empleados (dni, estado) VALUES ('87654321B', 'JUBILADO');
        SELECT '❌ ERROR [Emp]: Se permitió un estado fuera del ENUM.' AS 'Resultado';
    END;
    -- ========================================================================
    -- FASE 3: TESTS DE PROYECTOS
    -- ========================================================================
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT '✅ ÉXITO [Proy]: UNIQUE bloqueó nombre duplicado.' AS 'Resultado';
        INSERT INTO proyectos (nombre, id_departamento, fecha_inicio) VALUES ('Migración Linux', 1, '2026-02-01');
        SELECT '❌ ERROR [Proy]: Se permitió nombre duplicado en proyecto.' AS 'Resultado';
    END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT '✅ ÉXITO [Proy]: NOT NULL bloqueó nombre nulo.' AS 'Resultado';
        INSERT INTO proyectos (nombre, id_departamento, fecha_inicio) VALUES (NULL, 1, '2026-02-01');
        SELECT '❌ ERROR [Proy]: Se permitió nombre NULL en proyecto.' AS 'Resultado';
    END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT '✅ ÉXITO [Proy]: FK bloqueó id_departamento inexistente.' AS 'Resultado';
        INSERT INTO proyectos (nombre, id_departamento, fecha_inicio) VALUES ('Nuevo Proy', 99, '2026-02-01');
        SELECT '❌ ERROR [Proy]: Se permitió asignar un proyecto a un departamento que no existe.' AS 'Resultado';
    END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT '✅ ÉXITO [Proy]: NOT NULL bloqueó id_departamento nulo.' AS 'Resultado';
        INSERT INTO proyectos (nombre, id_departamento, fecha_inicio) VALUES ('Nuevo Proy', NULL, '2026-02-01');
        SELECT '❌ ERROR [Proy]: Se permitió id_departamento NULL.' AS 'Resultado';
    END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT '✅ ÉXITO [Proy]: NOT NULL bloqueó fecha_inicio nula.' AS 'Resultado';
        INSERT INTO proyectos (nombre, id_departamento, fecha_inicio) VALUES ('Nuevo Proy', 1, NULL);
        SELECT '❌ ERROR [Proy]: Se permitió fecha_inicio NULL.' AS 'Resultado';
    END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT '✅ ÉXITO [Proy]: CHECK bloqueó fecha_fin anterior a inicio.' AS 'Resultado';
        INSERT INTO proyectos (nombre, id_departamento, fecha_inicio, fecha_fin) 
        VALUES ('Nuevo Proy', 1, '2026-06-01', '2026-05-31');
        SELECT '❌ ERROR [Proy]: Se permitió fecha_fin anterior a fecha_inicio.' AS 'Resultado';
    END;

    -- ========================================================================
    -- FASE 4: TESTS DE ASIGNACIONES
    -- ========================================================================
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT '✅ ÉXITO [Asig]: PK bloqueó asignación duplicada.' AS 'Resultado';
        INSERT INTO asignaciones (id_empleado, id_proyecto) VALUES (1, 1);
        INSERT INTO asignaciones (id_empleado, id_proyecto) VALUES (1, 1);
        SELECT '❌ ERROR [Asig]: Se permitió duplicar la PK compuesta (mismo empleado y proyecto).' AS 'Resultado';
    END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT '✅ ÉXITO [Asig]: FK bloqueó empleado inexistente.' AS 'Resultado';
        INSERT INTO asignaciones (id_empleado, id_proyecto) VALUES (99, 1);
        SELECT '❌ ERROR [Asig]: Se permitió asignar un empleado inexistente.' AS 'Resultado';
    END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT '✅ ÉXITO [Asig]: FK bloqueó proyecto inexistente.' AS 'Resultado';
        INSERT INTO asignaciones (id_empleado, id_proyecto) VALUES (1, 99);
        SELECT '❌ ERROR [Asig]: Se permitió asignar un proyecto inexistente.' AS 'Resultado';
    END;

END //

DELIMITER ;

-- Ejecución
CALL TestRestriccionesCompletas();