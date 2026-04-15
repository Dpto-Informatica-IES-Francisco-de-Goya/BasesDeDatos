DELIMITER //
CREATE PROCEDURE calc_debt(IN p_init DECIMAL(10,2), IN p_target DECIMAL(10,2))
BEGIN
    DECLARE v_debt DECIMAL(10,2) DEFAULT p_init;
    WHILE v_debt < p_target DO
        SET v_debt = v_debt * 1.05;
    END WHILE;
    SELECT v_debt;
END  //
DELIMITER ;
