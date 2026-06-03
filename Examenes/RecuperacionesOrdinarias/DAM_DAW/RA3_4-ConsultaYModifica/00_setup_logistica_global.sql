SELECT '>>> Iniciando proceso de carga masiva (Logística 4.0)...' AS Progreso;

DROP DATABASE IF EXISTS logistica_global;
CREATE DATABASE logistica_global CHARACTER SET utf8mb4;
USE logistica_global;

SELECT '>>> Creando estructura de tablas...' AS Progreso;
-- ==========================================
-- 1. TABLA ALMACENES 
-- ==========================================
CREATE TABLE almacenes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cod_almacen VARCHAR(50),
    nombre_sucursal VARCHAR(150),
    ciudad_ubicacion VARCHAR(100),
    capacidad_m3 VARCHAR(50),
    tel_contacto VARCHAR(50),
    tipo_gestion VARCHAR(50),
    ubicacion_geografica VARCHAR(100)
) ENGINE=InnoDB;

-- ==========================================
-- 2. TABLA EMPLEADOS 
-- ==========================================
CREATE TABLE empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nif_nie VARCHAR(50),
    nombre_completo VARCHAR(200),
    email_corp VARCHAR(150),
    f_alta VARCHAR(100),
    puesto_rol VARCHAR(50),
    salario_base_sucio VARCHAR(50),
    num_ss VARCHAR(50),
    almacen_id INT,
    seguro_medico VARCHAR(50),
    activo_boolean VARCHAR(10)
) ENGINE=InnoDB;

-- ==========================================
-- 3. TABLA VEHICULOS 
-- ==========================================
CREATE TABLE vehiculos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    matricula VARCHAR(50),
    marca_modelo VARCHAR(150),
    año_fabricacion VARCHAR(20),
    capacidad_carga_kg VARCHAR(50),
    f_ultima_itv VARCHAR(50),
    estado_vehiculo VARCHAR(30),
    num_bastidor_vin VARCHAR(100),
    coordenadas_gps VARCHAR(100)
) ENGINE=InnoDB;

-- ==========================================
-- 4. TABLA CLIENTES 
-- ==========================================
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cif_nif VARCHAR(50),
    razon_social VARCHAR(200),
    direccion_fiscal TEXT,
    cp_postal VARCHAR(20),
    email_facturacion VARCHAR(150),
    tipo_cliente VARCHAR(50),
    limite_credito_sucio VARCHAR(50),
    fecha_alta_cliente VARCHAR(50),
    activo VARCHAR(10)
) ENGINE=InnoDB;

-- ==========================================
-- 5. TABLA ENVIOS 
-- ==========================================
CREATE TABLE envios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tracking_number VARCHAR(100),
    cliente_id INT,
    vehiculo_id INT,
    empleado_id INT,
    f_salida VARCHAR(100),
    f_llegada_prevista VARCHAR(100),
    f_entrega_real VARCHAR(100),
    peso_kg_bruto VARCHAR(50),
    volumen_m3 VARCHAR(50),
    importe_envio VARCHAR(50),
    seguro_contratado VARCHAR(50),
    estado_envio VARCHAR(50),
    almacen_destino_id INT,
    prioridad VARCHAR(20),
    ruta_origen_ciudad VARCHAR(100),
    ruta_destino_ciudad VARCHAR(100),
    ruta_distancia_km VARCHAR(50),
    ruta_peajes_estimados VARCHAR(50),
    ruta_tiempo_estimado_h VARCHAR(50)
) ENGINE=InnoDB;

-- ==========================================
-- 6. TABLA INCIDENCIAS 
-- ==========================================
CREATE TABLE incidencias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    envio_id INT,
    f_incidencia VARCHAR(50),
    descripcion_breve TEXT,
    coste_asociado_sucio VARCHAR(50),
    responsable_id INT,
    estado_resolucion VARCHAR(50),
    tipo_incidencia VARCHAR(50)
) ENGINE=InnoDB;

-- ==========================================
-- 7. TABLA PROVEEDORES 
-- ==========================================
CREATE TABLE proveedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cif_prov VARCHAR(50),
    nombre_comercial VARCHAR(150),
    tipo_suministro VARCHAR(100),
    tel_emergencias VARCHAR(50),
    email_prov VARCHAR(150),
    condiciones_pago VARCHAR(100),
    valoracion_estrellas VARCHAR(10),
    ultimo_pedido VARCHAR(50)
) ENGINE=InnoDB;

