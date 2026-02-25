# Pedidos pendientes de hace más de 90 días

```sql
select id_pedido,        
	datediff(curdate(),fecha_pedido) as diferencia 
from pedidos 
where estado = 'pendiente' 
	and datediff(curdate(),fecha_pedido) > 90 
order by fecha_pedido asc;
```

+-----------+------------+
| id_pedido | diferencia |
+-----------+------------+
|         3 |        905 |
|       155 |        833 |
|       147 |        807 |
|        69 |        736 |
|        48 |        690 |
|        35 |        688 |
|        26 |        566 |
|        53 |        516 |
|        83 |        460 |
|        94 |        402 |
|       107 |        391 |
|        57 |        372 |
|        65 |        363 |
|        87 |        310 |
|       116 |        285 |
|        82 |        280 |
|        95 |        278 |
|        72 |        236 |
|       137 |        233 |
|        67 |        137 |
|       132 |        134 |
+-----------+------------+
21 rows in set (0,00 sec)

