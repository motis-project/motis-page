@ECHO OFF
setlocal enabledelayedexpansion

# MOTIS is (currenlty) not UTF8 compatible.
# Convert HRD data from UTF8 to ISO_8859-1.
for %%f in (hrd\*) do (
  echo converting %%~nf"
  ..\iconv.exe -f utf-8 -t iso-8859-1 "%%f" > "%%f.txt"
  move "%%f.txt" "%%f"
)

# Create data\hrd\schedule.raw
motis.exe --dataset.path data/hrd --mode test

# Preprocess data.
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
  --ppr_graph data\routing-graph.ppr

# OSRM
mkdir data\car data\bike
mklink /D data\switzerland-latest.osm.pbf data\car\switzerland-latest.osm.pbf
mklink /D data\switzerland-latest.osm.pbf data\bike\switzerland-latest.osm.pbf
osrm-extract.exe data\car\switzerland-latest.osm.pbf -p profiles\car.lua
osrm-contract.exe data\car\switzerland-latest.osrm
osrm-extract.exe data\bike\switzerland-latest.osm.pbf -p profiles\bicycle.lua
osrm-contract.exe data\bike\switzerland-latest.osrm

# Write config file.
cat << EOF >> config.ini
server.static_path=web
dataset.path=data\hrd
ppr.graph=data\routing-graph.ppr
osrm.dataset=data\car\switzerland-latest.osrm
osrm.dataset=data\bike\switzerland-latest.osrm
address.db=data\at.db
parking.parking=data\parking.txt
parking.db=data\parking_footedges.db
exclude_modules=path
exclude_modules=tripbased
exclude_modules=csa
exclude_modules=bikesharing