---
layout: api
permalink: /docs/install
code: install
---

## Installation

This section describes how to setup a server similar to the [demo server](https://switzerland.motis-project.de) but without real-time updates.


### Data Download

To run your own MOTIS instance, you need an OpenStreetMap dataset and a timetable in either the GTFS or the HAFAS Rohdaten format. Note that currently, MOTIS supports only certain HAFAS Rohdaten versions (notably a version in use at Deutsche Bahn, the [AVV version](http://opendata.avv.de/) as well the one provided at [opentransportdata.swiss](https://opentransportdata.swiss)) and not all GTFS features.

  - Download the latest OpenStreetMap dataset for Switzerland in the ".osm.pbf" format from [geofabrik.de](https://download.geofabrik.de/europe/switzerland.html) and put it into your `data` folder.
  - Download the latest dataset HAFAS Rohdaten (version 5.20.39 - "Timetable 202x (HRDF)" not version 5.40) dataset from [opentransportdata.swiss](https://opentransportdata.swiss/en/dataset) and extract it into your `data/hrd` folder.


### Linux Installation Guide

Tested on Ubuntu 18.04.

  - **Step 1**: Install a new C++ standard library required by MOTIS.
{% highlight bash %}
apt install -y --no-install-recommends apt-utils software-properties-common
add-apt-repository -y ppa:ubuntu-toolchain-r/test
apt update
apt upgrade -y
{% endhighlight %}
  - **Step 2**: Download the MOTIS distribution from [here](https://github.com/motis-project/motis/releases/latest/download/motis-linux.tar.bz2) and extract it. The directory structure must look exactly like the one shown on the right.
  - **Start MOTIS**: `./motis/motis` and visit [https://localhost:8080](https://localhost:8080).


### Windows Installation Guide

Tested on Windows 10.

  - **Step 1**: Download the MOTIS distribution from [here](https://github.com/motis-project/motis/releases/latest/download/motis-windows.zip) and extract it. The directory structure must look exactly like the one shown on the right.
  - **Start MOTIS**: `motis\motis.exe` and visit [https://localhost:8080](https://localhost:8080).
