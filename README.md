# Çilek IoT Soğuk Zincir Telemetrisi Anomali Analizi

[🇹🇷 Türkçe](README.md) | [🇬🇧 English](README.en.md)

Bu proje, S1-S6 sevkiyatlarındaki IoT sensör sıcaklık anomalilerini analiz
etmektedir.

- **Güvenli sıcaklık aralığı:** 0.0°C - 4.0°C
- **Hedef veritabanı:** PostgreSQL
- **Toplam ham kayıt:** 14.398 satır

## Veri Kaynağı

Bu projede kullanılan çilek soğuk zinciri IoT telemetri verileri, Hugging
Face üzerindeki **Cold-Chain Transportation Strawberry Dataset** veri
setinden alınmıştır.

- **Kaynak:** [NifferLi/Cold-Chain-Transportation-Strawberry](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry)
- **İçerik:** S1-S6 sevkiyatları ve 9 sıcaklık sensöründen alınan zaman serisi ölçümleri
- **Erişim tarihi:** 31 Ekim 2026

Bu projede ham Parquet dosyaları okunmuş, sensör sütunları ilişkisel uzun
formata dönüştürülmüş ve `data/processed/measurements.csv` dosyası
oluşturulmuştur.