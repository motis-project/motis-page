---
layout: api
code: routing
---

## Intermodal and Timetable Routing from Door to Door

MOTIS supports a variety of use cases for intermodal travel. On the one hand, it can be used to compute optimal routes from door to door. On the other hand, it also supports timetable routing from station to station or "mixed" routing from station to address or from address to station. The core of MOTIS routing is a highly efficient timetable data model that enables [real time updates]({% link docs/features/realtime.md %}) and dynamic per-query extension to integrate the parts of the street network that are relevant for a particular query.

It is important to note that MOTIS delivers routing results that are feasible in reality and respects as many details as possible. An example is [through trains](https://en.wikipedia.org/wiki/Through_train) (train, bus, or tram services that change their identity) or [portion workings](https://en.wikipedia.org/wiki/Portion_working) (two or more services that couple/split at some point). Other examples are timezones, daylight saving time, or transfer times between tracks at the same platform.


### Multi Criteria Optimization

When traveling, there are many criteria to consider. Reaching the destination as quick as possible might be one goal. However, many travellers also value convenience or do not want to pay a high price. Since the trade-off between all criteria maybe different for each traveller, MOTIS computes a non-extensible Pareto set of all optimal connections. Therefore, the result set is guaranteed to contain the perfect journey plan for every existing tradeoff. This means that even for a single departure time, there can be one optimal journey for any number of transfers when considering only two optimization criteria. Optimizing multiple criteria at the same time makes the routing algorithmically challenging.


### Problem Types

Depending on the use case of the traveller, there are different algorithmic problem descriptions. Basically, there are two search directions: the user can either provide an arrival time (interval) or a departure time interval. The algorithm then searches backward (in time) from arrival to departure or forward (in time) from departure to arrival. Both types are supported by MOTIS for timetable as well as for intermodal routing.

If the user is currently traveling (e.g. searching for an alternative connection because the original journey is not feasible anymore due to delays), there is only one departure time: the current point in time. The time they need to wait until the first departure should be considered as travel time. Therefore, a connection which is 20min faster but departs 30min later still reaches the destination 10min later. This scenario / search type is called *OnTrip* in MOTIS.

However, if the user is planning their journey, it is useful to get an overview of a whole time interval and be able to scroll earlier and later to search for the best trip. Here, MOTIS optimizes for "later departure" and "earlier arrival" as Pareto criteria. This scenario / search type is called *PreTrip* in MOTIS.


### Algorithms

MOTIS provides multiple state-of-the-art routing algorithms implemented in an efficient manner at its core. All of them support the features mentioned above (e.g. through services / portion working) and are guaranteed to compute exactly the same results. The following algorithms are implemented in MOTIS:

  - Multi Criteria Pareto Dijkstra: Disser, Y., Müller–Hannemann, M., & Schnee, M. (2008, May). Multi-criteria shortest paths in time-dependent train networks. In International Workshop on Experimental and Efficient Algorithms (pp. 347-361). Springer, Berlin, Heidelberg. [PDF](https://www2.mathematik.tu-darmstadt.de/~disser/pdfs/DisserMullerHannemannSchnee08.pdf)
  - RAPTOR: Round-Based Public Transit Routing. By Daniel Delling, Thomas Pajor, Renato F. Werneck. Transportation Science, vol. 49(3), pp. 591–604, 2014. [PDF](https://pubsonline.informs.org/doi/10.1287/trsc.2014.0534)
  - CSA: Intriguingly Simple and Fast Transit Routing. By Julian Dibbelt, Thomas Pajor, Ben Strasser, Dorothea Wagner. In: Proceedings of the 12th International Symposium on Experimental Algorithms (SEA’13). Springer Berlin Heidelberg, pp. 43–54, 2013. [PDF](http://tpajor.com/assets/paper/dpsw-isftr-13.pdf)
  - TripBased Routing: Witt, S. (2015). Trip-based public transit routing. In Algorithms-ESA 2015 (pp. 1025-1036). Springer, Berlin, Heidelberg. [PDF](https://arxiv.org/pdf/1504.07149)

MOTIS also contains variants of these algorithms which are not described in the initial publications such as latest-departure problems, adjustments to support the specialities above (through services / portion working), etc.

### The routing JSON API is available over HTTP:

  - [Intermodal Routing API]({% link docs/api/endpoint/intermodal.md %})

### Try it out live:

  - [Demo](https://europe.motis-project.de/)
