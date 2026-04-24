# Memoria técnica

## Comandos a utilizar:

### Crear copia de seguridad completa
```bash
mysqldump -u admin -p logistica_global > 00_copia_inicial.sql
```

### Cargar la copia de seguridad completa
```bash
mysql -u admin -p logistica_global < 00_copia_inicial
```

### Crear una copia de seguridad incremental
Rotamos los logs con:

```bash
mysql -u admin -p -e "FLUSH LOGS;" 
```

Generamos la copia de seguridad:
```bash
mysqlbinlog --read-from-remote-server -u admin -p -h localhost binlog.??????
```


## Proceso de creación:

### 1.1 Copia de seguridad completa
```bash
mysqldump -u admin -p logistica_global > 00_copia_inicial.sql
```

### Rotación de logs
```bash
mysql -u admin -p -e "FLUSH LOGS;" 
```

### Resuelvo el ejercicio 1
```bash
mysql -u admin -p logistica_global < limpieza/p1_asir.sql
```


### Rotación de logs
```bash
mysql -u admin -p -e "FLUSH LOGS;" 
```

para garantizar que no hay más ejecuciones sql en la copia de seguridad.

### ¿Qué log me interesa?

```bash
mysql -u admin -p -e "SHOW MASTER STATUS;" 
```

Respuesta: binlog.000322

Por tanto en el binlog.000321 tengo la copia incremental del ejercicio 1.
### 1.2.a Creo la primera incremental
```bash
mysqlbinlog --read-from-remote-server -u admin -p -h localhost binlog.000321 > 01_incremental_ejercicio1.sql
```

### Resuelvo el ejercicio 2
```bash
mysql -u admin -p1234 logistica_global < limpieza/p2_asir.sql 
```

### Rotación de logs
Cerramos el log 322 antes de hacer la copia

```bash
mysql -u admin -p -e "FLUSH LOGS;" 
```


### 1.2.b Creo la incremental


```bash
mysqlbinlog --read-from-remote-server -u admin -p -h localhost binlog.000322 > 02_incremental_ejercicio2.sql
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
mysql -u admin -p -e "FLUSH LOGS;" 
```


### 1.4 Creo la incremental:

```bash
mysqlbinlog --read-from-remote-server -u admin -p -h localhost binlog.000323 > 03_incremental_ejercicio3.sql
```

## 1.5 Resumen de tablas

Tenemos las siguientes copias de seguridad:
- **00_copia_inicial.sql**: copia de seguridad completa antes de resolver la limpieza.
- **01_incremental_ejercicio1.sql**: copia de seguridad incremental desde la bbdd original que incluye la resolución del ejercicio 1.
- **02_incremental_ejercicio2.sql**: copia de seguridad incremental desde la bbdd original que incluye la resolución del ejercicio 2.
- **03_diferencial_ejers_1_y_2.sql**: copia de seguridad diferencial que combina las incrementales de los ejercicios 1 y 2, por lo que restaura desde la base de datos original, las limpiezas de los ejercicio 1 y 2.
- **03_incremental_ejercicio3.sql**: copia de seguridad incremental desde la bbdd original que incluye la resolución del ejercicio 3.


