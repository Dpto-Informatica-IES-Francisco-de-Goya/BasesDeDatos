DELIMITER //
CREATE PROCEDURE update_cat_prices(IN p_perc DECIMAL(5,2), IN p_cat_id INT)
BEGIN
    UPDATE film f JOIN film_category fc USING(film_id)
    SET f.rental_rate = f.rental_rate * (1 + p_perc/100)
    WHERE fc.category_id = p_cat_id;
END  //
DELIMITER ;
