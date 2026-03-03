DROP DATABASE IF EXISTS ejercicio2;
CREATE DATABASE ejercicio2;
USE ejercicio2;

SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE laboratorio(
	id INT UNSIGNED AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    investigador_principal INT UNSIGNED,
    CONSTRAINT pk_laboratorio PRIMARY KEY (id),
    CONSTRAINT fk_laboratorio_investigador FOREIGN KEY (investigador_principal)
		REFERENCES investigador(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE investigador (
    id INT UNSIGNED AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    laboratorio INT UNSIGNED NOT NULL,
    CONSTRAINT pk_investigador PRIMARY KEY (id),
    CONSTRAINT fk_investigador_laboratorio FOREIGN KEY (laboratorio)
		REFERENCES laboratorio(id) 
		ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO `ejercicio2`.`investigador`
(`id`,
`nombre`,
`laboratorio`)
VALUES
(2,
'Ochoa',
1);


SET FOREIGN_KEY_CHECKS = 1;

SELECT * FROM investigador;
SELECT * from laboratorio;

-- TIENE QUE FALLAR Y FALLA PORQUE NO HAY LABORATORIO ASOCIADO.
/*INSERT INTO `ejercicio2`.`investigador`
(`id`,
`nombre`)
VALUES
(1,
'Einstein');

*/