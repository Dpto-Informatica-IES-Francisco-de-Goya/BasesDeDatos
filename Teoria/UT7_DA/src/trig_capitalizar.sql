DELIMITER //
CREATE TRIGGER capitalizar_apellido BEFORE INSERT ON actor
FOR EACH ROW
BEGIN
    SET NEW.last_name = UPPER(NEW.last_name);
END  //
DELIMITER ;
