-- HAFTA 5: ANALIZ VE RAPORLAMA SORGULARI
-- SORGU 1: Sensor Basina Sicaklik Dagilimi ve Ozet Istatistikler
SELECT 
    sensor_id,
    COUNT(temp_c) AS gecerli_olcum_sayisi,
    ROUND(AVG(temp_c), 2) AS ortalama_sicaklik,
    MIN(temp_c) AS en_dusuk_sicaklik,
    MAX(temp_c) AS en_yuksek_sicaklik
FROM measurements
GROUP BY sensor_id
ORDER BY ortalama_sicaklik DESC;