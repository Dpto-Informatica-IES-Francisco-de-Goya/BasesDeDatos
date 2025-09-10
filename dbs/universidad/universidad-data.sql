-- Insertar registros en la tabla de Estudiantes
INSERT INTO Estudiantes (dni, nombre, fecha_nacimiento, carrera) VALUES
('11111111A', 'Juan Pérez', '2000-05-12', 'Ingeniería Informática'),
('22222222B', 'María González', '1999-08-25', 'Matemáticas'),
('33333333C', 'Carlos Rodríguez', '2001-03-14', 'Física'),
('44444444D', 'Ana Martínez', '2002-11-30', 'Ingeniería Civil'),
('55555555E', 'Laura Sánchez', '2000-02-19', 'Química');

-- Insertar registros en la tabla de Profesores
INSERT INTO Profesores (dni, nombre, especialidad) VALUES
('123456789A', 'Dr. Juan López', 'Matemáticas'),
('987654321B', 'Dra. María Torres', 'Física'),
('456789012C', 'Dr. Carlos Díaz', 'Ingeniería Informática'),
('234567890D', 'Dra. Ana Morales', 'Ingeniería Civil'),
('890123456E', 'Dr. Laura Rivas', 'Química');

-- Insertar registros en la tabla de Asignaturas
INSERT INTO Asignaturas (nombre_asignatura, dni_profesor) VALUES
('Cálculo Diferencial', '123456789A'),
('Física General', '987654321B'),
('Programación Avanzada', '456789012C'),
('Estructuras', '234567890D'),
('Química Orgánica', '890123456E');

-- Insertar registros en la tabla de Inscripciones
INSERT INTO Inscripciones (dni_estudiante, id_asignatura) VALUES
('11111111A', 1), -- Juan Pérez inscrito en Cálculo Diferencial
('11111111A', 3), -- Juan Pérez inscrito en Programación Avanzada
('22222222B', 1), -- María González inscrita en Cálculo Diferencial
('22222222B', 2), -- María González inscrita en Física General
('33333333C', 2), -- Carlos Rodríguez inscrito en Física General
('33333333C', 4), -- Carlos Rodríguez inscrito en Estructuras
('44444444D', 4), -- Ana Martínez inscrita en Estructuras
('55555555E', 5); -- Laura Sánchez inscrita en Química Orgánica

-- Insertar registros en la tabla de Calificaciones
INSERT INTO Calificaciones (id_inscripcion, nota, fecha_evaluacion) VALUES
(1, 8.5, '2023-01-15'),
(2, 9.0, '2023-02-20'),
(3, 7.5, '2023-03-10'),
(4, 8.0, '2023-04-05'),
(5, 6.0, '2023-05-18'),
(6, 9.5, '2023-06-22'),
(7, 7.0, '2023-07-15'),
(8, 8.5, '2023-08-01');
