-- Script de Soporte para el Laboratorio de Patrones NoSQL (Cassandra)
-- Contexto: GloboTour

USE globotour;

-- 1. Soporte para el Patrón de Series Temporales (IoT)
CREATE TABLE IF NOT EXISTS sensor_readings (
    hotel_id uuid,
    sensor_id text,
    day date,
    reading_time timestamp,
    value float,
    PRIMARY KEY ((hotel_id, day), reading_time)
) WITH CLUSTERING ORDER BY (reading_time DESC);

INSERT INTO sensor_readings (hotel_id, sensor_id, day, reading_time, value) 
VALUES (uuid(), 'SENSOR-SALA-A', '2024-04-16', toTimestamp(now()), 22.5);

INSERT INTO sensor_readings (hotel_id, sensor_id, day, reading_time, value) 
VALUES (uuid(), 'SENSOR-SALA-B', '2024-04-16', toTimestamp(now()), 23.1);


-- 2. Soporte para Contadores Atómicos
CREATE TABLE IF NOT EXISTS offer_stats (
    offer_id text PRIMARY KEY,
    views counter
);

-- Nota: No se puede hacer INSERT en tablas de contadores, solo UPDATE
UPDATE offer_stats SET views = views + 120 WHERE offer_id = 'OFERTA-PARIS-2024';
UPDATE offer_stats SET views = views + 45 WHERE offer_id = 'OFERTA-TOKYO-2024';


-- 3. Soporte para Ofertas Flash (TTL)
CREATE TABLE IF NOT EXISTS flash_offers (
    offer_id text PRIMARY KEY,
    discount float,
    description text
);

INSERT INTO flash_offers (offer_id, discount, description) 
VALUES ('FLASH-01', 0.25, '25% solo durante 2 horas') 
USING TTL 7200;
