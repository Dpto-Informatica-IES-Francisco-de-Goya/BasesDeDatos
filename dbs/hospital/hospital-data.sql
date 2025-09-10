-- Insertar 20 registros en la tabla de Médicos
INSERT INTO Medicos (dni, nombre, numero_colegiado) VALUES
('123456789A', 'Dr. Juan Pérez', 'MC-12345'),
('987654321B', 'Dra. María González', 'MC-54321'),
('456789012C', 'Dr. Carlos Rodríguez', 'MC-67890'),
('234567890D', 'Dra. Ana Martínez', 'MC-45678'),
('890123456E', 'Dr. Laura Sánchez', 'MC-23456'),
('567890123F', 'Dr. Pablo Gómez', 'MC-78901'),
('345678901G', 'Dra. Lucía Fernández', 'MC-89012'),
('678901234H', 'Dr. Sergio López', 'MC-34567'),
('012345678I', 'Dra. Andrea Díaz', 'MC-90123'),
('901234567J', 'Dr. Martín Vargas', 'MC-01234'),
('789012345K', 'Dra. Isabel Ruiz', 'MC-67890'),
('567890123L', 'Dr. Rafael Pérez', 'MC-45678'),
('345678901M', 'Dra. Elena Gómez', 'MC-89012'),
('234567890N', 'Dr. Alejandro Martínez', 'MC-23456'),
('678901234O', 'Dra. Sara Sánchez', 'MC-90123'),
('901234567P', 'Dr. Diego Fernández', 'MC-34567'),
('789012345Q', 'Dra. Sofía López', 'MC-01234'),
('567890123R', 'Dr. Javier Díaz', 'MC-67890'),
('345678901S', 'Dra. Carmen Vargas', 'MC-89012'),
('234567890T', 'Dr. Mario Ruiz', 'MC-23456');

-- Insertar 20 registros en la tabla de Pacientes
INSERT INTO Pacientes (dni, nombre, num_tarjeta_seguridad_social) VALUES
('11111111A', 'Juan Pérez', '1234567890A'),
('22222222B', 'María González', '0987654321B'),
('33333333C', 'Carlos Rodríguez', '4567890123C'),
('44444444D', 'Ana Martínez', '2345678901D'),
('55555555E', 'Laura Sánchez', '8901234567E'),
('66666666F', 'Pablo Gómez', '5678901234F'),
('77777777G', 'Lucía Fernández', '3456789012G'),
('88888888H', 'Sergio López', '6789012345H'),
('99999999I', 'Andrea Díaz', '0123456789I'),
('10101010J', 'Martín Vargas', '9012345678J'),
('12121212K', 'Isabel Ruiz', '7890123456K'),
('13131313L', 'Rafael Pérez', '5678901234L'),
('14141414M', 'Elena Gómez', '3456789012M'),
('15151515N', 'Alejandro Martínez', '2345678901N'),
('16161616O', 'Sara Sánchez', '6789012345O'),
('17171717P', 'Diego Fernández', '9012345678P'),
('18181818Q', 'Sofía López', '7890123456Q'),
('19191919R', 'Javier Díaz', '5678901234R'),
('20202020S', 'Carmen Vargas', '3456789012S'),
('21212121T', 'Mario Ruiz', '2345678901T');

-- Insertar 20 registros en la tabla de Análisis
INSERT INTO Analisis (dni_paciente, fecha_analisis, parametro_analizado, valor_analisis, dni_medico_solicitante) VALUES
('11111111A', '2023-01-01', 'Glucosa', 120.5, '123456789A'),
('22222222B', '2023-02-01', 'Hemoglobina', 14.3, '987654321B'),
('33333333C', '2023-03-01', 'Leucocitos', 8000.0, '456789012C'),
('44444444D', '2023-04-01', 'Colesterol', 200.0, '234567890D'),
('55555555E', '2023-05-01', 'Creatinina', 1.0, '890123456E'),
('66666666F', '2023-06-01', 'Glucosa', 110.0, '567890123F'),
('77777777G', '2023-07-01', 'Hemoglobina', 13.5, '345678901G'),
('88888888H', '2023-08-01', 'Leucocitos', 8500.0, '678901234H'),
('99999999I', '2023-09-01', 'Colesterol', 180.0, '012345678I'),
('10101010J', '2023-10-01', 'Creatinina', 1.2, '901234567J'),
('12121212K', '2023-11-01', 'Glucosa', 115.0, '789012345K'),
('13131313L', '2023-12-01', 'Hemoglobina', 13.0, '567890123L'),
('14141414M', '2024-01-01', 'Leucocitos', 8200.0, '345678901M'),
('15151515N', '2024-02-01', 'Colesterol', 190.0, '234567890N'),
('16161616O', '2024-03-01', 'Creatinina', 1.1, '678901234O'),
('17171717P', '2024-04-01', 'Glucosa', 118.0, '901234567P'),
('18181818Q', '2024-05-01', 'Hemoglobina', 12.5, '789012345Q'),
('19191919R', '2024-06-01', 'Leucocitos', 8300.0, '567890123R'),
('20202020S', '2024-07-01', 'Colesterol', 185.0, '345678901S'),
('21212121T', '2024-08-01', 'Creatinina', 1.3, '234567890T');
-- Insertar algunos registros en la tabla de AtencionMedica
INSERT INTO AtencionMedica (dni_paciente, dni_medico) VALUES
('11111111A', '123456789A'), -- Juan Pérez atendido por Dr. Juan Pérez
('22222222B', '987654321B'), -- María González atendida por Dra. María González
('33333333C', '456789012C'), -- Carlos Rodríguez atendido por Dr. Carlos Rodríguez
('44444444D', '234567890D'), -- Ana Martínez atendida por Dra. Ana Martínez
('55555555E', '890123456E'), -- Laura Sánchez atendida por Dr. Laura Sánchez
('66666666F', '567890123F'), -- Pablo Gómez atendido por Dr. Pablo Gómez
('77777777G', '345678901G'), -- Lucía Fernández atendida por Dra. Lucía Fernández
('88888888H', '678901234H'), -- Sergio López atendido por Dr. Sergio López
('99999999I', '012345678I'), -- Andrea Díaz atendida por Dra. Andrea Díaz
('10101010J', '901234567J'), -- Martín Vargas atendido por Dr. Martín Vargas
('12121212K', '789012345K'), -- Isabel Ruiz atendida por Dra. Isabel Ruiz
('13131313L', '567890123L'), -- Rafael Pérez atendido por Dr. Rafael Pérez
('14141414M', '345678901M'), -- Elena Gómez atendida por Dra. Elena Gómez
('15151515N', '234567890N'), -- Alejandro Martínez atendido por Dr. Alejandro Martínez
('16161616O', '678901234O'), -- Sara Sánchez atendida por Dra. Sara Sánchez
('17171717P', '901234567P'), -- Diego Fernández atendido por Dr. Diego Fernández
('18181818Q', '789012345Q'), -- Sofía López atendida por Dra. Sofía López
('19191919R', '567890123R'), -- Javier Díaz atendido por Dr. Javier Díaz
('20202020S', '345678901S'), -- Carmen Vargas atendida por Dra. Carmen Vargas
('21212121T', '234567890T'); -- Mario Ruiz atendido por Dr. Mario Ruiz
