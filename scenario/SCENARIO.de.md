# Szenario 3: Logistik und Lieferung x IoT-Sensornetz x Anomalieerkennung

[🇹🇷 Türkçe](../SCENARIO.md) | [🇬🇧 English](SCENARIO.en.md) | [🇩🇪 Deutsch](SCENARIO.de.md) | [🇫🇷 Français](SCENARIO.fr.md) | [🇮🇹 Italiano](SCENARIO.it.md) | [🇪🇸 Español](SCENARIO.es.md) | [🇨🇳 中文](SCENARIO.zh-CN.md)

**Studierendennummer:** 202607131002  
**Kurs:** Datenbankmanagement (PostgreSQL)  
**Szenario:** Logistik und Lieferung x IoT-Sensornetz x Anomalieerkennung

> Diese Datei beschreibt Geschichte, Analysefragen und Abgrenzung. Für
> technische Befehle und die Reproduktion siehe [README.md](../README.md).

## 1. Betriebsgeschichte und Problem

Erdbeeren reagieren empfindlich auf Temperaturschwankungen und haben eine
kurze Haltbarkeit. Während des Transports soll die Temperatur zwischen 0,0°C
und 4,0°C liegen. Niedrigere Werte können Frostschäden verursachen, höhere
Werte beschleunigen Atmung, Schimmelrisiko und Warenverlust.

Ein Logistikunternehmen sammelt in den Sendungen S1-S6 Messungen von neun
Sensoren in vorderen, mittleren und hinteren Bereichen. Das Qualitätsteam
möchte nicht nur wissen, ob eine Sendung auffällig ist, sondern auch, in
welchem Bereich, an welchem Sensor und zu welcher Tageszeit Probleme
wiederkehren. Sensorfehler müssen dabei von echten Temperaturverletzungen
getrennt werden.

## 2. Zentrale Forschungsfrage

> **Welche Sensoren zeigen die höchste Anomaliehäufigkeit und zu welchen
> Tageszeiten treten diese Anomalien am häufigsten auf?**

### Unterstützende Fragen

- Welche Sendungen haben den höchsten Anteil gültiger Grenzverletzungen?
- Unterscheiden sich `Front`, `Middle` und `Rear`?
- Gibt es Unterschiede zwischen `Top`, `Middle` und `Bottom`?
- Häufen sich Anomalien zu bestimmten Stunden?
- Wo treten die `-999.00`-Hardwarecodes am häufigsten auf?

## 3. Zielgruppen und Entscheidungen

- **Qualitätsprüfung der Kühlkette:** Kritische Verletzungen und betroffene
  Sendungen prüfen.
- **Logistik- und Flottenleitung:** Problemzonen erkennen und Wartung oder
  Isolierung priorisieren.
- **Datenbankstudierende:** Relationales Modell, Datenqualität und
  nachvollziehbare SQL-Auswertung demonstrieren.

## 4. Datenkontext

Die Daten stammen aus den S1-S6-Parquet-Dateien des Hugging-Face-Datensatzes
[Cold-Chain Transportation Strawberry
Dataset](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry).

- 6 Sendungen, 14.398 Rohzeitpunkte, gemeinsames Schema mit 37 Spalten
- 9 Sensoren: `Front_Top`, `Front_Middle`, `Front_Bottom`,
  `Middle_Top`, `Middle_Middle`, `Middle_Bottom`, `Rear_Top`,
  `Rear_Middle`, `Rear_Bottom`
- 129.582 Messungen nach der Umwandlung ins Langformat
- Sicherer Bereich: 0,0°C-4,0°C

Die Rohdaten liegen in `data/original/`, die Ausgabe in
`data/processed/measurements.csv`. Die technischen Verarbeitungsschritte
gehören in die README.

## 5. Week 3: Tabellen- und Spaltenkandidaten

### `sensors` — Dimensionstabelle

`sensor_id` (PK), `compartment_zone`, `vertical_level` und `installed_at`
beschreiben Identität und Position eines Sensors.

### `measurements` — Ereignis-/Telemetrietabelle

`id` (PK), `shipment_id`, `sensor_id`, `temp_c` und `measurement_time`
speichern eine Messung pro Sensor und Zeitpunkt. Nicht auswertbare Werte sind
`NULL`.

### `anomaly_thresholds` — Parametertabelle

`rule_id`, `product_name`, `min_safe_temp` und `max_safe_temp` halten die
Produktregeln getrennt von den Messdaten. Für Erdbeeren gelten 0,0°C und
4,0°C als Grenzen.

## 6. Week 4: Erwartete Datenprobleme

- `-999.00` ist ein Hardwarefehlercode, keine Temperatur; beim SQL-Import wird
  er zu `NULL` und separat als `SENSOR_FAULT` betrachtet.
- `NULL` bedeutet fehlende Beobachtung, nicht sichere Temperatur.
- Die neun breiten Sensorspalten werden mit `pandas.melt()` ins Langformat
  gebracht.
- Schema und Spalten der sechs Dateien müssen übereinstimmen.
- Die erwartete Zeilenzahl lautet `14.398 × 9 = 129.582`.

## 7. Week 5: Analysefragen

Die SQL-Auswertungen sollen Sensor-, Sendungs-, Bereichs- und Stundenvergleiche
ermöglichen. Zu untersuchen sind gültige Messungen, Fehlerwerte,
Anomalieraten, `EXTRACT(HOUR FROM measurement_time)` sowie die Klassen
unter 0,0°C, 4,0°C-8,0°C und über 8,0°C. Mittelwerte dürfen durch `NULL` oder
Hardwarecodes nicht verfälscht werden.

## 8. KI-Strategie und Abgrenzung

Die KI-Komponente ist für Week 11 geplant und in der aktuellen Zwischenprüfung
nicht fertig. Vorgesehene Klassen sind `NORMAL`, `SENSOR_FAULT`,
`COLD_ANOMALY`, `MODERATE_HEAT_ANOMALY` und `CRITICAL_HEAT_BREACH`.
Eine künftige dynamische Sicht `vw_ai_anomaly_logs` könnte die Regeln aus
`anomaly_thresholds` verwenden. Die KI-Erklärung steht in
[AI_BEYAN.md](../AI_BEYAN.md).

## 9. Zwischenprüfung und Finale

- **Zwischenprüfung, Weeks 3-5:** Daten verstehen, Tabellen modellieren,
  Qualitätsprobleme trennen, Langformat erzeugen, PostgreSQL laden und
  erklärbare SQL-Fragen beantworten.
- **Finale, Week 11:** Dynamische regelbasierte Sicht, erweiterte
  Anomalieklassifikation und geplante KI-Schicht.
