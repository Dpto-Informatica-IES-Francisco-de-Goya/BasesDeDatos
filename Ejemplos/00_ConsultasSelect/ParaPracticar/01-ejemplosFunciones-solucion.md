## 1. Funciones numéricas

### 1.1. Truncar el precio de cada producto a 1 decimal
```sql
SELECT id_producto, nombre, precio, TRUNCATE(precio, 1) AS precio_truncado_1
FROM productos;
```

### 1.2. Redondear hacia abajo (FLOOR) y hacia arriba (CEIL) el precio
```sql
SELECT id_producto, nombre, precio, FLOOR(precio) AS precio_floor, CEIL(precio) AS precio_ceil
FROM productos;
```

### 1.3. Calcular el precio con IVA (21%)
```sql
SELECT id_producto, nombre, precio, ROUND(precio * 1.21, 2) AS precio_con_iva
FROM productos;
```

### 1.4. Descuento del 15% aplicado sobre el precio
```sql
SELECT id_producto, nombre, precio, ROUND(precio * 0.85, 2) AS precio_con_desc_15
FROM productos;
```

### 1.5. Desviación estándar y varianza del precio del catálogo
```sql
SELECT ROUND(STDDEV_SAMP(precio), 4) AS std_precio, ROUND(VARIANCE(precio), 4) AS var_precio
FROM productos;
```

### 1.6. Diferencia absoluta frente a un stock objetivo (600 uds.)
```sql
SELECT id_producto, stock, ABS(stock - 600) AS diferencia_stock_objetivo
FROM productos;
```

---

## 2. Funciones de cadena

### 2.1. Concatenar categoría y nombre con separador usando `CONCAT_WS`
```sql
SELECT CONCAT_WS(' - ', categoria, nombre) AS etiqueta_producto
FROM productos;
```

### 2.2. Extraer una subcadena del nombre de cada producto (pos. 4, longitud 5)
```sql
SELECT nombre, SUBSTRING(nombre, 4, 5) AS subcadena_4_5
FROM productos;
```

### 2.3. Buscar la posición de una palabra dentro del nombre (por ejemplo 'Pro')
```sql
SELECT nombre, INSTR(nombre, 'Pro') AS pos_pro
FROM productos;
```

### 2.3. Buscar la posición de una palabra dentro del nombre (por ejemplo 'Pro')
```sql
SELECT nombre, INSTR(nombre, 'Pro') AS pos_pro
FROM productos
WHERE INSTR(nombre,'Pro') != 0;
```


### 2.4. Invertir el nombre de cada producto
```sql
SELECT nombre, REVERSE(nombre) AS nombre_invertido
FROM productos;
```

### 2.5. Rellenar a la izquierda el id_producto con ceros hasta 5 dígitos
```sql
SELECT id_producto, LPAD(id_producto, 5, '0') AS id_padded
FROM productos;
```

### 2.6. Enmascarar el nombre de cliente con asteriscos según su longitud
```sql
SELECT nombre, REPEAT('*', LENGTH(nombre)) AS nombre_enmascarado
FROM clientes;
```

### 2.7. Reemplazar el símbolo '@' en el email para mostrarlo “ofuscado”
```sql
SELECT email, REPLACE(email, '@', ' [at] ') AS email_ofuscado
FROM clientes;
```

---

## 3. Funciones de fecha

### 3.1. Obtener la fecha y hora actual (NOW)
```sql
SELECT NOW() AS fecha_y_hora_actual;
```

### 3.2. Formatear la fecha de pedido como “YYYY-MM”
```sql
SELECT id_pedido, DATE_FORMAT(fecha_pedido, '%Y-%m') AS anio_mes
FROM pedidos;
```
Para más información, consulta la documentación oficial (https://dev.mysql.com/doc/refman/8.4/en/date-and-time-functions.html#function_date-format)

### 3.3. Extraer el trimestre (QUARTER) de la fecha de pedido
```sql
SELECT id_pedido, QUARTER(fecha_pedido) AS trimestre
FROM pedidos;
```

### 3.4. Último día del mes de cada pedido
```sql
SELECT id_pedido, fecha_pedido, LAST_DAY(fecha_pedido) AS ultimo_dia_mes
FROM pedidos;
```

### 3.5. Diferencia en meses desde el registro de cada cliente hasta hoy
```sql
SELECT nombre, TIMESTAMPDIFF(MONTH, fecha_registro, CURDATE()) AS meses_desde_registro
FROM clientes;
```

### 3.6. Semana del año de cada pago (YEARWEEK)
```sql
SELECT id_pago, fecha_pago, YEARWEEK(fecha_pago, 3) AS anio_semana_iso
FROM pagos;
```

### 3.7. Restar 2 horas a la fecha/hora de cada pedido (SUBTIME)
```sql
SELECT id_pedido, fecha_pedido, SUBTIME(fecha_pedido, '02:00:00') AS fecha_menos_2h
FROM pedidos;
```

### 3.8. Sumar 10 minutos a la fecha/hora de cada pago (ADDTIME)
```sql
SELECT id_pago, fecha_pago, ADDTIME(fecha_pago, '00:10:00') AS fecha_mas_10min
FROM pagos;
```
