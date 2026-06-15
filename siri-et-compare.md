# SIRI-ET Compare
This Jupyter Notebook compares the data quality of DELFI SIRI-ET stream with the original communication logs of an ITCS of IVU. It requires two input files:
- `data/itcs.log` The communication logs of the IVU ITCS
- `data/siriet/*.xml` At least one recorded SIRI-ET dump of DELFI

## 1. Step: Extraction of ITCS Data
The ITCS log contains mixed text block logs and XML dumps of the VDV454-AUS data. The extraction block parses the XML contents and builds a dict in following structure:

```python
{
    'JourneyRef': [
        datetime(...),
        datetime(...),
        datetime(...),
        ...
    ]
}
```

This structure contains each journey and all timestamps, when data have been delivered for this journey.

    Number of unique journeys: 759
    Number of timestamp records: 7464
    

## 2. Step: Extraction of SIRI-ET Data
The SIRI-ET dumps contain a SIRI ServiceDelivery object. The extraction block parses the XMLs and extracts for each JourneyRef the RecordedAt timestamp into a structure like that:

```python
{
    'JourneyRef': [{
        'response_timestamp': datetime(...),'
        'recorded_at': datetime(...),
        'end_timestamp': datetime(...)
    }, {
        ...
    }]
}
```
The `recorded_at` is the timestamp when the message from the ITCS has arrived at the SIRI-ET broker. The `response_timestamp` represents the timestamp, when the updates became published in the SIRI-ET data.

    Found 486 SIRI-ET files to process.
    Processed 1/486 files (0.2%)
    Processed 100/486 files (20.6%)
    Processed 200/486 files (41.2%)
    Processed 300/486 files (61.7%)
    Processed 400/486 files (82.3%)
    Processed 486/486 files (100.0%)
    
    Analysis window: 2026-06-13T07:49:59.042000+00:00 to 2026-06-13T15:58:06.335000+00:00
    Number of SIRI snapshots: 486
    Number of unique SIRI journeys: 19,010
    Number of journeys from ITCS: 580
    Number of ITCS journeys not present in SIRI: 179
    Number of observations: 2,200,020
    

