IF p_edad >= 18 THEN
    SET p_mensaje = 'Mayor de edad';
ELSE
    SET p_mensaje = 'Menor de edad';
END IF;
