# Kura #3: Logistics and Delivery x IoT Sensor Network x Anomaly Detection

[🇹🇷 Türkçe](SCENARIO.md) | [🇬🇧 English](SCENARIO.en.md)

**Öğrenci No:** 202607131002  
**Ders:** Veritabanı Yönetim Sistemleri (PostgreSQL)  
**Senaryo Kurası:** Kura #3 (Lojistik ve Teslimat x IoT Sensör Ağı x Anomali Tespiti)  

---

## 1. Operasyonel Hikâye ve Problem Tanımı
Soğuk zincir lojistiğinde çilek gibi hassas meyvelerin taşınması sırasında ortam sıcaklığının 0.0°C ile 4.0°C arasında tutulması zorunludur. Sıcaklığın bu aralığın dışına çıkması ürünlerin bozulmasına, raf ömrünün kısalmasına ve ciddi ekonomik kayıplara yol açar. Bir depo ve lojistik işletmesi S1-S6 sevkiyatlarında konteyner içerisindeki 9 farklı sensörden (ön, orta, arka bölmeler) sıcaklık telemetri verilerini toplamaktadır. Sistem, normal sınırların dışına çıkan sapmaları (anomalileri) otomatik tespit etmelidir.

## 2. Ana Analiz Sorusu (Main Research Question)
> **"Hangi sensörlerde anomali sıklığı en yüksektir ve bu anomaliler günün hangi saatlerinde yoğunlaşmaktadır?"**

Dönem boyunca geliştirilecek tüm SQL sorguları ve veri modelleri doğrudan bu soruyu yanıtlamaya odaklanacaktır.

## 3. Hedef Kullanıcı Profili
- **Soğuk Zincir Kalite Denetçileri:** Kritik sıcaklık ihlali yapan sevkiyatları incelemek.
- **Lojistik ve Filo Yöneticileri:** Hangi sensör bölmelerinin (örn. kapıya yakın olan Rear bölmesi) yalıtım problemi yaşadığını saptamak.

## 4. Hafta 3 Tablo ve Sütun Adayları

### Tablo 1: `sensors` (Boyut Tablosu)
Konteyner ve depo içerisindeki fiziksel IoT sensörlerinin künyesini tutar.
- `sensor_id` (VARCHAR(50), PK): Sensörün benzersiz kodu (örn. Front_Top, Rear_Bottom).
- `compartment_zone` (VARCHAR(20)): Bulunduğu bölme (Front, Middle, Rear).
- `vertical_level` (VARCHAR(20)): Dikey konumu (Top, Middle, Bottom).
- `installed_at` (TIMESTAMP): Sensörün devreye alınma tarihi.

### Tablo 2: `measurements` (Olay/Telemetri Tablosu)
Sensörlerden gelen zaman serisi sıcaklık ölçümlerini saklar.
- `id` (BIGSERIAL, PK): Benzersiz ölçüm kayıt numarası.
- `shipment_id` (VARCHAR(10)): Sevkiyat referansı (S1, S2, S3, S4, S5, S6).
- `sensor_id` (VARCHAR(50), FK): Ölçümü yapan sensör kodu.
- `temp_c` (NUMERIC(5,2)): Ölçülen sıcaklık değeri (°C). Hatalı donanım okumalarında NULL.
- `measurement_time` (TIMESTAMP): Ölçümün alındığı zaman damgası.

### Tablo 3: `anomaly_thresholds` (Parametre Tablosu)
Güvenli sıcaklık sınırlarını ve ürün kurallarını dinamik olarak saklar.
- `rule_id` (SERIAL, PK): Kural kimliği.
- `product_name` (VARCHAR(50)): İzlenen ürün türü (Çilek).
- `min_safe_temp` (NUMERIC(4,2)): Kabul edilebilir en düşük sıcaklık (0.0°C).
- `max_safe_temp` (NUMERIC(4,2)): Kabul edilebilir en yüksek sıcaklık (4.0°C).



## 5. Yapay Zekâ Bileşeni Stratejisi (Dönem Sonu Hafta 11 Mimarisi)

### 5.1. Anomali Türlerinin Mantıksal Ayrımı (Kritik Kural)
Bu projede çilek soğuk zinciri izleme sürecinde iki farklı anomali türü veritabanı seviyesinde birbirinden kesin çizgilerle ayrılacaktır:

1. Donanım Arızası (SENSOR_FAULT):
   - Sensör kablosunun kopması, pilinin bitmesi veya kablosuz iletimin kesilmesidir.
   - Veritabanında NULL (ham veride -999.00) okumalarıyla temsil edilir.
   - Önemi: Bu durum bir "ürün bozulması" değil, doğrudan cihaz arızasıdır. Meyvenin donduğunu ya da yandığını göstermez.

2. Termal Soğuk Zincir İhlalleri (Biyolojik Risk):
   - Sensör sağlamdır ancak kamyon içi sıcaklık güvenli 0.0°C - 4.0°C aralığının dışına çıkmıştır.
   - Donma Riski (COLD_ANOMALY): Sıcaklık < 0.0°C (Çilek hücreleri donar, hücre zarı çatlar ve doku ölümü gerçekleşir).
   - Orta Düzey Isınma (MODERATE_HEAT_ANOMALY): 4.0°C < Sıcaklık <= 8.0°C (Solunum hızı artar, bakteri ve küf aktivitesi başlar).
   - Kritik Isınma İhlali (CRITICAL_HEAT_BREACH): Sıcaklık > 8.0°C (Geri dönüşsüz çürüme ve tam ürün kaybı).

### 5.2. Dinamik VIEW ile Veritabanı Otomasyonu (vw_ai_anomaly_logs)
Hafta 11 kapsamında statik bir Python betiği yerine veritabanı içerisinde çalışan dinamik bir VIEW (vw_ai_anomaly_logs) mimarisi kurulacaktır. Canlı ölçümler anomaly_thresholds tablosuyla eşleştirilerek her ölçüm anında otomatik olarak sınıflandırılacaktır (NORMAL, COLD_ANOMALY, MODERATE_HEAT_ANOMALY, CRITICAL_HEAT_BREACH, SENSOR_FAULT).