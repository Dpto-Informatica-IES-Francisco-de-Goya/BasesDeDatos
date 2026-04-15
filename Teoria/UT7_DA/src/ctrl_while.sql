DECLARE i INT DEFAULT 1;
WHILE i <= 5 DO
    INSERT INTO tabla_log(msg) VALUES (CONCAT('Paso ', i));
    SET i = i + 1;
END WHILE;