-- ==========================================
-- 8. TABLA MANTENIMIENTOS_FLOTA 
-- ==========================================
CREATE TABLE mantenimientos_flota (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vehiculo_id INT,
    f_mantenimiento VARCHAR(50),
    taller_nombre VARCHAR(150),
    coste_reparacion VARCHAR(50),
    piezas_reemplazadas TEXT,
    proxima_revision_estimada VARCHAR(50)
) ENGINE=InnoDB;

-- =============================================================================
-- GENERADOR DE DATOS MASIVOS (100.000 ENVIOS + 100+ EN EL RESTO)
-- CON 8 FORMATOS DE FECHA ALEATORIOS
-- =============================================================================

DELIMITER //
CREATE PROCEDURE GenerarDatosMasivos()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE fmt VARCHAR(50);
    
    -- Función interna simulada para obtener formato aleatorio
    -- 1: dd/mm/yyyy, 2: dd-mm-yyyy, 3: yyyy-mm-dd, 4: yyyy/mm/dd
    -- 5: dd/mm/yy, 6: dd-mm-yy, 7: yy-mm-dd, 8: yy/mm/dd

    -- 1. Almacenes (200 registros)
    WHILE i < 200 DO
        INSERT INTO almacenes (cod_almacen, nombre_sucursal, ciudad_ubicacion, capacidad_m3, tel_contacto, tipo_gestion, ubicacion_geografica)
        VALUES (
            CONCAT('ALM-', FLOOR(RAND()*999), IF(RAND()>0.5,' ','_')), 
            CONCAT('  Sucursal ', i, '  '),
            ELT(1 + FLOOR(RAND() * 5), 'Madrid', 'Barna', 'VLC', NULL, 'Sevilla '),
            CONCAT(FLOOR(RAND()*10000), IF(RAND()>0.5, ' m3', ' metros cúbicos')),
            CONCAT('+34 ', FLOOR(RAND()*999999999)),
            IF(RAND()>0.5, 'PROPIA', 'subcontrata'),
            CONCAT(RAND()*90, ',', RAND()*180)
        );
        SET i = i + 1;
    END WHILE;

    -- 2. Vehículos (200 registros)
    SET i = 0;
    WHILE i < 200 DO
        INSERT INTO vehiculos (matricula, marca_modelo, año_fabricacion, capacidad_carga_kg, f_ultima_itv, estado_vehiculo)
        VALUES (
            CONCAT(FLOOR(1000+RAND()*8999), ELT(1+FLOOR(RAND()*3), ' ABC', '-DEF', 'GHI')),
            CONCAT('Camioneta ', i),
            CONCAT('Año ', 2000 + FLOOR(RAND()*25)),
            CONCAT(FLOOR(1000+RAND()*5000), 'kg'),
            DATE_FORMAT(DATE_ADD('2024-01-01', INTERVAL i DAY), ELT(1 + FLOOR(RAND() * 8), '%d/%m/%Y', '%d-%m-%Y', '%Y-%m-%d', '%Y/%m/%d', '%d/%m/%y', '%d-%m-%y', '%y-%m-%d', '%y/%m/%d')),
            IF(RAND()>0.5, 'OK', 'TALLER')
        );
        SET i = i + 1;
    END WHILE;

    -- 3. Clientes (500 registros)
    SET i = 0;
    WHILE i < 500 DO
        INSERT INTO clientes (cif_nif, razon_social, limite_credito_sucio, fecha_alta_cliente)
        VALUES (
            CONCAT(ELT(1+FLOOR(RAND()*3), 'A', 'B', 'W'), FLOOR(10000000+RAND()*89999999)),
            CONCAT('Empresa ', i, ' S.L.'),
            CONCAT(FLOOR(RAND()*50000), IF(RAND()>0.5,'€',' USD')),
            DATE_FORMAT(DATE_ADD('2020-01-01', INTERVAL i DAY), ELT(1 + FLOOR(RAND() * 8), '%d/%m/%Y', '%d-%m-%Y', '%Y-%m-%d', '%Y/%m/%d', '%d/%m/%y', '%d-%m-%y', '%y-%m-%d', '%y/%m/%d'))
        );
        SET i = i + 1;
    END WHILE;

    -- 4. Empleados (1000 registros)
    SET i = 0;
    WHILE i < 1000 DO
        INSERT INTO empleados (nif_nie, nombre_completo, email_corp, f_alta, salario_base_sucio, activo_boolean)
        VALUES (
            CONCAT(FLOOR(RAND()*99999999), IF(RAND()>0.5,'A',' B ')), 
            CONCAT('Empleado ', i),
            CONCAT('user', i, IF(RAND()>0.8,'@@','@'), 'logistica.local'),
            DATE_FORMAT(DATE_ADD('2015-01-01', INTERVAL i DAY), ELT(1 + FLOOR(RAND() * 8), '%d/%m/%Y', '%d-%m-%Y', '%Y-%m-%d', '%Y/%m/%d', '%d/%m/%y', '%d-%m-%y', '%y-%m-%d', '%y/%m/%d')),
            CONCAT(ROUND(RAND()*3000, 2), ' EUR'),
            IF(RAND()>0.3, '1', 'NO')
        );
        SET i = i + 1;
    END WHILE;

    -- 5. Envíos (100.000 registros)
    SET i = 0;
    SELECT '>>> Iniciando carga de 100.000 envíos (Esto puede tardar)...' AS Info;
    WHILE i < 100000 DO
        INSERT INTO envios (tracking_number, cliente_id, vehiculo_id, f_salida, f_llegada_prevista, f_entrega_real, importe_envio, ruta_origen_ciudad, ruta_destino_ciudad, ruta_distancia_km)
        VALUES (
            CONCAT('TRK-', FLOOR(RAND()*99999999)),
            FLOOR(1 + RAND() * 500), 
            FLOOR(1 + RAND() * 200),
            DATE_FORMAT(DATE_ADD('2025-01-01', INTERVAL i MINUTE), ELT(1 + FLOOR(RAND() * 8), '%d/%m/%Y', '%d-%m-%Y', '%Y-%m-%d', '%Y/%m/%d', '%d/%m/%y', '%d-%m-%y', '%y-%m-%d', '%y/%m/%d')),
            DATE_FORMAT(DATE_ADD('2025-01-05', INTERVAL i MINUTE), ELT(1 + FLOOR(RAND() * 8), '%d/%m/%Y', '%d-%m-%Y', '%Y-%m-%d', '%Y/%m/%d', '%d/%m/%y', '%d-%m-%y', '%y-%m-%d', '%y/%m/%d')),
            DATE_FORMAT(DATE_ADD('2025-01-06', INTERVAL i MINUTE), ELT(1 + FLOOR(RAND() * 8), '%d/%m/%Y', '%d-%m-%Y', '%Y-%m-%d', '%Y/%m/%d', '%d/%m/%y', '%d-%m-%y', '%y-%m-%d', '%y/%m/%d')),
            CONCAT(ROUND(RAND()*500, 2), '€'),
            ELT(1 + FLOOR(RAND() * 5), 'Madrid', 'Barcelona', 'Valencia', 'Sevilla', 'Bilbao'),
            ELT(1 + FLOOR(RAND() * 5), 'Paris', 'Berlin', 'Lisboa', 'Roma', 'Londres'),
            CONCAT(FLOOR(100 + RAND() * 2000), ' km')
        );
        SET i = i + 1;
        -- Indicador de progreso cada 20.000 registros
        IF i % 20000 = 0 THEN
            SELECT CONCAT('... ', i, ' envíos procesados.') AS Checkpoint;
        END IF;
    END WHILE;

    -- 6. Incidencias (500 registros)
    SET i = 0;
    WHILE i < 500 DO
        INSERT INTO incidencias (envio_id, f_incidencia, descripcion_breve, coste_asociado_sucio)
        VALUES (
            FLOOR(1 + RAND() * 100000),
            DATE_FORMAT(DATE_ADD('2026-03-01', INTERVAL i HOUR), ELT(1 + FLOOR(RAND() * 8), '%d/%m/%Y', '%d-%m-%Y', '%Y-%m-%d', '%Y/%m/%d', '%d/%m/%y', '%d-%m-%y', '%y-%m-%d', '%y/%m/%d')),
            CONCAT('Retraso en entrega ', i),
            CONCAT(FLOOR(RAND()*100), ' pavos')
        );
        SET i = i + 1;
    END WHILE;

    -- 7. Proveedores (200 registros)
    SET i = 0;
    WHILE i < 200 DO
        INSERT INTO proveedores (cif_prov, nombre_comercial, valoracion_estrellas, ultimo_pedido)
        VALUES (
            CONCAT('CIF', i),
            CONCAT('Proveedor ', i),
            CONCAT(FLOOR(RAND()*5), ' *'),
            DATE_FORMAT(DATE_ADD('2024-01-01', INTERVAL i DAY), ELT(1 + FLOOR(RAND() * 8), '%d/%m/%Y', '%d-%m-%Y', '%Y-%m-%d', '%Y/%m/%d', '%d/%m/%y', '%d-%m-%y', '%y-%m-%d', '%y/%m/%d'))
        );
        SET i = i + 1;
    END WHILE;

    -- 8. Mantenimientos (200 registros)
    SET i = 0;
    WHILE i < 200 DO
        INSERT INTO mantenimientos_flota (vehiculo_id, f_mantenimiento, coste_reparacion)
        VALUES (
            FLOOR(1 + RAND() * 200),
            DATE_FORMAT(DATE_ADD('2026-01-01', INTERVAL i DAY), ELT(1 + FLOOR(RAND() * 8), '%d/%m/%Y', '%d-%m-%Y', '%Y-%m-%d', '%Y/%m/%d', '%d/%m/%y', '%d-%m-%y', '%y-%m-%d', '%y/%m/%d')),
            CONCAT(FLOOR(RAND()*1000), ' Euros')
        );
        SET i = i + 1;
    END WHILE;

