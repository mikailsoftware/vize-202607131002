# Draw #3: Logistics and Delivery x IoT Sensor Network x Anomaly Detection

[🇹🇷 Türkçe](../SCENARIO.md) | [🇬🇧 English](SCENARIO.en.md) | [🇩🇪 Deutsch](SCENARIO.de.md) | [🇫🇷 Français](SCENARIO.fr.md) | [🇮🇹 Italiano](SCENARIO.it.md) | [🇪🇸 Español](SCENARIO.es.md) | [🇨🇳 中文](SCENARIO.zh-CN.md)

**Student No:** 202607131002  
**Course:** Database Management Systems (PostgreSQL)  
**Scenario Draw:** Draw #3 — Logistics and Delivery x IoT Sensor Network x Anomaly Detection

> This file defines the operational story, analytical questions, and course
> boundaries. For commands, repository layout, and reproduction steps, see
> [README.en.md](../readme/README.en.md).

## 1. Operational story and problem

Strawberries are sensitive to temperature changes and have a short shelf
life. During cold-chain transport, the product rule expects the container
temperature to remain between 0.0°C and 4.0°C. Lower temperatures can cause
freezing injury; higher temperatures can accelerate respiration, mold risk,
and product loss.

A logistics operator collects temperature telemetry from nine sensors placed
in the front, middle, and rear compartments of containers across shipments
S1-S6. The quality team needs more than a yes/no shipment result: it needs to
know where a problem repeats, which sensor is involved, and at what times of
day. The database must therefore preserve raw readings while separating
sensor faults from genuine thermal risk.

## 2. Main research question

> **Which sensors have the highest anomaly frequency, and at which times of day
> do these anomalies occur most often?**

This question is the common target of the Week 5 queries. Results should be
compared by sensor location, shipment, and time period. Missing or hardware
error readings must not be counted as real temperature breaches.

### Supporting questions

- Which shipments have the highest share of out-of-range valid readings?
- Do `Front`, `Middle`, and `Rear` zones behave differently?
- Do `Top`, `Middle`, and `Bottom` levels show different patterns?
- Do anomalies cluster at particular hours?
- Which sensors or shipments contain the most `-999.00` hardware codes?

## 3. Target users and decisions

- **Cold-chain quality inspectors:** Review critical breaches and affected
  shipments before acceptance or additional inspection.
- **Logistics and fleet managers:** Identify problematic compartments and
  prioritize insulation or maintenance work.
- **Database/analytics students:** Demonstrate relational modeling, controlled
  data-quality handling, and evidence-based SQL analysis.

## 4. Data context

The scenario uses the S1-S6 Parquet files from the Hugging Face
[Cold-Chain Transportation Strawberry
Dataset](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry).

- 6 shipments (`S1`-`S6`)
- 14,398 raw time records
- A shared 37-column file schema
- 9 sensors: `Front_Top`, `Front_Middle`, `Front_Bottom`,
  `Middle_Top`, `Middle_Middle`, `Middle_Bottom`, `Rear_Top`,
  `Rear_Middle`, `Rear_Bottom`
- 129,582 sensor measurements after wide-to-long conversion
- Safe product range: 0.0°C-4.0°C

Raw inputs are kept under `data/original/`; the processed measurement file is
`data/processed/measurements.csv`. These paths are part of the project data
contract; the ETL details belong in the README.

## 5. Week 3: table and column candidates

### 5.1. `sensors` — dimension table

Stores physical sensor identity and position:

- `sensor_id` (`VARCHAR(50)`, PK): For example, `Front_Top` or `Rear_Bottom`
- `compartment_zone` (`VARCHAR(20)`): `Front`, `Middle`, or `Rear`
- `vertical_level` (`VARCHAR(20)`): `Top`, `Middle`, or `Bottom`
- `installed_at` (`TIMESTAMP`): Commissioning time

### 5.2. `measurements` — event/telemetry table

Stores each sensor reading for a shipment and timestamp:

- `id` (`BIGSERIAL`, PK)
- `shipment_id` (`VARCHAR(10)`): `S1`-`S6`
- `sensor_id` (`VARCHAR(50)`, FK)
- `temp_c` (`NUMERIC(5,2)`): Valid temperature or `NULL` when unavailable
- `measurement_time` (`TIMESTAMP`)

### 5.3. `anomaly_thresholds` — parameter table

Separates product rules from measurement rows:

- `rule_id` (`SERIAL`, PK)
- `product_name` (`VARCHAR(50)`): Strawberry
- `min_safe_temp` (`NUMERIC(4,2)`): 0.0°C
- `max_safe_temp` (`NUMERIC(4,2)`): 4.0°C

## 6. Week 4: expected data issues

1. **Hardware error code:** Raw `-999.00` is not a temperature. It becomes
   `NULL` during SQL import and is interpreted separately as `SENSOR_FAULT`.
2. **Missing measurement:** `NULL` does not mean safe temperature; it means
   that the observation cannot be evaluated.
3. **Wide format:** Nine sensors in one row make analysis harder. After
   `pandas.melt()`, each row should represent one sensor measurement.
4. **Schema consistency:** The 37-column structure and sensor fields should
   be compared across S1-S6.
5. **Row-count validation:** The expected long-format count is
   `14,398 × 9 = 129,582`.

This section defines data-preparation expectations; detailed Python commands
remain in the README.

## 7. Week 5: analytical questions

PostgreSQL queries should investigate at least:

- What are total, valid, `NULL`/fault, and anomalous counts per sensor?
- How does the valid breach rate differ by shipment?
- Are anomalies concentrated by hour using
  `EXTRACT(HOUR FROM measurement_time)`?
- Is anomaly frequency related to compartment or vertical level?
- How should below-0.0°C, 4.0°C-8.0°C, and above-8.0°C readings be separated?
- How do `NULL` and hardware codes stay out of averages?

Suggested labels for valid readings are `NORMAL`, `COLD_ANOMALY`,
`MODERATE_HEAT_ANOMALY`, and `CRITICAL_HEAT_BREACH`; unavailable readings
should be represented as `SENSOR_FAULT`.

## 8. AI component strategy and boundary

The AI component is a Week 11 end-of-term architecture, not a finished AI
model or live prediction service in the current midterm output.

The planned separation is:

- `SENSOR_FAULT`: Hardware or communication issue represented by raw `-999.00`.
- `COLD_ANOMALY`: `temp_c < 0.0°C`.
- `MODERATE_HEAT_ANOMALY`: `4.0°C < temp_c <= 8.0°C`.
- `CRITICAL_HEAT_BREACH`: `temp_c > 8.0°C`.
- `NORMAL`: Valid reading inside the safe range.

In future work, a dynamic `vw_ai_anomaly_logs` view backed by
`anomaly_thresholds` could classify each measurement. This is a target design,
not a completed AI feature. The AI-use disclosure is in
[AI_BEYAN.md](../AI_BEYAN.md).

## 9. Midterm/final boundary

- **Midterm, Weeks 3-5:** Understand the source and schema, design table
  candidates, isolate data-quality issues, produce the long-format output,
  import it into PostgreSQL, and write explainable SQL analyses.
- **Final/end of term, Week 11:** Build the parameter-driven dynamic view,
  extend anomaly classification, and evaluate the planned AI layer.

Keeping this boundary explicit prevents the current deliverable from
presenting future AI work as already completed.
