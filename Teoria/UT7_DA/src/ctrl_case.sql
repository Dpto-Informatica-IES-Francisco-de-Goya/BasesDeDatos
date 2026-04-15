CASE p_categoria_id
    WHEN 1 THEN SET p_nombre_cat = 'Acción';
    WHEN 2 THEN SET p_nombre_cat = 'Animación';
    ELSE SET p_nombre_cat = 'Otros';
END CASE;