END //
DELIMITER ;

SELECT '>>> Ejecutando procedimiento GenerarDatosMasivos (100k+ registros)...' AS Progreso;
CALL GenerarDatosMasivos();

UPDATE almacenes SET ubicacion_geografica = CONCAT('Lat: ', ROUND(36 + (RAND(42) * 7), 4), ' | Lon: ', ROUND(-9 + (RAND(42) * 12), 4)) WHERE id > 0;
UPDATE vehiculos SET coordenadas_gps = CONCAT(ROUND(36 + (RAND(42) * 7), 4), ', ', ROUND(-9 + (RAND(42) * 12), 4)) WHERE id > 0;

-- =============================================================================
-- RESTAURACIÓN DE EASTER EGGS (30 REGISTROS ABSURDOS ADAPTADOS)
-- =============================================================================

-- 1-5: Empleados
INSERT INTO empleados (nif_nie, nombre_completo, email_corp, f_alta, salario_base_sucio, puesto_rol, num_ss) VALUES
('00000000X', 'HAL 9000', 'hal@discovery.one', '12/01/1997', 'Electricidad gratis', 'IA Psicópata', '999-ERROR'),
('1-RING-RULE', 'Sauron el Grande', 'ojo@mordor.gov', 'Segunda Edad', '3 almas/mes', 'CEO (Ojo que todo lo ve)', '000-00-0001'),
('99999999L', 'El Doctor', 'doctor@tardis.blue', '1963-11-23', '2000 créditos galácticos', 'Señor del Tiempo', 'TIMELORD-01'),
('C3PO-R2D2', 'C-3PO', 'protocolo@tatooine.es', 'Hace mucho tiempo', 'Aceite de motor', 'Relaciones Humanas-Cyborg', '6-MILLION-FORMS'),
('42424242Z', 'Arthur Dent', 'arthur@hitchhiker.galaxy', 'Jueves', '42 Libras', 'Pasajero en pánico', 'DON-T-PANIC');

