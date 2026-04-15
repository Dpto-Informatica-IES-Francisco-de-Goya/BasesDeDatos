DELIMITER //
CREATE TRIGGER protect_actors BEFORE DELETE ON actor FOR EACH ROW
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count FROM film_actor WHERE actor_id = OLD.actor_id;
    IF v_count > 20 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Actor demasiado famoso para borrar';
    END IF;
END  //
DELIMITER ;
