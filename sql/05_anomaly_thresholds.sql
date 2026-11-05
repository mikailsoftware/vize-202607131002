-- Hafta 11 YZ Altyapisi: Dinamik Esik Tablosu
DROP TABLE IF EXISTS anomaly_thresholds;

CREATE TABLE anomaly_thresholds (
    rule_id SERIAL PRIMARY KEY,
    product_type VARCHAR(50) NOT NULL,
    min_safe_temp NUMERIC(4,2) NOT NULL,
    max_safe_temp NUMERIC(4,2) NOT NULL,
    critical_high_temp NUMERIC(4,2) NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO anomaly_thresholds (product_type, min_safe_temp, max_safe_temp, critical_high_temp)
VALUES ('Strawberry', 0.00, 4.00, 8.00);

SELECT * FROM anomaly_thresholds;