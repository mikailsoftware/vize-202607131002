# Strawberry IoT Cold Chain Telemetry Anomaly Analysis

[🇹🇷 Türkçe](README.md) | [🇬🇧 English](README.en.md)

This project analyzes IoT sensor temperature anomalies across shipments
S1-S6.

- **Safe temperature range:** 0.0°C - 4.0°C
- **Target database:** PostgreSQL
- **Total raw records:** 14,398 rows

## Data Source

The strawberry cold-chain IoT telemetry data used in this project was
obtained from the **Cold-Chain Transportation Strawberry Dataset** on
Hugging Face.

- **Source:** [NifferLi/Cold-Chain-Transportation-Strawberry](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry)
- **Content:** Time-series measurements from shipments S1-S6 and 9 temperature sensors
- **Access date:** 31 October 2026

In this project, the raw Parquet files were read, the sensor columns were
transformed into a relational long format, and
`data/processed/measurements.csv` was generated.
