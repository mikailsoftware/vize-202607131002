# Escenario 3: logística y entregas x red de sensores IoT x detección de anomalías

[🇹🇷 Türkçe](../SCENARIO.md) | [🇬🇧 English](SCENARIO.en.md) | [🇩🇪 Deutsch](SCENARIO.de.md) | [🇫🇷 Français](SCENARIO.fr.md) | [🇮🇹 Italiano](SCENARIO.it.md) | [🇪🇸 Español](SCENARIO.es.md) | [🇨🇳 中文](SCENARIO.zh-CN.md)

**Estudiante:** 202607131002  
**Curso:** sistemas de gestión de bases de datos (PostgreSQL)

> Este documento define la historia, las preguntas analíticas y los límites
> del proyecto. Los detalles técnicos están en [README.md](../README.md).

## 1. Historia operativa y problema

Las fresas son sensibles a los cambios de temperatura y tienen una vida útil
corta. Durante el transporte refrigerado, la temperatura debe mantenerse entre
0,0°C y 4,0°C. Los valores inferiores pueden causar daños por congelación y
los superiores aumentar la respiración, el moho y las pérdidas.

Una empresa logística recoge telemetría de nueve sensores situados en las
zonas delantera, central y trasera de los contenedores de los envíos S1-S6.
El equipo de calidad necesita saber dónde y cuándo se repiten los problemas,
no solo si un envío es anómalo. Los fallos del sensor deben separarse de las
violaciones térmicas reales.

## 2. Pregunta principal

> **¿Qué sensores tienen la mayor frecuencia de anomalías y en qué horas se
> producen con más frecuencia?**

También se comparan envíos, zonas (`Front`, `Middle`, `Rear`), niveles
(`Top`, `Middle`, `Bottom`), horas del día y la frecuencia de códigos de
hardware `-999.00`.

## 3. Usuarios y decisiones

- **Inspectores de calidad:** revisar incumplimientos críticos y envíos
  afectados.
- **Responsables de logística y flota:** localizar compartimentos que
  requieren aislamiento o mantenimiento.
- **Estudiantes de bases de datos:** demostrar modelado relacional, calidad de
  datos y análisis SQL explicable.

## 4. Contexto de los datos

Se utilizan los archivos Parquet S1-S6 del conjunto de Hugging Face
[Cold-Chain Transportation Strawberry
Dataset](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry).
Son 6 envíos, 14.398 registros brutos, 37 columnas y nueve sensores
(`Front_*`, `Middle_*`, `Rear_*`). La conversión a formato largo produce
129.582 mediciones. Los datos originales están en `data/original/` y la
salida en `data/processed/measurements.csv`.

## 5. Week 3: candidatos de tablas

`sensors` describe `sensor_id`, `compartment_zone`, `vertical_level` e
`installed_at`. `measurements` registra `id`, `shipment_id`, `sensor_id`,
`temp_c` y `measurement_time`. `anomaly_thresholds` guarda `rule_id`,
`product_name`, `min_safe_temp` y `max_safe_temp`, con límites de 0,0°C y
4,0°C para las fresas.

## 6. Week 4: problemas de datos esperados

`-999.00` es un código de fallo del hardware, no una temperatura; durante la
importación SQL se convierte en `NULL` y se clasifica por separado. `NULL`
significa que la observación no está disponible. Las nueve columnas de
sensores se transforman con `pandas.melt()`, se comprueba el esquema común de
37 columnas y se espera `14.398 × 9 = 129.582`.

## 7. Week 5: preguntas de análisis

Las consultas PostgreSQL deben comparar mediciones válidas, fallos y tasas de
anomalía por sensor, envío, zona y hora (`EXTRACT(HOUR FROM
measurement_time)`). Deben separar valores inferiores a 0,0°C, entre 4,0°C y
8,0°C y superiores a 8,0°C, sin distorsionar los promedios con datos ausentes.

## 8. Estrategia de IA y límites

El componente de IA está planificado para la Week 11 y no está terminado en
la entrega del parcial. Las clases previstas son `NORMAL`, `SENSOR_FAULT`,
`COLD_ANOMALY`, `MODERATE_HEAT_ANOMALY` y `CRITICAL_HEAT_BREACH`. Una vista
futura `vw_ai_anomaly_logs` podría utilizar `anomaly_thresholds`. Consulta
[AI_BEYAN.md](../AI_BEYAN.md).

## 9. Límite entre parcial y final

El parcial cubre Weeks 3-5: modelo, calidad, transformación, importación en
PostgreSQL y análisis SQL. La Week 11 cubre la vista dinámica, las clases
avanzadas y la evaluación de la capa de IA planificada.
