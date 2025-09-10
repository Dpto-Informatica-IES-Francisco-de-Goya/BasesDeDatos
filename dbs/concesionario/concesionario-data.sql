-- Insertar datos en la tabla CLIENTE
INSERT INTO CLIENTE (COD, NIF, NOMBRE, DIRECCION, CIUDAD) VALUES
(1, '12345678A', 'Juan Pérez', 'Calle Falsa 123', 'Madrid'),
(2, '23456789B', 'María López', 'Avenida Siempre Viva 456', 'Barcelona'),
(3, '34567890C', 'Carlos García', 'Calle del Sol 789', 'Valencia'),
(4, '45678901D', 'Ana Martínez', 'Plaza Mayor 101', 'Sevilla'),
(5, '56789012E', 'Pedro Sánchez', 'Calle Nueva 202', 'Bilbao');

-- Insertar datos en la tabla COCHE
INSERT INTO COCHE (MATRICULA, MARCA, MODELO, COLOR, PVP, CODCLIENTE) VALUES
('1234ABC', 'Toyota', 'Corolla', 'ROJO', 25000, 1),
('2345DEF', 'Ford', 'Fiesta', 'AZUL', 15000, 2),
('3456GHI', 'Honda', 'Civic', 'VERDE', 22000, 3),
('4567JKL', 'BMW', 'X5', 'ROJO', 35000, 4),
('5678MNO', 'Audi', 'A4', 'AZUL', 28000, 5);

-- Insertar datos en la tabla REVISION
INSERT INTO REVISION (COD, FECHA, MATRICULA) VALUES
(1, '2024-01-10', '1234ABC'),
(2, '2024-02-15', '2345DEF'),
(3, '2024-03-20', '3456GHI'),
(4, '2024-04-25', '4567JKL'),
(5, '2024-05-30', '5678MNO');

-- Insertar datos en la tabla OPERACION
INSERT INTO OPERACION (COD, DESCRIPCION, HORAS) VALUES
(1, 'Cambio de aceite', 2),
(2, 'Revisión de frenos', 3),
(3, 'Cambio de neumáticos', 4),
(4, 'Reemplazo de batería', 2),
(5, 'Inspección general', 1);

-- Insertar datos en la tabla CONSTA
INSERT INTO CONSTA (CODREVISION, CODOPERACION) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
