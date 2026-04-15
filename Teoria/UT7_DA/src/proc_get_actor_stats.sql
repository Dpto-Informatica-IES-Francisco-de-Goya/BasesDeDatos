DELIMITER //
CREATE PROCEDURE get_actor_stats(IN p_actor_id INT, OUT p_films INT, OUT p_avg_len DECIMAL(10,2))
BEGIN
    SELECT COUNT(*), AVG(length) INTO p_films, p_avg_len
    FROM film JOIN film_actor USING(film_id) WHERE actor_id = p_actor_id;
END  //
DELIMITER ;
