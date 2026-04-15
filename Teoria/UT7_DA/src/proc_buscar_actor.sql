DELIMITER //
CREATE PROCEDURE buscar_actor(IN p_apellido VARCHAR(45))
BEGIN
    SELECT first_name, last_name FROM actor 
    WHERE last_name LIKE CONCAT(p_apellido, '%');
END  //
DELIMITER ;
