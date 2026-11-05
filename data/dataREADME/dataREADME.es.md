# Tarjeta de datos — Telemetría IoT de la cadena de frío de fresas

[🇹🇷 Türkçe](../dataREADME.md) | [🇬🇧 English](dataREADME.en.md) | [🇩🇪 Deutsch](dataREADME.de.md) | [🇫🇷 Français](dataREADME.fr.md) | [🇮🇹 Italiano](dataREADME.it.md) | [🇪🇸 Español](dataREADME.es.md) | [🇨🇳 中文](dataREADME.zh-CN.md)

## 1. Conjunto de datos y alcance del examen parcial

Esta tarjeta describe la telemetría IoT de la cadena de frío usada por el
proyecto `vize-202607131002` para las semanas 3-5: preparación de datos,
diseño de tablas y análisis SQL. Incluye los envíos S1-S6 y las mediciones de
temperatura de nueve sensores.

- Datos brutos: **14.398 registros, 37 columnas**
- Sensores: **9**
- Formato largo: **14.398 × 9 = 129.582 filas de medición**
- Base de datos objetivo: PostgreSQL

## 2. Fuente y licencia

Los datos proceden del conjunto de Hugging Face [Cold-Chain Transportation
Strawberry](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry).
La licencia registrada en el proyecto es **Open Data Commons / CC-BY 4.0** y
la fecha de descarga es **octubre de 2026**. Los archivos Parquet brutos son
copias inmutables de los datos de origen.

## 3. Reglas de calidad y transformación

- El código de error de hardware `-999` (incluido `-999.00`) no es una
  temperatura y se guarda como `NULL` en SQL.
- Esta conversión evita que las mediciones ausentes distorsionen promedios y
  comprobaciones de umbral.
- Las nueve columnas de sensores se convierten de formato ancho a formato
  largo.
- La salida esperada en `data/processed/measurements.csv` contiene **129.582**
  filas.

## 4. Umbrales de temperatura

- Rango seguro: **0,0°C-4,0°C**
- Umbral de pérdida crítica: **por encima de 8,0°C**
- Los valores `-999` se excluyen de los cálculos de umbral.

## 5. Estructura de archivos

```text
vize-202607131002/
├── data/
│   ├── original/                 # Archivos Parquet brutos S1-S6
│   ├── processed/
│   │   └── measurements.csv      # Salida larga de 129.582 filas
│   └── dataREADME/               # Tarjeta y versiones lingüísticas
├── python/                       # Lectura, validación, transformación e importación
├── sql/                          # Esquema PostgreSQL y consultas de análisis
├── README.md                     # README principal
└── SCENARIO.md                  # Contexto del examen parcial
```

## 6. Flujo reproducible

Desde la raíz del proyecto, ejecutar en orden `python/01_read_files.py`,
`python/02_verify_schema.py`, `python/python03_find_errors.py`,
`python/04_process_data.py` y `python/05_import_data.py`.