-- 6-10: Almacenes (Con columna duplicada ubicacion_geografica)
INSERT INTO almacenes (cod_almacen, nombre_sucursal, ciudad_ubicacion, capacidad_m3, tipo_gestion, ubicacion_geografica) VALUES
('ALM-ALIEN', 'Área 51', 'Nevada', 'Infinita', 'Secreta', '37.2431° N, 115.7930° W'),
('ALM-BERMUDAS', 'Triángulo de las Bermudas', 'Océano', '0 m3', 'Misteriosa', 'Lat: Desconocida'),
('ALM-BAT', 'La Batcueva', 'Gotham', '5000 m3', 'Propia', 'Debajo de la Mansión Wayne'),
('ALM-TUPPER', 'Nevera Oficina', 'Planta 2', '0.05 m3', 'Biohazard', '40.4168, -3.7038'),
('ALM-NARNIA', 'Armario', 'Narnia', 'Reino', 'Monarquía', 'Detrás de los abrigos');

-- 11-15: Vehículos (Con columna duplicada coordenadas_gps)
INSERT INTO vehiculos (matricula, marca_modelo, f_ultima_itv, estado_vehiculo, capacidad_carga_kg, coordenadas_gps) VALUES
('XMAS-2025', 'Trineo Santa', '24/12/2025', 'Mágico', '9 renos/h', 'Polo Norte'),
('OUTATIME', 'DeLorean', '1985', 'Condensador OK', '1.21 GW', '88 mph'),
('FLY-KINTON', 'Nube Kinton', 'Eterna', 'Disponible', 'Pureza', 'Cielo'),
('TARDIS-01', 'Cabina Azul', '1066', 'Grande', 'Vórtice', 'Cualquier lugar'),
('CARPET-01', 'Alfombra', 'Agrabah', 'Aspirada', 'Deseos', 'Cueva de las maravillas');

