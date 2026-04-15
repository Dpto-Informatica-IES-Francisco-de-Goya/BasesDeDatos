DELIMITER //
CREATE PROCEDURE populate_test()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100 DO
        INSERT INTO test_table(val) VALUES (i);
        SET i = i + 1;
    END WHILE;
END  //
DELIMITER ;
