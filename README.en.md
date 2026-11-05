# Strawberry IoT Cold Chain Telemetry Analysis

[🇹🇷 Türkçe](README.md) | [🇬🇧 English](README.en.md) | [🇩🇪 Deutsch](README.de.md) | [🇫🇷 Français](README.fr.md) | [🇮🇹 Italiano](README.it.md) | [🇪🇸 Español](README.es.md) | [🇨🇳 中文](README.zh-CN.md)

This project converts temperature telemetry from nine IoT sensors across
shipments S1-S6 into a relational structure and prepares it for data-quality
and anomaly analysis in PostgreSQL. The operational story, problem statement,
and main research question are kept in [SCENARIO.en.md](SCENARIO.en.md);
this README focuses on the technical pipeline and how to reproduce it.

## Scope

- **Dataset:** Shipments S1-S6, 9 sensors, 14,398 raw time records
- **Raw schema:** 37 columns in Apache Parquet
- **Processed output:** 129,582 long-format measurement rows
- **Safe temperature range:** 0.0°C-4.0°C
- **Target database:** PostgreSQL
- **Course scope:** Midterm Weeks 3-5: preparation, schema design, and SQL analysis

No AI model or finished AI feature is part of this version. See
[AI_BEYAN.md](AI_BEYAN.md) for the disclosure of AI-assisted learning and
the student's contribution.

## Data source and repository layout

The data comes from the Hugging Face
[Cold-Chain Transportation Strawberry
Dataset](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry).
The six Parquet files are preserved as raw inputs under `data/original/` and
are not edited manually.

```text
vize-202607131002/
├── data/
│   ├── original/                 # S1-S6 Parquet files
│   └── processed/                # data/processed/
│       └── measurements.csv      # Long-format output
├── python/                      # Reading, validation, transformation, import
├── sql/                         # PostgreSQL schema and analysis queries
├── SCENARIO.md                  # Turkish story, problem, and main question
├── SCENARIO.en.md               # English scenario
└── AI_BEYAN.md                  # AI-use disclosure
```

## Technical pipeline

1. `python/01_read_files.py` discovers `data/original/*.parquet` and checks
   that the files can be read and counted.
2. `python/02_verify_schema.py` compares column names and order across S1-S6
   and verifies the shared 37-column schema.
3. `python/python03_find_errors.py` scans sensor fields for the `-999.00`
   hardware error code. It is not a real temperature and is treated as a data
   quality issue.
4. `python/04_process_data.py` uses `pandas.melt()` to unpivot the nine sensor
   columns from wide to long format. The output columns are `shipment_id`,
   `measurement_time`, `sensor_id`, and `temp_c`.
5. `python/05_import_data.py` loads the CSV into PostgreSQL, converts empty
   values and `-999` to `NULL`, and verifies 129,582 imported rows.

In short, one raw row contains nine sensors for one timestamp, while one
long-format row represents one sensor measurement:

```text
14,398 raw records × 9 sensors = 129,582 measurements
```

## PostgreSQL and SQL scope

The files in `sql/` are organized around the course weeks:

- `sql/sql01_create_tables.sql`: `measurements` table and query indexes
- `sql/02_import_data.sql`: post-import row-count check
- `sql/05_anomaly_thresholds.sql`: parameterized temperature thresholds
- `sql/hafta-04.sql`: Week 4 table and data queries
- `sql/hafta-05.sql`: Week 5 grouping, time, and anomaly analysis
- `sql/sql06_ai_anomaly_view.sql`: preparation for a future AI/anomaly view

`measurements.temp_c` is stored as `NUMERIC`. Converting `-999` to `NULL`
prevents hardware failures from distorting averages and threshold checks,
while keeping missing measurements distinct from real temperatures. The AI
view is preparation for future work, not a completed model.

## Reproducibility

Run these commands from the project root:

```bash
python python/01_read_files.py
python python/02_verify_schema.py
python python/python03_find_errors.py
python python/04_process_data.py
python python/05_import_data.py
```

For the final step, provide PostgreSQL settings through `PGHOST`, `PGPORT`,
`PGDATABASE`, `PGUSER`, and `PGPASSWORD`. The defaults are database
`strawberry_db` and port `5432`. Run the SQL files with a PostgreSQL client
after the import script.

## Data-quality notes

- The raw Parquet files are immutable copies of the source data.
- `-999.00` is a hardware error code and must not be interpreted as a valid
  temperature.
- Missing or invalid measurements are stored as `NULL` in SQL.
- 0.0°C-4.0°C is the safe range and temperatures above 8.0°C are treated as a
  critical-loss threshold; detailed interpretation belongs in the SQL queries.
