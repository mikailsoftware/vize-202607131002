# Veri Kartı — Çilek Soğuk Zinciri IoT Telemetrisi

[🇹🇷 Türkçe](dataREADME.md) | [🇬🇧 English](dataREADME/dataREADME.en.md) | [🇩🇪 Deutsch](dataREADME/dataREADME.de.md) | [🇫🇷 Français](dataREADME/dataREADME.fr.md) | [🇮🇹 Italiano](dataREADME/dataREADME.it.md) | [🇪🇸 Español](dataREADME/dataREADME.es.md) | [🇨🇳 中文](dataREADME/dataREADME.zh-CN.md)

## 1. Veri seti ve vize kapsamı

Bu veri kartı, `vize-202607131002` projesinin Vize Hafta 3-5 kapsamındaki
veri hazırlama, tablo tasarımı ve SQL analizleri için kullanılan çilek soğuk
zinciri IoT telemetrisini tanımlar. Veri, S1-S6 sevkiyatlarını ve dokuz
sensörden alınan sıcaklık ölçümlerini kapsar.

- Ham veri: **14.398 kayıt, 37 sütun**
- Sensör sayısı: **9**
- Uzun format: **14.398 × 9 = 129.582 ölçüm satırı**
- Hedef veritabanı: PostgreSQL

## 2. Veri kaynağı ve lisans

Veri, Hugging Face üzerindeki [Cold-Chain Transportation Strawberry
Dataset](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry)
veri setinden alınmıştır. Proje kaydındaki lisans bilgisi **Open Data
Commons / CC-BY 4.0**, indirme tarihi ise **Ekim 2026** olarak belirtilmiştir.
Ham Parquet dosyaları kaynak verinin değişmez kopyalarıdır; elle
değiştirilmez.

## 3. Kalite kuralları ve dönüşüm

- Sensör donanım hata kodu olan `-999` (ve `-999.00`) gerçek sıcaklık kabul
  edilmez ve SQL tarafında `NULL` olarak saklanır.
- `NULL` dönüşümü, eksik ölçümleri ortalama ve eşik analizlerini bozabilecek
  sahte sıcaklıklardan ayırır.
- Dokuz sensör sütunu geniş formattan uzun formata dönüştürülür. Her uzun
  format satırı tek bir sensör ölçümünü temsil eder.
- Beklenen çıktı `data/processed/measurements.csv` içinde **129.582** satırdır.

## 4. Sıcaklık eşikleri

- Güvenli aralık: **0,0°C-4,0°C**
- Kritik kayıp eşiği: **8,0°C üzeri**
- Eşikler `sql/05_anomaly_thresholds.sql` ve ilgili analiz sorgularında
  kullanılır; `-999` değerleri eşik hesabına katılmaz.

## 5. Dosya yapısı

```text
vize-202607131002/
├── data/
│   ├── original/                 # S1-S6 ham Parquet dosyaları
│   ├── processed/
│   │   └── measurements.csv      # 129.582 satırlık uzun format çıktı
│   └── dataREADME/               # Bu veri kartı ve dil sürümleri
├── python/                       # Okuma, doğrulama, dönüşüm ve aktarım
├── sql/                          # PostgreSQL şeması ve analiz sorguları
├── README.md                     # Proje ana README'si
└── SCENARIO.md                   # Vize senaryosu ve problem bağlamı
```

## 6. Yeniden üretilebilir akış

Proje kökünden `python/01_read_files.py`, `python/02_verify_schema.py`,
`python/python03_find_errors.py`, `python/04_process_data.py` ve
`python/05_import_data.py` sırasıyla çalıştırılır. Bu akış dosyaları okur,
37 sütunluk şemayı doğrular, `-999` değerlerini işaretler, dokuz sensörü
uzun formata çevirir ve PostgreSQL'e aktarır.
