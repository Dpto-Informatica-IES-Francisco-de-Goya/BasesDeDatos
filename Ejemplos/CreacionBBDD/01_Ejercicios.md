## Ejemplos:

### 3. Ejercicios Prácticos de Implementación

Dado que los alumnos ya disponen de modelos relacionales, estos ejercicios se enfocan estrictamente en la sintaxis, el descubrimiento de errores y la modificación de estructuras (evitando crear modelos desde cero).

### Ejercicio 1: Auditoría de Sintaxis y Refactorización

**Contexto:** Un desarrollador junior ha entregado el siguiente script que funciona, pero incumple todos los estándares de buenas prácticas de administración de bases de datos.

```sql
CREATE TABLE vehiculos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    matricula VARCHAR(10) UNIQUE,
    tipo VARCHAR(50),
    precio FLOAT,
    fecha_compra TIMESTAMP
);
```

**Tarea:**

1. Reescribir el `CREATE TABLE` aplicando tipos de datos estrictos (la matrícula tiene formato fijo, el precio es dinero, la fecha no necesita zonas horarias).
    
    

### Ejercicio 2: Scripting Modular y Dependencias Circulares

**Contexto:** Tienes dos entidades: `investigador` y `laboratorio`. Un laboratorio es dirigido por un investigador (FK de laboratorio a investigador), y un investigador trabaja en un laboratorio principal (FK de investigador a laboratorio).

**Tarea:**

1. Generar un script SQL estructurado que permita la creación de ambas tablas de forma exitosa. 
2. Todas las restricciones deben estar debidamente nombradas.
3. El script debe incluir una cabecera `DROP TABLE IF EXISTS...` en el orden correcto para poder ejecutarse de forma iterativa en la terminal de Linux sin generar errores.

### Ejemplo 3: Creación BBDD completa (Ejercicio de hacer en clase que se corrige automático)

Crea en MySQL la base de datos de este esquema relacional.

**Tabla: `empleados`**

| **Campo** | **Tipo** | Restricciones | **Restricciones** |
| --- | --- | --- | --- |
| **id_empleado** | Numérico | PK | AUTO_INCREMENT |
| **dni** | Cadena | UNIQUE | Obligatorio |
| **salario** | Número decimal |  | Por defecto, 1200.00 |
| **estado** |  |  | 'ACTIVO', 'INACTIVO' (Default: 'ACTIVO') |

**Tabla: `proyectos`**

| **Campo** | **Tipo** | **Clave** | **Atributos / Restricciones** |
| --- | --- | --- | --- |
| **id_proyecto** | Numérico | PK | AUTO_INCREMENT |
| **nombre** | Cadena | Único | Obligatorio |
| **id_departamento** | Numérico | FK, Obligatorio | (Ref: `departamentos`) |
| **fecha_inicio** | Fecha | Obligatorio |  |
| **fecha_fin** | Fecha |  | NULL o > fecha_inicio |

**Tabla: `asignaciones`**

| **Campo** | **Tipo** | **Clave** | **Atributos / Restricciones** |
| --- | --- | --- | --- |
| **id_empleado** | Numérico | PK, FK | Ref: `empleados` (ON DELETE CASCADE) |
| **id_proyecto** | Numérico | PK, FK | Ref: `proyectos` (ON DELETE CASCADE) |
| **horas_asignadas** | Numérico |  | DEFAULT 0 |

**Tabla: `departamentos`**

