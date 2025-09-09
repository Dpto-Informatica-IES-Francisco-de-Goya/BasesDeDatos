SELECT 'Creando funciones y procedimientos...';

DROP PROCEDURE IF EXISTS CountCustomerRentals;
DELIMITER $$
-- CREATE IF NOT EXISTS PROCEDURE CountCustomerRentas(
CREATE PROCEDURE CountCustomerRentals(
	IN p_customer_id INT,
	OUT p_rental_count INT
) 
BEGIN
	SELECT COUNT(*) INTO p_rental_count
	FROM rental
	WHERE customer_id = p_customer_id;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS TotalPaymentsByCustomer;

DELIMITER $$
CREATE FUNCTION TotalPaymentsByCustomer(
	p_customer_id INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE total DECIMAL(10,2);
	SELECT IFNULL(SUM(amount),0) INTO total
	FROM payment
	WHERE customer_id = p_customer_id;
	RETURN total;
END;
$$
DELIMITER ;

SELECT 'Testeando funciones y procedimientos';

-- El procedimiento se llama así, a pelo sin contexto.
CALL CountCustomerRentals(15,@total);
SELECT @total;

-- Lo guay de las funciones es que pueden utilizarse aquí. Por eso es obligatorio que
-- retornen algún valor. 

SELECT 
  customer_id,
  first_name,
  last_name,
  TotalPaymentsByCustomer(customer_id) AS total_pagado
FROM customer
LIMIT 10;

DROP FUNCTION IF EXISTS CustomerFullName;

DELIMITER $$
CREATE FUNCTION CustomerFullName(
	f_customer_id INT
)
RETURNS VARCHAR(100)
READS SQL DATA
DETERMINISTIC
BEGIN
	DECLARE fullname VARCHAR(100);
	SELECT CONCAT(first_name,' ',last_name) INTO fullname
	FROM customer
	WHERE customer_id = f_customer_id;
	return fullname;
END$$
DELIMITER ;
SELECT CustomerFullName(5) AS nombre_completo;

DROP FUNCTION IF EXISTS IsFilmAvailabe;
DELIMITER $$
CREATE FUNCTION IsFilmAvailable (f_film_id INT)
RETURNS BOOLEAN
DETERMINISTIC 
READS SQL DATA
BEGIN
	DECLARE available_count INT;
	SELECT COUNT(*) INTO available_count
	FROM inventory
	WHERE film_id = f_film_id
		AND inventory_id NOT IN (
			SELECT inventory_id
			FROM rental
			WHERE return_date IS NULL
	);
	RETURN available_count > 0;
END $$
DELIMITER ;

SELECT film_id, IsFilmAvailable(film_id) AS disponible
FROM film
LIMIT 5;


-- Dado un film_id, muestra cuántas veces se ha alquilado y la fecha del último alquiler

DROP PROCEDURE IF EXISTS GetFilmRentalStats;
DELIMITER $$
CREATE PROCEDURE GetFilmRentalStats(
	INOUT f_film_id INT,
	OUT out_title VARCHAR(100),
	OUT num_rentals INT,
	OUT last_rent DATE)
BEGIN
	SELECT 
		MIN(film.title),
		COUNT(rental_id) ,
		MAX(rental_date) INTO out_title,num_rentals,last_rent
	FROM film 
	JOIN inventory USING(film_id)
	JOIN rental USING (inventory_id)
	WHERE film_id = f_film_id
	GROUP BY film_id;
END $$
DELIMITER ;
		
SET @id=10;
CALL GetFilmRentalStats(@id,@title,@num,@total);
SELECT @id,@title,@num,@total;

--  CLIENTES CON MÁS DE X PELÍCULAS ALQUILADAS

DROP PROCEDURE IF EXISTS ClientesFrecuentes;
DROP FUNCTION IF EXISTS NumAlquileresEnRango;

DELIMITER $$
CREATE FUNCTION NumAlquileresEnRango(
	f_customer_id INT,
	fecha_ini DATE,
	fecha_fin DATE
)
RETURNS INT
READS SQL DATA
BEGIN
	DECLARE retval INT;
	SELECT count(rental_id) INTO retval
	FROM rental
	WHERE customer_id = f_customer_id
	AND rental_date BETWEEN fecha_ini AND fecha_fin;
	RETURN retval;
END
$$

CREATE PROCEDURE ClientesFrecuentes(
	IN umbral INT,
	IN fecha_ini DATE,
	IN fecha_fin DATE,
	OUT total_clientes INT
)
BEGIN
	CREATE TEMPORARY TABLE clientes_filtrados(
		customer_id INT ,
		first_name VARCHAR(100),
		last_name VARCHAR(100),
		num_alquileres INT);
	INSERT INTO clientes_filtrados 
		SELECT 
			customer_id, 
			first_name, 
			last_name, 
			NumAlquileresEnRango(customer_id,fecha_ini,fecha_fin) as TOTAL_NUM_RENTS
		FROM customer 
		JOIN rental USING(customer_id)
		GROUP BY customer_id, first_name, last_name
		HAVING TOTAL_NUM_RENTS > umbral
		ORDER BY TOTAL_NUM_RENTS DESC
	;
	SELECT count(customer_id) INTO total_clientes FROM clientes_filtrados;
	SELECT * FROM clientes_filtrados;
END $$
DELIMITER ;
