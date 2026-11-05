# Scheda dati — Telemetria IoT della catena del freddo delle fragole

[🇹🇷 Türkçe](../dataREADME.md) | [🇬🇧 English](dataREADME.en.md) | [🇩🇪 Deutsch](dataREADME.de.md) | [🇫🇷 Français](dataREADME.fr.md) | [🇮🇹 Italiano](dataREADME.it.md) | [🇪🇸 Español](dataREADME.es.md) | [🇨🇳 中文](dataREADME.zh-CN.md)

## 1. Dataset e ambito della prova intermedia

Questa scheda descrive la telemetria IoT della catena del freddo usata dal
progetto `vize-202607131002` per le settimane 3-5: preparazione dei dati,
progettazione delle tabelle e analisi SQL. Comprende le spedizioni S1-S6 e le
misure di temperatura di nove sensori.

- Dati grezzi: **14.398 record, 37 colonne**
- Sensori: **9**
- Formato lungo: **14.398 × 9 = 129.582 righe di misura**
- Database di destinazione: PostgreSQL

## 2. Fonte e licenza

I dati provengono dal dataset Hugging Face [Cold-Chain Transportation
Strawberry](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry).
La licenza indicata nel progetto è **Open Data Commons / CC-BY 4.0** e la data
di download è **ottobre 2026**. I file Parquet grezzi sono copie immutabili
dei dati originali.

## 3. Regole di qualità e trasformazione

- Il codice di errore hardware `-999` (compreso `-999.00`) non è una
  temperatura e viene salvato come `NULL` in SQL.
- La conversione impedisce che le misure mancanti alterino medie e soglie.
- Le nove colonne dei sensori vengono trasformate dal formato largo al formato
  lungo.
- L'output previsto in `data/processed/measurements.csv` contiene **129.582**
  righe.

## 4. Soglie di temperatura

- Intervallo sicuro: **0,0°C-4,0°C**
- Soglia di perdita critica: **oltre 8,0°C**
- I valori `-999` sono esclusi dai calcoli delle soglie.

## 5. Struttura dei file

```text
vize-202607131002/
├── data/
│   ├── original/                 # File Parquet grezzi S1-S6
│   ├── processed/
│   │   └── measurements.csv      # Output lungo di 129.582 righe
│   └── dataREADME/               # Scheda e versioni linguistiche
├── python/                       # Lettura, verifica, trasformazione e import
├── sql/                          # Schema PostgreSQL e query di analisi
├── README.md                     # README principale
└── SCENARIO.md                  # Contesto della prova intermedia
```

## 6. Flusso riproducibile

Dalla radice del progetto eseguire in ordine `python/01_read_files.py`,
`python/02_verify_schema.py`, `python/python03_find_errors.py`,
`python/04_process_data.py` e `python/05_import_data.py`.
