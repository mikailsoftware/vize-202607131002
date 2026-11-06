-- ============================================================================
-- ÖĞRENCİ PROJE İLERLEME RAPORU VE HAFTA 11 (FINAL) YZ TASLAĞI
-- Öğrenci No: 202607131002
-- Ders: Veritabanı Yönetim Sistemleri (PostgreSQL) — BLP 1005 (YZO)
-- Senaryo: Kura #3 (Lojistik ve Teslimat x IoT Sensör Ağı x Anomali Tespiti)
-- ============================================================================

/*
HOCAMA NOT / ŞU ANA KADAR NE YAPTIK VE NEDEN YAPTIK? (VİZE ÖZETİ)

Ham Veriyi Tanıma ve ETL (Hafta 3-4):

Kaggle üzerinden aldığımız 6 farklı çilek sevkiyatının (S1-S6) telemetri kayıtlarını
inceledik. Ham veri 14.398 satırdı ve 9 sensör sütun olarak yan yana duruyordu.

Bu geniş format ilişkisel veritabanı mantığına (1NF) uymadığı ve SQL'de "GROUP BY sensor_id"
yapmamızı engellediği için Python (pd.melt) kullanarak veriyi dikey formata çevirdik.

Sonuçta 129.582 satırlık temiz bir ölçüm tablosu (measurements.csv) elde ettik.

Veritabanı ve Veri Temizliği (Hafta 4):

PostgreSQL üzerinde 'measurements' tablosunu oluşturup verileri aktardık.

Ham veride sensör kablosu koptuğunda veya cihaz arızalandığında -999.00 hata kodu yazılmıştı.

Bu satırları tamamen silmedik; çünkü silseydik ölçüm zamanını ve sensörün arızalandığı bilgisini
kaybederdik. Bunun yerine sıcaklığı NULL yaptık. Böylece ortalamaların bozulmasını engelledik.

Analiz Sorguları (Hafta 5):

sql/hafta-05.sql içinde 5 temel analiz yaptık:

Sorgu 1: Sensör başına MIN, MAX ve AVG sıcaklıkları çıkardık.

Sorgu 2: COUNT(*) ile COUNT(temp_c) farkından hangi sensörün kaç kez koptuğunu bulduk.

Sorgu 3: 8°C üstüne çıkıp çileği çürüten kronik ihlalleri HAVING ile filtreledik. En çok
ihlal yaşayan bölmenin 'Front_Middle' (5.467 ihlal) olduğunu gördük.

Sorgu 4: EXTRACT(HOUR) ile anomalilerin günün hangi saatinde toplandığını araştırdık;
öğle saatlerinde (11:00 - 14:00) sıcaklığın zirve yaptığını kanıtladık.

Sorgu 5: COALESCE ile eksik verileri varsayılan 2°C ile doldurmanın gerçek ortalamayı nasıl
saptırdığını matematiksel olarak gösterdik.

Eşik Tablosu (Hafta 11 Hazırlığı):

Adım 18'de 'anomaly_thresholds' tablosunu kurduk (0°C altı donma, 4°C üstü bozulma başlangıcı,
8°C üstü kritik çürüme). Eşikleri koda gömmek yerine dinamik tabloda tuttuk.

BU DOSYADA NE OLACAK VE NEDEN ŞİMDİ DEĞİL DE FİNALDE (HAFTA 11)?

Gizem Hocamızın ders yönergesinde (Bölüm 1) belirtildiği üzere:
"Vizede ERD, JOIN, DDL ve YZ bileşeninin veritabanında uygulanması yer almaz.
Bu konular dönem sonunda gelir."

Bu kurala sadık kalarak, Yapay Zekâ sınıflandırma mekanizmasını vizede zorla çalıştırmak
yerine mimarisini planlayıp aşağıya taslak olarak bırakıyoruz.

DÖNEM SONUNDA (HAFTA 11 / FINAL) NELER YAPILACAK?

measurements tablosundaki canlı telemetri kayıtları ile anomaly_thresholds tablosundaki
kural sınırları CROSS JOIN ile dinamik olarak bağlanacak.

Aşağıdaki 'vw_ai_anomaly_logs' VIEW'ı aktif edilecek. Böylece her ölçüm geldiği anda
otomatik olarak etiketlenecek:

temp_c IS NULL                     -> 'SENSOR_FAULT' (Donanım arızası, meyve sağlam olabilir)

temp_c < min_safe_temp (0.0°C)     -> 'COLD_ANOMALY' (Donma riski, hücre hasarı)

temp_c > critical_high_temp (8.0°C)-> 'CRITICAL_HEAT_BREACH' (Tam ürün kaybı/çürüme)

temp_c > max_safe_temp (4.0°C)     -> 'MODERATE_HEAT_ANOMALY' (Erken bozulma riski)

Diğer durumlar                     -> 'NORMAL' (Soğuk zincir güvende)

İleride model veya ürün türü değiştiğinde kodlara dokunmadan sadece eşik tablosunu
güncelleyerek tüm sistemin canlı izlenmesi sağlanacak.
*/

-- ============================================================================
-- DÖNEM SONU (HAFTA 11) İÇİN HAZIRLANAN YZ SINIFLANDIRMA VIEW TASLAĞI:
-- (Hafta 11 tesliminde yorum satırları kaldırılarak aktif edilecektir)
-- ============================================================================

/*
CREATE OR REPLACE VIEW vw_ai_anomaly_logs AS
SELECT
m.id AS measurement_id,
m.shipment_id,
m.measurement_time,
m.sensor_id,
m.temp_c,
t.min_safe_temp,
t.max_safe_temp,
t.critical_high_temp,
CASE
WHEN m.temp_c IS NULL THEN 'SENSOR_FAULT'
WHEN m.temp_c < t.min_safe_temp THEN 'COLD_ANOMALY'
WHEN m.temp_c > t.critical_high_temp THEN 'CRITICAL_HEAT_BREACH'
WHEN m.temp_c > t.max_safe_temp THEN 'MODERATE_HEAT_ANOMALY'
ELSE 'NORMAL'
END AS ai_classification
FROM measurements m
CROSS JOIN anomaly_thresholds t
WHERE t.product_type = 'Strawberry';

-- Hafta 11 Doğrulama Sorgusu:
-- SELECT ai_classification, COUNT(*) AS sinif_adedi
-- FROM vw_ai_anomaly_logs
-- GROUP BY ai_classification;
*/