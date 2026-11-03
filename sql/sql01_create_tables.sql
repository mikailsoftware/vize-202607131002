-- Hafta 4: Veritabanı Tablo Yapısı
DROP TABLE IF EXISTS measurements;

CREATE TABLE measurements (
    id BIGSERIAL PRIMARY KEY,
    shipment_id VARCHAR(10) NOT NULL,
    measurement_time TIMESTAMP NOT NULL,
    sensor_id VARCHAR(50) NOT NULL,
    temp_c NUMERIC(5,2)
);

CREATE INDEX idx_measurements_sensor ON measurements(sensor_id);
CREATE INDEX idx_measurements_time ON measurements(measurement_time);
CREATE INDEX idx_measurements_shipment ON measurements(shipment_id);