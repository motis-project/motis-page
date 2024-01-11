---
layout: api
code: ppr
---

## Pedestrian Routing Request

The pedestrian routing API computes personalized pedestrian routes from a start location to a number of destination locations using Per Pedes Routing (PPR).

  - ##### <span class="param">start</span> required, type [Position]({% link docs/api/buildingblocks.md %}#position)
    The start location.
  - ##### <span class="param">destinations</span> required, array of [Position]({% link docs/api/buildingblocks.md %}#position)
    At least one destination location.
  - ##### <span class="param">search_options</span> required
    The PPR search profile and maximum walk duration to use. See [PPR Search Profile]({% link docs/api/buildingblocks.md %}#ppr-search-profile).
  - ##### <span class="param">include_steps</span> optional, type `boolean`, default is `false`
    Whether to include a travel itinerary in the response.
  - ##### <span class="param">include_edges</span> optional, type `boolean`, default is `false`
    Whether to include a list of all used edges in the response (useful for debugging purposes).
  - ##### <span class="param">include_path</span> optional, type `boolean`, default is `false`
    Whether to include the complete path as a single polyline in the response.

## Pedestrian Routing Response

The pedestrian routing response contains routes from the start location to each of the destination locations included in the request.

  - ##### <span class="param">routes</span> array of [Routes](#routes)
    Contains a list of routes for each destination included in the request. This list always has the same size as the `destinations` list from the request, and contains routes for the destinations in the same order as they appear in the request.

## Routes

  - ##### <span class="param">routes</span> array of [Route](#route)
    All pareto-optimal routes from the start location to this destination location. This list can be empty if no route could be found within the specified duration limit.


## Route

  - ##### <span class="param">distance</span> type `float`
    The total walking distance in meters.
  - ##### <span class="param">duration</span> type `integer`
    The total duration in minutes (rounded as specified in the search profile).
  - ##### <span class="param">duration_exact</span> type `float`
    The total duration in minutes.
  - ##### <span class="param">duration_division</span> type `float`
    Duration division, if used in the search profile and more routes than allowed were found.
  - ##### <span class="param">accessibility</span> type `integer`
    The total accessibility value of the connection (rounded as specified in the search profile).
  - ##### <span class="param">accessibility_exact</span> type `float`
    The total accessibility value of the connection.
  - ##### <span class="param">accessibility_division</span> type `float`
    Accessibility division, if used in the search profile and more routes than allowed were found.
  - ##### <span class="param">start</span> type [Position]({% link docs/api/buildingblocks.md %}#position)
    The start location of this route.
  - ##### <span class="param">destination</span> type [Position]({% link docs/api/buildingblocks.md %}#position)
    The destination location of this route.
  - ##### <span class="param">elevation_up</span> type `float`
    Total upwards elevation profile in meters.
  - ##### <span class="param">elevation_down</span> type `float`
    Total downwards elevation profile in meters.
  - ##### <span class="param">steps</span> array of [RouteStep](#routestep)
    A list of steps describing the itinerary. Only present if `include_steps` was set to `true` in the request (otherwise an empty array).
  - ##### <span class="param">edges</span> array of [Edge](#edge)
    A list of edges used in the route. Only present if `include_edges` was set to `true` in the request (otherwise an empty array).
  - ##### <span class="param">path</span> type [Polyline]({% link docs/api/buildingblocks.md %}#polyline)
    A polyline describing the complete route. Only present if `include_path` was set to `true` in the request (otherwise an empty polyline).

## RouteStep

  - ##### <span class="param">step_type</span> type `string`
    Type of this step.

    - `STREET`: Walk along a street.
    - `FOOTWAY`: Walk along a footpath.
    - `CROSSING`: Cross a street or railway/tram tracks.
    - `ELEVATOR`: Use an elevator.
    - `ENTRANCE`: Use an entrance.
    - `CYCLE_BARRIER`: Pass a cycle barrier.
  - ##### <span class="param">street_name</span> type `string`
    The name of the street, if applicable (otherwise an empty string).
  - ##### <span class="param">street_type</span> type `string`
    The type of street, footway or railway. See [OpenStreetMap](https://wiki.openstreetmap.org/wiki/Key:highway) for descriptions of the various types.

    - `NONE` (default)
    - `TRACK`
    - `FOOTWAY`
    - `PATH`
    - `CYCLEWAY`
    - `BRIDLEWAY`
    - `STAIRS`
    - `ESCALATOR`
    - `MOVING_WALKWAY`
    - `PLATFORM`
    - `SERVICE`
    - `PEDESTRIAN`
    - `LIVING`
    - `RESIDENTIAL`
    - `UNCLASSIFIED`
    - `TERTIARY`
    - `SECONDARY`
    - `PRIMARY`
    - `RAIL`
    - `TRAM`
  - ##### <span class="param">crossing_type</span> type `string`
    If `step_type` is `CROSSING`, this attribute specifies the type of crossing. See [OpenStreetMap](https://wiki.openstreetmap.org/wiki/Key:crossing) for descriptions of the various crossing types.

    - `NONE` (default)
    - `GENERATED`: Automatically generated unmarked crossing (not included in OpenStreetMap data).
    - `UNMARKED`: Unmarked crossing included in OpenStreetMap data.
    - `MARKED`: Marked crossing, i.e. with road markings.
    - `ISLAND`: Crossing with a traffic island.
    - `SIGNALS`: Crossing with traffic signals.
  - ##### <span class="param">distance</span> type `float`
    Length of this segment in meters.
  - ##### <span class="param">duration</span> type `float`
    Duration of this segment in seconds.
  - ##### <span class="param">accessibility</span> type `float`
    Accessibility value of this segment.
  - ##### <span class="param">path</span> type [Polyline]({% link docs/api/buildingblocks.md %}#polyline)
    A polyline describing this segment.
  - ##### <span class="param">elevation_up</span> type `int`
    Upwards elevation profile in meters.
  - ##### <span class="param">elevation_down</span> type `int`
    Downwards elevation profile in meters.
  - ##### <span class="param">incline_up</span> type `boolean`
    The direction of stairs (up or down).
  - ##### <span class="param">handrail</span> type `string`
    Whether the stairs have handrails.
    - `UNKNOWN`
    - `NO`
    - `YES`
  - ##### <span class="param">door_type</span> type `string`
    If `step_type` is `ENTRANCE`, this attribute specifies the type of door. See [OpenStreetMap](https://wiki.openstreetmap.org/wiki/Key:door) for descriptions of the various crossing types.

    - `UNKNOWN` (default)
    - `YES`
    - `NO`
    - `HINGED`
    - `SLIDING`
    - `REVOLVING`
    - `FOLDING`
    - `TRAPDOOR`
    - `OVERHEAD`
  - ##### <span class="param">automatic_door_type</span> type `string`
    If `step_type` is `ENTRANCE`, this attribute specifies the type of automatic door. See [OpenStreetMap](https://wiki.openstreetmap.org/wiki/Key:automatic_door) for descriptions of the various crossing types.

    - `UNKNOWN` (default)
    - `YES`
    - `NO`
    - `BUTTON`
    - `MOTION`
    - `FLOOR`
    - `CONTINUOUS`
    - `SLOWDOWN_BUTTON`
  - ##### <span class="param">traffic_signals_sound</span> type `string`
    If this is a crossing with traffic signals, specifies whether there are sound signals.
    - `UNKNOWN`
    - `NO`
    - `YES`
  - ##### <span class="param">traffic_signals_vibration</span> type `string`
    If this is a crossing with traffic signals, specifies whether there are vibration signals.
    - `UNKNOWN`
    - `NO`
    - `YES`

## Edge

  - ##### <span class="param">distance</span> type `float`
    Length of this edge in meters.
  - ##### <span class="param">duration</span> type `float`
    Duration of this edge in seconds.
  - ##### <span class="param">accessibility</span> type `float`
    Accessibility value of this edge.
  - ##### <span class="param">path</span> type [Polyline]({% link docs/api/buildingblocks.md %}#polyline)
    A polyline describing this edge.
  - ##### <span class="param">name</span> type `string`
    The name of the street, if applicable (otherwise an empty string).
  - ##### <span class="param">osm_way_id</span> type `integer`
    The OpenStreetMap way id of the way this edge is based on. This value is `0` for additional edges. For crossings the value is negative, the absolue value is the id of the way that is crossed.
  - ##### <span class="param">edge_type</span> type `string`
    The type of the routing graph edge.

    - `CONNECTION`
    - `STREET`
    - `FOOTWAY`
    - `CROSSING`
    - `ELEVATOR`
    - `ENTRANCE`
    - `CYCLE_BARRIER`
  - ##### <span class="param">street_type</span> type `string`
    The type of street, footway or railway. See [RouteStep](#routestep).
  - ##### <span class="param">crossing_type</span> type `string`
    See [RouteStep](#routestep).
  - ##### <span class="param">elevation_up</span> type `int`
    Upwards elevation profile in meters.
  - ##### <span class="param">elevation_down</span> type `int`
    Downwards elevation profile in meters.
  - ##### <span class="param">incline_up</span> type `boolean`
    The direction of stairs (up or down).
  - ##### <span class="param">handrail</span> type `string`
    Whether the stairs have handrails. See [RouteStep](#routestep).
  - ##### <span class="param">door_type</span> type `string`
    If `edge_type` is `ENTRANCE`, this attribute specifies the type of door. See [RouteStep](#routestep).
  - ##### <span class="param">automatic_door_type</span> type `string`
    If `edge_type` is `ENTRANCE`, this attribute specifies the type of automatic door. See [RouteStep](#routestep).
  - ##### <span class="param">traffic_signals_sound</span> type `string`
    If this is a crossing with traffic signals, specifies whether there are sound signals. See [RouteStep](#routestep).
  - ##### <span class="param">traffic_signals_vibration</span> type `string`
    If this is a crossing with traffic signals, specifies whether there are vibration signals. See [RouteStep](#routestep).

## PPR Search Profiles

This request returns a list of available PPR search profiles.

  - ##### <span class="param">profiles</span> array of [FootRoutingProfileInfo](#footroutingprofileinfo)
    List of all available PPR search profiles.

### FootRoutingProfileInfo

Contains basic information about a PPR search profile.

  - ##### <span class="param">name</span> type `string`
    The name of this search profile as used in routing requests (see [PPR Search Profile]({% link docs/api/buildingblocks.md %}#ppr-search-profile)).
  - ##### <span class="param">walking_speed</span> type `float`
    The walking speed of this profile in m/s.
