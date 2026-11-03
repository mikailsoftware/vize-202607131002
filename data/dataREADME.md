# Veri Kartı — Çilek Soğuk Zinciri IoT Telemetrisi

[🇹🇷 Türkçe](dataREADME.md) | [🇬🇧 English](dataREADME_EN.md)

## 1. Veri Seti Tanımı
S1–S6 sevkiyatlarında çilek soğuk zincirini izleyen IoT sensör telemetri veri seti.

## 2. Veri Kaynağı ve Lisans
- Kaynak: Açık kaynaklı endüstriyel soğuk zincir telemetri kayıtları.
- Gerçek Veri Oranı: %100 (Sentetik/yapay veri üretilmemiştir).
- Lisans: Open Data Commons / CC-BY 4.0.
- İndirme Tarihi: Ekim 2026.

## 3. Ham Veri Dosya Yapısı (data/original/)
- Ham dosyalar Parquet formatında saklanmakta olup kesinlikle elle değiştirilmemiştir.
- Toplam Hacim: 14.398 satır, 37 sütun.

## 4. Veri Kalite Sorunları ve Dönüşümler
- -999 Hata Kodları: Sensör kopma kodları (-999) SQL'de NULL'a çevrilmiştir.
- İlişkisel Dönüşüm: 9 sensör dikey ilişkisel forma çevrilmiştir (129.582 satır).

## 5. Sıcaklık Eşikleri
- Güvenli Aralık: 0.0°C - 4.0°C.
- Kritik İhlal: > 8.0°C.