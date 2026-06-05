/***** 			PREVIOS	 		*******/
SELECT * FROM mantenimientos_flota where vehiculo_id between 1 and 5;
SELECT * FROM vehiculos WHERE id between 1 and 5;

-- COMMITS IMPLÍCITOS: ALTER, DROP, CREATE, TRUNCATE

/* AQUÍ LO QUE QUIERAS */

/****** 		FUNCIONES DE TEXTO 			**********/
select substring_index('Año 2222',' ',1); -- Lo de ANTES de la primera ocurrencia
select substring_index('Año 2222',' ',-1); -- Lo de DESPUÉS de la primera ocurrencia
select substring_index('Año 2222',' ',2); -- Lo de ANTES de la 2ª ocurrencia
select substring_index('hola | que | tal','|',-2); -- Lo de DESPUÉS de la 2ª ocurrencia de derecha a izq.

/****** 		OTRAS FUNCIONES 			***********/
SELECT ifnull(año_fabricacion,'hola') from vehiculos;


/***** 			ORGANIZADO POR COMPETENCIAS 		*********/
/*¿QUÉ COMPETENCIAS HAY? ¿QUÉ TIENES QUE SABER?*/
-- ELIMINAR DUPLICADOS POR CUALQUIER CRITERIO/S.
-- SANEAR FECHAS.
-- ARREGLAR FK.
-- CREAR UNA TABLA NUEVA E INSERTARLE DATOS DE OTRA.

-- Eliminar los vehiculos con matricula repetida, quedándote con el que tenga un año de fabricación más reciente (3 ptos).
-- ¿Hay duplicados?
SELECT matricula,count(id)
FROM vehiculos
GROUP BY matricula
HAVING count(id) > 1;


explain vehiculos;
-- 1º LA CONSULTA CON SELECT
SELECT 
    v1.id,v1.matricula,v1.marca_modelo,
    v2.id,v2.matricula,v2.marca_modelo
FROM
    vehiculos v1
        JOIN
    vehiculos v2 ON v1.matricula = v2.matricula
WHERE
    v1.id > v2.id;
    
SELECT 
	*
FROM
    vehiculos v1
        JOIN
    vehiculos v2 ON v1.matricula = v2.matricula
WHERE
    v1.año_fabricacion > v2.año_fabricacion;


-- OJO CON LAS MATRÍCULAS. Hay que sanearlas para que 1234ABC sea la misma que 1234-ABC o 1234 ABC. Se sanean así:
update vehiculos
set matricula = trim(replace(replace(matricula,' ',''),'-',''));
    
-- vamos a quedarnos con el que se haya fabricado más tarde. Para ello, hay que sacar el número del año de la columna.
select año_fabricacion from vehiculos;
select substring('Año 2222',2,5);
select right('Año 2222',4);

-- Intentamos con select antes de update.
SELECT substring_index(año_fabricacion,' ',-1) from vehiculos; -- devuelve 206 rows
SELECT substring_index(año_fabricacion,' ',-1) from vehiculos where año_fabricacion REGEXP '.*[0-9]{4}$'; -- devuelve 200 rows.
-- CONCLUSIÓN: Hay 6 rows que no terminan en 4 dígitos.
SELECT año_fabricacion from vehiculos where año_fabricacion NOT REGEXP '.*[0-9]{4}$'; -- devuelve 0 ROWS.
-- OH NO!!! ¿DÓNDE ESTÁN ESAS 6 FILAS? 
SELECT año_fabricacion from vehiculos where año_fabricacion IS NULL; -- ¡AQUÍ! null es muy molesto.

-- AHORA YA SÍ: ELIMINAMOS POR MATRÍCULA DUPLICADA QUEDÁNDONOS CON EL QUE TIENE UN AÑO MÁS RECIENTE
START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;
SELECT 
	v1.id,v1.matricula,substring_index(v1.año_fabricacion,' ',-1),
    v2.id,v2.matricula,substring_index(v2.año_fabricacion,' ',-1)
FROM
    vehiculos v1
        JOIN
    vehiculos v2 ON v1.matricula = v2.matricula
WHERE
    substring_index(v1.año_fabricacion,' ',-1) > substring_index(v2.año_fabricacion,' ',-1);
    
-- construimos el delete para borrar el vehículo con un año menor
DELETE v2
FROM vehiculos v1
        JOIN
    vehiculos v2 ON v1.matricula = v2.matricula
WHERE
    substring_index(v1.año_fabricacion,' ',-1) > substring_index(v2.año_fabricacion,' ',-1);
-- COMPROBAMOS QUE NO HAY REPETIDOS
SELECT 
	v1.id,v1.matricula,substring_index(v1.año_fabricacion,' ',-1),
    v2.id,v2.matricula,substring_index(v2.año_fabricacion,' ',-1)
FROM
    vehiculos v1
        JOIN
    vehiculos v2 ON v1.matricula = v2.matricula
