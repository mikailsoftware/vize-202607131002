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

-- SORGU 2: Donanim Hata Kodu (NULL) ve Sensor Guvenilirlik Analizi
SELECT 
    sensor_id,
    COUNT(*) AS toplam_zaman_kaydi,
    COUNT(temp_c) AS gecerli_olcum_sayisi,
    COUNT(*) - COUNT(temp_c) AS donanim_ariza_sayisi,
    ROUND(100.0 * (COUNT(*) - COUNT(temp_c)) / COUNT(*), 2) AS ariza_yuzdesi
FROM measurements
GROUP BY sensor_id
ORDER BY donanim_ariza_sayisi DESC;