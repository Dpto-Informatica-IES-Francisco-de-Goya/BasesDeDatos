DELIMITER //
CREATE FUNCTION total_film_stock(p_film_id INT) RETURNS INT READS SQL DATA
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count FROM inventory i 
    WHERE film_id = p_film_id AND inventory_in_stock(i.inventory_id);
    RETURN v_count;
END  //
DELIMITER ;