| **Campo** | **Tipo** | **Clave** | **Atributos / Restricciones** |
| --- | --- | --- | --- |
| **id_departamento** | Numérico | PK | AUTO_INCREMENT |
| **codigo_dpto** | Cadena | Único, obligatorio | Todos tienen 5 caracteres |
| **nombre** | Cadena |  | Obligatorio |
| **presupuesto** | Número decimal |  | Obligatorio. No puede ser negativo. |
- Solución
    
    ```sql
    DROP DATABASE IF EXISTS gestion_proyectos;
    CREATE DATABASE gestion_proyectos;
    USE gestion_proyectos;
    
    -- 1. Tabla: departamentos (No tiene dependencias)
    CREATE TABLE departamentos (
        id_departamento INT AUTO_INCREMENT PRIMARY KEY,
        codigo_dpto CHAR(5) UNIQUE NOT NULL,
        nombre VARCHAR(100) NOT NULL,
        presupuesto DECIMAL(10,2) NOT NULL,
        CONSTRAINT chk_presupuesto_positivo CHECK (presupuesto >= 0)
    );
    
    -- 2. Tabla: empleados (No tiene dependencias)
    CREATE TABLE empleados (
        id_empleado INT AUTO_INCREMENT PRIMARY KEY,
        dni VARCHAR(15) UNIQUE NOT NULL,
        salario DECIMAL(10,2) DEFAULT 1200.00,
        estado ENUM('ACTIVO', 'INACTIVO') DEFAULT 'ACTIVO'
    );
    
    -- 3. Tabla: proyectos (Depende de departamentos)
    CREATE TABLE proyectos (
        id_proyecto INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) UNIQUE NOT NULL,
        id_departamento INT NOT NULL,
        fecha_inicio DATE NOT NULL,
        fecha_fin DATE,
        CONSTRAINT fk_proyectos_departamentos 
            FOREIGN KEY (id_departamento) 
            REFERENCES departamentos(id_departamento),
        CONSTRAINT chk_fechas_proyecto 
            CHECK (fecha_fin IS NULL OR fecha_fin > fecha_inicio)
    );
    
    -- 4. Tabla: asignaciones (Depende de empleados y proyectos)
    CREATE TABLE asignaciones (
        id_empleado INT,
        id_proyecto INT,
        horas_asignadas INT DEFAULT 0,
        PRIMARY KEY (id_empleado, id_proyecto),
        CONSTRAINT fk_asignaciones_empleados 
            FOREIGN KEY (id_empleado) 
            REFERENCES empleados(id_empleado) ON DELETE CASCADE,
        CONSTRAINT fk_asignaciones_proyectos 
            FOREIGN KEY (id_proyecto) 
            REFERENCES proyectos(id_proyecto) ON DELETE CASCADE
    );
    ```
    
- Script de prueba
    
    ```sql
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
    ```
    
- Script de corrección
    
    ```sql
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
    ```
    

## Práctica

