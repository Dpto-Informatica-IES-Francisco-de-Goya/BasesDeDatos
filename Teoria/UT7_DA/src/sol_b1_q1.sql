DELIMITER //
CREATE PROCEDURE rent_movie(IN p_cust_id INT, IN p_inv_id INT, IN p_staff_id INT)
BEGIN
    INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
    VALUES (NOW(), p_inv_id, p_cust_id, p_staff_id);
END  //
DELIMITER ;
