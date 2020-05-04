---
layout: api
permalink: /docs/install
code: install
---

## Installation

This section describes how to setup a server similar to the [demo server](https://switzerland.motis-project.de) but without real-time updates.


### Data Download

To run your own MOTIS instance, you need an OpenStreetMap dataset and a timetable in either the GTFS or the HAFAS Rohdaten format. Note that currently, MOTIS supports only certain HAFAS Rohdaten versions (notably a version in use at Deutsche Bahn as well the one provided at [opentransportdata.swiss](https://opentransportdata.swiss)) and not all GTFS features.

  - Download the latest OpenStreetMap dataset for Switzerland in the ".osm.pbf" format from [geofabrik.de](https://download.geofabrik.de/europe/switzerland.html) and put it into your `motis/data` folder.
  - Download the latest dataset HAFAS Rohdaten (version 5.20.39 - "Timetable 202x (HRDF)" not version 5.40) dataset from [opentransportdata.swiss](https://opentransportdata.swiss/en/dataset) and extract it into your `motis/data/hrd` folder. Delete the empty file `GRENZHALT`.


### Linux Installation Guide

Tested on Ubuntu 18.04.


  - **Step 1**: Install a new C++ standard library required by MOTIS.
{% highlight bash %}
apt install -y --no-install-recommends apt-utils software-properties-common
add-apt-repository -y ppa:ubuntu-toolchain-r/test
apt update
apt upgrade -y
{% endhighlight %}
  - **Step 2**: Download the MOTIS distribution from [here](https://github.com/motis-project/motis/releases/latest/download/motis-linux.tar.bz2) and extract it to the `motis` folder. The directory structure must look exactly like the one shown on the right.
  - **Step 3**: Copy the Linux preprocess script on the right to a file and execute the file `preprocess.sh`. If asked "approximate areas? (y/n) :" type `y` and press Enter. Warning: do not execute this script multiple times. The encoding conversion will destroy the file contents when run twice.
  - **Start MOTIS**: `./motis` and visit [https://localhost:8080](https://localhost:8080).


### Windows Installation Guide

Tested on Windows 10.

  - **Step 1**: Download the MOTIS distribution from [here](https://github.com/motis-project/motis/releases/latest/download/motis-windows.zip) and extract it to the `motis` folder. The directory structure must look exactly like the one shown on the right.
  - **Step 2**: Download the `iconv.exe` executable (static version, 64bit) from [here](https://mlocati.github.io/articles/gettext-iconv-windows.html) (it is located in the `bin` directory of the archive) and place it in the `motis` folder next to the MOTIS binaries.
  - **Step 3**: Copy the Windows preprocess script on the right to a file and execute the file `preprocess.bat`. If asked "approximate areas? (y/n) :" type `y` and press Enter. Warning: do not execute this script multiple times. The encoding conversion will destroy the file contents when run twice.
  - **Start MOTIS**: `motis.exe` and visit [https://localhost:8080](https://localhost:8080).
