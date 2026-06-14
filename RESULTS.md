# SIRI / ITCS Temporal Analysis Report

Generated: 2026-06-14 13:19:40 UTC

## 1. Study Design and Data Scope
This report evaluates temporal characteristics of real-time public transport information flows between an ITCS source system and SIRI-ET snapshots.

Observation window: 2026-06-13T07:49:59.042000+00:00 → 2026-06-13T15:58:06.335000+00:00
Number of SIRI snapshots analysed: 486
Number of journey observations analysed: 444306

## 2. Assimilation Latency

Assimilation latency measures the temporal distance between the latest ITCS update and the corresponding SIRI RecordedAtTime timestamp. It approximates internal processing and data ingestion latency within the ET generation chain.

### Statistical Summary
- Sample Count: 11873
- Mean: 6.021 s
- Standard Deviation: 135.797 s
- Maximum: 7428.323 s

### Quantiles
- P50: 3.129 s
- P60: 3.156 s
- P70: 3.184 s
- P80: 3.249 s
- P90: 3.376 s
- P95: 3.477 s
- P99: 3.593 s

### Distribution
![2. Assimilation Latency](results/assimilation_latency.png)

## 3. Event Propagation Latency

Event propagation latency measures the delay between an ITCS event occurrence and the first SIRI snapshot in which that event becomes externally visible. This metric represents the effective end-to-end propagation delay experienced by consumers.

### Statistical Summary
- Sample Count: 4865
- Mean: 1100.397 s
- Standard Deviation: 1932.845 s
- Maximum: 7605.527 s

### Quantiles
- P50: 235.323 s
- P60: 302.962 s
- P70: 642.494 s
- P80: 1582.743 s
- P90: 3552.393 s
- P95: 7187.069 s
- P99: 7367.667 s

### Distribution
![3. Event Propagation Latency](results/event_propagation_latency.png)
![3. Event Propagation Latency](results/event_propagation_latency_detail.png)

## 4. Snapshot Staleness

Snapshot staleness quantifies the age of information at the moment of publication. It is calculated as the difference between ResponseTimestamp and RecordedAtTime.

### Statistical Summary
- Sample Count: 12365
- Mean: 1300.912 s
- Standard Deviation: 2450.788 s
- Maximum: 9248.211 s

### Quantiles
- P50: 224.673 s
- P60: 315.506 s
- P70: 485.737 s
- P80: 962.347 s
- P90: 7184.515 s
- P95: 7388.294 s
- P99: 8098.863 s

### Distribution
![4. Snapshot Staleness](results/snapshot_staleness.png)

## 5. Post-Snapshot ITCS Update Activity

This metric quantifies how many ITCS updates occurred after a snapshot was published. High values indicate that additional state changes became available shortly after publication.

- Mean number of updates: 5.860
- Maximum number of updates: 47

![Future Updates](results/updates_after_snapshot.png)

## 6. Lost ITCS Updates

Number of ITCS updates which have not been published to the SIRI-ET data. *Possible Reason: The trip was estimated to be ended up after the ITCS update has been sent and was not further monitored anymore.* 

- Total ITCS updates : 5,614
- Propagated updates : 4,865
- Lost updates       : 749
- Loss rate          : 13.3416 %

![Lost Updates](results/lost_itcs_updates.png)

## 7. Interpretation

The presented metrics separate different stages of temporal behaviour within the real-time information pipeline.

- Assimilation latency characterises ingestion and processing delays.
- Event propagation latency characterises externally observable responsiveness.
- Snapshot staleness characterises information freshness at publication time.
- Post-snapshot update activity characterises remaining system dynamics after dissemination.

Together, these measures provide a decomposition of real-time system behaviour that can be used to identify bottlenecks and evaluate service quality.

## Appendix A: Complete Quantile Summary

### Assimilation Latency
- Sample Count: 11873
- Mean: 6.021
- StdDev: 135.797
- P50: 3.129
- P60: 3.156
- P70: 3.184
- P80: 3.249
- P90: 3.376
- P95: 3.477
- P99: 3.593
- Max: 7428.323

### Event Propagation Latency
- Sample Count: 4865
- Mean: 1100.397
- StdDev: 1932.845
- P50: 235.323
- P60: 302.962
- P70: 642.494
- P80: 1582.743
- P90: 3552.393
- P95: 7187.069
- P99: 7367.667
- Max: 7605.527

### Snapshot Staleness
- Sample Count: 12365
- Mean: 1300.912
- StdDev: 2450.788
- P50: 224.673
- P60: 315.506
- P70: 485.737
- P80: 962.347
- P90: 7184.515
- P95: 7388.294
- P99: 8098.863
- Max: 9248.211
