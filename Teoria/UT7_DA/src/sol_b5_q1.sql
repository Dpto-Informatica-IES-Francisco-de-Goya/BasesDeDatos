DELIMITER //
CREATE PROCEDURE total_staff_sales()
BEGIN
    DECLARE v_id INT;
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_fin INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT staff_id FROM staff;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_fin = TRUE;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_id;
        IF v_fin THEN LEAVE read_loop; END IF;
        SELECT SUM(amount) INTO v_total FROM payment WHERE staff_id = v_id;
        INSERT INTO staff_report(id, total) VALUES (v_id, v_total);
    END LOOP;
    CLOSE cur;
END  //
DELIMITER ;
