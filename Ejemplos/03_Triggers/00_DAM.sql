USE sakila;

DROP PROCEDURE saludo;

-- DELIMITER $€
DELIMITER //
CREATE PROCEDURE saludo()
BEGIN
    SELECT '¡Hola clase de DAM!' AS q1;
    SELECT '¡Hola clase de DAM! (1)' AS q2;
    SELECT '¡Hola clase de DAM! (2)' AS mensaje;
END  //
DELIMITER ;
CALL saludo();

DELIMITER //
CREATE PROCEDURE buscar_actor(IN p_apellido VARCHAR(45))
BEGIN
    SELECT first_name, last_name FROM actor 
    WHERE last_name LIKE CONCAT(p_apellido, '%');
END  //
DELIMITER ;
CALL buscar_actor('Jackman');

DELIMITER //
CREATE PROCEDURE contar_peliculas(OUT p_total INT)
BEGIN
    SELECT COUNT(*) INTO p_total FROM film;
END  //
DELIMITER ;

CALL contar_peliculas(@resultado);
select @resultado;

DELIMITER $$
CREATE PROCEDURE `film_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
    READS SQL DATA
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);

	-- PARA ASIGNAR A UNA VARIABLE UN VALOR, SE UTILIZA SELECT INTO.
     SELECT COUNT(*)
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id)
     INTO p_film_count;
END$$
DELIMITER ;

CALL `sakila`.`film_in_stock`(15, 2, @resultado);
select @resultado;



DELIMITER //
CREATE FUNCTION calcular_iva(p_precio DECIMAL(10,2)) 
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    RETURN p_precio * 1.21;
END  //
DELIMITER ;

CALL calcular_iva(10); -- no existe

CALL `sakila`.`film_in_stock`(15, 2, @resultado);
select @resultado;
SELECT calcular_iva(@resultado);

select calcular_iva(amount) from payment;


DELIMITER $$
CREATE FUNCTION `inventory_in_stock`(p_inventory_id INT) RETURNS tinyint(1)
    READS SQL DATA
BEGIN
    DECLARE v_rentals INT;
    DECLARE v_out     INT;

    
    

    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END$$
DELIMITER ;


-- Cuántos inventories hay disponibles en cada tienda
SELECT store_id, count(inventory_id) AS num_stock
FROM 
	inventory 
		JOIN
	store USING(store_id)
WHERE -- inventories que estén disponibles, es decir, que su fecha de devolución sea null
	inventory_in_stock(inventory_id)
GROUP BY store_id;

select * from rental;
select inventory_id,count(rental_id) from rental group by inventory_id;

-- COMPARA FUNCIONES CON PROCEDIMIENTOS. Encuentra parecidos y diferencias.