- Enunciado:
    
    [Práctica Creación BBDD](https://www.notion.so/Pr-ctica-Creaci-n-BBDD-3109472decc78019ad7fe60b40ee7bf2?pvs=21)
    
- Solución

```sql
DROP DATABASE IF EXISTS gestion_universidad;
CREATE DATABASE gestion_universidad;
USE gestion_universidad;

-- 1. Tabla: facultades (Se crea sin la FK a decano inicialmente para romper el ciclo)
CREATE TABLE facultades (
    id_facultad INT AUTO_INCREMENT PRIMARY KEY,
    codigo CHAR(4) UNIQUE NOT NULL,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    id_decano INT
);

-- 2. Tabla: profesores (Depende de facultades)
CREATE TABLE profesores (
    id_profesor INT AUTO_INCREMENT PRIMARY KEY,
    nif CHAR(9) UNIQUE NOT NULL,
    nombre_completo VARCHAR(150) NOT NULL,
    salario DECIMAL(10,2) DEFAULT 2000.00,
    id_facultad INT NOT NULL,
    CONSTRAINT chk_salario_positivo CHECK (salario > 0),
    CONSTRAINT fk_profesores_facultades 
        FOREIGN KEY (id_facultad) 
        REFERENCES facultades(id_facultad)
);

-- 3. Alterar facultades para añadir la FK circular a profesores
ALTER TABLE facultades
    ADD CONSTRAINT fk_facultades_decano 
    FOREIGN KEY (id_decano) 
    REFERENCES profesores(id_profesor);

-- 4. Tabla: grados (Depende de facultades)
CREATE TABLE grados (
    id_grado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    id_facultad INT NOT NULL,
    CONSTRAINT fk_grados_facultades 
        FOREIGN KEY (id_facultad) 
        REFERENCES facultades(id_facultad)
);

-- 5. Tabla: asignaturas (No tiene dependencias foráneas directas en este esquema simplificado, podría depender de grados)
CREATE TABLE asignaturas (
    id_asignatura INT AUTO_INCREMENT PRIMARY KEY,
    codigo_asig VARCHAR(10) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    creditos INT DEFAULT 6,
    CONSTRAINT chk_creditos_minimos CHECK (creditos >= 3)
);

-- 6. Tabla: imparten (Depende de profesores y asignaturas)
CREATE TABLE imparten (
    id_profesor INT,
    id_asignatura INT,
    tipo_grupo ENUM('TEORIA', 'PRACTICA') DEFAULT 'TEORIA',
    PRIMARY KEY (id_profesor, id_asignatura),
    CONSTRAINT fk_imparten_profesores 
        FOREIGN KEY (id_profesor) 
        REFERENCES profesores(id_profesor) ON DELETE CASCADE,
    CONSTRAINT fk_imparten_asignaturas 
        FOREIGN KEY (id_asignatura) 
        REFERENCES asignaturas(id_asignatura) ON DELETE CASCADE
);
```

- Corrección

```sql
USE gestion_universidad;

-- Forzamos el modo estricto para asegurar que MySQL no silencie errores de truncamiento o ENUMs
SET SESSION sql_mode = 'STRICT_ALL_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DELIMITER //

DROP PROCEDURE IF EXISTS TestRestriccionesCompletas //

CREATE PROCEDURE TestRestriccionesCompletas()
BEGIN
    -- ========================================================================
    -- FASE 0: LIMPIEZA DEL ENTORNO
    -- ========================================================================
    -- Rompemos la dependencia circular antes de borrar para evitar errores de FK
    UPDATE facultades SET id_decano = NULL;
    
    DELETE FROM imparten;
    DELETE FROM asignaturas;
    DELETE FROM grados;
    DELETE FROM profesores;
    DELETE FROM facultades;

    -- ========================================================================
    -- FASE 1: INSERCIONES VÁLIDAS (COMPROBACIÓN DEL "HAPPY PATH")
    -- ========================================================================
    
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @err_msg = MESSAGE_TEXT;
            SELECT CONCAT('❌ ERROR CRÍTICO [Válido - Facultad]: Falló inserción. Detalle: ', @err_msg) AS 'Resultado';
        END;
        INSERT INTO facultades (id_facultad, codigo, nombre) VALUES (1, 'INFO', 'Facultad de Informática');
        SELECT '✅ ÉXITO [Válido - Facultad]: Registro base insertado correctamente.' AS 'Resultado';
    END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @err_msg = MESSAGE_TEXT;
            SELECT CONCAT('❌ ERROR CRÍTICO [Válido - Profesor]: Falló inserción. Detalle: ', @err_msg) AS 'Resultado';
        END;
        INSERT INTO profesores (id_profesor, nif, nombre_completo, salario, id_facultad) 
        VALUES (1, '12345678A', 'Alan Turing', 2500.00, 1);
        SELECT '✅ ÉXITO [Válido - Profesor]: Registro base insertado correctamente.' AS 'Resultado';
    END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @err_msg = MESSAGE_TEXT;
            SELECT CONCAT('❌ ERROR CRÍTICO [Válido - Update Decano]: Falló la actualización de la FK circular. Detalle: ', @err_msg) AS 'Resultado';
        END;
        UPDATE facultades SET id_decano = 1 WHERE id_facultad = 1;
        SELECT '✅ ÉXITO [Válido - Update Decano]: Dependencia circular establecida correctamente.' AS 'Resultado';
    END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @err_msg = MESSAGE_TEXT;
            SELECT CONCAT('❌ ERROR CRÍTICO [Válido - Asignatura]: Falló inserción. Detalle: ', @err_msg) AS 'Resultado';
        END;
        INSERT INTO asignaturas (id_asignatura, codigo_asig, nombre, creditos) 
        VALUES (1, 'BBDD-01', 'Bases de Datos', 6);
        SELECT '✅ ÉXITO [Válido - Asignatura]: Registro base insertado correctamente.' AS 'Resultado';
    END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @err_msg = MESSAGE_TEXT;
            SELECT CONCAT('❌ ERROR CRÍTICO [Válido - Imparten]: Falló inserción. Detalle: ', @err_msg) AS 'Resultado';
        END;
        INSERT INTO imparten (id_profesor, id_asignatura, tipo_grupo) VALUES (1, 1, 'TEORIA');
        SELECT '✅ ÉXITO [Válido - Imparten]: Registro base insertado correctamente.' AS 'Resultado';
    END;

    -- ========================================================================
    -- FASE 2: TESTS DE RESTRICCIONES (SE ESPERA QUE FALLEN Y LANCES EXCEPCIÓN)
    -- ========================================================================

    -- TESTS DE FACULTADES
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @err_msg = MESSAGE_TEXT;
            SELECT CONCAT('✅ ÉXITO [Test UNIQUE Facultad]: Bloqueó duplicado. (', @err_msg, ')') AS 'Resultado';
        END;
        INSERT INTO facultades (codigo, nombre) VALUES ('INFO', 'Otra Facultad');
        SELECT '❌ ERROR [Test UNIQUE Facultad]: Se permitió duplicar el código (INFO).' AS 'Resultado';
    END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @err_msg = MESSAGE_TEXT;
            SELECT CONCAT('✅ ÉXITO [Test FK Facultad]: Bloqueó decano inexistente. (', @err_msg, ')') AS 'Resultado';
        END;
        INSERT INTO facultades (codigo, nombre, id_decano) VALUES ('MAT', 'Matemáticas', 999);
        SELECT '❌ ERROR [Test FK Facultad]: Se permitió insertar un id_decano que no existe en profesores.' AS 'Resultado';
    END;

    -- TESTS DE PROFESORES
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @err_msg = MESSAGE_TEXT;
            SELECT CONCAT('✅ ÉXITO [Test UNIQUE Profesor]: Bloqueó NIF duplicado. (', @err_msg, ')') AS 'Resultado';
        END;
        INSERT INTO profesores (nif, nombre_completo, id_facultad) VALUES ('12345678A', 'Grace Hopper', 1);
        SELECT '❌ ERROR [Test UNIQUE Profesor]: Se permitió un NIF duplicado (12345678A).' AS 'Resultado';
    END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @err_msg = MESSAGE_TEXT;
            SELECT CONCAT('✅ ÉXITO [Test NOT NULL Profesor]: Bloqueó facultad nula. (', @err_msg, ')') AS 'Resultado';
        END;
        INSERT INTO profesores (nif, nombre_completo, id_facultad) VALUES ('87654321B', 'Grace Hopper', NULL);
        SELECT '❌ ERROR [Test NOT NULL Profesor]: Se permitió id_facultad NULL.' AS 'Resultado';
    END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @err_msg = MESSAGE_TEXT;
            SELECT CONCAT('✅ ÉXITO [Test CHECK Profesor]: Bloqueó salario 0 o negativo. (', @err_msg, ')') AS 'Resultado';
        END;
        INSERT INTO profesores (nif, nombre_completo, salario, id_facultad) VALUES ('87654321B', 'Grace Hopper', 0.00, 1);
        SELECT '❌ ERROR [Test CHECK Profesor]: Se permitió salario <= 0.' AS 'Resultado';
    END;

    -- TESTS DE ASIGNATURAS
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @err_msg = MESSAGE_TEXT;
            SELECT CONCAT('✅ ÉXITO [Test UNIQUE Asignatura]: Bloqueó código duplicado. (', @err_msg, ')') AS 'Resultado';
        END;
        INSERT INTO asignaturas (codigo_asig, nombre) VALUES ('BBDD-01', 'Bases de Datos Avanzadas');
        SELECT '❌ ERROR [Test UNIQUE Asignatura]: Se permitió codigo_asig duplicado.' AS 'Resultado';
    END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @err_msg = MESSAGE_TEXT;
            SELECT CONCAT('✅ ÉXITO [Test CHECK Asignatura]: Bloqueó créditos insuficientes. (', @err_msg, ')') AS 'Resultado';
        END;
        INSERT INTO asignaturas (codigo_asig, nombre, creditos) VALUES ('PROG-01', 'Programación', 2);
        SELECT '❌ ERROR [Test CHECK Asignatura]: Se permitieron menos de 3 créditos.' AS 'Resultado';
    END;

    -- TESTS DE IMPARTEN
    BEGIN
        -- Capturamos el error específico de ENUM (Data truncated / Data too long) y cualquier otra excepción
        DECLARE EXIT HANDLER FOR 1265, SQLEXCEPTION 
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @err_msg = MESSAGE_TEXT;
            SELECT CONCAT('✅ ÉXITO [Test ENUM Imparten]: Bloqueó tipo_grupo inválido. (', @err_msg, ')') AS 'Resultado';
        END;
        INSERT INTO imparten (id_profesor, id_asignatura, tipo_grupo) VALUES (1, 1, 'SEMINARIO');
        SELECT '❌ ERROR [Test ENUM Imparten]: Se permitió un tipo de grupo fuera del ENUM.' AS 'Resultado';
    END;

    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @err_msg = MESSAGE_TEXT;
            SELECT CONCAT('✅ ÉXITO [Test PK Imparten]: Bloqueó asignación duplicada. (', @err_msg, ')') AS 'Resultado';
        END;
        -- Intentamos insertar la misma combinación que se insertó en la Fase 1
        INSERT INTO imparten (id_profesor, id_asignatura, tipo_grupo) VALUES (1, 1, 'PRACTICA');
        SELECT '❌ ERROR [Test PK Imparten]: Se permitió duplicar la PK compuesta (profesor 1, asignatura 1).' AS 'Resultado';
    END;

END //

DELIMITER ;

-- Ejecución del script de corrección
CALL TestRestriccionesCompletas();
```
