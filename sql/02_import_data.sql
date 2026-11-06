-- CSV aktarımı python/05_import_data.py tarafından yapılır.
-- VS Code terminalinde çalıştır:
-- python python/05_import_data.py
--
-- Script, data/processed/measurements.csv dosyasını PostgreSQL'e aktarır.
-- -999 değerlerini NULL olarak yükler ve 129.582 satırı doğrular.

SELECT COUNT(*) AS yuklenen_satir_sayisi
FROM measurements;