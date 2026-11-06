# IoT-Telemetrieanalyse der Erdbeer-Kühlkette

[🇹🇷 Türkçe](../README.md) | [🇬🇧 English](README.en.md) | [🇩🇪 Deutsch](README.de.md) | [🇫🇷 Français](README.fr.md) | [🇮🇹 Italiano](README.it.md) | [🇪🇸 Español](README.es.md) | [🇨🇳 中文](README.zh-CN.md)

Dieses Projekt überführt Temperaturdaten von neun IoT-Sensoren aus den
Sendungen S1-S6 in eine relationale Struktur und bereitet sie für
Datenqualitäts- und Anomalieanalysen in PostgreSQL auf. Die operative
Geschichte, die Problemdefinition und die zentrale Forschungsfrage stehen in
[SCENARIO.md](../SCENARIO.md) bzw. [SCENARIO.en.md](../scenario/SCENARIO.en.md); diese Datei
konzentriert sich auf den technischen Ablauf.

## Umfang

- **Datensatz:** Sendungen S1-S6, 9 Sensoren, 14.398 Rohzeitpunkte
- **Rohschema:** 37 Spalten im Apache-Parquet-Format
- **Verarbeitete Ausgabe:** 129.582 Messzeilen im Langformat
- **Sicherer Temperaturbereich:** 0,0°C-4,0°C
- **Zieldatenbank:** PostgreSQL
- **Kursumfang:** Zwischenprüfung, Wochen 3-5

Ein fertiges KI-Modell ist nicht Bestandteil dieser Version. Die Erklärung zur
KI-Nutzung steht in [AI_BEYAN.md](../AI_BEYAN.md).

## Datenquelle und Struktur

Die Daten stammen aus dem Hugging-Face-Datensatz
[Cold-Chain Transportation Strawberry
Dataset](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry).
Die sechs Parquet-Dateien liegen unverändert unter `data/original/`.

```text
data/original/                 # Rohdateien S1-S6
data/processed/measurements.csv # Langformat
python/                        # Lesen, Prüfen, Umformen, Import
sql/                           # PostgreSQL-Schema und Analysen
SCENARIO.md                    # Geschichte und Fragestellung
AI_BEYAN.md                    # KI-Nutzungserklärung
```

## Technischer Ablauf

1. `python/01_read_files.py` findet und liest die Parquet-Dateien.
2. `python/02_verify_schema.py` prüft die gemeinsame 37-Spalten-Struktur.
3. `python/python03_find_errors.py` sucht den Hardware-Fehlercode `-999.00`.
4. `python/04_process_data.py` wandelt die neun Sensorspalten mit
   `pandas.melt()` vom Breit- ins Langformat um.
5. `python/05_import_data.py` lädt die CSV nach PostgreSQL, ersetzt leere
   Werte und `-999` durch `NULL` und prüft 129.582 Zeilen.

Eine Rohzeile enthält neun Sensoren zu einem Zeitpunkt; eine Langformatzeile
steht für genau eine Messung: `14.398 × 9 = 129.582`.

## PostgreSQL, SQL und Datenqualität

Die SQL-Dateien `sql/sql01_create_tables.sql`, `sql/02_import_data.sql`,
`sql/05_anomaly_thresholds.sql`, `sql/hafta-04.sql`, `sql/hafta-05.sql` und
`sql/sql06_ai_anomaly_view.sql` decken Tabellenerstellung, Importkontrolle,
Schwellwerte und die Analysen der Wochen 4-5 ab. Die AI-Ansicht ist nur eine
Vorbereitung für spätere Arbeiten.

`-999.00` ist kein Temperaturwert, sondern ein Hardwarefehlercode. Er wird
für SQL-Analysen als `NULL` behandelt. Der sichere Bereich liegt bei
0,0°C-4,0°C; über 8,0°C gilt als kritischer Schwellenwert.

## Reproduzierbarkeit

Aus dem Projektstamm ausführen:

```bash
python python/01_read_files.py
python python/02_verify_schema.py
python python/python03_find_errors.py
python python/04_process_data.py
python python/05_import_data.py
```

Die PostgreSQL-Variablen `PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER` und
`PGPASSWORD` können gesetzt werden. Standardwerte sind `strawberry_db` und
Port `5432`. Danach die SQL-Dateien mit einem PostgreSQL-Client ausführen.
