explain envios;
select importe_envio from envios order by id desc;
select importe_envio
from envios 
WHERE 
importe_envio REGEXP '^[0-9]+\\.[0-9][0-9]$'
;

START TRANSACTION;

UPDATE envios  
SET importe_envio = CASE
	WHEN importe_envio REGEXP '^[0-9]+(\\.[0-9]+)?$' THEN ROUND(REPLACE(TRIM(importe_envio),'€','') * 1.1,2)
    ELSE '0' END;

SELECT importe_envio FROM envios ORDER BY id desc;

SAVEPOINT antes_del_error;

DELETE FROM envios
WHERE almacen_destino_id = 1;

ROLLBACK to antes_del_error;
-- rollback;
COMMIT;

