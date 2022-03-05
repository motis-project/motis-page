---
layout: post
title:  "MOTIS v0.7: GTFS-RT Update Timer"
date:   2022-03-05 13:04:00 +0100
categories: release
author: felixguendling
version: 0.7.4
---

MOTIS version v0.7 brings several small improvements to make deploying MOTIS as easy as possible. It eliminates the need for external scripts (except for scheduled restarts). Additionally, it now runs on Apple Silicon (arm64 M1 CPUs).


## GTFS-RT Polling Timer inside MOTIS

Previously, a separate cron-job to download the GTFS-RT update to the filesystem and trigger MOTIS to read it was required to update MOTIS. Now, the `ris.input` can handle URLs directly. MOTIS uses an internal timer to poll the given URLs and store and process the update. The following example shows a `config.ini` for a single timetable:

```ini
[import]
input=schedule:/input/gtfs-nl
input=osm:path_to_osm

[ris]
input=http://gtfs.ovapi.nl/nl/tripUpdates.pb
init_time=NOW
gtfsrt.is_addition_skip_allowed=false
instant_forward=true

# ... (configuration for other modules)
```

For multiple timetables, a tag is needed. The tags for the timetable and the GTFS-RT update need to match exactly to be able to match station IDs and trip IDs:

```ini
[import]
input=schedule-nl:/input/gtfs-nl
input=schedule-swiss:/input/gtfs-swiss
input=osm:path_to_osm

[ris]
input=nl|http://gtfs.ovapi.nl/nl/tripUpdates.pb
input=swiss|https://api.opentransportdata.swiss/gtfsrt2020|my_auth_key

# ...
```

## Environment Variables

MOTIS can now be configured in three ways: command-line flags, configuration files (system configuration which is overriden by the user configuration) as well as environment variables since this release.

The translation between configuration keys and environment variable names is straightforward:

  - prepend `MOTIS_`
  - all uppercase / all-caps
  - replace `.` by `_`
  - replace `_` by `__` (two `_` characters)

Unkown environment variables are ignored by MOTIS.


## Fixes

The returned routing interval for the trip-based routing is now correct.