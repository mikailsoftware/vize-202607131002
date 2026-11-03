
# Data Card — Strawberry Cold Chain IoT Telemetry

[🇹🇷 Türkçe](dataREADME.md) | [🇬🇧 English](dataREADME_EN.md)

## 1. Dataset Overview
IoT sensor telemetry dataset monitoring strawberry cold-chain logistics across Shipments S1 to S6.

## 2. Data Provenance and Licensing
- Source: Open industrial cold-chain telemetry logs.
- Authentic Data Ratio: 100% (Zero synthetic rows).
- License: Open Data Commons / CC-BY 4.0.
- Retrieval Date: October 2026.

## 3. Raw Data Integrity (data/original/)
- Raw files are stored in Apache Parquet format and remain immutable (never edited manually).
- Total Volume: 14,398 rows, 37 columns across S1–S6.

## 4. Known Data Quality Issues
- Hardware Failure Codes (-999): Hardware error codes (-999.00) are converted to SQL NULLs to prevent average skew.
- Wide Format: 9 compartment sensors are unpivoted into long relational format (129,582 rows).

## 5. Safe Thresholds
- Safe Range: 0.0°C to 4.0°C.
- Critical Loss Threshold: > 8.0°C.