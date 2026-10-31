# Draw #3: Logistics and Delivery x IoT Sensor Network x Anomaly Detection

[🇹🇷 Türkçe](SCENARIO.md) | [🇬🇧 English](SCENARIO.en.md)

**Student No:** 202607131002  
**Course:** Database Management Systems (PostgreSQL)  
**Scenario Draw:** Draw #3 (Logistics and Delivery x IoT Sensor Network x Anomaly Detection)  

---

## 1. Operational Story and Problem Definition

During the transportation of sensitive fruits such as strawberries in cold-chain logistics, the ambient temperature must be kept between 0.0°C and 4.0°C. Temperatures outside this range can spoil products, shorten their shelf life, and cause significant financial losses. A warehouse and logistics company collects temperature telemetry data from 9 different sensors (front, middle, and rear compartments) inside containers across shipments S1-S6. The system must automatically detect deviations (anomalies) outside the normal limits.

## 2. Main Research Question

> **"Which sensors have the highest anomaly frequency, and at which times of day do these anomalies occur most often?"**

All SQL queries and data models developed throughout the term will focus directly on answering this question.

## 3. Target User Profile

- **Cold-Chain Quality Inspectors:** Reviewing shipments with critical temperature violations.
- **Logistics and Fleet Managers:** Identifying which sensor compartments (for example, the Rear compartment near the door) have insulation problems.

## 4. Week 3 Table and Column Candidates

### Table 1: `sensors` (Dimension Table)

Stores the identities of physical IoT sensors inside containers and warehouses.

- `sensor_id` (VARCHAR(50), PK): Unique sensor code (for example, Front_Top, Rear_Bottom).
- `compartment_zone` (VARCHAR(20)): Compartment location (Front, Middle, Rear).
- `vertical_level` (VARCHAR(20)): Vertical position (Top, Middle, Bottom).
- `installed_at` (TIMESTAMP): Date and time when the sensor was commissioned.

### Table 2: `measurements` (Event/Telemetry Table)

Stores time-series temperature measurements received from sensors.

- `id` (BIGSERIAL, PK): Unique measurement record number.
- `shipment_id` (VARCHAR(10)): Shipment reference (S1, S2, S3, S4, S5, S6).
- `sensor_id` (VARCHAR(50), FK): Sensor code that produced the measurement.
- `temp_c` (NUMERIC(5,2)): Measured temperature (°C). NULL for faulty hardware readings.
- `measurement_time` (TIMESTAMP): Timestamp when the measurement was taken.

### Table 3: `anomaly_thresholds` (Parameter Table)

Dynamically stores safe temperature limits and product rules.

- `rule_id` (SERIAL, PK): Rule identifier.
- `product_name` (VARCHAR(50)): Type of monitored product (Strawberry).
- `min_safe_temp` (NUMERIC(4,2)): Lowest acceptable temperature (0.0°C).
- `max_safe_temp` (NUMERIC(4,2)): Highest acceptable temperature (4.0°C).
