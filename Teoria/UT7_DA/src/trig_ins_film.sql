DELIMITER //
CREATE TRIGGER ins_film AFTER INSERT ON film 
FOR EACH ROW 
BEGIN
    INSERT INTO film_text (film_id, title, description)
    VALUES (NEW.film_id, NEW.title, NEW.description);
END  //
DELIMITER ;
