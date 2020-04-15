---
layout: api
code: address
---

## Address Autocompletion Based on OpenStreetMap Data

The address autocomplete API takes the string the user typed in the input field and "guesses" which addresses he could have meant.

### Request

  - ##### <span class="param">input</span> type `string`
    The string the user typed in the input field

### Response

The response contains a list of guesses in the `guesses` field.


  - ##### <span class="param">pos</span> see [Position]({% link docs/api/buildingblocks.md %}#position)
    The string the user typed in the input field
  - ##### <span class="param">name</span> type `string`
    The street name.
  - ##### <span class="param">type</span> type `string`
    The type of the address. May be `street` or `place`.
  - ##### <span class="param">regions</span> see [Region](#region)
    Regions (city, country, etc.) the address is located in.

### Region

  - ##### <span class="param">name</span> see [Range](#range)
    The region name.
  - ##### <span class="param">admin_level</span> see [Range](#range)
    The admin level corresponding to the [OpenStreetMap admin level](https://wiki.openstreetmap.org/wiki/Key:admin_level).