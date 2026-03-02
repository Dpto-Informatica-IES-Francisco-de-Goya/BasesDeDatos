USE obras_musicales;

INSERT INTO `obras_musicales`.`compositor`
(`id_compositor`,
`nombre`,
`año_nacimiento`,
`nacionalidad`)
VALUES
(1,
'Chaikovski',
1866,
'RU');

INSERT INTO `obras_musicales`.`compositor`
(`id_compositor`,
`nombre`,
`año_nacimiento`,
`nacionalidad`)
VALUES
(2,
'Vivladi',
1678,
'IT');



INSERT INTO obras_musicales.obra
(`id_obra`,
`titulo`,
`tipo`,
`modo`,
`tono`,
`id_compositor`)
VALUES
(1,
'Cascanueces',
'Sinfonía',
'Frigio',
'domayor',
1);

-- RETORCEMOS:


INSERT INTO obras_musicales.obra
(
`titulo`,
`tipo`,
`modo`,
`tono`,
`id_compositor`)
VALUES
(
'Las cuatro estaciones',
'Sinfonía',
'Frigio',
'domenor',
1);




