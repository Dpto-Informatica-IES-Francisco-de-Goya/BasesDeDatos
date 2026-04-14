show tables;
explain envios;

DROP INDEX idx_envios_cliente_id ON envios;
select * from envios where id between 1000 and 1500; -- esta consulta mira 500 filas de la tabla. Tarda 0.00048

select * from envios where cliente_id between 1000 and 1500; -- esta consulta mira 100.000 filas de la tabla y devuelve 0. Tarda 0.06?
CREATE INDEX idx_envios_cliente_id ON envios(cliente_id);
select * from envios where cliente_id between 1000 and 1500; -- esta consulta mira 100.000 filas de la tabla y devuelve 0. Tarda 0.00098.

/*CONCLUSIÓN:
- El índice hace que la consulta sea 100 veces más rápida.
- ¿Todas las consultas sobre cliente_id van a ser 100 veces más rápidas? No. Mira el ejemplo. 
*/

DROP INDEX idx_envios_cliente_id ON envios;
select * from envios where id between 10 and 30; -- esta consulta "mira 100000 filas de la tabla". Tarda 0.0016 (debe de haber optimizaciones internas)
CREATE INDEX idx_envios_cliente_id ON envios(cliente_id);
select * from envios where id between 10 and 30; -- esta consulta mira 21 filas de la tabla. Tarda 0.0012
explain envios;
SHOW INDEX FROM envios;

select * from envios IGNORE INDEX (idx_envios_cliente_id) where cliente_id between 10 and 150; -- esta consulta mira ______ filas de la tabla. Tarda 0.00031

