---
layout: api
example: samples/Connection.json
---

## Connection

A connection is a journey from a coordinate/station to another coordinate/station. The core of the journey is the stop sequence. Other information (such as `transports` and `trips`) reference stops by their index in the stop sequence.

  - ##### <span class="param">stops</span> array of [Stops](#stop)
    The stop sequence including (real-time) event times and information about alighting and entering of services. This is the core of the journey. All other collections in the `Connection` reference stop indices.
  - ##### <span class="param">transports</span> array of [Transports](#transport)
    Information about the transports that are used with their corresponding stop range.
  - ##### <span class="param">trips</span> array of [Trips](#trip)
    Trip IDs for each trip that is used in the journey with their corresponding stop range.
  - ##### <span class="param">attributes</span> array of [Attributes](#attribute)
    Attributes that are active within the corresponding stop range.
  - ##### <span class="param">free_texts</span> array of [Free Texts](#free-text)
    Free text messages can be used by the operator to inform and guide users.
  - ##### <span class="param">problems</span> array of [Problems](#problem)
    Problems with the journey. This is empty for fresh journeys but can be populated when real-time information such as cancellations, etc. are processed.

### Stop

The stops are the basic building block of the journey data structure. Everything else references stops by their index.

Note that there are four cases for `exit` and `enter`: when entering the first train, only `enter` is set. When exiting the last train, only `exit` is set. There may be walk segments before the first `enter` and after the last `exit`. For a direct interchange between two trains, `enter` *and* `exit` are set. For a walk between two stops, `exit` is set at the first stop and `enter` is set at the second stop. There may be more than one walk segments in between. For every stop where the train just stops, neither `enter` nor `exit` is set.

  - ##### <span class="param">station</span> see [Station]({% link api/buildingblocks.md %}#Station)
  - ##### <span class="param">arrival</span> see [Event Info](#event-info)
  - ##### <span class="param">departure</span> see [Event Info](#event-info)
  - ##### <span class="param">exit</span> type `boolean`
    Indicates whether the passenger alights from the vehicle at this stop.
  - ##### <span class="param">enter</span> type `boolean`
    Indicates whether the passenger enters the vehicle at this stop.


#### Event Info

  - ##### <span class="param">time</span> type `integer`
    Real-time timestamp. See [Times]({% link api/buildingblocks.md %}#times).
  - ##### <span class="param">schedule_time</span> type `integer`
    Schedule timestamp. See [Times]({% link api/buildingblocks.md %}#times).
  - ##### <span class="param">track</span> type `string`
    The real-time track name.
  - ##### <span class="param">schedule_track</span> type `string`
    The schedule track name.
  - ##### <span class="param">valid</span> type `bool`
    If this flag is missing, the event is invalid. This is the case for the arrival event at the first stop and the departure event at the last stop.
  - ##### <span class="param">reason</span>
    The information source for the real-time timestamp. The system is conservative in the sense that it selects the maximum timestamp from propagation, forecast or schedule time if there is no `IS` or `REPAIR` timestamp given.
    - `SCHEDULE`: the real-time timestamp is the schedule time. No real-time information.
    - `REPAIR`: there are conflicting real-time information and this timestamp needed to be repaired such that basic properties of the timetable hold (i.e. timestamps need to correspond to the event order).
    - `IS`: the system received a real-time message that the event took place with this timestamp.
    - `PROPAGATION`: the timestamp was computed by propagating times (e.g. from earlier stops of the stop sequence of a trip)
    - `FORECAST`: the system received a message that forecasted the event time.


### Transport

Note that this information is compressed: it can be the case that the transport spans multiple physical trips (with a interchange between - indicated by `enter` and `exit`) if the specified information (train number, etc.) does not change. But it can also be the case that there are multiple `Transport` items for one physical trip if the train number, category, provider, line ID or direction information change during the ride. Thus, generally there is a new `Transport` item when the referenced information changes.

  - ##### <span class="param">range</span> see [Range](#range)
  - ##### <span class="param">category_name</span> type `string`
    The human readable category name.
  - ##### <span class="param">category_id</span> type `integer`
    The internal category ID.
  - ##### <span class="param">clasz</span> type `integer`
    The train class from 0 to 9. Since `class` is a reserved keyword in many programming languages, this entry is named `clasz`. This is an artificial classification:
      - `0`: long distance high speed trains (e.g. TGV)
      - `1`: long distance inter city trains
      - `2`: long distance night trains
      - `3`: regional express trains
      - `4`: regional trains
      - `5`: metro trains
      - `6`: subway trains
      - `7`: trams
      - `8`: buses
      - `9`: other (flights, ferries, taxis, etc.)
  - ##### <span class="param">train_nr</span> type `integer`
    The unique train if available.
  - ##### <span class="param">line_id</span> type `string`
    The line name/number.
  - ##### <span class="param">name</span> type `string`
    Complete official name. E.g. "TGV 123"
  - ##### <span class="param">provider</span> type `string`
    The name of the train operator company.
  - ##### <span class="param">direction</span> type `string`
    The direction of the train. This might be a station name but could also be a city name or something else.


### Trip

In contrast to the [Transports](#transport), there is one trip for each physical trip used in the journey. There might be multiple trips for one segment if there are multiple trains linked together.

  - ##### <span class="param">range</span> see [Range](#range)
    The stop range where this trip is used.
  - ##### <span class="param">id</span> see [Trip ID]({% link api/buildingblocks.md %}#trip-id)
    The trip ID. This can be used to uniquely identify the trip in other API requests.
  - ##### <span class="param">debug</span> type `string`
    A string of the form `filename:123:456` specifying the filename and the line range (from 123 to 456) where the services is located in the input timetable. This is useful for debugging purposes.

### Attribute

Attributes are used to convey further information about the service (e.g. WiFi availability, accessibility information, etc.). As for the [Transports](#transport), attribute ranges may span multiple physical trips if the attribute applies to both trips.

  - ##### <span class="param">range</span> see [Range](#range)
    The stop range where this attribute applies.
  - ##### <span class="param">code</span> type `string`
    A unique ID for the attribute.
  - ##### <span class="param">text</span> type `string`
    The display text for this attribute.


### Free Text

Free texts are used to inform the user about real-time updates of any kind.

  - ##### <span class="param">range</span> see [Range](#range)
    The stop range where this free text information applies.
  - ##### <span class="param">code</span> type `integer`
    A unique ID for the free text.
  - ##### <span class="param">text</span> type `string`
    The display text for this attribute.
  - ##### <span class="param">type</span> type `string`
    Type of the information.

### Problem

When checking journeys with the `revise` module, it may find that the journey is not feasible anymore. This will be expressed by the problem annotations.


  - ##### <span class="param">range</span> see [Range](#range)
    The stop where the problem appears.
  - ##### <span class="param">type</span> type `enum`
    The reason why the journey is not feasible anymore:
      - `INTERCHANGE_TIME_VIOLATED`: the interchange time between arrival and departure is not sufficient
      - `CANCELED_TRAIN`: a train in the journey was cancelled. This problem type is also set if the train does not service the stop (e.g. due to a rerouting) where the passenger wanted to enter/alight the train.


### Range

The range type specifies two stop indices for which the given information applies.

  - ##### <span class="param">from</span> type `integer`
    The first index where the information applies.
  - ##### <span class="param">to</span> type `integer`
    The last index where the information applies.