---
layout: post
title:  "MOTIS v0.2: Simple Import"
date:   2020-05-17 18:45:00 +0100
categories: release
author: felixguendling
version: 0.2
---

This new release of MOTIS comes with a simplified import: all steps that were carried out by separate executable binaries before, can now be realised with the main `motis` binary. This makes it much easier to start a MOTIS server. It is now impossible to forget a preprocessing step and the MOTIS configuration is much simpler now, because every input file path can be derived from the initial (simple) import configuration.


## Data Directory

The data directory contains all original (raw) import data (e.g. OpenStreetMap and timetable data) as well as the processed databases (e.g. pedestrian, bicycle, or car routing graphs). The idea is that this directory should be portable, i.e. it can be moved from one server (or path) to another and be used without further changes.

Content:

  - **Input Files**: timetable data (mandatory), OpenStreetMap data (optional), SRTM topographic data, etc. These files should be placed there by the user.
  - **Logs**: the `log` folder contains one file for each preprocessing task. MOTIS only appends to theses files to enable the user to trace errors.
  - **Preprocessed Data**: for each preprocessing task, the data directory contains a folder containing the preprocessed database file (after the task completed).
  - **`import.ini`**: Each step leaves a `import.ini` file in the respective folder (in the data directory) containing information about the input dataset. This is used to check whether the preprocessing is already done, needs to be repeated (input data update), or whether this is the first time (no `import.ini` present). For example, the `import.ini` contains the [hashed](https://en.wikipedia.org/wiki/Hash_function) first 50 megabytes and the size of the OSM file or the hash of the "eckdaten" file of HAFAS Rohdaten dataset.
  - Additionally, the data directory can contain temporary files or caches.


## Commandline

The release introduces two new commandline flags:

  - `--import.data_dir`: specifies the [Data Directory](#data-directory).
  - `--import.paths`: a list of files and folders which should be used as input. MOTIS automatically detects whether this is a GTFS, HAFAS Rohdaten, OSM, etc. file and forwards these files to the corresponding import tasks. If the given path is contained in the `import.data_dir`, MOTIS stores a relative path in the `import.ini` file making the `data` directory portable if it is self-contained.


## UTF-8 Support for HAFAS Rohdaten

The HAFAS Rohdaten for Switzerland are in UTF-8 encoding. Since MOTIS currently only supports the ISO 8859-1 encoding, the data needed to be transformed using `iconv`. This step has now been automated in MOTIS and not required anymore. MOTIS expects the Switzerland dataset to be UTF-8 encoded. Thus, any conversion outside of MOTIS will lead to errors from now on!


## Support for Data of the Aachener Verkehrsverbund (AVV)

The Aachener Verkehrsverbund (AVV) provides open data HAFAS Rohdaten at [opendata.avv.de/current_HAFAS](http://opendata.avv.de/current_HAFAS/). With the new v0.2 release, MOTIS is now capable of parsing this dataset including "Durchbindungen" and "Vereinigungen". Unfortunately, the file `zeitvs` containing timezone and daylight saving time information cannot be handled by MOTIS at the moment. Replacing this file with the following lines, sovles this issue for now:

    0000000 +0100 +0200 29032020 0200 25102020 0300 +0200 28032021 0200 31102021 0300
    8000000 +0100 +0200 29032020 0200 25102020 0300 +0200 28032021 0200 31102021 0300