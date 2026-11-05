# Analisi della telemetria IoT della catena del freddo delle fragole

[🇹🇷 Türkçe](README.md) | [🇬🇧 English](README.en.md) | [🇩🇪 Deutsch](README.de.md) | [🇫🇷 Français](README.fr.md) | [🇮🇹 Italiano](README.it.md) | [🇪🇸 Español](README.es.md) | [🇨🇳 中文](README.zh-CN.md)

Il progetto trasforma i dati di temperatura di nove sensori IoT delle
spedizioni S1-S6 in una struttura relazionale e li prepara per le analisi di
qualità e anomalie in PostgreSQL. La storia operativa e la domanda principale
sono in [SCENARIO.md](SCENARIO.md) e [SCENARIO.en.md](SCENARIO.en.md); questo
README descrive il flusso tecnico.

## Ambito

- **Dati:** spedizioni S1-S6, 9 sensori, 14.398 record temporali grezzi
- **Schema grezzo:** 37 colonne Apache Parquet
- **Output elaborato:** 129.582 misure in formato lungo
- **Intervallo sicuro:** 0,0°C-4,0°C
- **Database:** PostgreSQL
- **Corso:** settimane 3-5 della prova intermedia

Questa versione non include un modello di IA completato. La dichiarazione
sull'uso dell'IA è in [AI_BEYAN.md](AI_BEYAN.md).

## Fonte e struttura

I dati provengono dal dataset Hugging Face
[Cold-Chain Transportation Strawberry
Dataset](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry).
I sei file Parquet sono conservati senza modifiche in `data/original/`.

```text
data/original/                  # File grezzi S1-S6
data/processed/measurements.csv # Output in formato lungo
python/                         # Lettura, verifica, trasformazione, import
sql/                            # Schema PostgreSQL e analisi
SCENARIO.md                     # Storia e domanda principale
AI_BEYAN.md                     # Dichiarazione sull'IA
```

## Flusso tecnico

1. `python/01_read_files.py` individua e legge i file Parquet.
2. `python/02_verify_schema.py` verifica lo schema comune di 37 colonne.
3. `python/python03_find_errors.py` cerca il codice di errore hardware
   `-999.00`.
4. `python/04_process_data.py` usa `pandas.melt()` per passare dal formato
   largo a quello lungo.
5. `python/05_import_data.py` carica il CSV in PostgreSQL, converte i valori
   vuoti e `-999` in `NULL` e verifica 129.582 righe.

Una riga grezza contiene nove sensori per un istante; una riga lunga
rappresenta una singola misura: `14.398 × 9 = 129.582`.

## PostgreSQL, SQL e qualità dei dati

I file `sql/sql01_create_tables.sql`, `sql/02_import_data.sql`,
`sql/05_anomaly_thresholds.sql`, `sql/hafta-04.sql`, `sql/hafta-05.sql` e
`sql/sql06_ai_anomaly_view.sql` coprono tabelle, controllo dell'importazione,
soglie e analisi delle settimane 4-5. La vista AI è una preparazione futura,
non un modello completato.

`-999.00` è un codice di guasto hardware, non una temperatura, e viene
memorizzato come `NULL`. L'intervallo sicuro è 0,0°C-4,0°C; oltre 8,0°C si
applica la soglia critica.

## Riproducibilità

Eseguire dalla radice del progetto:

```bash
python python/01_read_files.py
python python/02_verify_schema.py
python python/python03_find_errors.py
python python/04_process_data.py
python python/05_import_data.py
```

Le variabili PostgreSQL `PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER` e
`PGPASSWORD` sono configurabili. I valori predefiniti sono `strawberry_db` e
la porta `5432`. Eseguire poi i file SQL con un client PostgreSQL.