WHERE
    substring_index(v1.año_fabricacion,' ',-1) > substring_index(v2.año_fabricacion,' ',-1);
COMMIT;

select matricula from vehiculos;

-- otra forma, 
/*
SELECT 
	v1.id,v1.matricula,substring_index(v1.año_fabricacion,' ',-1),
    v2.id,v2.matricula,substring_index(v2.año_fabricacion,' ',-1)
FROM
    vehiculos v1
        JOIN
    vehiculos v2 ON v1.matricula = v2.matricula
WHERE
    substring_index(v1.año_fabricacion,' ',-1) < substring_index(v2.año_fabricacion,' ',-1);
    
DELETE v1
FROM vehiculos v1
        JOIN
    vehiculos v2 ON v1.matricula = v2.matricula
WHERE
    substring_index(v1.año_fabricacion,' ',-1) < substring_index(v2.año_fabricacion,' ',-1);
*/


-- Arreglar FKs (cliente_id, vehiculo_id, empleado_id, almacen_destino_id ...)
-- Arreglar Fechas



/******			ORGANIZADO POR TABLAS			**********/



/*******************************************************************
*******************************************************************
						ALMACENES
                        (terminado el miércoles a la hora de comer)
*******************************************************************
*******************************************************************/

select * from almacenes;

/* TODOs:
- Eliminar la _ de cod_almacen
- El nombre de sucursal es absurdo. Quitar la palabra "sucursal" del nombro si todos son sucursales de verdad
- Revisar que no haya nombres de sucursal repetidos y añadirle una restricción de unique. [EX - 1pto]
- Hacer una tabla "ciudades" con los nombres de las ciudades y dejar en esta tabla almacenes un id que sea FK a esa tabla ciudades [EX - 2.5pts]
- Barna y VLC ponerlos como Valencia y Barcelona.
- Dejar capacidad_m3 como una columna numérica. [EX - 1.5 pto]
- Teléfonos de contacto con prefijo español, solo pueden empezar por 9,7 o 6.
- Separar ubicación geográfica en 2 columnas numéricas diferentes llamadas latitud y longitud. Borrar después esa columna.
- Eliminar duplicados por código de almacen si están en la misma ciudad. [EX - 2.5 pto]
- Eliminar duplicados por código de almacen si se llaman igual.
- Eliminar duplicados por nombre.
- Tipo_gestión es una columna un poco rara. Ponerla bonita.
- Convertir a L la capacidad (sabiendo que 1m³ son 1000L). [EX - 2pto] 
- PRO: Sacar la distancia entre almacenes con una formulita a partir de latitud y longitud. (Esa formulita se la sabe chatty).*/


/* SOLUCIONES */

-- Eliminar la _ de cod_almacen
-- El nombre de sucursal es absurdo. Quitar la palabra "sucursal" del nombro si todos son sucursales de verdad

SELECT * FROM almacenes;

-- Revisar que no haya nombres de sucursal repetidos y añadirle una restricción de unique. [EX - 1pto]
-- Hacer una tabla "ciudades" con los nombres de las ciudades y dejar en esta tabla almacenes un id que sea FK a esa tabla ciudades [EX - 2.5pts]
-- Barna y VLC ponerlos como Valencia y Barcelona.
-- Dejar capacidad_m3 como una columna numérica. [EX - 1.5 pto]
-- Teléfonos de contacto con prefijo español, solo pueden empezar por 9,7 o 6.
-- Separar ubicación geográfica en 2 columnas numéricas diferentes llamadas latitud y longitud. Borrar después esa columna.
-- Eliminar duplicados por código de almacen si están en la misma ciudad. [EX - 2.5 pto]
-- Eliminar duplicados por código de almacen si se llaman igual.
-- Eliminar duplicados por nombre.
-- Tipo_gestión es una columna un poco rara. Ponerla bonita.
-- Convertir a L la capacidad (sabiendo que 1m³ son 1000L). [EX - 2pto] 
-- PRO: Sacar la distancia entre almacenes con una formulita a partir de latitud y longitud. (Esa formulita se la sabe chatty).


/*******************************************************************
*******************************************************************
						CLIENTES (la tarde del miércoles)
*******************************************************************
*******************************************************************/



/*******************************************************************
*******************************************************************
						empleados
*******************************************************************
*******************************************************************/



/*******************************************************************
*******************************************************************
						ENVIOS
*******************************************************************
*******************************************************************/

SELECT * FROM envios;



/*******************************************************************
*******************************************************************
						VEHICULOS
*******************************************************************
*******************************************************************/


/** AVISOS: */
-- OJO CON LAS MATRÍCULAS. Hay que sanearlas para que 1234ABC sea la misma que 1234-ABC o 1234 ABC. Se sanean así:
update vehiculos
set matricula = trim(replace(replace(matricula,' ',''),'-',''));
