# Análisis de telemetría IoT de la cadena de frío de fresas

[🇹🇷 Türkçe](../README.md) | [🇬🇧 English](README.en.md) | [🇩🇪 Deutsch](README.de.md) | [🇫🇷 Français](README.fr.md) | [🇮🇹 Italiano](README.it.md) | [🇪🇸 Español](README.es.md) | [🇨🇳 中文](README.zh-CN.md)

Este proyecto transforma las mediciones de temperatura de nueve sensores IoT
de los envíos S1-S6 en una estructura relacional y las prepara para análisis
de calidad y anomalías en PostgreSQL. La historia operativa y la pregunta
principal están en [SCENARIO.md](../SCENARIO.md) y
[SCENARIO.en.md](../scenario/SCENARIO.en.md); este README se centra en el flujo técnico.

## Alcance

- **Datos:** envíos S1-S6, 9 sensores, 14.398 registros temporales brutos
- **Esquema bruto:** 37 columnas en Apache Parquet
- **Salida procesada:** 129.582 mediciones en formato largo
- **Rango seguro:** 0,0°C-4,0°C
- **Base de datos:** PostgreSQL
- **Curso:** semanas 3-5 del examen parcial

Esta versión no incluye un modelo de IA terminado. La declaración de uso de
IA está disponible en [AI_BEYAN.md](../AI_BEYAN.md).

## Fuente y estructura

Los datos proceden del conjunto de Hugging Face
[Cold-Chain Transportation Strawberry
Dataset](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry).
Los seis archivos Parquet se conservan sin modificaciones en `data/original/`.

```text
data/original/                  # Archivos brutos S1-S6
data/processed/measurements.csv # Salida en formato largo
python/                         # Lectura, validación, transformación, importación
sql/                            # Esquema PostgreSQL y análisis
SCENARIO.md                     # Historia y pregunta principal
AI_BEYAN.md                     # Declaración de uso de IA
```

## Flujo técnico

1. `python/01_read_files.py` localiza y lee los archivos Parquet.
2. `python/02_verify_schema.py` verifica el esquema común de 37 columnas.
3. `python/python03_find_errors.py` busca el código de error de hardware
   `-999.00`.
4. `python/04_process_data.py` usa `pandas.melt()` para pasar de formato ancho
   a formato largo.
5. `python/05_import_data.py` carga el CSV en PostgreSQL, convierte los
   valores vacíos y `-999` en `NULL` y verifica 129.582 filas.

Una fila bruta contiene nueve sensores para un instante; una fila larga
representa una medición: `14.398 × 9 = 129.582`.

## PostgreSQL, SQL y calidad

Los archivos `sql/sql01_create_tables.sql`, `sql/02_import_data.sql`,
`sql/05_anomaly_thresholds.sql`, `sql/hafta-04.sql`, `sql/hafta-05.sql` y
`sql/sql06_ai_anomaly_view.sql` cubren tablas, control de importación, umbrales y
análisis de las semanas 4-5. La vista de IA es una preparación para el futuro,
no un modelo terminado.

`-999.00` es un código de error de hardware, no una temperatura, y se guarda
como `NULL`. El rango seguro es 0,0°C-4,0°C; por encima de 8,0°C se considera
un umbral crítico.

## Reproducibilidad

Ejecutar desde la raíz del proyecto:

```bash
python python/01_read_files.py
python python/02_verify_schema.py
python python/python03_find_errors.py
python python/04_process_data.py
python python/05_import_data.py
```

Las variables PostgreSQL `PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER` y
`PGPASSWORD` son configurables. Los valores predeterminados son
`strawberry_db` y el puerto `5432`. Después, ejecutar los archivos SQL con un
cliente de PostgreSQL.
