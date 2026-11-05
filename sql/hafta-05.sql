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

-- SORGU 3: Kritik Esigi (>8.0 C) Asan Kronik Arizali Sensorler (HAVING)
SELECT 
    sensor_id,
    COUNT(*) AS kritik_ihlal_sayisi,
    ROUND(AVG(temp_c), 2) AS ihlal_anindaki_ortalama_sicaklik
FROM measurements
WHERE temp_c > 8.0
GROUP BY sensor_id
HAVING COUNT(*) >= 20
ORDER BY kritik_ihlal_sayisi DESC;

-- SORGU 4: Saat Dilimlerine Gore Anomali Yogunlugu (EXTRACT HOUR)
SELECT 
    EXTRACT(HOUR FROM measurement_time) AS saat_dilimi,
    COUNT(*) AS anomali_sayisi,
    ROUND(AVG(temp_c), 2) AS anomali_saatindeki_ortalama_temp
FROM measurements
WHERE temp_c < 0.0 OR temp_c > 4.0
GROUP BY EXTRACT(HOUR FROM measurement_time)
ORDER BY anomali_sayisi DESC;