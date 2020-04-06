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

### IntermodalOntripStart

Pretrip journey planning involves searching in a time interval. Therefore, the Pareto optimization criteria are not travel time and number of transfes but "later departure", "earlier arrival" and number of transfers. This means that the result set may contain a longer journey with more transfers if its departure is later or its arrival is earlier.

  - ##### <span class="param">station</span> required
    The departure station for `search_dir=Forward` or arrival station for `search_dir=Backward`. See [InputStation]({% link api/buildingblocks.md %}#InputStation)
  - ##### <span class="param">SearchDir</span> optional, default is `Forward`
     The search direction.
       - `Forward`
       - `Backward`


## IntermodalOntripStart

  - ##### <span class="param">SearchType</span> optional, default is `Default`
     The optimization criteria to consider.
       - `Default`
       - `SingleCriterion`
       - `SingleCriterionNoIntercity`
  - ##### <span class="param">SearchDir</span> optional, default is `Forward`
     The search direction.
       - `Forward`
       - `Backward`


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