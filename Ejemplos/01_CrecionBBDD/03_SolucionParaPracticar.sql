DROP DATABASE IF EXISTS taller_autorepair;
CREATE DATABASE taller_autorepair;
USE taller_autorepair;

-- 1. Entidad Generalizada: personas
CREATE TABLE personas (
    id_persona INT AUTO_INCREMENT,
    dni VARCHAR(9) NOT NULL,
    nombre_completo VARCHAR(150) NOT NULL,
    email VARCHAR(100) NOT NULL,
    CONSTRAINT pk_personas PRIMARY KEY (id_persona),
    CONSTRAINT uq_personas_dni UNIQUE (dni),
    CONSTRAINT uq_personas_email UNIQUE (email),
    CONSTRAINT chk_personas_dni CHECK (CHAR_LENGTH(dni) = 9),
    CONSTRAINT chk_personas_email CHECK (email LIKE '%@%')
);

-- 2. Entidad Especializada: empleados (Reflexivas de jerarquía y pareja)
CREATE TABLE empleados (
    id_persona INT NOT NULL,
    num_ss VARCHAR(20) NOT NULL,
    capacitaciones SET('MOTOR', 'CHAPA', 'PINTURA', 'ELECTRICIDAD') NULL,
    id_jefe INT NULL,
    id_pareja_asignada INT NOT NULL,
    CONSTRAINT pk_empleados PRIMARY KEY (id_persona),
    CONSTRAINT uq_empleados_num_ss UNIQUE (num_ss),
    CONSTRAINT fk_empleados_personas FOREIGN KEY (id_persona) REFERENCES personas(id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_empleados_empleados_jefe FOREIGN KEY (id_jefe) REFERENCES empleados(id_persona) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_empleados_empleados_pareja FOREIGN KEY (id_pareja_asignada) REFERENCES empleados(id_persona) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 3. Entidad Especializada: clientes
CREATE TABLE clientes (
    id_persona INT NOT NULL,
    tipo_cliente ENUM('PARTICULAR', 'EMPRESA', 'FLOTA') NOT NULL,
    limite_credito DECIMAL(10,2) DEFAULT 0.00,
    CONSTRAINT pk_clientes PRIMARY KEY (id_persona),
    CONSTRAINT fk_clientes_personas FOREIGN KEY (id_persona) REFERENCES personas(id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_clientes_credito CHECK (limite_credito >= 0)
);

-- 4. Tabla: vehiculos
CREATE TABLE vehiculos (
    id_vehiculo INT AUTO_INCREMENT,
    matricula VARCHAR(7) NOT NULL,
    id_cliente INT NOT NULL,
    CONSTRAINT pk_vehiculos PRIMARY KEY (id_vehiculo),
    CONSTRAINT uq_vehiculos_matricula UNIQUE (matricula),
    CONSTRAINT fk_vehiculos_clientes FOREIGN KEY (id_cliente) REFERENCES clientes(id_persona) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_vehiculos_matricula CHECK (CHAR_LENGTH(matricula) = 7)
);

-- 5. Tabla: reparaciones
CREATE TABLE reparaciones (
    id_reparacion INT AUTO_INCREMENT,
    fecha_ingreso DATE DEFAULT (CURRENT_DATE),
    id_vehiculo INT NOT NULL,
    CONSTRAINT pk_reparaciones PRIMARY KEY (id_reparacion),
    CONSTRAINT fk_reparaciones_vehiculos FOREIGN KEY (id_vehiculo) REFERENCES vehiculos(id_vehiculo) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 6. Tabla: piezas
CREATE TABLE piezas (
    id_pieza INT AUTO_INCREMENT,
    referencia VARCHAR(50) NOT NULL,
    stock_actual INT DEFAULT 0,
    CONSTRAINT pk_piezas PRIMARY KEY (id_pieza),
    CONSTRAINT uq_piezas_referencia UNIQUE (referencia)
);

-- 7. Tabla N:M Reflexiva: piezas_compatibles (PK Compuesta)
CREATE TABLE piezas_compatibles (
    id_pieza_original INT NOT NULL,
    id_pieza_sustituta INT NOT NULL,
    CONSTRAINT pk_piezas_compatibles PRIMARY KEY (id_pieza_original, id_pieza_sustituta),
    CONSTRAINT fk_piezas_compatibles_piezas_original FOREIGN KEY (id_pieza_original) REFERENCES piezas(id_pieza) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_piezas_compatibles_piezas_sustituta FOREIGN KEY (id_pieza_sustituta) REFERENCES piezas(id_pieza) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 8. Tabla N:M: inspecciones_previas (PK artificial y FK opcional)
CREATE TABLE inspecciones_previas (
    id_inspeccion INT AUTO_INCREMENT,
    id_vehiculo INT NOT NULL,
    id_empleado_revisor INT NULL,
    fecha_programada DATE NOT NULL,
    gravedad_estimada INT NOT NULL,
    CONSTRAINT pk_inspecciones_previas PRIMARY KEY (id_inspeccion),
    CONSTRAINT fk_inspecciones_previas_vehiculos FOREIGN KEY (id_vehiculo) REFERENCES vehiculos(id_vehiculo) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_inspecciones_previas_empleados FOREIGN KEY (id_empleado_revisor) REFERENCES empleados(id_persona) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_inspecciones_previas_gravedad CHECK (gravedad_estimada BETWEEN 1 AND 5)
);

-- 9. Tabla Ternaria: instalaciones (PK de 3 campos)
CREATE TABLE instalaciones (
    id_empleado INT NOT NULL,
    id_reparacion INT NOT NULL,
    id_pieza INT NOT NULL,
    cantidad_usada INT NOT NULL,
    CONSTRAINT pk_instalaciones PRIMARY KEY (id_empleado, id_reparacion, id_pieza),
    CONSTRAINT fk_instalaciones_empleados FOREIGN KEY (id_empleado) REFERENCES empleados(id_persona) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_instalaciones_reparaciones FOREIGN KEY (id_reparacion) REFERENCES reparaciones(id_reparacion) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_instalaciones_piezas FOREIGN KEY (id_pieza) REFERENCES piezas(id_pieza) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_instalaciones_cantidad CHECK (cantidad_usada > 0)
);