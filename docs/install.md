---
layout: api
permalink: /docs/install
shellexample: samples/preprocess.sh
---

## Installation

This section describes how to setup a server similar to the [demo server](https://demo.motis-project.de/public/).


### Data Download

To run your own MOTIS instance, you need an OpenStreetMap dataset and a timetable in either the GTFS or the HAFAS Rohdaten format. Note that currently, MOTIS supports only certain HAFAS Rohdaten versions (notably a version in use at Deutsche Bahn as well the one provided at [opentransportdata.swiss](https://opentransportdata.swiss)) and not all GTFS features.

  - Download the latest OpenStreetMap dataset for Swizerland in the ".osm.pbf" format from [geofabrik.de](https://download.geofabrik.de/europe/switzerland.html) and put it into your `motis/data` folder. Delete the file `GRENZHALT`.
  - Download the latest dataset HAFAS Rohdaten (version 5.20.39 - "Timetable 202x (HRDF)" not version 5.40) dataset from [opentransportdata.swiss](https://opentransportdata.swiss/en/dataset) and extract it into your `motis/data/hrd` folder.

<!--
  - This step is only required for real-time support: Download the latest GTFS dataset from  [opentransportdata.swiss](https://opentransportdata.swiss/en/dataset) and extract it into your `data/gtfs` folder.
-->


### Linux Installation Guide

Tested on Ubuntu 18.04.

  - **Step 1**: Download the motis binaries from [here](https://github.com/motis-project/motis/releases/latest/download/motis-linux.zip) and place them in the `motis` folder.
  - **Step 2**: Start MOTIS with `./motis --dataset.path data/hrd`


### Windows Installation Guide

  - **Step 1**:  Download the motis binaries from [here](https://github.com/motis-project/motis/releases/latest/download/motis-windows.zip) and place them in the `motis` folder.
  - **Step 2**: Download the `iconv.exe` binary (static version, 64bit) from [here](https://mlocati.github.io/articles/gettext-iconv-windows.html) (it is located in the `bin` directory of the archive) and place it in the `motis` folder next to the MOTIS binaries.
  - **Step 3**: Create a file `convert.bat` in the `motis/data` folder and copy the following script into this file:
{% highlight batch %}
@ECHO OFF
setlocal enabledelayedexpansion
for %%f in (hrd\*) do (
  echo converting %%~nf"
  ..\iconv.exe -f utf-8 -t iso-8859-1 "%%f" > "%%f.txt"
  move "%%f.txt" "%%f"
)
{% endhighlight %}
  - **Step 4**: Start a `cmd.exe` command prompt and type `cd C:\path\to\motis\data` (hit Enter).
  - **Step 5**: Type `convert.bat` (hit Enter). This will convert all files from UTF-8 to ISO-8859-1 file encoding that is required by MOTIS.
  - **Step 6**: Go the main folder (`cd C:\path\to\motis`) and run MOTIS in test mode to generate the `schedule.raw`. When this step succeeds, you can already use MOTIS as a timetable information system. The following steps are required for intermodal routing features.
{% highlight bash %}
motis.exe --dataset.path data\hrd --mode test
{% endhighlight %}
  - **Step 7**: Run the Per Pedes Routing preprocessing step:
{% highlight bash %}
ppr-preprocess.exe -o data\switzerland-latest.osm.pbf -g data\routing-graph.ppr
{% endhighlight %}
  - **Step 8**: Build the index for address and places autocompletion:
{% highlight bash %}
at-example.exe extract data\switzerland-latest.osm.pbf data\at.db
{% endhighlight %}
  - **Step 9**: Extract and contract the car and bikcycle routing graph:
{% highlight bash %}
mkdir data\car
move data\switzerland-latest.osm.pbf data\car

osrm-extract.exe data\car\switzerland-latest.osm.pbf -p profiles\car.lua
osrm-contract.exe data\car\switzerland-latest.osrm

mkdir data\bike
move data\car\switzerland-latest.osm.pbf data\bike\switzerland-latest.osm.pbf

osrm-extract.exe data\bike\switzerland-latest.osm.pbf -p profiles\bicycle.lua
osrm-contract.exe data\bike\switzerland-latest.osrm

move data\bike\switzerland-latest.osm.pbf data\switzerland-latest.osm.pbf
{% endhighlight %}
  - **Step 10**: Create the path database for detailed routes on the map.
{% highlight bash %}
path-prepare.exe
  --schedule data\hrd
  --osm data\switzerland-latest.osm.pbf
  --osrm data\car\switzerland-latest.osrm
{% endhighlight %}

  - **Step 11**: Create the parking database:
{% highlight bash %}
parking-prepare.exe
  --osm data\switzerland-latest.osm.pbf
  --schedule data\hrd
  --db data\parking_footedges.db
  --parking data\parking.txt
  --ppr_graph data\routing-graph.ppr
{% endhighlight %}

  - **Step 12**: Create the configuration file `motis/config.ini`:
{% highlight ini %}
server.static_path=web
dataset.path=data/hrd
ppr.graph=data/routing-graph.ppr
osrm.dataset=data/car/switzerland-latest.osrm
osrm.dataset=data/bike/switzerland-latest.osrm
address.db=data/at.db
parking.parking=data/parking.txt
parking.db=data/parking_footedges.db
exclude_modules=path
exclude_modules=tripbased
exclude_modules=csa
exclude_modules=bikesharing
{% endhighlight %}

  - **Start MOTIS**: `motis.exe -c config.ini` and visit [https://localhost:8080](https://localhost:8080).