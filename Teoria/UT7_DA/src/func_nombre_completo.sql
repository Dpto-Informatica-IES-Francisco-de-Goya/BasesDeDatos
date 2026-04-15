DELIMITER //
CREATE FUNCTION nombre_completo(p_nombre VARCHAR(45), p_apellido VARCHAR(45)) 
RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
    RETURN CONCAT(p_apellido, ', ', p_nombre);
END  //
DELIMITER ;
