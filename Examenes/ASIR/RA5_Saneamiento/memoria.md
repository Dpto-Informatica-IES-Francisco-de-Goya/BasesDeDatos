# Memoria técnica

## Comandos a utilizar:

### Crear copia de seguridad completa
```bash
mysqldump -u admin -p1234 logistica_global > 00_copia_inicial.sql
```

### Cargar la copia de seguridad completa
```bash
mysql -u admin -p1234 logistica_global < 00_copia_inicial
```

### Crear una copia de seguridad incremental
Rotamos los logs con:

```bash
mysql -u admin -p1234 -e "FLUSH LOGS;" 
```

Generamos la copia de seguridad:
```bash
mysqlbinlog --read-from-remote-server -u admin -p1234 -h localhost binlog.??????
```


## Proceso de creación:

### 1.1 Copia de seguridad completa
```bash
mysqldump -u admin -p1234 logistica_global > 00_copia_inicial.sql
```

### Rotación de logs
```bash
mysql -u admin -p1234 -e "FLUSH LOGS;" 
```

### Resuelvo el ejercicio 1
```bash
mysql -u admin -p1234 logistica_global < limpieza/p1_asir.sql
```


### Rotación de logs
```bash
mysql -u admin -p1234 -e "FLUSH LOGS;" 
```

para garantizar que no hay más ejecuciones sql en la copia de seguridad.

### ¿Qué log me interesa?

```bash
mysql -u admin -p1234 -e "SHOW MASTER STATUS;" 
```

Respuesta: binlog.000322

Por tanto en el binlog.000321 tengo la copia incremental del ejercicio 1.
### 1.2.a Creo la primera incremental
```bash
mysqlbinlog --read-from-remote-server -u admin -p1234 -h localhost binlog.000321 > 01_incremental_ejercicio1.sql
```

### Resuelvo el ejercicio 2
```bash
mysql -u admin -p1234 logistica_global < limpieza/p2_asir.sql 
```

### Rotación de logs
Cerramos el log 322 antes de hacer la copia

```bash
mysql -u admin -p1234 -e "FLUSH LOGS;" 
```


### 1.2.b Creo la incremental


```bash
mysqlbinlog --read-from-remote-server -u admin -p1234 -h localhost binlog.000322 > 02_incremental_ejercicio2.sql
```

### 1.3 Creo la diferencial

```bash
cat 01_incremental_ejercicio1.sql 02_incremental_ejercicio2.sql > 03_diferencial_ejers_1_y_2.sql
```

### Resuelvo el ejercicio 3

```bash
mysql -u admin -p1234 logistica_global < limpieza/p3_asir.sql 
``` 


### Rotación de logs
Cierro el log 333

```bash
mysql -u admin -p1234 -e "FLUSH LOGS;" 
```


### 1.4 Creo la incremental:

```bash
mysqlbinlog --read-from-remote-server -u admin -p1234 -h localhost binlog.000323 > 03_incremental_ejercicio3.sql
```

## 1.5 Resumen de tablas

Tenemos las siguientes copias de seguridad:
- **00_copia_inicial.sql**: copia de seguridad completa antes de resolver la limpieza.
- **01_incremental_ejercicio1.sql**: copia de seguridad incremental desde la bbdd original que incluye la resolución del ejercicio 1.
- **02_incremental_ejercicio2.sql**: copia de seguridad incremental desde la bbdd original que incluye la resolución del ejercicio 2.
- **03_diferencial_ejers_1_y_2.sql**: copia de seguridad diferencial que combina las incrementales de los ejercicios 1 y 2, por lo que restaura desde la base de datos original, las limpiezas de los ejercicio 1 y 2.
- **03_incremental_ejercicio3.sql**: copia de seguridad incremental desde la bbdd original que incluye la resolución del ejercicio 3.



## Restaurar las copias de seguridad

Situado desde la carpeta donde están los backups:

```bash 
mysql -u admin -p1234 logistica_global < 00_copia_inicial.sql             

## Comprobamos que no hay "salario_neto"
mysql -u admin -p1234 logistica_global -e "select salario_neto from empleados"

mysql -u admin -p1234 logistica_global < 01_incremental_ejercicio1.sql

## Comprobamos que sí hay "salario_neto"
mysql -u admin -p1234 logistica_global -e "select salario_neto from empleados limit 1;"
## Se ha restaurado correctamente el ejercicio 1

## Comprobamos que hay almacenes duplicados
mysql -u admin -p1234 logistica_global -e "select cod_almacen,count(id) from almacenes group by cod_almacen having count(id) > 1 limit 2;"

## Restauramos la incremental del ejercicio 2
mysql -u admin -p1234 logistica_global < 02_incremental_ejercicio2.sql

## Comprobamos que  NO hay almacenes duplicados
mysql -u admin -p1234 logistica_global -e "select cod_almacen,count(id) from almacenes group by cod_almacen having count(id) > 1 limit 2;"

## Restauramos la copia de seguridad inicial para probar a ver si la diferencial funciona:

mysql -u admin -p1234 logistica_global < 00_copia_inicial.sql             

## Comprobamos que no hay "salario_neto"
mysql -u admin -p1234 logistica_global -e "select salario_neto from empleados"

## Comprobamos que hay almacenes duplicados
mysql -u admin -p1234 logistica_global -e "select cod_almacen,count(id) from almacenes group by cod_almacen having count(id) > 1 limit 2;"

## Restauramos la diferencial
mysql -u admin -p1234 logistica_global < 03_diferencial_ejers_1_y_2.sql 

## Comprobamos que sí hay "salario_neto"
mysql -u admin -p1234 logistica_global -e "select salario_neto from empleados limit 2"

## Comprobamos que no hay almacenes duplicados
mysql -u admin -p1234 logistica_global -e "select cod_almacen,count(id) from almacenes group by cod_almacen having count(id) > 1 limit 2;"

## Comprobamos que hay envíos con vehículos que no existen
mysql -u admin -p1234 logistica_global -e "select count(*) as num_vehiculos from envios where vehiculo_id not in (select id from vehiculos);"

## Restauramos la incremental del ejercicio 3
mysql -u admin -p logistica_global < 03_
incremental_ejercicio3.sql 

## Comprobamos que NO hay envíos con vehículos que no existen
mysql -u admin -p1234 logistica_global -e "select count(*) as num_vehiculos from envios where vehiculo_id not in (select id from vehiculos);"

```