DELIMITER //
CREATE TRIGGER check_min_inventory BEFORE INSERT ON rental FOR EACH ROW
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count FROM inventory WHERE inventory_id = NEW.inventory_id;
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Copia de inventario no existente';
    END IF;
END  //
DELIMITER ;
