INSERT INTO `ejercicio1`.`vehiculos`
(`id`,
`matricula`,
`tipo`,
`precio`,
`fecha_compra`)
VALUES
(1,
'5555BBB',
'F1',
150,
'2026-02-26');

SELECT * FROM vehiculos;

INSERT INTO `ejercicio1`.`vehiculos`
(
`matricula`,
`tipo`,
`precio`,
`fecha_compra`)
VALUES
('4444BBB',
'F1',
150,
'2026-02-26');

-- DA ERROR
INSERT INTO `ejercicio1`.`vehiculos`
(
`matricula`,
`tipo`,
`precio`,
`fecha_compra`)
VALUES
('3333BBB',
'F1',
-150,
'2026-02-26');

INSERT INTO `ejercicio1`.`vehiculos`
(
`matricula`,
`tipo`,
`precio`)
VALUES
('3333BBB',
'F1',
150);

-- FALLA POR EL NOT NULL
INSERT INTO `ejercicio1`.`vehiculos`
(
`matricula`,
`precio`)
VALUES
('2222BBB',
150);

-- FALLA POR MATRÍCULA REPETIDA
INSERT INTO `ejercicio1`.`vehiculos`
(
`matricula`,
`tipo`,
`precio`)
VALUES
('5555BBB',
'F1',
150);

select * from vehiculos;

