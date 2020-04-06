---
layout: api
request: samples/IntermodalRequest.json
response: samples/IntermodalResponse.json
---

## Intermodal Routing Request

This is the intermodal routing API. Intermodal here means that start as well as destination can be either a coordinate (latitude and longitude) or a public transport station (given by its name and/or ID). This request enables the search algorithm in the backend to use all transport modes specified in the request.

  - ##### <span class="param">start_type</span> required
    Specifies the type of the `start` parameter. See [Start](#start).
  - ##### <span class="param">start</span> required
    See [Start](#start).
  - ##### <span class="param">start_modes</span> required
    The transport modes allowed at the start. See [Modes](#modes).
  - ##### <span class="param">destination</span> required
    See [Destination](#destination).
  - ##### <span class="param">destination_modes</span> required
    The transport modes allowed at the destination. See [Modes](#modes).
  - ##### <span class="param">search_type</span> optional, default is `Default`
    This parameter specifies the set of optimization criteria to use.

    - `Default`: optimize travel time and number of transfers. This computes the Pareto set using multi-criteria optimization.
    - `SingleCriterion`: optimizes a weighted sum where every transfer counts 20 minutes.
    - `SingleCriterionNoIntercity`: the same as `SingleCriterion` - excluding all long distance (intercity) trains
  - ##### <span class="param">search_dir</span> optional, default is `Forward`
    The search direction. This defines whether the algorithm searches from departure to arrival (forward in time) or from arrival to departure (backward in time). Thus, `start` is either specifying the source (`search_dir=Forward`) or the destination (`search_dir=Backward`).

    - `Forward`: the start parameter specifies the departure of the journey. The destination parameter specifies the arrival of the journey.
    - `Backward`: the start parameter specifies the arrival of the journey. The destination parameter specifies the departure of the journey.

## Start

Start defines the entry point from where to start the search. If the search direction `search_dir` is set to `Forward`, this the beginning of the journey (departure). However, if `search_dir` is set to `Backward`, this is the end of the journey (arrival) because then, the algorithm searches starting from the arrival station / location.

  - ##### <span class="param">start_type</span> required
    The type of the struct of the `start` entry.
    - [`IntermodalOntripStart`](#intermodal-ontrip-start): single departure/arrival (depending on `search_dir`) time with start coordinates.
    - [`IntermodalPretripStart`](#intermodal-pretrip-start): departure/arrival (depending on `search_dir`) time interval with start coordinates
    - [`PretripStart`](#pretrip-start): departure/arrival (depending on `search_dir`) time interval with start station
    - [`OntripStationStart`](#ontrip-station-start): single departure/arrival (depending on `search_dir`) time with station
    - [`OntripTrainStart`](#ontrip-train-start): specifies the train the user is currently in. Time and location are determined automatically.

### Intermodal Ontrip Start

For "ontrip" queries, the travel time is the time between the given `departure_time` (which is actually the arrival time when `search_dir` is set to `Forward`) and the departure/arrival at the search destination.

  - ##### <span class="param">position</span> required
    The departure coordinates for `search_dir=Forward` or arrival coordinates for `search_dir=Backward`. See [Position]({% link api/buildingblocks.md %}#Position).
  - ##### <span class="param">departure_time</span> required
    The time to start the search at. The search does only consider arrivals before (if `search_dir` is `Backward`) or departures after (if `search_dir` is `Forward`) this point in time. Times in MOTIS are given as Unix timestamp (seconds since 01.01.1970).


### Intermodal PreTrip Start

Pretrip journey planning considers all departures/arrivals in a time interval (depending on the `search_dir`). Therefore, the Pareto optimization criteria are not travel time and number of transfers but "later departure", "earlier arrival" and number of transfers. This means that the result set may contain a longer journey with more transfers if its departure is later or its arrival is earlier.

If a client application wants provides the functionality to scroll through connections (search for earlier or later connections when the user requests this) it should use the `extend_interval_earlier` and `extend_interval_later`. The basic procedure would look like this:Remember the `interval_begin` and `interval_end` attributes from the response.

  - At the first request, set `min_connection_count` to a low number grater then zero (for example 3). Set `extend_interval_earlier` as well as `extend_interval_later` to true.
  -

  - ##### <span class="param">position</span> required
    The departure coordinates for `search_dir=Forward` or arrival coordinates for `search_dir=Backward`. See [Position]({% link api/buildingblocks.md %}#Position).
  - ##### <span class="param">interval</span> required
  - ##### <span class="param">min_connection_count</span> optional, default is `0`
  - ##### <span class="param">extend_interval_earlier</span> optional, default is `false`
  - ##### <span class="param">extend_interval_later</span> optional, default is `false`


## Destination

Start defines the entry point from where to start the search. If the search direction `search_dir` is set to `Forward`, this the beginning of the journey (departure). However, if `search_dir` is set to `Backward`, the is the end of the journey (arrival) because then, the algorithm searches starting from the arrival station / location.


### IntermodalPretripStart

  - ##### <span class="param">SearchType</span> optional, default is `Default`
     The optimization criteria to consider.
       - `Default`
       - `SingleCriterion`
  - ##### <span class="param">SearchDir</span> optional, default is `Forward`
     The search direction.
       - `Forward`
       - `Backward`


### IntermodalOntripStart


## Modes