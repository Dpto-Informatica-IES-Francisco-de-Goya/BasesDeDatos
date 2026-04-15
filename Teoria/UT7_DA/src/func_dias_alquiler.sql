DELIMITER //
CREATE FUNCTION dias_alquiler(p_rental_id INT) 
RETURNS INT READS SQL DATA
BEGIN
    DECLARE v_dias INT;
    SELECT DATEDIFF(return_date, rental_date) INTO v_dias 
    FROM rental WHERE rental_id = p_rental_id;
    RETURN v_dias;
END  //
DELIMITER ;