-- 16-20: Envíos (Estructura desnormalizada con rutas)
INSERT INTO envios (tracking_number, f_salida, importe_envio, peso_kg_bruto, estado_envio, ruta_origen_ciudad, ruta_destino_ciudad) VALUES
('PRECIOUSSS', '3000 BC', 'Alma', '1kg', 'Perdido', 'La Comarca', 'Monte del Destino'),
('CAT-SCHRODINGER', '2026.03.17', '50€', '0.5kg', 'Superposición', 'Caja A', 'Caja B'),
('MILLHOUSE-DIGNITY', '1995', '0.05$', '0.001kg', 'Extraviado', 'Escuela', 'Olvido'),
('TOP-SECRET-BURGER', 'Mañana', '1M$', '0.1kg', 'Robado', 'Cubo de Cebo', 'Krustáceo Krujiente'),
('THE-EX-TEN', 'Examen', 'Un 10.0', 'Incal', 'Concedido', 'Duda', 'Aprobado');

-- 21-25: Incidencias
INSERT INTO incidencias (f_incidencia, descripcion_breve, coste_asociado_sucio, estado_resolucion) VALUES
('2026-03-17', 'Ataque de ganso con cuchillo', '3 piñas', 'Pan dado'),
('0000-00-00', 'Glitch Matrix', 'NULL', 'Gato negro x2'),
('2026.01.01', 'Patitos de goma', '150€', 'Inflado'),
('Ayer', 'Secuestro Bigfoot', 'Modem roto', 'En el bosque'),
('Mañana', 'Paradoja temporal', '-50€', 'No tocar');

-- 26-30: Clientes/Proveedores/Mantenimiento
INSERT INTO clientes (razon_social, cif_nif, tipo_cliente) VALUES ('Tony Stark', 'IRON-MAN', 'Vengador'), ('ACME Corp', 'COYOTE', 'Trampas');
INSERT INTO proveedores (nombre_comercial, tipo_suministro) VALUES ('Ollivanders', 'Varitas');
INSERT INTO mantenimientos_flota (vehiculo_id, taller_nombre, piezas_reemplazadas) VALUES (1, 'Taller de Geppetto', 'Corazón de madera');

-- Modificación quirúrgica
UPDATE empleados SET nombre_completo = 'Don Limpio (El Único Registro Sano)' WHERE id = 500;

-- =============================================================================
-- CORRUPCIÓN QUIRÚRGICA ADICIONAL (NULLS, DUPLICADOS Y HUÉRFANOS)
-- =============================================================================

-- 1. Inyección de NULLs en campos críticos (conceptualmente NOT NULL)
UPDATE empleados SET nif_nie = NULL WHERE id % 100 = 0;
UPDATE vehiculos SET matricula = NULL WHERE id IN (10, 50, 100);
UPDATE clientes SET razon_social = NULL WHERE id = 1;
UPDATE envios SET tracking_number = NULL WHERE id BETWEEN 1000 AND 1010;

-- 2. Duplicación de atributos que deberían ser únicos (cod_almacen)
INSERT INTO almacenes (cod_almacen, nombre_sucursal, ciudad_ubicacion) 
VALUES ('ALM-001', 'Sucursal  A', 'Madrid'),
       ('ALM-001', 'Duplicada B', 'Barcelona');

-- 3. Generación de Huérfanos (FKs que apuntan al vacío)
-- Empleados en almacenes que no existen
UPDATE empleados SET almacen_id = 99999 WHERE id % 50 = 0;

-- Envíos de clientes y vehículos inexistentes
UPDATE envios SET cliente_id = -1 WHERE id BETWEEN 130 AND 140;
UPDATE envios SET vehiculo_id = 0 WHERE id BETWEEN 5000 AND 5050;

-- Incidencias de envíos borrados
UPDATE incidencias SET envio_id = 888888 WHERE id < 20;

-- 4. Datos "Fantasma" (Registros con campos clave vacíos o con espacios)
INSERT INTO clientes (cif_nif, razon_social) VALUES (' ', 'Empresa Espacio S.A.');
INSERT INTO vehiculos (matricula, marca_modelo) VALUES ('', 'Vehículo Fantasma');

SELECT '>>> PROCESO FINALIZADO CON ÉXITO. Datos listos para saneamiento.' AS Estado;
