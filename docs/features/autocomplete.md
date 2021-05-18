---
layout: api
code: autocompletion
---

## Autocompletion of Addresses and Station Names

To enable the search from address to address, the user needs to be able to enter addresses into the system. Since most users do not know the exact spelling of an address in the database (e.g. is it "Darmstadt, Bismarckstraße" or "Bismarckstraße Darmstadt") an exact string matching algorithm is not suitable for this task.

Furthermore, the algorithm needs to be extremly fast - otherwise the user experience will be suboptimal. If the user is significant faster with typing than the autocomplete delivers matching suggestions, the user will be annoyed.

The MOTIS address autocompletion is based on OpenStreetMap data. It can complete street names and house number. The algorithm can handle fuzzy user inputs that may contain typing mistakes or wrong spelling. This is archived by using a fast fuzzy matching algorithm based on trigram matches with [Cosine similarity](https://en.wikipedia.org/wiki/Cosine_similarity).

Basically, every potential trigram, that is three consecutive characters in a word - for example the word hello contains three trigrams ("hel", "ell", "llo") - is an entry in a very large multidimensional vector. If a streetname contains a trigram, the component representing this trigram is set to one, otherwise it is set to zero. These vectors can be created for the user input as well as for every streetname in the OpenStreetMap dataset. The algorithm computes the closest match to the user input by computing this metric for every streetname and outputs those with a high similarity.



### The Autocompletion Feature is Available as JSON API over HTTP:

  - [Address Autocomplete]({% link docs/api/endpoint/address.md %})
  - [Station autocomplete]({% link docs/api/endpoint/guesser.md %})


### Try it out live:

  - [Demo](https://europe.motis-project.de)
