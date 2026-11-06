# Fiche de données — Télémétrie IoT de la chaîne du froid des fraises

[🇹🇷 Türkçe](../dataREADME.md) | [🇬🇧 English](dataREADME.en.md) | [🇩🇪 Deutsch](dataREADME.de.md) | [🇫🇷 Français](dataREADME.fr.md) | [🇮🇹 Italiano](dataREADME.it.md) | [🇪🇸 Español](dataREADME.es.md) | [🇨🇳 中文](dataREADME.zh-CN.md)

## 1. Jeu de données et périmètre du contrôle

Cette fiche décrit la télémétrie IoT de la chaîne du froid utilisée par le
projet `vize-202607131002` pour les semaines 3-5 : préparation des données,
conception des tables et analyse SQL. Elle couvre les expéditions S1-S6 et
les mesures de température de neuf capteurs.

- Données brutes : **14 398 enregistrements, 37 colonnes**
- Capteurs : **9**
- Format long : **14 398 × 9 = 129 582 lignes de mesure**
- Base cible : PostgreSQL

## 2. Source et licence

Les données proviennent du jeu Hugging Face [Cold-Chain Transportation
Strawberry](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry).
La licence indiquée dans le projet est **Open Data Commons / CC-BY 4.0** et la
date de téléchargement est **octobre 2026**. Les fichiers Parquet bruts sont
des copies immuables des données sources.

## 3. Règles de qualité et transformation

- Le code d'erreur matériel `-999` (y compris `-999.00`) n'est pas une
  température et est enregistré comme `NULL` dans SQL.
- Cette conversion exclut les mesures manquantes des moyennes et des contrôles
  de seuil.
- Les neuf colonnes de capteurs passent du format large au format long.
- La sortie attendue dans `data/processed/measurements.csv` contient
  **129 582** lignes.

## 4. Seuils de température

- Plage sûre : **0,0°C-4,0°C**
- Seuil de perte critique : **au-dessus de 8,0°C**
- Les valeurs `-999` sont exclues des calculs de seuil.

## 5. Structure des fichiers

```text
vize-202607131002/
├── data/
│   ├── original/                 # Fichiers Parquet bruts S1-S6
│   ├── processed/
│   │   └── measurements.csv      # Sortie longue de 129 582 lignes
│   └── dataREADME/               # Fiche et versions linguistiques
├── python/                       # Lecture, validation, transformation, import
├── sql/                          # Schéma PostgreSQL et requêtes d'analyse
├── README.md                     # README principal
└── SCENARIO.md                  # Contexte du contrôle
```

## 6. Flux reproductible

Depuis la racine du projet, exécuter dans l'ordre
`python/01_read_files.py`, `python/02_verify_schema.py`,
`python/python03_find_errors.py`, `python/04_process_data.py` et
`python/05_import_data.py`.
