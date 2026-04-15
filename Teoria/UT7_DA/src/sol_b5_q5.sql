DELIMITER //
CREATE PROCEDURE replace_desc(IN p_old VARCHAR(50), IN p_new VARCHAR(50))
BEGIN
    DECLARE v_id INT;
    DECLARE v_desc TEXT;
    DECLARE v_fin INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT film_id, description FROM film;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_fin = TRUE;
    OPEN cur;
    loop_res: LOOP
        FETCH cur INTO v_id, v_desc;
        IF v_fin THEN LEAVE loop_res; END IF;
        IF v_desc LIKE CONCAT('%', p_old, '%') THEN
            UPDATE film SET description = REPLACE(v_desc, p_old, p_new) WHERE film_id = v_id;
        END IF;
    END LOOP;
    CLOSE cur;
END  //
DELIMITER ;
