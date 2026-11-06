# Scénario 3 : logistique et livraison x réseau de capteurs IoT x détection d'anomalies

[🇹🇷 Türkçe](../SCENARIO.md) | [🇬🇧 English](SCENARIO.en.md) | [🇩🇪 Deutsch](SCENARIO.de.md) | [🇫🇷 Français](SCENARIO.fr.md) | [🇮🇹 Italiano](SCENARIO.it.md) | [🇪🇸 Español](SCENARIO.es.md) | [🇨🇳 中文](SCENARIO.zh-CN.md)

**Étudiant :** 202607131002  
**Cours :** systèmes de gestion de bases de données (PostgreSQL)

> Ce fichier présente l'histoire opérationnelle, les questions d'analyse et
> les limites du projet. Les détails d'exécution sont dans
> [README.md](../README.md).

## 1. Histoire opérationnelle et problème

Les fraises sont sensibles aux variations de température et se conservent
peu de temps. La règle produit vise une température comprise entre 0,0°C et
4,0°C pendant le transport réfrigéré. Une température plus basse peut causer
des dégâts de gel; une température plus élevée augmente la respiration, le
risque de moisissure et les pertes.

Un opérateur logistique collecte, pour les expéditions S1-S6, la télémétrie de
neuf capteurs placés à l'avant, au milieu et à l'arrière des conteneurs.
L'équipe qualité veut savoir où et quand les problèmes se répètent, et pas
seulement si une expédition est problématique. Les pannes de capteur doivent
être distinguées des véritables dépassements thermiques.

## 2. Question principale

> **Quels capteurs présentent la fréquence d'anomalies la plus élevée et à
> quelles heures ces anomalies apparaissent-elles le plus souvent ?**

Questions complémentaires : les taux diffèrent-ils selon l'expédition, la
zone (`Front`, `Middle`, `Rear`) ou le niveau (`Top`, `Middle`, `Bottom`) ?
Les anomalies se concentrent-elles à certaines heures ? Où apparaissent les
codes matériels `-999.00` ?

## 3. Utilisateurs et décisions

- **Contrôleurs qualité :** vérifier les violations critiques et les
  expéditions concernées.
- **Responsables logistiques :** identifier les zones à isoler ou à entretenir.
- **Étudiants en bases de données :** démontrer modélisation relationnelle,
  qualité des données et analyse SQL explicable.

## 4. Contexte des données

Les données proviennent du jeu Hugging Face
[Cold-Chain Transportation Strawberry
Dataset](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry).
Il comprend 6 expéditions, 14 398 enregistrements bruts, 37 colonnes et neuf
capteurs (`Front_*`, `Middle_*`, `Rear_*`). La conversion au format long
produit 129 582 mesures. Les fichiers sources sont dans `data/original/` et
la sortie dans `data/processed/measurements.csv`.

## 5. Week 3 : candidats de tables

`sensors` décrit `sensor_id`, `compartment_zone`, `vertical_level` et
`installed_at`. `measurements` contient `id`, `shipment_id`, `sensor_id`,
`temp_c` et `measurement_time`. `anomaly_thresholds` conserve `rule_id`,
`product_name`, `min_safe_temp` et `max_safe_temp`, avec des limites de
0,0°C et 4,0°C pour les fraises.

## 6. Week 4 : problèmes de données attendus

`-999.00` est un code de panne, pas une température; il devient `NULL` lors
de l'import SQL et doit être classé séparément. `NULL` signifie une observation
indisponible. Les neuf colonnes de capteurs sont dénormalisées avec
`pandas.melt()`, le schéma commun de 37 colonnes est vérifié et le résultat
attendu est `14 398 × 9 = 129 582` lignes.

## 7. Week 5 : questions d'analyse

Les requêtes PostgreSQL doivent comparer les volumes valides, les pannes et
les taux d'anomalie par capteur, expédition, zone et heure
(`EXTRACT(HOUR FROM measurement_time)`). Elles doivent distinguer les valeurs
inférieures à 0,0°C, de 4,0°C à 8,0°C et supérieures à 8,0°C, sans fausser les
moyennes avec des valeurs manquantes.

## 8. Stratégie IA et limite

La composante IA est une architecture planifiée pour la Week 11, pas une
fonction terminée de cette évaluation intermédiaire. Les classes prévues sont
`NORMAL`, `SENSOR_FAULT`, `COLD_ANOMALY`, `MODERATE_HEAT_ANOMALY` et
`CRITICAL_HEAT_BREACH`. Une vue future `vw_ai_anomaly_logs` pourrait utiliser
`anomaly_thresholds`. Voir [AI_BEYAN.md](../AI_BEYAN.md).

## 9. Limite entre évaluation et finale

La période intermédiaire couvre les Weeks 3-5 : modèle, qualité, conversion,
import PostgreSQL et analyses SQL. La Week 11 couvre la vue dynamique,
l'extension des classes d'anomalie et l'évaluation de la couche IA planifiée.
