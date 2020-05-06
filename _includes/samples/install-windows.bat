@ECHO OFF
setlocal enabledelayedexpansion

REM MOTIS is (currenlty) not UTF8 compatible.
REM Convert HRD data from UTF8 to ISO_8859-1.
for %%f in (data\hrd\*) do (
  echo converting %%~nf"
  iconv.exe -f utf-8 -t iso-8859-1 "%%f" > "%%f.txt"
  move "%%f.txt" "%%f"
)

REM Create data\hrd\schedule.raw
motis.exe --dataset.path data/hrd --mode test

REM OSRM
mkdir data\car
move data\switzerland-latest.osm.pbf data\car

osrm-extract.exe data\car\switzerland-latest.osm.pbf -p osrm-profiles\car.lua
osrm-contract.exe data\car\switzerland-latest.osrm

mkdir data\bike
move data\car\switzerland-latest.osm.pbf data\bike\switzerland-latest.osm.pbf

osrm-extract.exe data\bike\switzerland-latest.osm.pbf -p osrm-profiles\bicycle.lua
osrm-contract.exe data\bike\switzerland-latest.osrm

move data\bike\switzerland-latest.osm.pbf data\switzerland-latest.osm.pbf

REM Preprocess data.
ppr-preprocess.exe -o data\switzerland-latest.osm.pbf -g data\routing-graph.ppr
at-example.exe extract data\switzerland-latest.osm.pbf data\at.db
path-prepare.exe ^
  --schedule data\hrd ^
  --osm data\switzerland-latest.osm.pbf ^
  --osrm data\car\switzerland-latest.osrm
parking-prepare.exe ^
  --osm data\switzerland-latest.osm.pbf ^
  --schedule data\hrd ^
  --db data\parking_footedges.db ^
  --parking data\parking.txt ^
  --ppr_graph data\routing-graph.ppr ^
  --ppr_profile ppr-profiles

REM Write config file.
(
echo server.static_path=web
echo dataset.path=data\hrd
echo ppr.graph=data\routing-graph.ppr
echo ppr.profile=ppr-profiles
echo osrm.dataset=data\car\switzerland-latest.osrm
echo osrm.dataset=data\bike\switzerland-latest.osrm
echo address.db=data\at.db
echo parking.parking=data\parking.txt
echo parking.db=data\parking_footedges.db
echo exclude_modules=path
echo exclude_modules=tripbased
echo exclude_modules=csa
echo exclude_modules=bikesharing
)>"config.ini"