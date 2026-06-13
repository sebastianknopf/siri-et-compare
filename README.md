# SIRI / ITCS Temporal Analysis Report

Generated: 2026-06-13 16:43:50 UTC

## 1. Study Design and Data Scope
This analysis investigates temporal coupling between ITCS event streams and SIRI-ET snapshots.

Observation window: 2026-06-13T07:49:59.042000+00:00 → 2026-06-13T15:58:06.335000+00:00
Number of SIRI snapshots: 486
Number of filtered journey observations: 444306

## 2. Assimilation Latency
Time between last ITCS update and ET RecordedAtTime.

Statistical summary:
- Mean: 3.168
- StdDev: 0.146
- Max: 3.821
- P50: 3.136
- P60: 3.165
- P70: 3.196
- P80: 3.254
- P90: 3.384
- P95: 3.485
- P99: 3.593

Distribution:
![2. Assimilation Latency](results\assimilation_latency.png)

## 3. Snapshot Staleness
Time gap between ET creation and publication.

Statistical summary:
- Mean: 1365.235
- StdDev: 2509.331
- Max: 10223.396
- P50: 229.417
- P60: 326.443
- P70: 512.028
- P80: 1127.194
- P90: 7203.185
- P95: 7446.132
- P99: 8184.598

Distribution:
![3. Snapshot Staleness](results\snapshot_staleness.png)

## 4. Publication Latency
End-to-end delay from ITCS update to SIRI availability.

Statistical summary:
- Mean: 1306.789
- StdDev: 2472.754
- Max: 10227.158
- P50: 204.476
- P60: 302.481
- P70: 478.861
- P80: 1004.501
- P90: 7187.667
- P95: 7435.774
- P99: 8187.827

Distribution:
![4. Publication Latency](results\publication_latency.png)

## 5. Post-snapshot ITCS Update Activity
Number of ITCS updates after snapshot publication.

- Mean: 5.856
- Max: 47

Distribution:
![ITCS Updates](results\updates_after_snapshot.png)

## 6. Interpretation
The decomposition separates ingestion latency, system processing delay, and dissemination delay, allowing structured evaluation of real-time transport data pipelines.

## Appendix: Full Quantile Summary

### Assimilation Latency
- Mean: 3.168
- StdDev: 0.146
- P50: 3.136
- P60: 3.165
- P70: 3.196
- P80: 3.254
- P90: 3.384
- P95: 3.485
- P99: 3.593
- Max: 3.821

### Snapshot Staleness
- Mean: 1365.235
- StdDev: 2509.331
- P50: 229.417
- P60: 326.443
- P70: 512.028
- P80: 1127.194
- P90: 7203.185
- P95: 7446.132
- P99: 8184.598
- Max: 10223.396

### Publication Latency
- Mean: 1306.789
- StdDev: 2472.754
- P50: 204.476
- P60: 302.481
- P70: 478.861
- P80: 1004.501
- P90: 7187.667
- P95: 7435.774
- P99: 8187.827
- Max: 10227.158