## 3. Step: Metrics
Out of the collected data, following metrics are calculated:
- Assimilation Latency: This is the time which an ITCS update takes to be recorded by the SIRI-ET sink. It is **not** the time when the update becomes visible!
- Propagation Latency: This is the time range which an ITCS updates takes to be visible in SIRI-ET data.
- Snapshot Staleness: Difference between `ResponseTimestamp` and `RecordedAt` of a journey in a SIRI-ET snapshot.
- Future ITCS Updates: Number of updates the ITCS has sent after the last publication of a journey in a SIRI-ET snapshot.
- Lost ITCS Updates: Number of updates the ITCS has sent, but never appeared in a SIRI-ET snapshot.

    
    ## Results
    Matched observations: 68118
    
    ## Assimilation Latency (ITCS → SIRI Data Sink)
    - Mean    : 66.997 s
    - StdDev  : 103.664 s
    - Max     : 1187.971 s
    - P50     : 3.499 s
    - P60     : 33.137 s
    - P70     : 78.154 s
    - P80     : 138.059 s
    - P90     : 213.022 s
    - P95     : 273.051 s
    - P99     : 408.121 s
    - Samples : 5692
    
    ## Propagation Latency (ITCS → SIRI Visibility)
    - Mean    : 160.551 s
    - StdDev  : 104.900 s
    - Max     : 600.527 s
    - P50     : 151.671 s
    - P60     : 179.101 s
    - P70     : 216.049 s
    - P80     : 254.101 s
    - P90     : 299.101 s
    - P95     : 342.827 s
    - P99     : 422.904 s
    - Samples : 5744
    
    ## Snapshot Staleness
    - Mean    : 2361.295 s
    - StdDev  : 2219.314 s
    - Max     : 9662.466 s
    - P50     : 1614.688 s
    - P60     : 2471.655 s
    - P70     : 3481.209 s
    - P80     : 4584.627 s
    - P90     : 5890.771 s
    - P95     : 6639.136 s
    - P99     : 7492.840 s
    - Samples : 68118
    
    ## Future ITCS Updates
    - Mean : 7.829
    - Max  : 62
    
    ## Lost ITCS Updates
    - Total ITCS updates  : 5,744
    - Propagated updates  : 5,692
    - Lost updates        : 52
    - Loss rate (updates) : 0.9053 %
    
    Unpropagated Updates:
    | Jorney | ITCS Update | Last RecordedAt | Aimed/Estimated End |
    | ----- | ----- | ----- | ----- |
    | MAND_EBE_LIN_744_FRTNR_247_UML_3210_FRTINUML_4 | 2026-06-13T09:48:10+00:00 | 2026-06-13T09:46:13+00:00 | 2026-06-13T09:46:00+00:00 |
    | MAND_BIN_LIN_736_FRTNR_17_UML_2021_FRTINUML_5 | 2026-06-13T07:56:55+00:00 | 2026-06-13T07:55:13+00:00 | 2026-06-13T07:54:00+00:00 |
    | MAND_BIN_LIN_739_FRTNR_19_UML_2021_FRTINUML_7 | 2026-06-13T09:20:40+00:00 | 2026-06-13T09:19:58+00:00 | 2026-06-13T09:20:00+00:00 |
    | MAND_EBE_LIN_7112_FRTNR_46_UML_6106_FRTINUML_4 | 2026-06-13T08:14:10+00:00 | 2026-06-13T08:13:58+00:00 | 2026-06-13T08:28:00+00:00 |
    | MAND_EBE_LIN_7112_FRTNR_46_UML_6106_FRTINUML_4 | 2026-06-13T08:16:55+00:00 | 2026-06-13T08:13:58+00:00 | 2026-06-13T08:28:00+00:00 |
    | MAND_WOLF_LIN_738_FRTNR_8830_UML_8037_FRTINUML_9 | 2026-06-13T09:37:25+00:00 | 2026-06-13T09:37:13+00:00 | 2026-06-13T09:34:00+00:00 |
    | MAND_WOLF_LIN_738_FRTNR_8830_UML_8037_FRTINUML_9 | 2026-06-13T09:37:40+00:00 | 2026-06-13T09:37:13+00:00 | 2026-06-13T09:34:00+00:00 |
    | MAND_EBE_LIN_1044_FRTNR_5_UML_5060_FRTINUML_4 | 2026-06-13T08:57:55+00:00 | 2026-06-13T08:57:43+00:00 | 2026-06-13T08:57:00+00:00 |
    | MAND_EBE_LIN_155_FRTNR_434_UML_3250_FRTINUML_6 | 2026-06-13T07:58:40+00:00 | 2026-06-13T07:58:28+00:00 | 2026-06-13T08:02:00+00:00 |
    | MAND_WOLF_LIN_736_FRTNR_1424_UML_8031_FRTINUML_7 | 2026-06-13T07:57:10+00:00 | 2026-06-13T07:53:58+00:00 | 2026-06-13T08:04:00+00:00 |
    | MAND_EBE_LIN_241_FRTNR_46_UML_5161_FRTINUML_8 | 2026-06-13T09:58:25+00:00 | 2026-06-13T09:58:13+00:00 | 2026-06-13T09:58:00+00:00 |
    | MAND_EBE_LIN_241_FRTNR_46_UML_5161_FRTINUML_8 | 2026-06-13T09:59:40+00:00 | 2026-06-13T09:58:13+00:00 | 2026-06-13T09:58:00+00:00 |
    | MAND_EBE_LIN_244_FRTNR_77_UML_5064_FRTINUML_8 | 2026-06-13T09:13:10+00:00 | 2026-06-13T09:11:58+00:00 | 2026-06-13T09:26:00+00:00 |
    | MAND_EBE_LIN_244_FRTNR_77_UML_5064_FRTINUML_8 | 2026-06-13T09:18:25+00:00 | 2026-06-13T09:11:58+00:00 | 2026-06-13T09:26:00+00:00 |
    | MAND_EBE_LIN_244_FRTNR_77_UML_5064_FRTINUML_8 | 2026-06-13T09:18:40+00:00 | 2026-06-13T09:11:58+00:00 | 2026-06-13T09:26:00+00:00 |
    | MAND_EBE_LIN_244_FRTNR_77_UML_5064_FRTINUML_8 | 2026-06-13T09:23:25+00:00 | 2026-06-13T09:11:58+00:00 | 2026-06-13T09:26:00+00:00 |
    | MAND_EBE_LIN_244_FRTNR_77_UML_5064_FRTINUML_8 | 2026-06-13T09:23:40+00:00 | 2026-06-13T09:11:58+00:00 | 2026-06-13T09:26:00+00:00 |
    | MAND_EBE_LIN_244_FRTNR_77_UML_5064_FRTINUML_8 | 2026-06-13T09:25:55+00:00 | 2026-06-13T09:11:58+00:00 | 2026-06-13T09:26:00+00:00 |
    | MAND_EBE_LIN_244_FRTNR_77_UML_5064_FRTINUML_8 | 2026-06-13T09:28:25+00:00 | 2026-06-13T09:11:58+00:00 | 2026-06-13T09:26:00+00:00 |
    | MAND_BIN_LIN_739_FRTNR_18_UML_2021_FRTINUML_6 | 2026-06-13T08:32:55+00:00 | 2026-06-13T08:32:43+00:00 | 2026-06-13T08:39:00+00:00 |
    | MAND_BIN_LIN_739_FRTNR_18_UML_2021_FRTINUML_6 | 2026-06-13T08:38:25+00:00 | 2026-06-13T08:32:43+00:00 | 2026-06-13T08:39:00+00:00 |
    | MAND_EBE_LIN_2_FRTNR_67_UML_3244_FRTINUML_7 | 2026-06-13T09:48:40+00:00 | 2026-06-13T09:47:43+00:00 | 2026-06-13T09:46:00+00:00 |
    | MAND_EBE_LIN_2_FRTNR_76_UML_3244_FRTINUML_8 | 2026-06-13T10:16:55+00:00 | 2026-06-13T10:16:43+00:00 | 2026-06-13T10:16:00+00:00 |
    | MAND_WOLF_LIN_739_FRTNR_8832_UML_8037_FRTINUML_11 | 2026-06-13T10:39:55+00:00 | 2026-06-13T10:39:43+00:00 | 2026-06-13T10:39:00+00:00 |
    | MAND_EBE_LIN_7103_FRTNR_34_UML_6005_FRTINUML_12 | 2026-06-13T10:29:40+00:00 | 2026-06-13T10:25:28+00:00 | 2026-06-13T10:27:00+00:00 |
    | MAND_EBE_LIN_7715_FRTNR_140_UML_3201_FRTINUML_9 | 2026-06-13T10:48:40+00:00 | 2026-06-13T10:47:43+00:00 | 2026-06-13T10:45:00+00:00 |
    | MAND_EBE_LIN_7104_FRTNR_113_UML_6108_FRTINUML_5 | 2026-06-13T10:57:40+00:00 | 2026-06-13T10:57:28+00:00 | 2026-06-13T10:57:00+00:00 |
    | MAND_EBE_LIN_2_FRTNR_83_UML_3244_FRTINUML_9 | 2026-06-13T11:19:10+00:00 | 2026-06-13T11:18:58+00:00 | 2026-06-13T11:01:00+00:00 |
    | MAND_WOLF_LIN_739_FRTNR_8833_UML_8037_FRTINUML_12 | 2026-06-13T11:20:40+00:00 | 2026-06-13T11:17:28+00:00 | 2026-06-13T11:20:00+00:00 |
    | MAND_EBE_LIN_744_FRTNR_324_UML_3208_FRTINUML_7 | 2026-06-13T11:39:55+00:00 | 2026-06-13T11:33:43+00:00 | 2026-06-13T11:22:00+00:00 |
    | MAND_EBE_LIN_7110_FRTNR_198_UML_6107_FRTINUML_10 | 2026-06-13T11:04:25+00:00 | 2026-06-13T11:03:13+00:00 | 2026-06-13T11:02:00+00:00 |
    | MAND_EBE_LIN_7104_FRTNR_115_UML_6002_FRTINUML_11 | 2026-06-13T11:24:55+00:00 | 2026-06-13T11:24:43+00:00 | 2026-06-13T11:27:00+00:00 |
    | MAND_EBE_LIN_1044_FRTNR_22_UML_5062_FRTINUML_6 | 2026-06-13T12:43:40+00:00 | 2026-06-13T12:43:13+00:00 | 2026-06-13T12:14:00+00:00 |
    | MAND_EBE_LIN_1044_FRTNR_13_UML_5061_FRTINUML_6 | 2026-06-13T13:10:25+00:00 | 2026-06-13T12:59:13+00:00 | 2026-06-13T12:57:00+00:00 |
    | MAND_EBE_LIN_155_FRTNR_466_UML_3250_FRTINUML_14 | 2026-06-13T12:04:55+00:00 | 2026-06-13T12:03:28+00:00 | 2026-06-13T12:02:00+00:00 |
    | MAND_EBE_LIN_7105_FRTNR_252_UML_6108_FRTINUML_9 | 2026-06-13T12:48:55+00:00 | 2026-06-13T12:47:43+00:00 | 2026-06-13T12:48:00+00:00 |
    | MAND_WOLF_LIN_737_FRTNR_8836_UML_8037_FRTINUML_15 | 2026-06-13T13:24:40+00:00 | 2026-06-13T13:24:28+00:00 | 2026-06-13T13:32:00+00:00 |
    | MAND_WOLF_LIN_737_FRTNR_8836_UML_8037_FRTINUML_15 | 2026-06-13T13:29:55+00:00 | 2026-06-13T13:24:28+00:00 | 2026-06-13T13:32:00+00:00 |
    | MAND_WOLF_LIN_737_FRTNR_8836_UML_8037_FRTINUML_15 | 2026-06-13T13:30:10+00:00 | 2026-06-13T13:24:28+00:00 | 2026-06-13T13:32:00+00:00 |
    | MAND_EBE_LIN_7110_FRTNR_195_UML_6006_FRTINUML_5 | 2026-06-13T13:09:55+00:00 | 2026-06-13T13:09:43+00:00 | 2026-06-13T13:10:00+00:00 |
    | MAND_WOLF_LIN_736_FRTNR_8663_UML_8032_FRTINUML_1 | 2026-06-13T11:56:55+00:00 | 2026-06-13T11:54:28+00:00 | 2026-06-13T11:54:00+00:00 |
    | MAND_WOLF_LIN_736_FRTNR_2501_UML_8034_FRTINUML_11 | 2026-06-13T14:05:25+00:00 | 2026-06-13T14:05:13+00:00 | 2026-06-13T14:04:00+00:00 |
    | MAND_EBE_LIN_151_FRTNR_285_UML_3252_FRTINUML_6 | 2026-06-13T12:52:25+00:00 | 2026-06-13T12:48:43+00:00 | 2026-06-13T12:48:00+00:00 |
    | MAND_EBE_LIN_1044_FRTNR_107_UML_5062_FRTINUML_8 | 2026-06-13T14:06:25+00:00 | 2026-06-13T14:04:28+00:00 | 2026-06-13T13:57:00+00:00 |
    | MAND_EBE_LIN_151_FRTNR_281_UML_3252_FRTINUML_4 | 2026-06-13T12:22:40+00:00 | 2026-06-13T12:22:28+00:00 | 2026-06-13T12:28:00+00:00 |
    | MAND_BIN_LIN_738_FRTNR_6475_UML_2023_FRTINUML_1 | 2026-06-13T12:56:55+00:00 | 2026-06-13T12:54:13+00:00 | 2026-06-13T12:55:00+00:00 |
    | MAND_EBE_LIN_7715_FRTNR_122_UML_3213_FRTINUML_2 | 2026-06-13T12:52:55+00:00 | 2026-06-13T12:31:58+00:00 | 2026-06-13T12:45:00+00:00 |
    | MAND_EBE_LIN_244_FRTNR_85_UML_5067_FRTINUML_1 | 2026-06-13T13:21:25+00:00 | 2026-06-13T13:21:13+00:00 | 2026-06-13T13:26:00+00:00 |
    | MAND_EBE_LIN_244_FRTNR_85_UML_5067_FRTINUML_1 | 2026-06-13T13:23:40+00:00 | 2026-06-13T13:21:13+00:00 | 2026-06-13T13:26:00+00:00 |
    | MAND_EBE_LIN_7110_FRTNR_222_UML_6107_FRTINUML_22 | 2026-06-13T15:04:10+00:00 | 2026-06-13T15:02:58+00:00 | 2026-06-13T15:02:00+00:00 |
    | MAND_EBE_LIN_7104_FRTNR_132_UML_6111_FRTINUML_3 | 2026-06-13T15:17:25+00:00 | 2026-06-13T15:16:42+00:00 | 2026-06-13T15:31:00+00:00 |
    | MAND_EBE_LIN_7104_FRTNR_132_UML_6111_FRTINUML_3 | 2026-06-13T15:18:40+00:00 | 2026-06-13T15:16:42+00:00 | 2026-06-13T15:31:00+00:00 |
    
    ## Lost ITCS Journeys
    - Total ITCS journeys : 580
    - Propagated journeys : 580
    - Lost journeys       : 0
    - Loss rate (journeys): 0.0000 %
    
    


    
![png](siri-et-compare_files/siri-et-compare_6_1.png)
    



    
![png](siri-et-compare_files/siri-et-compare_6_2.png)
    



    
![png](siri-et-compare_files/siri-et-compare_6_3.png)
    



    
![png](siri-et-compare_files/siri-et-compare_6_4.png)
    



    
![png](siri-et-compare_files/siri-et-compare_6_5.png)
    

