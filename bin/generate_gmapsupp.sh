#!/bin/bash

set -e

PAIS=$1

cd ~/garmin-osm

./bin/build_mkgmap.sh
./bin/01_cleanosmdata.sh
./bin/02_getosmdata.sh ${PAIS}
./bin/03_boundaries.sh ${PAIS}
./bin/04_splitter.sh ${PAIS}
./bin/05_mkgarminmap.sh ${PAIS}
./bin/06_gensum.sh ${PAIS}
./bin/07_create_json_data.sh ${PAIS}

mkdir -p /home/humitos/apps/argentinaenpython.com.ar/mapas-de-openstreetmap-para-garmin/${PAIS}
mv gmapsupp.img /home/humitos/apps/argentinaenpython.com.ar/mapas-de-openstreetmap-para-garmin/${PAIS}
