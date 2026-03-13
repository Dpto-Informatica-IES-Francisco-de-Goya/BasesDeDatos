DROP DATABASE IF EXISTS tech_solutions;
CREATE DATABASE tech_solutions;
USE tech_solutions;

CREATE TABLE empleados (
    id_emp SMALLINT UNSIGNED AUTO_INCREMENT, 
    alias VARCHAR(10) NOT NULL,
    rol ENUM('MANAGER', 'DEV') NOT NULL,
    stack SET('JAVA', 'PYTHON', 'JS', 'PHP') NULL,
    bonus DECIMAL(10,2) DEFAULT 0.00,
    id_mentor SMALLINT UNSIGNED NULL,
    CONSTRAINT pk_empleados PRIMARY KEY (id_emp),
    CONSTRAINT uq_empleados_alias UNIQUE (alias),
    CONSTRAINT chk_empleados_bonus CHECK (bonus >= 0)
);

CREATE TABLE sprints (
    id_sprint SMALLINT UNSIGNED AUTO_INCREMENT,
    codigo CHAR(6) NOT NULL,
    f_inicio DATE NOT NULL,
    f_fin DATE NOT NULL,
    CONSTRAINT pk_sprints PRIMARY KEY (id_sprint),
    CONSTRAINT uq_sprints_codigo UNIQUE (codigo),
    CONSTRAINT chk_sprints_codigo_len CHECK (CHAR_LENGTH(codigo) = 6),
    CONSTRAINT chk_sprints_fechas CHECK (f_fin > f_inicio)
);

CREATE TABLE tickets (
    id_ticket INT UNSIGNED AUTO_INCREMENT,
    titulo VARCHAR(100) NOT NULL,
    descripcion TEXT NULL,
    estado ENUM('TODO', 'WIP', 'DONE') DEFAULT 'TODO',
    id_sprint SMALLINT UNSIGNED NOT NULL,
    CONSTRAINT pk_tickets PRIMARY KEY (id_ticket),
    CONSTRAINT fk_tickets_sprints FOREIGN KEY (id_sprint)
        REFERENCES sprints (id_sprint)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE asignaciones (
    id_emp SMALLINT UNSIGNED,
    id_ticket INT UNSIGNED,
    horas DECIMAL(5 , 2 ) NOT NULL,
    CONSTRAINT pk_asignaciones PRIMARY KEY (id_emp , id_ticket),
    CONSTRAINT fk_asignaciones_empleados FOREIGN KEY (id_emp)
        REFERENCES empleados (id_emp)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_asignaciones_tickets FOREIGN KEY (id_ticket)
        REFERENCES tickets (id_ticket)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_asignaciones_horas CHECK (horas > 0)
);

-- Implementación de la relación reflexiva 
ALTER TABLE empleados 
	ADD CONSTRAINT fk_empleados_empleados 
	FOREIGN KEY (id_mentor) 
	REFERENCES empleados(id_emp) 
	ON DELETE RESTRICT ON UPDATE CASCADE;