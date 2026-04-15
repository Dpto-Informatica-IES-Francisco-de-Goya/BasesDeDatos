DELIMITER //
CREATE TRIGGER log_nuevo_cliente AFTER INSERT ON customer
FOR EACH ROW
BEGIN
    INSERT INTO logs(accion, id_cliente) VALUES ('NUEVO', NEW.customer_id);
END  //
DELIMITER ;
