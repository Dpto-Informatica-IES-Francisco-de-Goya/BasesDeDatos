INSERT INTO municipios (cod_m, nom_m, extension, n_habitantes) VALUES 
('V', 'Valencia', 5, 1500000),
('M', 'Madrid', 20, 5000000),
('B', 'Barcelona', 12, 2500000);

INSERT INTO viviendas (cod_v, direccion, tipo, n_habitaciones, cod_m) VALUES 
('1', 'Colón, 25-30', 'PI', 3, 'V'),
('2', 'Blasco Ibáñez, 3', 'CH', 5, 'V'),
('3', 'Av. Mediterráneo, 67', 'CA', 4, 'V'),
('4', 'Gran Vía, 5 1ºA', 'PI', 2, 'M'),
('5', 'Av. Extremadura, 5', 'CH', 3, 'M'),
('6', 'C/Toledo, 5 1º', 'PI', 1, 'M'),
('7', 'Pº de Gracia, 5', 'CA', 6, 'B'),
('8', 'Diagonal 47-26', 'PI', 2, 'B');

INSERT INTO personas (dni, nombre, apellidos, e_civil, fecha_nto, sit_laboral, cod_v_vive) VALUES 
('901234', 'Rosa Mª', 'Puig Vázquez', 'V', '1974-02-03', 'A', '1'),
('123456', 'Antonio', 'Morales Pérez', 'S', '1974-02-03', 'A', '2'),
('789012', 'Pedro', 'Morales Miguelez', 'C', '1948-06-12', 'N', '2'),
('345678', 'Maria', 'Pérez Reig', 'C', '1945-11-05', 'A', '2'),
('567890', 'Berta', 'Antúnez Veiga', 'C', '1959-02-03', 'A', '4'),
('234567', 'Mario', 'Pereira Martínez', 'C', '1958-02-03', 'A', '4'),
('456789', 'Ana', 'Rodríguez Pérez', 'C', '1960-02-03', 'A', '5'),
('678901', 'Jose', 'Gancedo Comuñas', 'C', '1960-08-15', 'A', '5'),
('890123', 'Ana', 'Gancedo Rodríguez', 'S', '1980-01-06', 'N', '5'),
('012345', 'Jose', 'Gancedo Rodríguez', 'S', '1972-04-28', 'N', '5'),
('112233', 'Luis', 'Rodríguez Huerga', 'S', '1971-05-05', 'A', '6'),
('445566', 'Rosana', 'Salví García', 'S', '1971-02-06', 'A', '8'),
('778899', 'María', 'Salví García', 'S', '1974-04-23', 'A', '8');

INSERT INTO propiedad (cod_v, dni, porcentaje_propiedad) VALUES 
('1', '901234', 100),
('2', '345678', 50),
('2', '789012', 50),
('3', '901234', 100),
('4', '567890', 50),
('4', '234567', 50),
('5', '456789', 50),
('5', '678901', 50),
('6', '112233', 100),
('7', '778899', 100),
('8', '445566', 80),
('8', '778899', 20);
