# Kura #3: Lojistik ve Teslimat x IoT Sensör Ağı x Anomali Tespiti

[🇹🇷 Türkçe](SCENARIO.md) | [🇬🇧 English](SCENARIO.en.md) | [🇩🇪 Deutsch](SCENARIO.de.md) | [🇫🇷 Français](SCENARIO.fr.md) | [🇮🇹 Italiano](SCENARIO.it.md) | [🇪🇸 Español](SCENARIO.es.md) | [🇨🇳 中文](SCENARIO.zh-CN.md)

**Öğrenci No:** 202607131002  
**Ders:** Veritabanı Yönetim Sistemleri (PostgreSQL)  
**Senaryo Kurası:** Kura #3 — Lojistik ve Teslimat x IoT Sensör Ağı x Anomali Tespiti

> Bu dosya operasyonel hikâyeyi, analiz sorularını ve dönem kapsamını tanımlar.
> Veri işleme komutları, klasör yapısı ve yeniden üretme adımları için
> [README.md](README.md) dosyasına bakın.

## 1. Operasyonel hikâye ve problem

Çilek, sıcaklık değişimlerine duyarlı ve raf ömrü kısa bir üründür. Soğuk zincir
taşıması sırasında konteyner içindeki sıcaklığın ürün kuralına göre
0.0°C-4.0°C aralığında tutulması beklenir. Sıcaklığın düşmesi donma hasarına,
yükselmesi ise solunum hızının, küf riskinin ve ürün kaybının artmasına yol
açabilir.

Lojistik işletmesi S1-S6 sevkiyatlarında konteynerin ön, orta ve arka
bölmelerine yerleştirilmiş dokuz sensörden sıcaklık telemetrisi toplamaktadır.
Kalite ekibi yalnızca “bir sevkiyat sorunlu mu?” sorusunu değil, sorunun
konteynerin hangi bölgesinde, hangi sensörde ve günün hangi saatlerinde
tekrarlandığını da bilmek istemektedir. Bu nedenle veri tabanı, ham okumaları
izlenebilir biçimde saklamalı ve sensör arızası ile gerçek termal riski
birbirine karıştırmamalıdır.

## 2. Ana araştırma sorusu

> **Hangi sensörlerde anomali sıklığı en yüksektir ve bu anomaliler günün hangi
> saatlerinde yoğunlaşmaktadır?**

Bu soru, Week 5 sorgularının ortak hedefidir. Sonuçlar sensör konumu,
sevkiyat ve zaman dilimi bakımından karşılaştırılmalı; eksik veya donanım
hatası okumaları gerçek sıcaklık ihlali gibi sayılmamalıdır.

### Destekleyici sorular

- Hangi sevkiyatlarda normal aralık dışındaki ölçüm oranı daha yüksektir?
- `Front`, `Middle` ve `Rear` bölgeleri arasında sistematik fark var mıdır?
- `Top`, `Middle` ve `Bottom` seviyeleri farklı davranıyor mu?
- Anomaliler belirli saatlerde kümeleniyor mu?
- `-999.00` donanım hata kodları hangi sensörlerde ve sevkiyatlarda daha
  sık görülüyor?

## 3. Hedef kullanıcılar ve kararlar

- **Soğuk zincir kalite denetçisi:** Kritik ihlalleri ve etkilenen sevkiyatları
  inceler; ürün kabulü veya ek kontrol kararı verir.
- **Lojistik/f​​ilo yöneticisi:** Sorunlu bölme veya sensör konumunu belirler;
  yalıtım, kapı kullanımı ve bakım planını değerlendirir.
- **Veri tabanı/analiz öğrencisi:** Ham telemetrinin ilişkisel modele
  dönüştürülmesini, veri kalitesinin korunmasını ve SQL ile kanıtlanabilir
  sonuçlar üretilmesini gösterir.

## 4. Veri bağlamı ve gözlemler

Bu senaryo, Hugging Face üzerindeki Cold-Chain Transportation Strawberry
Dataset kaynağından gelen S1-S6 Parquet dosyalarını kullanır. Veri bağlamı:

- 6 sevkiyat (`S1`-`S6`)
- 14.398 ham zaman kaydı
- Dosya başına ortak 37 sütun
- 9 sensör: `Front_Top`, `Front_Middle`, `Front_Bottom`,
  `Middle_Top`, `Middle_Middle`, `Middle_Bottom`, `Rear_Top`,
  `Rear_Middle`, `Rear_Bottom`
- Geniş formattan uzun formata dönüştürüldüğünde 129.582 sensör ölçümü
- Güvenli ürün aralığı: 0.0°C-4.0°C

Ham dosyalar `data/original/`, işlenmiş ölçümler
`data/processed/measurements.csv` altındadır. Bu dosya adları ve klasörler
senaryonun veri sözleşmesidir; ayrıntılı ETL akışı README’de açıklanır.

## 5. Week 3: tablo ve sütun adayları

### 5.1. `sensors` — boyut tablosu

Fiziksel sensörlerin konumunu ve kimliğini tutar:

- `sensor_id` (`VARCHAR(50)`, PK): Örneğin `Front_Top`, `Rear_Bottom`
- `compartment_zone` (`VARCHAR(20)`): `Front`, `Middle`, `Rear`
- `vertical_level` (`VARCHAR(20)`): `Top`, `Middle`, `Bottom`
- `installed_at` (`TIMESTAMP`): Devreye alma zamanı

