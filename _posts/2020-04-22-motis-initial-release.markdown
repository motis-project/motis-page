---
layout: post
title:  "MOTIS Initial Release"
date:   2020-04-22 12:22:54 +0100
categories: release
author: felixguendling
version: 0.1
---

We are happy to announce the first MOTIS open source release! MOTIS is an acronym that stands for **M**ulti **O**bjective **T**ravel **I**information **S**ystem. One of its main features is computing optimal intermodal journeys (including private car, bicycle, bus, tram, trains, etc.) from door to door based on a real-time timetable.

This post will not go into the details of the functionality of MOTIS; these are listed on the main page of [motis-project.de](https://motis-project.de) as well as on the "Docs" page. A description of the JSON API provided by MOTIS can be found [here]({% link docs/api/index.md %}).

MOTIS started as a research software project at the Technical University of Darmstadt in cooperation with Deutsche Bahn and <a href="https://datagon.de/">datagon GmbH</a> in the early 2000s. Since then, the codebase has seen many new features and overhauls. MOTIS has been used for quality assurance at Deutsche Bahn and as a basis for [PANDA](https://inside.bahn.de/anschlusszug-panda/), a tool to assist train dispatchers in their decision making process which is developed by the [team of Prof. Dr. Matthias Müller-Hannemann at the Martin-Luther-Universität Halle-Wittenberg](https://www.informatik.uni-halle.de/arbeitsgruppen/datenstrukturen/).

### GitHub

We use GitHub to

  - track code changes (Git): [github.com/motis-project/motis](https://github.com/motis-project/motis)
  - track issues (bug reports, enhancements, etc.): [github.com/motis-project/motis/issues](http://github.com/motis-project/motis/issues)
  - monitor software quality through continuous integration (CI): [github.com/motis-project/motis/actions](https://github.com/motis-project/motis/actions)
  - release new versions of MOTIS: [github.com/motis-project/motis/releases](https://github.com/motis-project/motis/releases)


Every successful CI build produces a MOTIS distribution archive.


### Status

Since the API as well as the internal data model is still subject to change, MOTIS is to be considered in a "beta" status. Therefore, the first version is named v0.1 and not v1.0.


### Initial contributors

Since the original commit history did contain data that was not suited for publication, we had to start with a fresh history. Therefore, we list all contributers to the initial version here.

  - Sebastian Fahnenschreiber <a href="https://github.com/sfahnens">@sfahnens</a>
  - Felix Gündling <a href="https://github.com/felixguendling">@felixguendling</a>
  - Simon Gündling <a href="https://github.com/deskjet">@deskjet</a>
  - Florian Hopp
  - Pablo Hoch <a href="https://github.com/pablohoch">@pablohoch</a>
  - Tobias Raffel <a href="https://github.com/traffel">@traffel</a>
  - Jonas Schlitzer <a href="https://github.com/joschli">@joschli</a>
  - Mathias Schnee <a href="http://drschnee.de">DrSchnee.de</a>
  - Mohammad Keyhani <a href="https://www.linkedin.com/in/dr-mohammad-h-keyhani-101a7312a/">LinkedIn</a>
  - Leon Steiner <a href="https://github.com/nZeloT">@nZeloT</a>
  - Tim Witzel <a href="https://github.com/Nicrey">@Nicrey</a>


All new contributers will be listed [here](https://github.com/motis-project/motis/graphs/contributors).