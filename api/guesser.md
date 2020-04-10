---
layout: api
request: samples/GuesserRequest.json
response: samples/GuesserResponse.json
---

## Station Autocompletion Based on Timetable Data

The station autocomplete API takes the string the user typed in the input field and "guesses" which station he could have meant.

### Request

  - ##### <span class="param">input</span> type `string`
    The string the user typed in the input field
  - ##### <span class="param">guess_count</span> type `integer`
    The number of guesses to produce.

### Response

The response contains a list of [Stations]({% link api/buildingblocks.md %}#station) in the `guesses` field.