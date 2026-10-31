# Kura #3: Logistics and Delivery x IoT Sensor Network x Anomaly Detection

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