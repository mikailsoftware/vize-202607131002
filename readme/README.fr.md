# Analyse de la télémétrie IoT de la chaîne du froid des fraises

[🇹🇷 Türkçe](../README.md) | [🇬🇧 English](README.en.md) | [🇩🇪 Deutsch](README.de.md) | [🇫🇷 Français](README.fr.md) | [🇮🇹 Italiano](README.it.md) | [🇪🇸 Español](README.es.md) | [🇨🇳 中文](README.zh-CN.md)

Ce projet transforme les mesures de température de neuf capteurs IoT des
expéditions S1-S6 en structure relationnelle, puis les prépare pour des
analyses de qualité et d'anomalies dans PostgreSQL. L'histoire opérationnelle
et la question principale sont décrites dans [SCENARIO.md](../SCENARIO.md) et
[SCENARIO.en.md](../scenario/SCENARIO.en.md); ce fichier présente le flux technique.

## Périmètre

- **Données :** expéditions S1-S6, 9 capteurs, 14 398 enregistrements bruts
- **Schéma brut :** 37 colonnes au format Apache Parquet
- **Sortie traitée :** 129 582 mesures au format long
- **Plage sûre :** 0,0°C-4,0°C
- **Base cible :** PostgreSQL
- **Cours :** semaines 3 à 5 de l'examen intermédiaire

Aucun modèle d'IA terminé n'est inclus dans cette version. Voir
[AI_BEYAN.md](../AI_BEYAN.md) pour la déclaration d'utilisation de l'IA.

## Source et organisation

Les données proviennent du jeu Hugging Face
[Cold-Chain Transportation Strawberry
Dataset](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry).
Les six fichiers Parquet sont conservés sans modification dans
`data/original/`.

```text
data/original/                  # Fichiers bruts S1-S6
data/processed/measurements.csv # Sortie au format long
python/                         # Lecture, validation, transformation, import
sql/                            # Schéma PostgreSQL et analyses
SCENARIO.md                     # Histoire et question de recherche
AI_BEYAN.md                     # Déclaration d'utilisation de l'IA
```

## Flux technique

1. `python/01_read_files.py` trouve et lit les fichiers Parquet.
2. `python/02_verify_schema.py` vérifie le schéma commun de 37 colonnes.
3. `python/python03_find_errors.py` recherche le code matériel `-999.00`.
4. `python/04_process_data.py` utilise `pandas.melt()` pour passer du format
   large au format long.
5. `python/05_import_data.py` charge le CSV dans PostgreSQL, convertit les
   valeurs vides et `-999` en `NULL`, puis vérifie 129 582 lignes.

Une ligne brute contient neuf capteurs pour un instant; une ligne longue
représente une mesure : `14 398 × 9 = 129 582`.

## PostgreSQL, SQL et qualité

Les fichiers `sql/sql01_create_tables.sql`, `sql/02_import_data.sql`,
`sql/05_anomaly_thresholds.sql`, `sql/hafta-04.sql`, `sql/hafta-05.sql` et
`sql/sql06_ai_anomaly_view.sql` couvrent les tables, le contrôle d'import, les
seuils et les analyses des semaines 4-5. La vue AI prépare un travail futur;
elle ne constitue pas un modèle terminé.

`-999.00` est un code d'erreur matériel, pas une température. Il est donc
stocké comme `NULL` pour éviter de fausser les moyennes. La plage sûre est
0,0°C-4,0°C et le seuil critique est supérieur à 8,0°C.

## Reproductibilité

Depuis la racine du projet :

```bash
python python/01_read_files.py
python python/02_verify_schema.py
python python/python03_find_errors.py
python python/04_process_data.py
python python/05_import_data.py
```

Les variables PostgreSQL `PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER` et
`PGPASSWORD` sont configurables. Les valeurs par défaut sont `strawberry_db`
et le port `5432`. Exécuter ensuite les fichiers SQL avec un client
PostgreSQL.
