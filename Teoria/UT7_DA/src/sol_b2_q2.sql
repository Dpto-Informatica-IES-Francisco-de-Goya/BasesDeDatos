DELIMITER //
CREATE FUNCTION get_customer_status(p_cust_id INT) RETURNS VARCHAR(20) READS SQL DATA
BEGIN
    DECLARE v_spent DECIMAL(10,2);
    SELECT SUM(amount) INTO v_spent FROM payment WHERE customer_id = p_cust_id;
    RETURN IF(v_spent > 150, 'VIP', 'ESTANDAR');
END  //
DELIMITER ;
