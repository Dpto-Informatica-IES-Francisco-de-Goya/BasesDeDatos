DELIMITER //
CREATE PROCEDURE overdue_report()
BEGIN
    DECLARE v_id INT;
    DECLARE v_fin INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT rental_id FROM rental WHERE return_date IS NULL AND rental_date < DATE_SUB(NOW(), INTERVAL 7 DAY);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_fin = TRUE;
    OPEN cur;
    loop_o: LOOP
        FETCH cur INTO v_id;
        IF v_fin THEN LEAVE loop_o; END IF;
        INSERT INTO overdue_logs(rental_id) VALUES (v_id);
    END LOOP;
    CLOSE cur;
END  //
DELIMITER ;
