---
layout: api
---

## Installation

This section describes how to setup a server similar to the [demo server](https://demo.motis-project.de/public/).


### Data Download

To run your own MOTIS instance, you need an OpenStreetMap dataset and a timetable in either the GTFS or the HAFAS Rohdaten format. Note that currently, MOTIS supports only certain HAFAS Rohdaten versions (notably a version in use at Deutsche Bahn as well the one provided at [opentransportdata.swiss](https://opentransportdata.swiss)) and not all GTFS features.

  - Download the latest OpenStreetMap dataset for Swizerland in the ".osm.pbf" format from [geofabrik.de](https://download.geofabrik.de/europe/switzerland.html) and put it into your `data` folder.
  - Download the latest dataset HAFAS Rohdaten dataset from [opentransportdata.swiss](https://opentransportdata.swiss/en/dataset) and extract it into your `data/hrd` folder.

<!--
  - This step is only required for real-time support: Download the latest GTFS dataset from  [opentransportdata.swiss](https://opentransportdata.swiss/en/dataset) and extract it into your `data/gtfs` folder.
-->


### Linux Installation Guide

Tested on Ubuntu 18.04.

  - **Step 1**: Download and unzip the latest release: [motis](https://github.com/motis-project/motis/releases/latest/download/motis-linux.zip)
  - **Step 2**: Start MOTIS with `./motis --dataset.path data/hrd`


### Windows Installation Guide

Start a PowerShell or cmd.exe prompt:

  - **Step 1**: Download and unzip the latest release: [motis](https://github.com/motis-project/motis/releases/latest/download/motis-windows.zip)
  - **Step 2**: Start MOTIS with `motis.exe --dataset.path data/hrd`