DELIMITER //
CREATE FUNCTION gen_mkt_email(p_first VARCHAR(45), p_last VARCHAR(45)) RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
    RETURN LOWER(CONCAT(p_first, '.', p_last, '@sakilavideo.com'));
END  //
DELIMITER ;
