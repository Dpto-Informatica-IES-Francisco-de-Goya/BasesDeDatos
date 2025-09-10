DROP DATABASE IF EXISTS MUNICIPIO;
CREATE DATABASE MUNICIPIOS;
USE MUNICIPIOS;

CREATE TABLE municipios (
    cod_m VARCHAR(10) PRIMARY KEY,
    nom_m VARCHAR(20),
    extension INT,
    n_habitantes INT
);

CREATE TABLE viviendas (
    cod_v VARCHAR(10) PRIMARY KEY,
    direccion VARCHAR(50),
    tipo VARCHAR(2),
    n_habitaciones INT,
    cod_m VARCHAR(10),
    CONSTRAINT fk_viviendas_municipios FOREIGN KEY (cod_m) REFERENCES municipios(cod_m)
);

CREATE TABLE personas (
    dni VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(15),
    apellidos VARCHAR(20),
    e_civil CHAR(1),
    fecha_nto DATE,
    sit_laboral CHAR(1),
    cod_v_vive VARCHAR(10),
    CONSTRAINT fk_personas_viviendas FOREIGN KEY (cod_v_vive) REFERENCES viviendas(cod_v)
);

CREATE TABLE propiedad (
    cod_v VARCHAR(10),
    dni VARCHAR(10),
    porcentaje_propiedad INT,
    PRIMARY KEY (cod_v, dni),
    CONSTRAINT fk_propiedad_vivienda FOREIGN KEY (cod_v) REFERENCES viviendas(cod_v),
    CONSTRAINT fk_propiedad_persona FOREIGN KEY (dni) REFERENCES personas(dni)
);
