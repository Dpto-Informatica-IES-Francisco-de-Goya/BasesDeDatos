-- Recuperación Ordinaria RA5 DAM/DAW - Programación de BBDD
-- Base de datos: sakila

-- ============================================================
-- EJERCICIO 1: Procedimiento con bucle [RA5-CE.g]
-- ============================================================


DELIMITER $$

CREATE PROCEDURE p_register_payment_plan(
    IN  p_payment_id       INT,
    IN  p_parts            INT,
    OUT p_amount_inserted  INT
)
BEGIN
    DECLARE v_customer_id  SMALLINT UNSIGNED;
    DECLARE v_staff_id     TINYINT UNSIGNED;
    DECLARE v_rental_id    INT;
    DECLARE v_amount       DECIMAL(5,2);
    DECLARE v_payment_date DATETIME;
    DECLARE v_new_amount   DECIMAL(5,2);
    DECLARE v_counter      INT DEFAULT 0;

    IF p_parts > 0 THEN
        -- Obtener datos del pago original
        SELECT customer_id, staff_id, rental_id, amount, payment_date
        INTO v_customer_id, v_staff_id, v_rental_id, v_amount, v_payment_date
        FROM payment
        WHERE payment_id = p_payment_id;

        -- Calcular importe fraccionado (con decimales para la inserción)
        SET v_new_amount = v_amount / p_parts;
        
        -- Devolver el importe en el parámetro de salida (según enunciado INT)
        SET p_amount_inserted = v_new_amount;

        WHILE v_counter < p_parts DO
            INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
            VALUES (v_customer_id, v_staff_id, v_rental_id, v_new_amount, v_payment_date);

            SET v_counter = v_counter + 1;
        END WHILE;

        -- Eliminar el pago original
        DELETE FROM payment WHERE payment_id = p_payment_id;
    END IF;
END$$

/*
Rúbrica: 
- Estructura y variables declaradas: 0/0.75
- Bucle 0/1
- If: 0/0.5
- Inserción: 0/0.5
- Borrado: 0/0.5
- Llamada al procedimiento: 0/0.75
*/

DELIMITER ;

-- Ejemplo de ejecución
-- CALL p_register_payment_plan(1, 2, @importe);
-- SELECT @importe;

-- ============================================================
-- EJERCICIO 2: Trigger de validación [RA5-CE.h]
-- ============================================================
DELIMITER $$

CREATE TRIGGER tr_prevent_free_rental
BEFORE INSERT ON film
FOR EACH ROW
BEGIN
    IF NEW.rental_rate = 0.00 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: No se pueden insertar peliculas sin coste de alquiler';
    END IF;
END$$

DELIMITER ;

/*
Rúbrica:
- Estructura 0.75/0.75
- Uso de new.rental_rate 0.75/0.75
- Excepción: 0.5/0.5
- Funciona: 1/1
Nota:
*/

-- Prueba: debe lanzar error
-- INSERT INTO film (title, language_id, rental_duration, rental_rate, replacement_cost)
-- VALUES ('PELICULA GRATUITA', 1, 3, 0.00, 15.00);

-- ============================================================
-- EJERCICIO 3: Función de consulta [RA5-CE.f]
-- ============================================================
DELIMITER $$

CREATE FUNCTION f_customer_total_spent(p_customer_id INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);

    SELECT COALESCE(SUM(amount), 0.00)
    INTO v_total
    FROM payment
    WHERE customer_id = p_customer_id;

    RETURN v_total;
END$$

DELIMITER ;

-- Ejemplo de ejecución
-- SELECT first_name, last_name, f_customer_total_spent(customer_id)
-- FROM customer
-- WHERE customer_id = 1;
