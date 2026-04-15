DELIMITER //
CREATE PROCEDURE GenerarEnviosMasivos()
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < 100000 DO
        INSERT INTO envios (tracking_number, cliente_id, f_salida, importe_envio)
        VALUES (CONCAT('TRK-', FLOOR(RAND()*99999999)),
                FLOOR(1 + RAND() * 500), 
                DATE_FORMAT(DATE_ADD('2025-01-01', INTERVAL i MINUTE), 
                            ELT(1 + FLOOR(RAND() * 4), '%d/%m/%Y', '%Y-%m-%d', '%d-%m-%y', '%y/%m/%d')),
                CONCAT(ROUND(RAND()*500, 2), ' EUR'));
        SET i = i + 1;
        IF i % 20000 = 0 THEN
            SELECT CONCAT('... ', i, ' envios procesados.') AS Progreso;
        END IF;
    END WHILE;
END  //
DELIMITER ;
