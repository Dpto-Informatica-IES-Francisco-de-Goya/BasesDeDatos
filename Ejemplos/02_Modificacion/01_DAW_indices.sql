use logistica_globa;
select * from envios where cliente_id = 1 limit 5;
select * from envios where id between 1000 and 1500; -- tarda 0.000?? y mira 500 filas
select * from envios where cliente_id between 1000 and 1500; -- tarda 0.0?? y mira 100.000

CREATE INDEX idx_envios_cliente_id ON envios(cliente_id);
select * from envios where cliente_id between 1000 and 1500; -- tarda 0.00030

EXPLAIN envios;
SHOW INDEX FROM envios;

select * from envios;

use sakila;

show tables;
show index from actor;
