DELIMITER //
CREATE TRIGGER audit_pay AFTER UPDATE ON payment FOR EACH ROW
BEGIN
    IF OLD.amount <> NEW.amount THEN
        INSERT INTO audit_payments(payment_id, old_amt, new_amt)
        VALUES (OLD.payment_id, OLD.amount, NEW.amount);
    END IF;
END  //
DELIMITER ;
