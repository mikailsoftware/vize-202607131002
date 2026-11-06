from pathlib import Path
import os

import psycopg2


project_root = Path(__file__).parent.parent
csv_file = project_root / "data" / "processed" / "measurements.csv"

if not csv_file.exists():
    raise FileNotFoundError(f"CSV dosyası bulunamadı: {csv_file}")

connection = psycopg2.connect(
    host=os.getenv("PGHOST", "localhost"),
    port=os.getenv("PGPORT", "5432"),
    dbname=os.getenv("PGDATABASE", "strawberry_db"),
    user=os.getenv("PGUSER", "postgres"),
    password=os.getenv("PGPASSWORD"),
)

try:
    with connection.cursor() as cursor:
        cursor.execute(
            """
            CREATE TABLE IF NOT EXISTS measurements (
                id BIGSERIAL PRIMARY KEY,
                shipment_id VARCHAR(10) NOT NULL,
                measurement_time TIMESTAMP NOT NULL,
                sensor_id VARCHAR(50) NOT NULL,
                temp_c NUMERIC(5, 2)
            );
            """
        )

        cursor.execute("TRUNCATE TABLE measurements RESTART IDENTITY;")
        cursor.execute(
            """
            CREATE TEMP TABLE measurements_import (
                shipment_id TEXT,
                measurement_time TEXT,
                sensor_id TEXT,
                temp_c TEXT
            ) ON COMMIT DROP;
            """
        )

        with csv_file.open("r", encoding="utf-8", newline="") as file:
            cursor.copy_expert(
                """
                COPY measurements_import
                FROM STDIN
                WITH (FORMAT CSV, HEADER TRUE);
                """,
                file,
            )

        cursor.execute(
            """
            INSERT INTO measurements
                (shipment_id, measurement_time, sensor_id, temp_c)
            SELECT
                shipment_id,
                measurement_time::TIMESTAMP,
                sensor_id,
                NULLIF(NULLIF(temp_c, ''), '-999')::NUMERIC(5, 2)
            FROM measurements_import;
            """
        )

        cursor.execute("SELECT COUNT(*) FROM measurements;")
        loaded_rows = cursor.fetchone()[0]

    connection.commit()
finally:
    connection.close()

expected_rows = 129_582
print(f"Yüklenen satır sayısı: {loaded_rows:,}".replace(",", "."))

if loaded_rows != expected_rows:
    raise RuntimeError(
        f"Beklenen satır sayısı {expected_rows:,}, ancak {loaded_rows:,} satır yüklendi."
    )

print("VERİ AKTARIMI BAŞARILI: 129.582 satır PostgreSQL'e yüklendi.")
