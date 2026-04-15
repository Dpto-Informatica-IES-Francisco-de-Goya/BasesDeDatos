DELIMITER //
CREATE PROCEDURE contar_peliculas(OUT p_total INT)
BEGIN
    SELECT COUNT(*) INTO p_total FROM film;
END  //
DELIMITER ;
