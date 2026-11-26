-- Ödev 2, Bölüm 1: Filo soruları
-- Ad Soyad: Mikail Furkan Toprak (202607131002)
-- Veritabanı: robot_fleet
-- Her sorgunun altına sonucu açıklayan tek cümlelik yorum yazıldı.

-- Soru 1: Her robotun adı, operatör adı ve operatör telefonu (INNER JOIN)
SELECT r.name, o.operator_name, o.phone
FROM robots r
INNER JOIN operators o ON r.operator_name = o.operator_name;

-- Yorum: 9 satır döndü, çünkü 10 robottan yalnızca Mars-03'ün operatörü boş (NULL) ve NULL hiçbir operatörle eşleşmediği için INNER JOIN onu dışarıda bıraktı.


-- Soru 2: Aynı liste, bütün robotlar görünsün (LEFT JOIN). 1. sorguyla karşılaştır, kim kayboldu?
SELECT r.name, o.operator_name, o.phone
FROM robots r
LEFT JOIN operators o ON r.operator_name = o.operator_name;

-- Yorum: 10 satır döndü; 1. sorguda kaybolan Mars-03 artık operatör adı ve telefon sütunları NULL olarak listede görünüyor.


-- Soru 3: Hiç görev almamış robotların adı ve modeli
SELECT r.name, r.model
FROM robots r
LEFT JOIN missions m ON m.robot_id = r.id
WHERE m.id IS NULL;

-- Yorum: 4 satır döndü (Kartal-02, Atlas-03, Mars-03, Kartal-04), çünkü bu robotların missions tablosunda hiç eşleşen satırı yok ve LEFT JOIN sonrası m.id NULL kalıyor.


-- Soru 4a: JOIN ile hesaplanan toplam batarya (görevi olan robotlar)
SELECT sum(r.battery_level) AS toplam_batarya
FROM robots r
INNER JOIN missions m ON m.robot_id = r.id;

-- Soru 4b: JOIN kullanmadan doğru toplam
SELECT sum(battery_level) AS toplam_batarya
FROM robots
WHERE id IN (SELECT robot_id FROM missions);

-- Yorum (iki sonuç ve fark): 4a 700, 4b 262 verdi; JOIN her robotu görev sayısı kadar tekrarladığı için (fan-out) bataryalar 3 görevli robotlarda üç kez, 2 görevlilerde iki kez toplandı, doğru değer 4b'deki 262.


-- Soru 5: Robot başına görev sayısı; count(*) ve count(m.id) yan yana
SELECT r.name,
       count(*)    AS count_yildiz,
       count(m.id) AS count_m_id
FROM robots r
LEFT JOIN missions m ON m.robot_id = r.id
GROUP BY r.id, r.name
ORDER BY r.id;

-- Yorum (hangi robotlarda ikisi farklı?): Kartal-02, Atlas-03, Mars-03 ve Kartal-04'te count(*) 1, count(m.id) 0 çıktı, çünkü LEFT JOIN bu robotlar için NULL'lu bir satır üretiyor, count(*) o satırı sayıyor ama count(m.id) NULL'u saymıyor; doğru görev sayısı count(m.id).
