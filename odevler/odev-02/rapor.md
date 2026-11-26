# Ödev Raporu

**Ödev no:** Ödev 2     **Hafta:** 6-7     **Tarih:** 27 / 11 / 2026

**Ad Soyad:** Mikail Furkan Toprak  **Öğrenci No:** 202607131002

**Program:** ☒ Yapay Zeka Operatörlüğü  ☐ Robotik ve Yapay Zeka

**Kullandığım veritabanı:** ☐ `llm_ops`  ☒ `robot_fleet`

**PR bağlantısı:** https://github.com/mikailsoftware/vize-202607131002/pull/2

**Commit sayısı:** 7

---

## 1. Fan-out

4. soruda toplam batarya, JOIN'siz doğru hesapta **262** çıkması gerekirken JOIN'li sorguda **700** çıktı. Sebebi, `robots` ile `missions` birleşince her robotun satırı görev sayısı kadar çoğalması ve `sum()` bu kopyaları da toplaması. Atlas-01, Kartal-01 ve Kartal-03 üçer kez, Mars-01 ile Mars-02 ikişer kez, Atlas-02 bir kez sayıldı. Hiç görevi olmayan Kartal-02, Atlas-03, Mars-03 ve Kartal-04 INNER JOIN'de hiç yer almadı.

Gerçek bir raporda bu hata filonun toplam şarjını yaklaşık 2,7 kat şişik gösterir. Filo sorumlusu elinde yeterli enerji varmış gibi düşünüp şarj planını yanlış yapabilir. Görev sayısı fazla olan robotların bataryası daha ağır bastığı için sonuç sadece büyük değil, çarpık da olur.

## 2. En zor karar

ERD'de en çok düşündüren karar `measurements` tablosunun anahtarı oldu. İki seçenek vardı: yapay bir `id` (BIGSERIAL) kullanmak ya da (`shipment_id`, `sensor_id`, `measurement_time`) üçlüsünü bileşik doğal anahtar yapmak. Önce `sensor_id` ile zamanı anahtar saymak yeterli göründü, ama CSV'de bu ikili 55.899 kez tekrar ediyor, çünkü farklı sevkiyatların zaman damgaları örtüşüyor; üçlü ise hiç tekrar etmiyor. Bileşik anahtar doğru olurdu ama üç sütunluk bir anahtar, ileride ölçümlere başka bir tablo bağlanırsa işi zorlaştırır. Bu yüzden `id`'yi birincil anahtar yaptım ve üçlüye ayrıca `UNIQUE` koyarak aynı ölçümün iki kez yüklenmesini engelledim. Bedeli bir sütun ve bir indeks fazlası, karşılığında anahtar kısa ve model sade kalıyor.

---

## 3. Yapay zeka kullanım beyanı

☐ Bu ödevde yapay zeka aracı **kullanmadım.**

☒ Kullandım, aşağıda belirttim:

| Soru no | Araç | Ne sordum (özet) | Cevabı nasıl doğruladım |
|---|---|---|---|
| Bölüm 1, soru 1-5 | Claude | robot_fleet için 5 JOIN sorgusunu ve tek cümlelik yorumlarını yazmasını istedim | Sorguları psql'de kendim çalıştırdım, satır sayılarını (9, 10, 4) tablodaki verilerle elle karşılaştırdım, 4. soruda 700 ve 262 farkını robot başına görev sayısıyla kontrol ettim |
| Bölüm 2 (ERD, normalizasyon, JOIN soruları) | Claude | vize projemin senaryo ve SQL dosyalarını verip ERD, normalizasyon tablosu ve iki JOIN sorusunun taslağını istedim | ERD'yi `SCENARIO.md`'deki tablo adaylarıyla ve `measurements.csv` verisiyle karşılaştırdım, (shipment_id, sensor_id, measurement_time) üçlüsünün tekrar etmediğini sorguyla kontrol ettim |
| Rapor, madde 1 | Claude | fan-out sorusunun taslağını yazmasını istedim | Hangi robotun kaç kez sayıldığını soru 4 ve 5'in çıktısıyla karşılaştırdım |
| Rapor, madde 2 | Claude | ERD'deki karar noktalarını çıkarmasını ve anahtar seçimi için bir taslak yazmasını istedim | Taslağı okudum, 55.899 ve "üçlü tekrar etmiyor" bilgisini `measurements.csv` üzerinde kendim kontrol ettim |

---

**İmza:** ________________________

*Doğruluk beyanı: Bu çalışmayı kendim yaptım. Kullandığım tüm yardımcı kaynakları ve yapay zeka araçlarını yukarıda beyan ettim.*
