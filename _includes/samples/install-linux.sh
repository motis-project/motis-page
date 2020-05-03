# iconv cannot handle empty files.
find . -empty -delete

# MOTIS is (currenlty) not UTF8 compatible.
# Convert HRD data from UTF8 to ISO_8859-1.
for file in data/hrd/*
do
    iconv -f UTF8 -t ISO_8859-1 "$file" > "$file.new" &&
    mv -f "$file.new" "$file"
done

# Create data/hrd/schedule.raw
./motis --dataset.path data/hrd --mode test

# OSRM
mkdir -p data/car data/bike
ln -s `pwd`/data/switzerland-latest.osm.pbf data/car/switzerland-latest.osm.pbf
ln -s `pwd`/data/switzerland-latest.osm.pbf data/bike/switzerland-latest.osm.pbf
./osrm-extract data/car/switzerland-latest.osm.pbf -p profiles/car.lua
./osrm-contract data/car/switzerland-latest.osrm
./osrm-extract data/bike/switzerland-latest.osm.pbf -p profiles/bicycle.lua
./osrm-contract data/bike/switzerland-latest.osrm

# Preprocess data.
./ppr-preprocess -o data/switzerland-latest.osm.pbf -g data/routing-graph.ppr
./at-example extract data/switzerland-latest.osm.pbf data/at.db
./path-prepare \
  --schedule data/hrd \
  --osm data/switzerland-latest.osm.pbf \
  --osrm data/car/switzerland-latest.osrm
./parking-prepare \
  --osm data/switzerland-latest.osm.pbf \
  --schedule data/hrd \
  --db data/parking_footedges.db \
  --parking data/parking.txt \
  --ppr_graph data/routing-graph.ppr

# Write config file.
cat << EOF >> config.ini
server.static_path=web
dataset.path=data/hrd
ppr.graph=data/routing-graph.ppr
osrm.dataset=data/car/switzerland-latest.osrm
osrm.dataset=data/bike/switzerland-latest.osrm
address.db=data/at.db
parking.parking=data/parking.txt
parking.db=data/parking_footedges.db
exclude_modules=path
exclude_modules=tripbased
exclude_modules=csa
exclude_modules=bikesharing