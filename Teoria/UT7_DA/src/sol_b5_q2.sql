DELIMITER //
CREATE PROCEDURE capitalize_actors()
BEGIN
    DECLARE v_id INT;
    DECLARE v_fname VARCHAR(45);
    DECLARE v_fin INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT actor_id, first_name FROM actor;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_fin = TRUE;
    OPEN cur;
    loop1: LOOP
        FETCH cur INTO v_id, v_fname;
        IF v_fin THEN LEAVE loop1; END IF;
        UPDATE actor SET first_name = CONCAT(UPPER(LEFT(v_fname,1)), LOWER(SUBSTRING(v_fname,2))) 
        WHERE actor_id = v_id;
    END LOOP;
    CLOSE cur;
END  //
DELIMITER ;
