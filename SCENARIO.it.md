# Scenario 3: logistica e consegne x rete di sensori IoT x rilevamento anomalie

[🇹🇷 Türkçe](SCENARIO.md) | [🇬🇧 English](SCENARIO.en.md) | [🇩🇪 Deutsch](SCENARIO.de.md) | [🇫🇷 Français](SCENARIO.fr.md) | [🇮🇹 Italiano](SCENARIO.it.md) | [🇪🇸 Español](SCENARIO.es.md) | [🇨🇳 中文](SCENARIO.zh-CN.md)

**Studente:** 202607131002  
**Corso:** sistemi di gestione dei database (PostgreSQL)

> Questo documento definisce storia, domande analitiche e confini del progetto.
> I dettagli tecnici sono in [README.md](README.md).

## 1. Storia operativa e problema

Le fragole sono sensibili agli sbalzi termici e hanno una breve durata.
Durante il trasporto refrigerato la temperatura dovrebbe rimanere tra 0,0°C e
4,0°C. Valori inferiori possono causare danni da gelo; valori superiori
aumentano respirazione, muffe e perdite.

Un operatore logistico raccoglie dati da nove sensori nelle zone anteriore,
centrale e posteriore dei container delle spedizioni S1-S6. Il controllo
qualità deve capire dove e quando i problemi si ripetono, non solo se una
spedizione è anomala. I guasti dei sensori devono essere distinti dalle
violazioni termiche reali.

## 2. Domanda principale

> **Quali sensori hanno la frequenza di anomalie più alta e in quali ore si
> verificano più spesso?**

Le domande di supporto riguardano il confronto tra spedizioni, zone
(`Front`, `Middle`, `Rear`), livelli (`Top`, `Middle`, `Bottom`), ore del
giorno e frequenza dei codici hardware `-999.00`.

## 3. Utenti e decisioni

- **Ispettori della catena del freddo:** controllare violazioni e spedizioni
  critiche.
- **Responsabili logistici:** individuare compartimenti da isolare o
  sottoporre a manutenzione.
- **Studenti di database:** dimostrare modello relazionale, qualità dei dati e
  analisi SQL spiegabile.

## 4. Contesto dei dati

Il progetto usa il dataset Hugging Face
[Cold-Chain Transportation Strawberry
Dataset](https://huggingface.co/datasets/NifferLi/Cold-Chain-Transportation-Strawberry).
Sono presenti 6 spedizioni, 14.398 record grezzi, 37 colonne e nove sensori
(`Front_*`, `Middle_*`, `Rear_*`). La conversione in formato lungo produce
129.582 misure. Gli input sono in `data/original/` e l'output in
`data/processed/measurements.csv`.

## 5. Week 3: candidati di tabelle

La tabella `sensors` descrive `sensor_id`, `compartment_zone`,
`vertical_level` e `installed_at`. La tabella `measurements` registra `id`,
`shipment_id`, `sensor_id`, `temp_c` e `measurement_time`. La tabella
`anomaly_thresholds` conserva `rule_id`, `product_name`, `min_safe_temp` e
`max_safe_temp`, con limiti 0,0°C e 4,0°C per le fragole.

## 6. Week 4: problemi attesi

`-999.00` è un codice di guasto hardware, non una temperatura; durante
l'import SQL diventa `NULL` e viene classificato separatamente. `NULL`
indica un'osservazione indisponibile. Le nove colonne dei sensori vengono
trasformate con `pandas.melt()`, il sistema verifica lo schema comune di 37
colonne e il risultato atteso è `14.398 × 9 = 129.582`.

## 7. Week 5: domande analitiche

Le query PostgreSQL devono confrontare conteggi validi, guasti e tassi di
anomalia per sensore, spedizione, zona e ora
(`EXTRACT(HOUR FROM measurement_time)`). Devono distinguere valori sotto
0,0°C, tra 4,0°C e 8,0°C e sopra 8,0°C, senza alterare le medie con dati
mancanti.

## 8. Strategia IA e confini

La componente IA è pianificata per la Week 11 e non è una funzione completata
nella prova intermedia. Le classi previste sono `NORMAL`, `SENSOR_FAULT`,
`COLD_ANOMALY`, `MODERATE_HEAT_ANOMALY` e `CRITICAL_HEAT_BREACH`. Una futura
vista `vw_ai_anomaly_logs` potrà usare `anomaly_thresholds`. Vedere
[AI_BEYAN.md](AI_BEYAN.md).

## 9. Confine tra prova intermedia e finale

La prova copre le Weeks 3-5: modello, qualità, trasformazione, importazione
PostgreSQL e analisi SQL. La Week 11 copre la vista dinamica, le classi
avanzate e la valutazione della componente IA pianificata.