### 5.2. `measurements` — olay/telemetri tablosu

Her sensörün belirli bir sevkiyat ve zamandaki okumasını tutar:

- `id` (`BIGSERIAL`, PK)
- `shipment_id` (`VARCHAR(10)`): `S1`-`S6`
- `sensor_id` (`VARCHAR(50)`, FK)
- `temp_c` (`NUMERIC(5,2)`): Geçerli sıcaklık veya veri yoksa `NULL`
- `measurement_time` (`TIMESTAMP`)

### 5.3. `anomaly_thresholds` — parametre tablosu

Ürün kurallarını ölçümlerden ayırır:

- `rule_id` (`SERIAL`, PK)
- `product_name` (`VARCHAR(50)`): Çilek
- `min_safe_temp` (`NUMERIC(4,2)`): 0.0°C
- `max_safe_temp` (`NUMERIC(4,2)`): 4.0°C

Bu model, eşiklerin sorgu içine sabitlenmesi yerine kural tablosundan
okunmasına izin verir.

## 6. Week 4: beklenen veri sorunları

Week 4 çalışmasında beklenen sorunlar ve bunların anlamı:

1. **Donanım hata kodu:** Ham sensör değerindeki `-999.00`, gerçek sıcaklık
   değildir. SQL aktarımında `NULL` yapılır ve `SENSOR_FAULT` olarak ayrıca
   yorumlanır.
2. **Eksik ölçüm:** `NULL`, sıcaklığın güvenli olduğu anlamına gelmez; yalnızca
   ölçümün kullanılamadığını gösterir.
3. **Geniş veri biçimi:** Dokuz sensörün aynı satırda bulunması analizleri
   zorlaştırır. `pandas.melt()` sonrası her satır tek bir sensör ölçümünü
   temsil etmelidir.
4. **Şema tutarlılığı:** S1-S6 dosyalarının 37 sütunluk yapısı ve sensör
   alanları karşılaştırılmalıdır.
5. **Kayıt sayısı doğrulaması:** 14.398 × 9 hesabı ile 129.582 uzun-format
   satırın üretildiği kontrol edilmelidir.

Bu bölüm veri hazırlama ve modelleme beklentisini tanımlar; ayrıntılı Python
çalıştırma komutları README’de tutulur.

## 7. Week 5: analiz soruları

PostgreSQL üzerinde üretilecek sorgular en az şu soruları incelemelidir:

- Sensör bazında toplam ölçüm, geçerli ölçüm, `NULL`/arıza sayısı ve anomali
  sayısı nedir?
- Sevkiyat bazında sıcaklık ihlali oranı nasıl değişmektedir?
- Saat (`EXTRACT(HOUR FROM measurement_time)`) bazında yoğunlaşma var mıdır?
- Bölge ve dikey seviye ile anomali sıklığı arasında ilişki var mıdır?
- 0.0°C altı, 4.0°C-8.0°C arası ve 8.0°C üstü okumalar nasıl ayrılır?
- Ortalama hesapları `NULL` ve donanım hatası kodlarından nasıl korunur?

Beklenen sınıflar, geçerli ölçümler için `NORMAL`, `COLD_ANOMALY`,
`MODERATE_HEAT_ANOMALY` ve `CRITICAL_HEAT_BREACH`; ölçüm yokluğu için
`SENSOR_FAULT` olarak düşünülebilir.

## 8. YZ bileşeni stratejisi ve kapsam sınırı

YZ bileşeni dönem sonu Week 11 için planlanan bir mimaridir; mevcut vize
çıktısı tamamlanmış bir AI modeli veya canlı tahmin sistemi değildir.

Planlanan ayrım:

- `SENSOR_FAULT`: Ham `-999.00` değerinden gelen donanım/iletişim sorunu.
- `COLD_ANOMALY`: `temp_c < 0.0°C`.
- `MODERATE_HEAT_ANOMALY`: `4.0°C < temp_c <= 8.0°C`.
- `CRITICAL_HEAT_BREACH`: `temp_c > 8.0°C`.
- `NORMAL`: Geçerli ve güvenli aralıkta ölçüm.

Gelecekte `anomaly_thresholds` tablosuyla beslenen dinamik
`vw_ai_anomaly_logs` görünümü her ölçümü bu etiketlerden biriyle
sınıflandırabilir. Bu tasarım hedefidir; bu vizede AI özelliği bitmiş gibi
sunulmaz. AI kullanımının açıklaması [AI_BEYAN.md](AI_BEYAN.md) dosyasındadır.

## 9. Vize/final sınırı

- **Vize, Week 3-5:** Veri kaynağını ve şemayı anlamak, tablo adaylarını
  tasarlamak, veri kalitesi sorunlarını ayırmak, uzun-format çıktıyı üretmek,
  PostgreSQL'e aktarmak ve açıklanabilir SQL analizleri yazmak.
- **Final/dönem sonu, Week 11:** Parametre tabanlı dinamik görünüm, daha ileri
  anomali sınıflandırması ve planlanan AI katmanının değerlendirilmesi.

Bu ayrım, mevcut çıktının kapasitesini olduğundan fazla göstermemek ve
gelecek çalışmayı açıkça plan olarak tutmak için korunur.
