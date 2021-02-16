---
layout: api
code: intermodal
---

## Intermodal Routing Request

This is the intermodal routing API. Intermodal here means that start as well as destination can be either a coordinate (latitude and longitude) or a public transport station (given by its name and/or ID). This request enables the search algorithm in the backend to use all transport modes specified in the request.

  - ##### <span class="param">start_type</span> required
    Specifies the type of the `start` parameter. See [Start](#start).
  - ##### <span class="param">start</span> required
    See [Start](#start).
  - ##### <span class="param">start_modes</span> required
    The transport modes allowed at the start. See [Modes](#modes).
  - ##### <span class="param">destination_type</span> required
    Specifies the type of the `destination` parameter. See [Destination](#destination).
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
    The departure coordinates for `search_dir=Forward` or arrival coordinates for `search_dir=Backward`. See [Position]({% link docs/api/buildingblocks.md %}#position).
  - ##### <span class="param">departure_time</span> required
    The time to start the search at. The search does only consider arrivals before (if `search_dir` is `Backward`) or departures after (if `search_dir` is `Forward`) this point in time. See [Times]({% link docs/api/index.md %}#times).


### OnTrip Station Start

This query is useful if the traveller is currently at a station (or planning to be at a station) and wants to compute optimal journeys to their destination (station or location). For "ontrip" queries, the travel time is the time between the given `departure_time` (which is actually the arrival time when `search_dir` is set to `Forward`) and the departure/arrival at the search destination.

  - ##### <span class="param">station</span> required
    The departure station for `search_dir=Forward` or arrival station for `search_dir=Backward`. See [InputStation]({% link docs/api/buildingblocks.md %}#input-station).
  - ##### <span class="param">departure_time</span> required
    The time to start the search at. The search does only consider arrivals before (if `search_dir` is `Backward`) or departures after (if `search_dir` is `Forward`) this point in time. See [Times]({% link docs/api/index.md %}#times).


### OnTrip Train Start

This start type is useful if the user is currently in a train. The search algorithm first locates the train and considers all feasible options: at each next stop, the user can either stay in the train or alight. After alighting, the user can either be at their destination, change to another train or walk to another station. Note that the [OnTrip Station Start](#ontrip-station-start) has not the same effect as it will not count the transfer time to other trains.

  - ##### <span class="param">trip</span> required
    The trip to search from. See [Trip ID]({% link docs/api/buildingblocks.md %}#trip-id).
  - ##### <span class="param">station</span> required
    Station to start searching from (one of the stops of the trip). Should be the first station, the user can alight. See [Input Station]({% link docs/api/buildingblocks.md %}#input-station).
  - ##### <span class="param">arrival_time</span> required
    The arrival time to assume at the station. See [Times]({% link docs/api/index.md %}#times).


### Intermodal PreTrip Start

Pretrip journey planning considers all departures/arrivals in a time interval (depending on the `search_dir`). Therefore, the Pareto optimization criteria are not travel time and number of transfers but "later departure", "earlier arrival" and number of transfers. This means that the result set may contain a longer journey with more transfers if its departure is later or its arrival is earlier.

Note that this API does not return journeys that are superseded by journeys arriving (`search_dir=Forward`) or departing (`search_dir=Backward`) outside of the interval. This way, the union of journey Pareto-sets with disjunct search intervals are still Pareto-sets where every connection stays optimal. This property is important to deliver coherent results for the "search earlier" and "search later" functionality in a user interface.

If a client application provides the functionality to scroll through connections (search for earlier or later connections) it is recommended to use the `extend_interval_earlier` and `extend_interval_later` parameters: since the search backend of MOTIS is stateless, it is the task of the client to keep track bounds of the interval that has been considered. Therefore, it is important to store the `interval_begin` and `interval_end` attributes from the routing response. For the first request, set `extend_interval_earlier` as well as `extend_interval_later` to true. For subsequent requests set `extend_interval_earlier` if searching for earlier connections and `extend_interval_later` for later connections.

  - ##### <span class="param">position</span> required
    The departure coordinates for `search_dir=Forward` or arrival coordinates for `search_dir=Backward`. See [Position]({% link docs/api/buildingblocks.md %}#Position).
  - ##### <span class="param">interval</span> required
    The (initial) time interval to consider to depart / arrive. This time interval may be extended by the search algorithm if the `min_connection_count` cannot be reached with non-Pareto-dominated connections departing/arriving within the interval. See [Interval]({% link docs/api/buildingblocks.md %}#interval).
  - ##### <span class="param">min_connection_count</span> optional `integer`, default is `0`
    This requires interval extension to be enabled. Thus, `extend_interval_earlier || extend_interval_later` needs to be `true`. Otherwise, `min_connection_count` does not have an effect. The search extends the interval in the specified direction until there are `min_connection_count` Pateto-optimal connections in the result set. *Note*: if there are less than `min_connection_count` journeys in the result set, this means that the interval bounds have been reached. If the interval has been extended, the response contains the new bounds.
  - ##### <span class="param">extend_interval_earlier</span> optional `boolean`, default is `false`
    Extend the interval to search for earlier connections until `min_connection_count` is reached.
  - ##### <span class="param">extend_interval_later</span> optional `boolean`, default is `false`
    Extend the interval to search for later connections until `min_connection_count` is reached.


### PreTrip Start

This start type is similar to the [Intermodal PreTrip Start](#intermodal-pretrip-start). The only difference is that the `position` is a `station` here. So for this start type, the search is restricted to start from this station.

The search will only consider footpaths from the timetable data (HAFAS Rohdaten or GTFS). In contrast to the [Intermodal PreTrip Start](#intermodal-pretrip-start), equivalent stations (see HAFAS Rohdaten documentation "Meta Station") are considered as start stations, too.

  - ##### <span class="param">station</span> required
    The station to start from. See [Input Station]({% link docs/api/buildingblocks.md %}#input-station)
  - ##### <span class="param">interval</span> required
    See corresponding parameter in [Intermodal PreTrip Start](#intermodal-pretrip-start).
  - ##### <span class="param">min_connection_count</span> optional `integer`, default is `0`
    See corresponding parameter in [Intermodal PreTrip Start](#intermodal-pretrip-start).
  - ##### <span class="param">extend_interval_earlier</span> optional `boolean`, default is `false`
    See corresponding parameter in [Intermodal PreTrip Start](#intermodal-pretrip-start).
  - ##### <span class="param">extend_interval_later</span> optional `boolean`, default is `false`
    See corresponding parameter in [Intermodal PreTrip Start](#intermodal-pretrip-start).


## Destination

If the search direction `search_dir` is set to `Forward`, this the end of the journey (arrival). However, if `search_dir` is set to `Backward`, the is the begin of the journey (departure) because then, the algorithm searches starting from the arrival station / location.

  - ##### <span class="param">destination_type</span> required
    The type of the struct of the `destination` entry.
    - `InputStation`: `destination` is an [Input Station]({% link docs/api/buildingblocks.md %}#input-station)
    - `InputPosition`: `destination` is an [Position]({% link docs/api/buildingblocks.md %}#position)


## Modes

The `start_modes` and `destination_modes` lists determine which transport modes are used in conjunction with Intermodal [OnTrip Start](#intermodal-ontrip-start), [Intermodal PreTrip Start](#intermodal-pretrip-start) and [`InputPosition` destination type](#destination). If a station is specified as start / destination, the modes have no effect and should be left empty.

Both, `start_modes` and `destination_modes` are arrays that contain the following data structures:

  - ##### <span class="param">mode_type</span> required
    - [`Foot`](#foot): walking within a specified duration
    - [`Bike`](#bike): riding a bicyle within a specified duration
    - [`Car`](#car): driving a case within a specified duration
    - [`FootPPR`](#foot-ppr): walking within a specified duration (with profile parameter)
    - [`CarParking`](#car-parking): like car but uses a parking place near the station
  - ##### <span class="param">mode</span> required
    See blow.


### Foot

  - ##### <span class="param">duration</span> required
    Maximal duration to walk in minutes.

### Bike

  - ##### <span class="param">duration</span> required
    Maximal duration to ride in minutes.

### Car

  - ##### <span class="param">duration</span> required
    Maximal duration to drive in minutes.

### Foot PPR

  - ##### <span class="param">profile</span> required
    See [PPR Search Profile]({% link docs/api/buildingblocks.md %}#ppr-search-profile).

### Car Parking

  - ##### <span class="param">max_car_duration</span> required, type `integer`
    Maximal duration to drive in minutes.
  - ##### <span class="param">ppr_search_options</span> required
    Used for the section from the parking place to the station. See [PPR Search Profile]({% link docs/api/buildingblocks.md %}#ppr-search-profile).

## Routing Response

The routing response contains all Pareto-optimal connections.

  - ##### <span class="param">connections</span> array of [Connections]({% link docs/api/connection.md %})
    Array of all optimal connections.
  - ##### <span class="param">interval_begin</span> type `integer`
    The interval that was searched. This might differ from the initial interval given in the request if `min_connection_count` was set to a value greater than zero.
  - ##### <span class="param">interval_end</span> type `integer`
    The end of the interval that was searched.
