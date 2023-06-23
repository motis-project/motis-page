---
layout: post
title:  "MOTIS v0.10: New Core GTFS-RT Delays"
date:   2023-06-23 14:20:00 +0200
categories: release
author: felixguendling
version: 0.10.0
---

With MOTIS v0.10.0, it is now possible to update the new data model with GTFS-RT delay updates. Other types of updates are not supported yet (like train or stop cancellations, track changes, etc.) but will be in the future. Currently, only the routing of the new core provides real-time information. All other modules still depend on the old core being loaded. The next step is to make them compatible with the new `nigiri` core.

<p align="center">
<img src="/assets/real_time_connection.png" alt="Connection annotated with real-time information" style="width:440px;"/>
</p>


## MOTIS Demo

The MOTIS demo at [europe.motis-project.de](https://europe.motis-project.de) has been updated and now has datasets from Poland, Switzerland, Belgium, Netherlands, and Germany which makes it the largest open source routing deployment of the world. Real-time data is configured for some cities in Poland, SNCB in Belgium and the dataset for Netherlands. Unfortunately, there is no open GTFS-RT data from the national access point in Germany.

![map of Europe with trains in Netherlands, Belgium, Switzerland, Poland, and Germany](/assets/motis_europe_1.png)

We will add new datasets step by step until we cover Europe.


## Example Configuration

The following configuration shows how to setup real-time routing with MOTIS and the new core (`nigiri`). Note that if a GTFS-RT data source is configured, the tag (here for example `nl` and `swiss`) needs to match exactly one tag given in `import.paths`.

```ini
modules=intermodal
modules=ppr
modules=parking
modules=osrm
modules=lookup
modules=railviz
modules=address
modules=guesser
modules=routing
modules=nigiri
modules=tiles
modules=path

intermodal.router=nigiri
server.static_path=/motis/web

[tiles]
import.use_coastline=true
profile=/motis/tiles-profiles/background.lua

[dataset]
link_stop_distance=0
begin=TODAY
cache_graph=true
read_graph_mmap=true

[import]
data_dir=/data
paths=coastline:/input/land-polygons-complete-4326.zip
paths=schedule-delfi:/input/schedule/delfi
paths=schedule-nl:/input/schedule/nl
paths=schedule-swiss:/input/schedule/swiss
paths=osm:/input/osm.pbf

[osrm]
profiles=/motis/osrm-profiles/car.lua
profiles=/motis/osrm-profiles/bike.lua

[nigiri]
first_day=TODAY
num_days=2
default_timezone=Europe/Berlin
gtfsrt=nl|http://gtfs.ovapi.nl/nl/tripUpdates.pb
gtfsrt=swiss|https://api.opentransportdata.swiss/gtfsrt2020|API_KEY
```


## Sponsor

This work is partially sponsored by [INIT](https://www.initse.com).

<p align="center" style="margin-bottom: 30px">
  <a href="https://www.initse.com">
    <img src="/assets/init_logo.svg" alt="INIT Logo" style="width: 140px" />
  </a>
</p>
