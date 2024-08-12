---
layout: post
title:  "MOTIS v0.12: triptix GmbH + NRW Mobidrom"
date:   2024-06-16 21:30:00 +0200
categories: release
author: felixguendling
version: 0.12.7
---

It's been a while since the last update. MOTIS has seen countless improvements and new features since then. This news will give a short overview. But before we go into the details, I am thrilled to announce a freshly formed collaboration between the newly founded [triptix GmbH](https://triptix.tech) which offers professional services around MOTIS and [NRW Mobidrom GmbH](https://www.mobidrom.nrw) in Düsseldorf, Germany. Mobidrom will offer data and routing services for the German state North Rhine-Westphalia. MOTIS is going to be one of the core building blocks of NRW Mobidrom's routing services. With this collaboration, we will jointly bring MOTIS to the next level by implementing some of the most important items from the [MOTIS potential GitHub issue](https://github.com/motis-project/motis/issues/452).

The following two features from the [NRW.Mobidrom](https://www.mobidrom.nrw) + [triptix GmbH](https://triptix.tech) collaboration are already available with this release:

- routing with a filter for bike carriage
- limiting the number of transfers

The collaboration roadmap contains further improvements in all areas:

- via routing (routing via an ordered list of given stops)
- configuring a minimal transfer time and transfer time factors to allow for faster or transfers with an extra buffer based on the user's preference
- a more convenient configuration format (upgrading from INI to JSON/Yaml)
- implementing real-time monitoring (e.g. with Grafana as destination)
- improving cloud readiness through different measures such as allowing MOTIS to start with just the pre-processed data without having to access the `input` folder
- improved support for GBFS such as respecting zones where the vehicle should not be parked

<p align="center" style="margin: 50px 0px">
  <a href="https://mobidrom.nrw">
    <img src="/assets/mobidrom_logo.png" alt="NRW Mobidrom Logo" style="width: 200px" />
  </a>
</p>

## New Street Routing `osr`

In the past releases, MOTIS has also taken a big leap forward to become more scalable. With [`osr`](https://github.com/motis-project/osr), we have now the most memory-efficient street routing. It supports wheelchair routing, pedestrian routing, bike routing and car routing. We are fully committed to this routing now and will add existing use cases such as park and ride or sharing mobility (`gbfs` module) to `osr`. This will enable us to provide better routing results with less preprocessing time and a **10x reduced memory** usage.


## New GeoCoding / Address Auto Complete `adr`

The new `adr` module by [triptix GmbH](https://triptix.tech) (licensed under the AGPL v3 license) provides planet wide address autocomplete and geocoding in under 8 GB of RAM with fast response times, fuzzy string matching, as well as house number granularity.

<p align="center" style="margin-bottom: 30px">
  <a href="https://triptix.tech">
    <img src="/assets/triptix_logo.svg" alt="triptix GmbH Logo" style="width: 140px" /><br>
    triptix GmbH
  </a>
</p>


## New Routing Core

The new routing core is now the default and the old routing core has been removed. We recommend to upgrade to the latest release to make full use of the speed gains we have achieved in the past releases. MOTIS now allows to filter the modes of transportation for each routing query.
