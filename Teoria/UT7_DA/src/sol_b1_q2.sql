DELIMITER //
CREATE PROCEDURE close_store(IN p_store_id INT)
BEGIN
    DECLARE v_target_store INT;
    SELECT store_id INTO v_target_store FROM store WHERE store_id <> p_store_id LIMIT 1;
    UPDATE staff SET store_id = v_target_store WHERE store_id = p_store_id;
END  //
DELIMITER ;
