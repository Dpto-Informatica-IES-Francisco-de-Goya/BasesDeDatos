DELIMITER //
CREATE PROCEDURE check_and_rent(IN p_film_id INT, IN p_store_id INT)
BEGIN
    DECLARE v_stock INT;
    CALL film_in_stock(p_film_id, p_store_id, v_stock);
    IF v_stock > 0 THEN SELECT 'Disponible' AS msg;
    ELSE SELECT 'Sin existencias' AS msg;
    END IF;
END  //
DELIMITER ;
