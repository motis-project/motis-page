---
layout: post
title:  "MOTIS v0.5: Tooling Subcommands, musl Binaries, Docker Improvements"
date:   2021-09-11 22:02:00 +0100
categories: release
author: felixguendling
version: 0.5.3
---

MOTIS version v0.5 now comes with subcommands. If no subcommand is given, the MOTIS binary will behave as usual (e.g. start the server or process a batch file of queries depending on the `--mode`). A subcommand can be given like this `motis generate --help`. This will print the help message of the query generator subcommand. The subcommands are documented in the [MOTIS Wiki](https://github.com/motis-project/motis/wiki/Tools). Please feel free to support us in extending the documentation (e.g. by filing an issue) if you find something is missing.

MOTIS uses [mimalloc](https://github.com/microsoft/mimalloc) since version v0.5.3. Without, the [Europe demo](https://europe.motis-project.de) will not be able to load on with 64GB RAM. With mimalloc this issue is solved.

## Do a Full Evaluation Run

With the new version, it is now possible to do a full evaluation run just with the released MOTIS binary. Assuming you have a working `config.ini` in your current directory and `motis` in your `PATH`, you can just follow the these steps:

  - Generating a random batch of MOTIS queries `motis generate`
  - Compute responses `motis --mode batch --batch_input_file queries_fwd_routing.txt`
  - Show statistics `motis analyze responses.txt`
  - Compare with other responses: `motis compare other_responses.txt responses.txt queries_fwd_routing.txt`
  - Print a human readable version of the first response `head -n1 responses.txt | motis print`

## Portable Binaries without Dependencies

By switching to a statically linked musl C standard library, MOTIS binaries for Linux are now independent of the Linux operating system and should run on any available Linux distribution (old and new). This does also apply to the binaries for ARM (32bit and 64bit). So it is now possible to run MOTIS directly on the Raspberry Pi without Docker (which was not possible with MOTIS v0.4).


## Docker Improvements

### Minimal Images

By switching to musl binaries (as described above), we now are able to switch the Docker base image to Alpine linux which has a minimal footprint.

### System Configuration

MOTIS now has an additional command line flag `--system_config` where you can provide an additional `config.ini`. Values from the normal configuration (`-c` or `--config`) override the values from the system config in the same way as options from the command line override the `config.ini` values.

We provide a system config for the docker image which already configures all [PPR](https://github.com/motis-project/ppr) profiles, [Tiles](https://github.com/motis-project/tiles) profiles, [OSRM](https://github.com/motis-project/osrm-backend) profiles and the web folder.

### Separate Volumes for Input and Data

Previously, MOTIS wrote the preprocessed `schedule.raw` file directly into the schedule folder. This way, it was required that MOTIS had write access to the schedule folder. Now, the `schedule.raw` gets written to `${data_dir}/schedule/${prefix}_schedule.raw`. This way, it's now possible to have separate volumes for MOTIS:

  - The input volume provides the timetables, OpenStreetMap files, etc. This can now be mounted read-only.
  - The data volume is the only folder, MOTIS writes data to. However, it does not need to be shared with the host system.

Our `docker compose` configuration to accomplish this looks like this:

```yaml
version: "3.9"
services:
  motis-delfi:
    image: ghcr.io/motis-project/motis:latest
    ports:
      - "8080:8080"
    volumes:
      - type: bind
        source: ./data
        target: /input
        read_only: true
      - type: volume
        source: data-volume
        target: /data
    restart: always
volumes:
 data-volume:
```

If you name your schedule in your input folder `schedule` and your your OpenStreetMap File `osm.pbf`, you do not need to change the import paths because these are the defaults configured in the MOTIS Docker system configuration.