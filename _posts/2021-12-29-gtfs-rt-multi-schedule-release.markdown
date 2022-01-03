---
layout: post
title:  "MOTIS v0.6: Multi Schedule Support for GTFS-RT"
date:   2021-12-29 20:19:00 +0100
categories: release
author: felixguendling
version: 0.6.0
---

MOTIS version v0.4 [brought multi-schedule support](https://motis-project.de/release/2021/08/10/motis-multi-schedule-release.html). Since v0.4, MOTIS can load multiple schedules. To be able to distinguish the station IDs from different datasets, the IDs get prefixed with a unique tag from the configuration file. Since the GTFS-RT real-time updates do not apply this tag, it has not been possible to mix multiple schedules and update them with GTFS-RT. Until now - this release of MOTIS enables the real-time receiver to prefix the station IDs with a tag that can be configured in the configuration. Additionally, the GTFS and GTFS-RT in MOTIS has been improved regarding robustness (for example for invalid `stops.txt` files referencing non-existent trips) and more features of the specification (e.g. empty `calendar.txt` or empty `calendar_dates.txt` and GTFS-RT feeds which only use sequence numbers to identify stops) are now supported.

To use multiple schedules with GTFS-RT, the configuration could look like this:

```ini
modules=intermodal
modules=tripbased
modules=ppr
modules=parking
modules=osrm
modules=lookup
modules=railviz
modules=address
modules=guesser
modules=routing
modules=ris
modules=rt

dataset.num_days=3

[import]
paths=schedule-delfi:/input/schedule-delfi
paths=schedule-nl:/input/schedule-nl
paths=schedule-swiss:/input/schedule-swiss
paths=osm:/input/osm.pbf

[ris]
db=/data/ris.mdb
gtfsrt.is_addition_skip_allowed=false
instant_forward=true
clear_db=true
init_time=NOW
input=swiss:/input/rt/swiss
input=nl:/input/rt/nl
```

This uses the schedule timetables from Germany (DELFI GTFS dataset), the Netherlands, and the Swiss as well as real-time updates from the Swiss and Netherlands. Unfortunately, there is no official GTFS-RT real-time data stream for Germany. Note that the tags used to identify the schedule timetable (`delfi`, `nl`, and `swiss`) need to match the tags in the `ris` section for the real-time receiver.

Currently, you need an additional script to download the GTFS-RT real-time updates and inform MOTIS about the updates:

```sh
while true; do
  # SWISS
  mkdir -p data/rt/swiss
  url="https://api.opentransportdata.swiss/gtfsrt2020"
  filename="data/rt/swiss/$(date +%Y%m%d-%H%M%S).pb"
  auth="YOUR_API_KEY"
  curl -X GET -H "Content-type: application/octet-stream" -H "Authorization: ${auth}" -o "$filename" "$url"

  # NL
  mkdir -p data/rt/nl
  url="http://gtfs.ovapi.nl/nl/vehiclePositions.pb"
  filename="data/rt/nl/$(date +%Y%m%d-%H%M%S).pb"
  curl -X GET -H "Content-type: application/octet-stream" -o "$filename" "$url"

  # UPDATE MOTIS
  curl --insecure https://localhost:8080/ris/read
  sleep 30

  # DELETE UPDATES
  rm -rf data/rt
done
```

We are working on improving the documentation ([here](https://motis-project.de/docs)] and in the [GitHub Wiki](https://github.com/motis-project/motis/wiki)) for more complex MOTIS setups. Please feel free to ask questions via the GitHub [issues](https://github.com/motis-project/motis/issues).

We are working on improving the support for GTFS and GTFS-RT, for example by moving the download functionality directly into MOTIS so the update script above won't be necessary anymore. Furthermore, we are looking forward to next year where we will see [GBFS](https://github.com/NABSA/gbfs)-support in MOTIS as well as a new data model supporting timetables with arbitrary length (at least 1-2 years) in an memory-efficient manner. The work on these features is sponsored by [INIT](https://initse.com).
