mi_bucle: LOOP
    IF v_error = TRUE THEN
        LEAVE mi_bucle;
    END IF;
    -- Realizar acciones...
END LOOP mi_bucle;
