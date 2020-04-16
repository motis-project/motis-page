---
layout: api
code: api
---

## General Info about the MOTIS API

MOTIS uses the same message format for batch evaluations as well as for the WebSocket and HTTP endpoints when MOTIS is in server mode. This is the same message format used to communicate between MOTIS modules. MOTIS can also use remote instances for a set of modules.

The MOTIS HTTP endpoint is *not* a REST endpoint: everything goes through a HTTP POST request to the same URL. However, MOTIS messages have a `destination` field which contains a `target` string. For empty requests, it is possible to just access the HTTP GET address with the `target` as path. This will call the MOTIS method associated with this `target` and return the response as JSON.

All major general purpose programming languages (Java, C#, Python, C/C++, etc.) can consume the MOTIS HTTP JSON API. It is recommended to use a HTTP client and JSON parser library.

## Skipped Attributes

If an attribute has its default value it is skipped. This is important for integer and double values as well as for enums. Thus, clients should not depend on the existence of keys in the JSON response but rather assume the default value (zero / first enum entry) if a key is missing.


## Times

Every timestamp, in requests as well as in responses is given as Unix timestamp. It is the number of seconds that have elapsed since the Unix epoch, that is the time 00:00:00 UTC on 1 January 1970, minus leap seconds. Most programming languages have functions to deal with this time format.

## Message Format

The message format is based on Google's <a href="https://google.github.io/flatbuffers/">FlatBuffers</a> which is a binary format that can be converted to and from JSON. Flatbuffer messages are described in ".fbs" files. The full format description can be found [here](https://github.com/motis-project/motis/tree/master/protocol). The API endpoints document only the `content` section of the message.

The example on the left demonstrates the general message structure.

  - ##### <span class="param">destination</span> required
    Specifies the type of the `target` parameter. The `type` parameter is always `Module` for messages sent via HTTP/WebSocket.
  - ##### <span class="param">content_type</span> required
    Specifies the content type of the message. This is specified in the API endpoints.
  - ##### <span class="param">content</span> required
    The actual message content.