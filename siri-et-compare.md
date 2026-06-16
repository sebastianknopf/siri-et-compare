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
    | Journey (Hash) | ITCS Update | Last RecordedAt | Aimed/Estimated End |
    | ----- | ----- | ----- | ----- |
    | 78b7a0758a634f0d6857c19d03c5fba5 | 2026-06-13T09:48:10+00:00 | 2026-06-13T09:46:13+00:00 | 2026-06-13T09:46:00+00:00 |
    | be6d75f634d316f7e0768a1d90bd5400 | 2026-06-13T07:56:55+00:00 | 2026-06-13T07:55:13+00:00 | 2026-06-13T07:54:00+00:00 |
    | 9b4270376e5e17f24da3458e10df72af | 2026-06-13T09:20:40+00:00 | 2026-06-13T09:19:58+00:00 | 2026-06-13T09:20:00+00:00 |
    | 22bb53e53edbdb0b160b63462e62ecc8 | 2026-06-13T08:14:10+00:00 | 2026-06-13T08:13:58+00:00 | 2026-06-13T08:28:00+00:00 |
    | 22bb53e53edbdb0b160b63462e62ecc8 | 2026-06-13T08:16:55+00:00 | 2026-06-13T08:13:58+00:00 | 2026-06-13T08:28:00+00:00 |
    | 23b7653bde6a0b9cea14255b006927a7 | 2026-06-13T09:37:25+00:00 | 2026-06-13T09:37:13+00:00 | 2026-06-13T09:34:00+00:00 |
    | 23b7653bde6a0b9cea14255b006927a7 | 2026-06-13T09:37:40+00:00 | 2026-06-13T09:37:13+00:00 | 2026-06-13T09:34:00+00:00 |
    | f98bc5eb2373e9683883b6c222da89dc | 2026-06-13T08:57:55+00:00 | 2026-06-13T08:57:43+00:00 | 2026-06-13T08:57:00+00:00 |
    | 66e44d3ca666894e47d796a27b2aa911 | 2026-06-13T07:58:40+00:00 | 2026-06-13T07:58:28+00:00 | 2026-06-13T08:02:00+00:00 |
    | 4a41ebc822731609cfb7e09b9fe66df9 | 2026-06-13T07:57:10+00:00 | 2026-06-13T07:53:58+00:00 | 2026-06-13T08:04:00+00:00 |
    | d60ff5c7e180988a794895a615e93c8e | 2026-06-13T09:58:25+00:00 | 2026-06-13T09:58:13+00:00 | 2026-06-13T09:58:00+00:00 |
    | d60ff5c7e180988a794895a615e93c8e | 2026-06-13T09:59:40+00:00 | 2026-06-13T09:58:13+00:00 | 2026-06-13T09:58:00+00:00 |
    | 12d2f0574cfb2a85ebb08448af7a2fe3 | 2026-06-13T09:13:10+00:00 | 2026-06-13T09:11:58+00:00 | 2026-06-13T09:26:00+00:00 |
    | 12d2f0574cfb2a85ebb08448af7a2fe3 | 2026-06-13T09:18:25+00:00 | 2026-06-13T09:11:58+00:00 | 2026-06-13T09:26:00+00:00 |
    | 12d2f0574cfb2a85ebb08448af7a2fe3 | 2026-06-13T09:18:40+00:00 | 2026-06-13T09:11:58+00:00 | 2026-06-13T09:26:00+00:00 |
    | 12d2f0574cfb2a85ebb08448af7a2fe3 | 2026-06-13T09:23:25+00:00 | 2026-06-13T09:11:58+00:00 | 2026-06-13T09:26:00+00:00 |
    | 12d2f0574cfb2a85ebb08448af7a2fe3 | 2026-06-13T09:23:40+00:00 | 2026-06-13T09:11:58+00:00 | 2026-06-13T09:26:00+00:00 |
    | 12d2f0574cfb2a85ebb08448af7a2fe3 | 2026-06-13T09:25:55+00:00 | 2026-06-13T09:11:58+00:00 | 2026-06-13T09:26:00+00:00 |
    | 12d2f0574cfb2a85ebb08448af7a2fe3 | 2026-06-13T09:28:25+00:00 | 2026-06-13T09:11:58+00:00 | 2026-06-13T09:26:00+00:00 |
    | d7ee3cf606df7f7a6a74566615a96c85 | 2026-06-13T08:32:55+00:00 | 2026-06-13T08:32:43+00:00 | 2026-06-13T08:39:00+00:00 |
    | d7ee3cf606df7f7a6a74566615a96c85 | 2026-06-13T08:38:25+00:00 | 2026-06-13T08:32:43+00:00 | 2026-06-13T08:39:00+00:00 |
    | 4d75e4909d0285e61daa5ef4f1c9d396 | 2026-06-13T09:48:40+00:00 | 2026-06-13T09:47:43+00:00 | 2026-06-13T09:46:00+00:00 |
    | 3c45d7ba59c6d2eca978a024ad3b075d | 2026-06-13T10:16:55+00:00 | 2026-06-13T10:16:43+00:00 | 2026-06-13T10:16:00+00:00 |
    | 7e50a2c7d669012dac638cf54b2d0dc6 | 2026-06-13T10:39:55+00:00 | 2026-06-13T10:39:43+00:00 | 2026-06-13T10:39:00+00:00 |
    | 5128ff48e7ebdd5ae78a8ffe0c598def | 2026-06-13T10:29:40+00:00 | 2026-06-13T10:25:28+00:00 | 2026-06-13T10:27:00+00:00 |
    | b215446485b9d3433e4dfcf87b54963c | 2026-06-13T10:48:40+00:00 | 2026-06-13T10:47:43+00:00 | 2026-06-13T10:45:00+00:00 |
    | ef67220d80836e9f9a82e07bc2c88df5 | 2026-06-13T10:57:40+00:00 | 2026-06-13T10:57:28+00:00 | 2026-06-13T10:57:00+00:00 |
    | 7c5b3861be282b2f9d7d97630892989b | 2026-06-13T11:19:10+00:00 | 2026-06-13T11:18:58+00:00 | 2026-06-13T11:01:00+00:00 |
    | 547a55137b96f38c68d91b3027e31b6d | 2026-06-13T11:20:40+00:00 | 2026-06-13T11:17:28+00:00 | 2026-06-13T11:20:00+00:00 |
    | 430565dbf48068f706df5ef9d68fd522 | 2026-06-13T11:39:55+00:00 | 2026-06-13T11:33:43+00:00 | 2026-06-13T11:22:00+00:00 |
    | 1f127ead4c810c68e7af1f3f05e6867a | 2026-06-13T11:04:25+00:00 | 2026-06-13T11:03:13+00:00 | 2026-06-13T11:02:00+00:00 |
    | 472672da5a59968c034a580cc87795d5 | 2026-06-13T11:24:55+00:00 | 2026-06-13T11:24:43+00:00 | 2026-06-13T11:27:00+00:00 |
    | 9b8fcf3147ec6c05f9acc4ca9feb65b0 | 2026-06-13T12:43:40+00:00 | 2026-06-13T12:43:13+00:00 | 2026-06-13T12:14:00+00:00 |
    | b5e8feed5c1afcf2df0a2cd83c2dfb41 | 2026-06-13T13:10:25+00:00 | 2026-06-13T12:59:13+00:00 | 2026-06-13T12:57:00+00:00 |
    | e2d6466b37b6573d789940fb890b139b | 2026-06-13T12:04:55+00:00 | 2026-06-13T12:03:28+00:00 | 2026-06-13T12:02:00+00:00 |
    | a00f0ed5f45fb02562ba4cf653ff95de | 2026-06-13T12:48:55+00:00 | 2026-06-13T12:47:43+00:00 | 2026-06-13T12:48:00+00:00 |
    | 456d46b4979713173ca820f61edf422a | 2026-06-13T13:24:40+00:00 | 2026-06-13T13:24:28+00:00 | 2026-06-13T13:32:00+00:00 |
    | 456d46b4979713173ca820f61edf422a | 2026-06-13T13:29:55+00:00 | 2026-06-13T13:24:28+00:00 | 2026-06-13T13:32:00+00:00 |
    | 456d46b4979713173ca820f61edf422a | 2026-06-13T13:30:10+00:00 | 2026-06-13T13:24:28+00:00 | 2026-06-13T13:32:00+00:00 |
    | b834c8d16649e75492e922f2209d37f8 | 2026-06-13T13:09:55+00:00 | 2026-06-13T13:09:43+00:00 | 2026-06-13T13:10:00+00:00 |
    | 24f8f7cf4733b023463f33ad32595f0c | 2026-06-13T11:56:55+00:00 | 2026-06-13T11:54:28+00:00 | 2026-06-13T11:54:00+00:00 |
    | 579b5d12a10c1eb19ac4838a27e1b5b9 | 2026-06-13T14:05:25+00:00 | 2026-06-13T14:05:13+00:00 | 2026-06-13T14:04:00+00:00 |
    | ab83ddb65562879cc253692e733068ac | 2026-06-13T12:52:25+00:00 | 2026-06-13T12:48:43+00:00 | 2026-06-13T12:48:00+00:00 |
    | e45c956592d76d7f0a555aeff8f412ad | 2026-06-13T14:06:25+00:00 | 2026-06-13T14:04:28+00:00 | 2026-06-13T13:57:00+00:00 |
    | dda905de25394148e84414b84275214d | 2026-06-13T12:22:40+00:00 | 2026-06-13T12:22:28+00:00 | 2026-06-13T12:28:00+00:00 |
    | 8ba17be11961f8aece52ca5128a8dda8 | 2026-06-13T12:56:55+00:00 | 2026-06-13T12:54:13+00:00 | 2026-06-13T12:55:00+00:00 |
    | 71b2303c4dca9c3d93aaf89f6a5839b5 | 2026-06-13T12:52:55+00:00 | 2026-06-13T12:31:58+00:00 | 2026-06-13T12:45:00+00:00 |
    | 24f055dae05ad5c5b837736525d988b1 | 2026-06-13T13:21:25+00:00 | 2026-06-13T13:21:13+00:00 | 2026-06-13T13:26:00+00:00 |
    | 24f055dae05ad5c5b837736525d988b1 | 2026-06-13T13:23:40+00:00 | 2026-06-13T13:21:13+00:00 | 2026-06-13T13:26:00+00:00 |
    | decf95ba52e7756804b71a70f522fc74 | 2026-06-13T15:04:10+00:00 | 2026-06-13T15:02:58+00:00 | 2026-06-13T15:02:00+00:00 |
    | 00f90934c558953aef0affec278d32a7 | 2026-06-13T15:17:25+00:00 | 2026-06-13T15:16:42+00:00 | 2026-06-13T15:31:00+00:00 |
    | 00f90934c558953aef0affec278d32a7 | 2026-06-13T15:18:40+00:00 | 2026-06-13T15:16:42+00:00 | 2026-06-13T15:31:00+00:00 |
    
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
    

