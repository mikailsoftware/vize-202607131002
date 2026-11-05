# Yapay Zekâ Kullanım Beyanı

**Öğrenci No:** 202607131002  
**Ders:** Veritabanı Yönetim Sistemleri (PostgreSQL) — BLP 1005 (YZO)  
**Senaryo Kurası:** Kura #3 — Lojistik ve Teslimat x IoT Sensör Ağı x Anomali Tespiti  
**Proje Konusu:** Çilek soğuk zinciri taşımacılığında IoT sensör verileriyle sıcaklık anomalilerinin incelenmesi  
**Proje Deposu:** `vize-202607131002`  
**Tarih:** Güz 2026  

## 1. Kullanılan Yapay Zekâ Araçları

Bu projede GitHub Copilot ve Google Gemini araçlarından yalnızca öğrenme, araştırma ve teknik danışmanlık amacıyla yararlanılmıştır.

Yapay zekâ araçları projenin tamamını öğrencinin yerine hazırlamak amacıyla kullanılmamıştır. Bu araçlar; kullanılan teknolojileri anlamak, hata mesajlarını yorumlamak, kod ve SQL yapısını öğrenmek, proje kapsamını planlamak ve dokümantasyon hakkında fikir almak için yardımcı kaynak olarak kullanılmıştır.

## 2. Yapay Zekâdan Yararlanılan Konular

Yapay zekâ araçlarından aşağıdaki konularda destek alınmıştır:

- Lojistik ve teslimat alanında IoT sensör ağı senaryosunun oluşturulması
- Çilek soğuk zinciri problemi ve sıcaklık anomalilerinin araştırılması
- Uygun açık veri kaynağının araştırılması
- Parquet dosya formatının anlaşılması
- Python ve Pandas kullanımının öğrenilmesi
- `pathlib.Path` ile taşınabilir dosya yolları oluşturulması
- `glob()` ile Parquet dosyalarının bulunması
- `pandas.read_parquet()` ile veri okunması
- S1-S6 dosyalarının satır ve sütun yapısının incelenmesi
- Veri şemasının programatik olarak karşılaştırılması
- `pandas.melt()` fonksiyonunun çalışma mantığının öğrenilmesi
- Geniş veri formatının uzun/ilişkisel formata dönüştürülmesi
- `NULL` ve donanım hata kodlarının veri analizindeki etkisinin anlaşılması
- PostgreSQL tablo ve veri aktarım yapısının öğrenilmesi
- `SELECT`, `WHERE`, `GROUP BY`, `HAVING`, `NULL`, `EXTRACT(HOUR)`, `CASE WHEN` ve `COALESCE()` konularının anlaşılması
- Anomali eşiklerinin ve sınıflandırma mantığının planlanması
- Git commit mesajlarının daha anlaşılır yazılması
- İngilizce dokümantasyon ve Conventional Commits öneklerinin kullanılması

Yapay zekâ tarafından verilen açıklamalar ve örnekler doğrudan ve kontrol edilmeden teslim edilmemiştir. Örnek kodlar gerçek proje dosyaları üzerinde çalıştırılmış, elde edilen çıktılar incelenmiş ve proje gereksinimleriyle karşılaştırılmıştır.

## 3. Öğrencinin Gerçekleştirdiği Python Çalışmaları

S1-S6 sevkiyatlarına ait altı Parquet dosyası proje klasörüne yerleştirilmiş ve Python kullanılarak incelenmiştir.

`python/01_read_files.py` dosyası ile:

- Proje kök dizini Python dosyasının konumuna göre dinamik olarak bulunmuştur.
- `data/original/` klasöründeki Parquet dosyaları listelenmiştir.
- Altı sevkiyat dosyasının okunabildiği kontrol edilmiştir.
- Her dosyanın satır ve sütun sayısı yazdırılmıştır.
- S1-S6 dosyalarının toplam 14.398 ham kayıt içerdiği doğrulanmıştır.

Python sürecinde aşağıdaki araç ve yapılar kullanılmış veya incelenmiştir:

- `pathlib`
- `Path`
- `glob()`
- `pandas`
- `pandas.read_parquet()`
- `DataFrame`
- `head()`
- `shape`
- `columns`
- `dtypes`
- `len()`

Dosya yolu hatasıyla karşılaşıldığında, göreli dosya yolunun Python’un çalıştırıldığı klasöre bağlı olduğu anlaşılmıştır. Bu sorunu azaltmak için proje kök dizininin betiğin kendi konumuna göre bulunması yöntemi kullanılmıştır.

## 4. Veri Şeması ve Veri Kalitesi Kontrolleri

`python/02_verify_schema.py` dosyası ile S1-S6 dosyalarının sütun yapısı programatik olarak karşılaştırılmıştır.

Bu kontrolde:

- Sütun adları karşılaştırılmıştır.
- Sütunların sırası karşılaştırılmıştır.
- Her dosyada 37 sütun bulunduğu doğrulanmıştır.
- Dosyaların aynı şemaya sahip olduğu kontrol edilmiştir.

`python/03_find_errors.py` dosyası ile sensör sütunlarında bulunan `-999.00` donanım hata kodları taranmıştır.

Bu değerler gerçek sıcaklık ölçümü olarak kabul edilmemiştir. Sensör bağlantısının kopması veya cihaz arızası gibi durumları gösterebileceği için veri analizinde ayrı bir veri kalitesi problemi olarak değerlendirilmiştir.

## 5. Veri Dönüşümü ve ETL Çalışması

`python/04_process_data.py` dosyası ile ham veride yan yana bulunan dokuz sensör sütunu `pandas.melt()` kullanılarak uzun ve ilişkisel forma dönüştürülmüştür.

Dönüştürülen sensör alanları şunlardır:

- `Front_Top`
- `Front_Middle`
- `Front_Bottom`
- `Middle_Top`
- `Middle_Middle`
- `Middle_Bottom`
- `Rear_Top`
- `Rear_Middle`
- `Rear_Bottom`

Geniş formattaki veri:

```text
Bir satır = bir zaman kaydındaki dokuz sensör sütunu