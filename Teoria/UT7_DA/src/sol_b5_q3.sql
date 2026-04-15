DELIMITER //
CREATE PROCEDURE cat_report()
BEGIN
    DECLARE v_name VARCHAR(25);
    DECLARE v_rev DECIMAL(10,2);
    DECLARE v_fin INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT name FROM category;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_fin = TRUE;
    OPEN cur;
    loop_r: LOOP
        FETCH cur INTO v_name;
        IF v_fin THEN LEAVE loop_r; END IF;
        SELECT SUM(amount) INTO v_rev FROM payment JOIN rental USING(rental_id) 
        JOIN inventory USING(inventory_id) JOIN film_category USING(film_id) 
        JOIN category USING(category_id) WHERE name = v_name;
        INSERT INTO cat_stats VALUES (v_name, v_rev);
    END LOOP;
    CLOSE cur;
END  //
DELIMITER ;
