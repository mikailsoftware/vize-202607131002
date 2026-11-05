-- HAFTA 4: TEMEL SELECT VE WHERE SORGULARI
SELECT id, shipment_id, measurement_time, sensor_id, temp_c
FROM measurements
ORDER BY id ASC
LIMIT 10;

SELECT shipment_id, sensor_id, temp_c, measurement_time
FROM measurements
WHERE temp_c > 4.0
ORDER BY temp_c DESC
LIMIT 10;