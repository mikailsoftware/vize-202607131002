# Ödev 2: JOIN, ERD ve Normalizasyon

**Ad Soyad:** Mikail Furkan Toprak
**Öğrenci No:** 202607131002
**Ders:** BLP 1005 Veritabanı Yönetim Sistemleri (Yapay Zeka Operatörlüğü)
**Teslim:** 27 Kasım 2026, 09:00 (branch `odev-02`, reviewer: gizemturker)

## Bu klasörde ne var

| Dosya | İçerik |
|---|---|
| `sorgular.sql` | Bölüm 1: 5 JOIN sorgusu ve her birinin altında tek cümlelik yorum |
| `rapor.md` | Bölüm 3: bir sayfalık rapor (fan-out, en zor karar, YZ beyanı) |

Bölüm 2 (ERD, normalizasyon notu ve iki JOIN sorusu) bu klasörde değil, reponun kökündeki [README.md](../../README.md) dosyasında, "Veri Modeli" başlığının altında.

## Çalıştırma

```bash
createdb robot_fleet
psql -d robot_fleet -f data/robot_fleet.sql   # ders reposundaki dosya
psql -d robot_fleet -f odevler/odev-02/sorgular.sql
```

Ders reposundaki `robot_fleet.sql` her çalıştırıldığında tabloları silip yeniden kurduğu için istediğin kadar tekrar çalıştırabilirsin.

## Kısa özet

- Sorgu 1 ve 2'de `INNER JOIN` 9, `LEFT JOIN` 10 satır döndürdü. Aradaki fark, operatörü boş (NULL) olan Mars-03.
- Sorgu 3'te hiç görevi olmayan 4 robot bulundu.
- Sorgu 4'te `JOIN` ile toplam batarya 700, doğru değer ise 262 çıktı. `JOIN` her robotu görev sayısı kadar tekrar ettiği için (fan-out) toplam şişti.
- Sorgu 5'te `count(*)` ve `count(m.id)`, hiç görevi olmayan robotlarda farklı sonuç verdi.

## Yapay zeka kullanımı

Bu ödevde Claude'dan yardım aldım. Hangi bölümde ne sorduğum ve sonuçları nasıl doğruladığım `rapor.md` içindeki beyan tablosunda yazıyor.
