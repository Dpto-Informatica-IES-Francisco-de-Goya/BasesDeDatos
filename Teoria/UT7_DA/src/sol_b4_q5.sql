DELIMITER //
CREATE TRIGGER email_hist BEFORE UPDATE ON customer FOR EACH ROW
BEGIN
    IF OLD.email <> NEW.email THEN
        INSERT INTO email_history(customer_id, old_email) VALUES (OLD.customer_id, OLD.email);
    END IF;
END  //
DELIMITER ;
