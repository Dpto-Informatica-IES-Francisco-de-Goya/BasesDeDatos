drop database banco;
create database banco;
use banco;
create table directores
(id integer not null primary key,
nombre varchar(15),
apellidos  varchar(50),
sueldo decimal(9,2)
);

create table sucursales
(nsucursal decimal(6) not null primary key,
nombre varchar(50),
director integer,
direccion varchar(50),
foreign key(director) references directores(id)
);

create table clientes
( dni char(9) not null primary key,
nombre varchar(15),
apellidos varchar(50),
direccion  varchar(50),
fecha_de_alta date,
credito decimal(9),
nsucursal decimal(6),
foreign key(nsucursal) references sucursales(nsucursal)
);
