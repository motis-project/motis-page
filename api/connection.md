---
layout: api
example: samples/Connection.json
---

## Connection

A `Connection` is a journey from a coordinate/station to another coordinate/station.

  - ##### <span class="param">stops</span> array of [Stops](#stop)
    The stop sequence including (real-time) event times and information about alighting and entering of services. This is the core of the journey. All other collections in the `Connection` reference stop indices.
  - ##### <span class="param">transports</span> array of [Transports](#transport)
    Information about the transports that are used with their corresponding stop range.
  - ##### <span class="param">trips</span> array of [Trips](#trip)
    Trip IDs for each trip that is used in the journey with their corresponding stop range.
  - ##### <span class="param">attributes</span> array of [Attributes](#attribute)
    Attributes that are active within the corresponding stop range.
  - ##### <span class="param">free_texts</span>
    The maximal time duration in seconds.
  - ##### <span class="param">problems</span>
    The maximal time duration in seconds.