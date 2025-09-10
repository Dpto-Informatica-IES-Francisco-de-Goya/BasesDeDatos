CREATE DATABASE comercio;
USE comercio;

CREATE TABLE productos (
idfab VARCHAR(3) NOT NULL,
idproducto VARCHAR(6) NOT NULL,
descripcion VARCHAR(100) NOT NULL,
precio DECIMAL(9 , 2) NOT NULL,
existencias INTEGER NOT NULL,
PRIMARY KEY (idfab, idproducto)
);

CREATE TABLE oficinas (
oficina DECIMAL (2) NOT NULL PRIMARY KEY,
ciudad VARCHAR (50) NOT NULL,
region VARCHAR (6) NOT NULL,
director INTEGER,
objetivo INTEGER,
ventas INTEGER
);

CREATE TABLE empleados (
numemp INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY ,
nombre VARCHAR (1000),
edad INTEGER,
oficina DECIMAL (2),
titulo VARCHAR(50),
contrato DATE,
jefe INTEGER,
cuota DECIMAL(9 , 2),
ventas DECIMAL (9 , 2),
FOREIGN KEY (oficina) REFERENCES oficinas (oficina)
);

CREATE TABLE clientes (
numclie INT NOT NULL PRIMARY KEY,
nombre VARCHAR (100) NOT NULL,
repclie INT NOT NULL,
limitecredito DECIMAL(9 , 2) NOT NULL,
FOREIGN KEY (repclie) references empleados (numemp)
);

CREATE TABLE pedidos (
codigo INT auto_increment NOT NULL PRIMARY KEY,
numpedido INT(6),
fechapedido DATE,
clie INT(50),
rep INT,
fab VARCHAR (3),
producto VARCHAR (5),
    cant INT,
    importe DECIMAL (9 , 2),
    FOREIGN KEY (fab, producto) REFERENCES productos (idfab, idproducto),
FOREIGN KEY (rep) REFERENCES empleados (numemp),
FOREIGN KEY (clie) REFERENCES clientes (numclie)
    
);
