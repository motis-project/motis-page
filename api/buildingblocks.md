---
layout: api
---

## Input Station

A input station is a station from user input. If the user used the auto-completion function and the station ID is available, then the `id` field is used to resolve the station. If this is not the case (the user just entered a string), the `name` field is filled with a (possibly incomplete or misspelled) station name. In the latter case, MOTIS will use the first guess from the station auto-complete to resolve the station `id`.

  - ##### <span class="param">id</span> can be empty if `name` is set
    The station ID if available.
  - ##### <span class="param">name</span> can be empty if `id` is set
    The station name if no ID is available.


## Position

A geographic coordinate.

  - ##### <span class="param">lat</span> type `float`
    Latitude (north-south position)
  - ##### <span class="param">lng</span> type `float`
    Longitude (east-west position)


## Interval

A time interval.

  - ##### <span class="param">begin</span> type `integer`
    The first time in the interval. See [Times]({% link api/index.md %}#times).
  - ##### <span class="param">begin</span> type `integer`
    The first time not in the interval. See [Times]({% link api/index.md %}#times).


## Trip ID

This combination of information is used as key to unambiguously identify a unique service trip (bus, train, etc.). The trip ID can be split into two parts: the primary trip ID (first three parameters) and the secondary trip ID (last three parameters). In most cases, the primary trip ID should be sufficient to uniquely identify a trip.

   - ##### <span class="param">station_id</span> type `string`
     The station ID of the first departure.
   - ##### <span class="param">train_nr</span> type `integer`
     The unique train number at the first departure.
   - ##### <span class="param">time</span> type `integer`
     The first departure time. See [Times]({% link api/index.md %}#times).
   - ##### <span class="param">target_station_id</span> type `string`
     The final destination of the trip.
   - ##### <span class="param">target_time</span> type `integer`
     The arrival time at the destination.
   - ##### <span class="param">line_id</span> type `string`
     The line name.

## PPR Search Profile

The profile to use for the Per Pedes Routing search.

  - ##### <span class="param">profile</span> required, type `string`
    The search profile to use.
  - ##### <span class="param">duration_limit</span> required, type `integer`
    The maximal time duration in seconds.
