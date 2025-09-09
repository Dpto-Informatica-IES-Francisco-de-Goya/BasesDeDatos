/* Queremos conocer los actores que más dinero han generado con sus películas en 
un determinado rango de fechas de alquiler*/

DROP PROCEDURE IF EXISTS ActoresRentables;
DROP FUNCTION IF EXISTS TotalFacturadoPorActorEnRango;

DELIMITER $$
CREATE FUNCTION TotalFacturadoPorActorEnRango(
	f_actor_id INT,
	fecha_ini DATE,
	fecha_fin DATE
) 
RETURNS DECIMAL(10,2) -- Mismo tipo que lo que se va a sumar para devolver. Sumar peras con peras.
READS SQL DATA
BEGIN
	DECLARE retval INT;
	SELECT sum(amount) INTO retval
	-- hacemos una subconsulta en el FROM para solo coger las películas del actor
	FROM 
		(SELECT * FROM film_actor WHERE actor_id = f_actor_id) AS nfilm_actor
	JOIN 
		inventory USING(film_id)
	JOIN 
		(SELECT * FROM rental WHERE rental_date BETWEEN fecha_ini AND fecha_fin) 
		AS nrental USING(inventory_id)
	JOIN payment USING(rental_id)
	GROUP BY actor_id -- TODO: ¿Podría quitarlo?
	HAVING actor_id = f_actor_id;
	RETURN retval;
END$$
CREATE PROCEDURE ActoresRentables(
	IN min_facturacion INT,
	IN fecha_ini DATE,
	IN fecha_fin DATE,
	OUT total_actores INT)
BEGIN
	CREATE TEMPORARY TABLE IF NOT EXISTS TT_ActoresRentables(
		actor_id INT,
		first_name VARCHAR(45),
		last_name VARCHAR(45),
		facturado INT);
	TRUNCATE TABLE TT_ActoresRentables; -- Por si acaso había datos de una ejecución anterior.
	INSERT INTO TT_ActoresRentables 
	SELECT 
		actor_id,first_name,last_name,
		TotalFacturadoPorActorEnRango(actor_id,fecha_ini,fecha_fin)
	FROM actor
	WHERE TotalFacturadoPorActorEnRango(actor_id,fecha_ini,fecha_fin)
	SELECT COUNT(actor_id) INTO total_actores FROM TT_ActoresRentables;
	SELECT * FROM TT_ActoresRentables;

END$$
DELIMITER ;
