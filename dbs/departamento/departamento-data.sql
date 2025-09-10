INSERT INTO Departamento(Codigo, Presupuesto, Habitacion) VALUES('INF', 10000, '101');

INSERT INTO Departamento(Codigo, Presupuesto, Habitacion) VALUES('MKT', 15000, '102');

INSERT INTO Departamento(Codigo, Presupuesto, Habitacion) VALUES('ADM', 1500, '103');

INSERT INTO Ordenador (Memoria, Procesador, CodigoDepartamento) VALUES(8, 'I5', 'INF');

INSERT INTO Ordenador (Memoria, Procesador, CodigoDepartamento) VALUES(16, 'I7', 'INF');

INSERT INTO Profesor (Dni, Nombre, Categoria, Antiguedad, CodigoDepartamento) 
VALUES('00000000X', 'Bob Esponja', 'JD', 15, 'INF');
INSERT INTO Profesor (Dni, Nombre, Categoria, Antiguedad, CodigoDepartamento) 
VALUES('00000001X', 'Calamardo', 'PS', 5, 'INF');
INSERT INTO Profesor (Dni, Nombre, Categoria, Antiguedad, CodigoDepartamento) 
VALUES('00000002X', 'George Pig', 'PT', 6, 'INF');

INSERT INTO Profesor (Dni, Nombre, Categoria, Antiguedad, CodigoDepartamento) 
VALUES('00000003X', 'Peppa Pig', 'JD', 15, 'MKT');
INSERT INTO Profesor (Dni, Nombre, Categoria, Antiguedad, CodigoDepartamento) 
VALUES('00000004X', 'Pocoyo', 'PS', 10, 'MKT');

-- Este profesor no tiene departamento
INSERT INTO Profesor (Dni, Nombre, Categoria, Antiguedad, CodigoDepartamento) 
VALUES('00000005X', 'Elly', 'PS', 5, null);
