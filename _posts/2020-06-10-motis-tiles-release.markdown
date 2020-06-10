---
layout: post
title:  "MOTIS v0.3: Tiles Module & Improved GTFS Support"
date:   2020-06-10 21:33:00 +0100
categories: release
author: felixguendling
version: 0.3
---

With version v0.3, MOTIS comes with an embedded tile server which is based on [@sfahnens](https://github.com/sfahnens/tiles) tile server library. This was the last step to a full One-Stop-Shopping package for the MOTIS web user interface. Now, MOTIS provides everything what is displayed (autocomplete for stops and places, routing, map view) on its own, with a one-click automatic data preprocessing experience.

## Web UI

The web user interface now uses [Mapbox GL JS](https://docs.mapbox.com/mapbox-gl-js/api/) with vector tiles instead of [Leaflet](https://leafletjs.com/) which enables 3D support by holding CTRL, clicking (hold) and moving the mouse.

![RailViz 3D Map](/assets/railviz3d.png)

Furthermore, the network format has been improved to be more efficient and compact. This was accomplished by reusing path segments and introducing Google's [polyline encoding](https://developers.google.com/maps/documentation/utilities/polylineutility) to compress geographic coordinate strings. The changes had a huge impact:  a response that was 2.5 megabytes in size now is only about 250 kilobytes which is a 10x improvement (both measurements with Apache 2's deflate compression enabled).

Busses that travel a longer distance are visible earlier when zooming in. This is to avoid intra-city busses to bunch up when viewing the map on higher zoom levels.


## GTFS

With this release, MOTIS supports GTFS better:

  - The data preprocessing step now fixes bad stop positions (here: if trips exceed 350km/h over beeline distance) automatically to improve the display on the map.
  - The `block_id` attribute is now handled correctly to support chained trips that are services by the same physical vehicle. The connection search does not consider this as a transfer between two vehicles but rather one trip. This is especially important for circular routes like the Berlin "Ringbahn" lines S41 and S42.
  - To improve the matching of stations, all stations within close proximity (currently 100 meter) are considered as "meta stations" and footpaths are added accordingly. The same applies to stations which are connected through a parent relationship.


## Direct Connections by Bike and Car

Before this release, MOTIS computed direct footpaths. This release extends this functionality to support direct connections with bike and car, too. For direct connections to show up in the connection list, the sum of the times configured in the means transportation settings for start and destination needs to be greater or equal to the duration of the direct connection.

![Direct Connections in Berlin](/assets/direct.png)


## New Test Servers

To test the features described above, new test servers were introduced. The following list contains all MOTIS demo servers used for MOTIS development. These might be used to test new features during MOTIS development. Thus, they cannot be considered "stable" all the time.

  - Switzerland (HAFAS Rohdaten)
    - URL: **[switzerland.motis-project.de](https://switzerland.motis-project.de/)**
    - dataset source: [opentransportdata.swiss/en/dataset](https://opentransportdata.swiss/en/dataset)

  - DELFI (GTFS) - Germany (with some blank spots)
    - URL: **[delfi.motis-project.de](https://delfi.motis-project.de/)**
    - dataset source: [www.opendata-oepnv.de/ht/de/datensaetze](https://www.opendata-oepnv.de/ht/de/datensaetze)

  - Verkehrsverbund Berlin-Brandenburg (GTFS)
    - URL: **[vbb.motis-project.de](https://vbb.motis-project.de)**
    - dataset source: [daten.berlin.de/datensaetze/vbb-fahrplandaten-gtfs](https://daten.berlin.de/datensaetze/vbb-fahrplandaten-gtfs)

  - Aachener Verkehrsverbund (HAFAS Rohdaten)
    - URL: **[avv.motis-project.de](https://avv.motis-project.de/)**
    - dataset source: [avv.de/de/fahrplaene/opendata-service](https://avv.de/de/fahrplaene/opendata-service)