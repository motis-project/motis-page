---
layout: api
---

## InputStation

A input station is a station from user input. If the user used the auto-completion function and the station ID is available, then the `id` field is used to resolve the station. If this is not the case (the user just entered a string), the `name` field is filled with a (possibly incomplete or misspelled) station name. In the latter case, MOTIS will use the first guess from the station auto-complete to resolve the station `id`.

  - ##### <span class="param">id</span> optional if `name` is set
    The station ID if available.
  - ##### <span class="param">name</span> optional if `id` is set
    The station name if no ID is available.


## Position

A geographic coordinate.

  - ##### <span class="param">lat</span> type `double`
  Latitude (north-south position)
  - ##### <span class="param">lng</span> type `double`
  Longitude (east-west position)
