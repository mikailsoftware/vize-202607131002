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


## 5. AI Component Strategy (End-of-Term Week 11 Architecture)

### 5.1. Logical Separation of Anomaly Types (Critical Rule)
In this strawberry cold-chain monitoring system, two distinct classes of anomalies are strictly decoupled at the database level:

1. Hardware Sensor Fault (SENSOR_FAULT):
   - Physical sensor disconnection, telemetry transmission packet loss, or depleted battery voltage.
   - Identified by NULL values (originally recorded as -999.00 hardware error codes in raw telemetry).
   - Domain Significance: This is an equipment communication failure, NOT biological strawberry spoilage. It indicates missing telemetry.

2. Thermal Cold-Chain Breaches (Biological Spoilage Risk):
   - The sensor is functioning properly, but the measured temperature breaches the established safe threshold of 0.0°C to 4.0°C.
   - Cold Anomaly (COLD_ANOMALY): temp_c < 0.0°C. Risk of freezing injury, cell wall collapse, and loss of fruit texture.
   - Moderate Heat Anomaly (MODERATE_HEAT_ANOMALY): 4.0°C < temp_c <= 8.0°C. Accelerated respiration rate, mold germination, and reduced shelf-life.
   - Critical Heat Breach (CRITICAL_HEAT_BREACH): temp_c > 8.0°C. Severe thermal abuse resulting in irreversible decay and product write-off.

### 5.2. Database Automation via Dynamic View (vw_ai_anomaly_logs)
Rather than relying on static scripts, the Week 11 AI component integrates directly within PostgreSQL using a dynamic view architecture:
- A parameter table (anomaly_thresholds) maintains active safe boundaries per cargo type.
- A virtual classification view (vw_ai_anomaly_logs) dynamically cross-joins measurements with these thresholds, automatically tagging each reading with an ai_classification label (NORMAL, COLD_ANOMALY, MODERATE_HEAT_ANOMALY, CRITICAL_HEAT_BREACH, SENSOR_FAULT).
