DELIMITER //
CREATE PROCEDURE purge_audit_logs(IN p_days INT)
BEGIN
    DELETE FROM audit_log WHERE log_date < DATE_SUB(NOW(), INTERVAL p_days DAY);
END  //
DELIMITER ;
