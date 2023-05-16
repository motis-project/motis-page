---
layout: post
title:  "MOTIS v0.9: New MOTIS Core"
date:   2023-05-16 16:10:00 +0200
categories: release
author: felixguendling
version: 0.9.1
---

MOTIS v0.9.0 is the first version that offers to disable the old and active the new timetable datamodel. The new datamodel is contained in the `nigiri` module where nigiri is an internal acronym which stands for "Next Generation Routing". There are several major differences and improvements between the old and the new model:

- The biggest difference is that the new model uses bitfields to encode the traffic days of trips. The new datamodel is accompanied by a modified version of the RAPTOR routing algorithm that can deal with the bitfield-based datamodel. The old datamodel uses linearly more memory for larger timetable intervals. With traffic day bitfields, larger timetable periods have zero memory overhead - only more bits will be set. The current default size of traffic day bitfields is 512bit which is more than enough to cover one year of timetable data. However, in future versions this might be configurable as a runtime parameter.
- Also all other data structures in `nigiri` are optimized for minimal space usage and highest performance. Where possible, data is stored in the forward-star-representation which is optimal regarding space usage.
- Furthermore, the `schedule.raw` intermediate format got eliminated which speeds up the loading of data significantly. Additionally, it saves a lot of memory because previously the `schedule.raw` had to be loaded into memory when building the routing graph - which more than double the memory requirements of MOTIS in many cases.


## Using the new Core

MOTIS now has a new flag to tell it to not populate the old data model: `dataset.no_schedule=true`. Like every other configuration variable, it can either be provided in form of a `config.ini`, command line parameter or environment variable. Note that currently only the routing functionality is available with the new core. Modules such as `railviz`, `lookup`, `guesser`, `path`, `parking`, `cc` or `revise` will be updated step by step to support the new `nigiri` data model.

To configure `nigiri`, you need to set the following variables. This will provide station to station routing on the timetable only:

```ini
modules=nigiri

# Configure timetables
import.paths=schedule-avv:AVV_HAFAS_520.zip
import.paths=schedule-ber:berlin.zip

# Configure schedule range
nigiri.first_day=2023-05-15
nigiri.num_days=7
```

The following setup provides door-to-door routing based on nigiri (without loading the old data model).

```ini
modules=nigiri
modules=intermodal
modules=osrm

# Configure datasets
import.paths=schedule-avv:AVV_HAFAS_520.zip
import.paths=schedule-ber:berlin.zip
import.paths=osm:input/osm.pbf

# OSRM profiles (add more if needed)
osrm.profiles=motis/profiles-osrm/foot.lua

# Configure schedule range
nigiri.first_day=2023-05-15
nigiri.num_days=7

# Provide /lookup/geo_station target
# as an alternative to the lookup module
# required by the intermodal module
nigiri.geo_lookup=true
```

Note that `nigiri` requires you to set a non-empty tag for every schedule (here `delfi`). As you can see, nigiri is capable of loading ZIP files directly so you don't have to unpack the zip archives before loading them with MOTIS.


## API Improvements

Withe the 0.9 release, MOTIS offers now a more compact API as well as a OpenAPI specification that can be used to generate client code in popular programming languages.

Here a comparison of a intermodal routing request with the old and the new API:

### Old

```json
{
  "destination": {
    "type": "Module",
    "target": "/intermodal"
  },
  "content_type": "IntermodalRoutingRequest",
  "content": {
    "start_type": "PretripStart",
    "start": {
      "station": {
        "name": "Zürich, Stampfenbachplatz",
        "id": "8591379"
      },
      "interval": {
        "begin": 1586078940,
        "end": 1586086140
      },
      "min_connection_count": 5,
      "extend_interval_earlier": true,
      "extend_interval_later": true
    },
    "start_modes": [
      {
        "mode_type": "Foot",
        "mode": {
          "search_options": {
            "profile": "default",
            "duration_limit": 900
          }
        }
      }
    ],
    "destination_type": "InputStation",
    "destination": {
      "name": "Olten",
      "id": "8500218"
    },
    "destination_modes": [
      {
        "mode_type": "Foot",
        "mode": {
          "search_options": {
            "profile": "default",
            "duration_limit": 900
          }
        }
      }
    ],
    "search_type": "Accessibility",
    "search_dir": "Forward",
    "router": "/nigiri"
  }
}
```

### New
```json
{
  "_type": "IntermodalRoutingRequest",
  "start": {
    "_type": "PretripStart",
    "station": {
      "name": "Zürich, Stampfenbachplatz",
      "id": "8591379"
    },
    "interval": {
      "begin": 1586078940,
      "end": 1586086140
    },
    "min_connection_count": 5,
    "extend_interval_earlier": true,
    "extend_interval_later": true
  },
  "start_modes": [
    {
      "_type": "Foot",
      "search_options": {
        "profile": "default",
        "duration_limit": 900
      }
    }
  ],
  "destination": {
    "_type": "InputStation",
    "name": "Olten",
    "id": "8500218"
  },
  "destination_modes": [
    {
      "_type": "Foot",
      "search_options": {
        "profile": "default",
        "duration_limit": 900
      }
    }
  ],
  "search_type": "Accessibility",
  "search_dir": "Forward",
  "router": "/nigiri"
}
```

As you can see, you can skip now the message envelope containing `destination` and `content`. In case of `union` data types, the type information (which had previously been outside the union data type) is now encoded in the `_type` field. This is necessary to make this API compatible to OpenAPI.


## Sponsor

This work is partially sponsored by [INIT](https://www.initse.com).

<p align="center" style="margin-bottom: 30px">
  <a href="https://www.initse.com">
    <img src="/assets/init_logo.svg" alt="INIT Logo" style="width: 140px" />
  </a>
</p>