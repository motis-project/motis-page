---
layout: post
title:  "MOTIS v0.4: Multi Schedule & Docker + Raspberry Pi Support"
date:   2021-08-10 21:33:00 +0100
categories: release
author: felixguendling
version: 0.4
---

MOTIS version v0.4 supports loading multiple timetables thanks to [@sfahnens](https://github.com/sfahnens). We demo this new feature on our Europe instance on [europe.motis-project.de](https://europe.motis-project.de) where the German [DELFI GTFS timetable](https://www.opendata-oepnv.de/ht/de/organisation/delfi/startseite), the Swiss [HRD dataset](https://opentransportdata.swiss/en/dataset), and the [Flixbus GTFS dataset](https://transitfeeds.com/p/flixbus-united-states/1246). Loading more timetables is possible. We are working on covering whole Europe.

Additionally, we support two three platforms, namely Linux ARM systems (32bit armv7 as well as 64bit aarch64), 32bit x86 Linux systems, and Docker. Using the combination (Docker on ARM), it's now possible to deploy MOTIS to a Raspberry Pi on the default Rasbian distribution. Note that the resources (memory as well as compute power) on such a device are limited, so it won't be possible to deploy large datasets like the combined Europe timetable mentioned above. It should be possible to use the 32bit x86 MOTIS binary to preprocess data on a beefier desktop or server machine and transfer the preprocessed data to the Pi.


## Documentation

You are looking for Documentation on MOTIS? The API is documented here [motis-project.de/docs/api](https://motis-project.de/docs/api/). For operating your own MOTIS instance as well as for people interested in extending MOTIS, we started to document all the bits and pieces in the [GitHub Wiki](https://github.com/motis-project/motis/wiki). Feel free to help us with this or [open a ticket](https://github.com/motis-project/motis/issues) if you have issues or questions.


## Multi-Timetable Configuration

In order to support loading multiple timetables, the configuration format has been adjusted. In particular, the import paths now are prefixed by a tag indicating which type of input is following. For example, `--import.paths schedule-sbb:/data/sbb-gtfs schedule-delfi:/data/delfi-gtfs --osm:/data/dach.osm.pbf` tells MOTIS to load the `sbb` timetable located at `/data/sbb-gtfs`, the `delfi` timetable at `/data/delfi-gtfs`, and an OpenStreetMap dataset at `/data/dach.osm.pbf`. If you have only one timetable, you don't need to name it and can just use `--import.paths schedule:/data/hrd`. Loading of multiple OpenStreetMap datasets is currently not supported.

Supported prefix tags are:

  - `schedule` and `schedule-$name`: timetable data in GTFS or HAFAS Rohdatan format. Multiple timetables are merged.
  - `osm`: OpenStreetMap data in the `.osm.pbf` Protocoll Buffers format
  - `dem`: elevation data for use in the [PPR pedestrian routing](https://github.com/motis-project/ppr) in the `.hdr` or `.bil` format. You need to set the `--ppr.import.use_dem true` option for the PPR module to recognize the input.
  - `coastline`: OpenStreetMap coastline data for use in the `tiles` module. You need to set the `--tiles.import.use_coastline true` option for the tiles module to recognize the input.


## Docker

The MOTIS Project now leverages GitHub's container registry to provide up-to-date Docker images. The CI pipeline automatically produces a ready-to-use MOTIS docker image for every release and for every commit on the main branch. The docker image is configured accept data on the `/data` mount forwards MOTIS's default network port `8080`.

<p align="center" style="margin-bottom: 30px">
  <img src="/assets/docker.png" style="width: 200px; margin-right: 50px" />
  <img src="/assets/pi.svg" style="width: 140px" /> 
</p>

One simple way to test the Docker image is to use `docker compose`. For this, follow the [instructions to install Docker](https://docs.docker.com/get-docker/), install the [`compose` extension](https://github.com/docker/compose-cli), create a `docker-compose.yml` with the following contents:

```yml
version: "3.9"
services:
  motis:
    image: ghcr.io/motis-project/motis:v0.4
    ports:
      - "80:8080"
    volumes:
      - "/home/pi/data:/data"
    restart: always
```

You need a `data` folder which provides a `config.ini` as well as the timetable and OpenStreetMap dataset. The data folder will be mounted inside the Docker container as `/data`. Finally, you can start MOTIS using `sudo docker compose up -d`. For more details on how to configure MOTIS, see in the [GitHub Wiki](https://github.com/motis-project/motis/wiki/Configuration).