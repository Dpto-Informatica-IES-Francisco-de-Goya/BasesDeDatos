DELIMITER //
CREATE PROCEDURE desc_rating(IN p_rating VARCHAR(10), OUT p_desc VARCHAR(100))
BEGIN
    CASE p_rating
        WHEN 'G' THEN SET p_desc = 'Todos los publicos';
        WHEN 'PG' THEN SET p_desc = 'Supervision de padres';
        WHEN 'R' THEN SET p_desc = 'Restringido (+18)';
        ELSE SET p_desc = 'Otras categorias';
    END CASE;
END  //
DELIMITER ;
