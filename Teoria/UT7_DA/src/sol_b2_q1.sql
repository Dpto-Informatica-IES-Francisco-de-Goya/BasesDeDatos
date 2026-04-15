DELIMITER //
CREATE FUNCTION get_late_fine(p_rental_id INT) RETURNS DECIMAL(10,2) READS SQL DATA
BEGIN
    DECLARE v_delay INT;
    SELECT DATEDIFF(IFNULL(return_date, NOW()), rental_date) - f.rental_duration INTO v_delay
    FROM rental r JOIN inventory i USING(inventory_id) JOIN film f USING(film_id)
    WHERE r.rental_id = p_rental_id;
    RETURN IF(v_delay > 0, v_delay * 1.50, 0.00);
END  //
DELIMITER ;
