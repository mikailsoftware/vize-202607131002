# Datenkarte — IoT-Telemetrie der Erdbeer-Kühlkette

[🇹🇷 Türkçe](../dataREADME.md) | [🇬🇧 English](dataREADME.en.md) | [🇩🇪 Deutsch](dataREADME.de.md) | [🇫🇷 Français](dataREADME.fr.md) | [🇮🇹 Italiano](dataREADME.it.md) | [🇪🇸 Español](dataREADME.es.md) | [🇨🇳 中文](dataREADME.zh-CN.md)

## 1. Datensatz und Umfang der Zwischenprüfung

Diese Datenkarte beschreibt die Erdbeer-Kühlketten-Telemetrie des Projekts
`vize-202607131002`. Sie gehört zum Umfang der Wochen 3-5 der
Zwischenprüfung: Datenaufbereitung, Tabellendesign und SQL-Analyse. Enthalten
sind die Sendungen S1-S6 und Temperaturmessungen von neun Sensoren.

- Rohdaten: **14.398 Datensätze, 37 Spalten**
- Sensoren: **9**
- Langformat: **14.398 × 9 = 129.582 Messzeilen**
- Zieldatenbank: PostgreSQL

## 2. Datenquelle und Lizenz

Die Daten stammen aus dem Hugging-Face-Datensatz [Cold-Chain Transportation
Strawberry](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry).
Im Projekt ist die Lizenz als **Open Data Commons / CC-BY 4.0** und das
Abrufdatum als **Oktober 2026** dokumentiert. Die Parquet-Rohdateien sind
unveränderliche Kopien der Quelldaten.

## 3. Qualitätsregeln und Umformung

- Der Hardwarefehlercode `-999` (einschließlich `-999.00`) ist keine
  Temperatur und wird in SQL als `NULL` gespeichert.
- Dadurch werden fehlende Messungen aus Mittelwerten und Schwellenprüfungen
  herausgehalten.
- Die neun Sensorspalten werden vom Breit- ins Langformat umgeformt; jede
  Langformatzeile entspricht einer Sensormessung.
- Die erwartete Ausgabe in `data/processed/measurements.csv` umfasst
  **129.582** Zeilen.

## 4. Temperaturschwellen

- Sicherer Bereich: **0,0°C-4,0°C**
- Kritischer Verlustschwellenwert: **über 8,0°C**
- `-999` fließt nicht in die Schwellenberechnung ein.

## 5. Dateistruktur

```text
vize-202607131002/
├── data/
│   ├── original/                 # Unveränderte S1-S6-Parquetdateien
│   ├── processed/
│   │   └── measurements.csv      # Ausgabe mit 129.582 Langformatzeilen
│   └── dataREADME/               # Datenkarte und Sprachversionen
├── python/                       # Lesen, Prüfen, Umformen und Import
├── sql/                          # PostgreSQL-Schema und Analyseabfragen
├── README.md                     # Haupt-README
└── SCENARIO.md                  # Zwischenprüfungs-Szenario
```

## 6. Reproduzierbarer Ablauf

Vom Projektstamm aus werden `python/01_read_files.py`,
`python/02_verify_schema.py`, `python/python03_find_errors.py`,
`python/04_process_data.py` und `python/05_import_data.py` in dieser
Reihenfolge ausgeführt.
