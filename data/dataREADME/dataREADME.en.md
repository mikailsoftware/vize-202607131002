# Data Card — Strawberry Cold-Chain IoT Telemetry

[🇹🇷 Türkçe](../dataREADME.md) | [🇬🇧 English](dataREADME.en.md) | [🇩🇪 Deutsch](dataREADME.de.md) | [🇫🇷 Français](dataREADME.fr.md) | [🇮🇹 Italiano](dataREADME.it.md) | [🇪🇸 Español](dataREADME.es.md) | [🇨🇳 中文](dataREADME.zh-CN.md)

## 1. Dataset and midterm scope

This data card describes the strawberry cold-chain IoT telemetry used by
project `vize-202607131002` for the midterm Weeks 3-5 scope: data
preparation, table design, and SQL analysis. The data covers shipments S1-S6
and temperature measurements from nine sensors.

- Raw data: **14,398 records, 37 columns**
- Sensors: **9**
- Long format: **14,398 × 9 = 129,582 measurement rows**
- Target database: PostgreSQL

## 2. Data source and licence

The data comes from the Hugging Face [Cold-Chain Transportation Strawberry
Dataset](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry).
The project record lists the licence as **Open Data Commons / CC-BY 4.0** and
the retrieval date as **October 2026**. The raw Parquet files are immutable
copies of the source data and are not edited manually.

## 3. Quality rules and transformation

- The sensor hardware error code `-999` (including `-999.00`) is not a real
  temperature and is stored as SQL `NULL`.
- Converting `-999` to `NULL` keeps missing measurements out of averages and
  threshold analysis.
- The nine sensor columns are unpivoted from wide to long format. Each long
  row represents one sensor measurement.
- The expected output is **129,582** rows in
  `data/processed/measurements.csv`.

## 4. Temperature thresholds

- Safe range: **0.0°C-4.0°C**
- Critical-loss threshold: **above 8.0°C**
- The thresholds are used by `sql/05_anomaly_thresholds.sql` and related
  analysis queries; `-999` values are excluded from threshold calculations.

## 5. File structure

```text
vize-202607131002/
├── data/
│   ├── original/                 # Raw S1-S6 Parquet files
│   ├── processed/
│   │   └── measurements.csv      # 129,582-row long-format output
│   └── dataREADME/               # This card and language versions
├── python/                       # Reading, validation, transformation, import
├── sql/                          # PostgreSQL schema and analysis queries
├── README.md                     # Main project README
└── SCENARIO.md                  # Midterm scenario and problem context
```

## 6. Reproducible flow

From the project root, run `python/01_read_files.py`,
`python/02_verify_schema.py`, `python/python03_find_errors.py`,
`python/04_process_data.py`, and `python/05_import_data.py` in order. The
flow reads the files, verifies the 37-column schema, identifies `-999`,
unpivots the nine sensors, and imports the result into PostgreSQL.
