#!/bin/bash

PAIS=$1
DATA_JSON=/home/humitos/apps/argentinaenpython.com.ar/mapas-de-openstreetmap-para-garmin/${PAIS}_osm-data.json

echo '{"{{'${PAIS}'_size}}": "[[size]]", "{{'${PAIS}'_date}}": "[[date]]", "{{'${PAIS}'_md5}}": "[[md5]]", "{{'${PAIS}'_sha1}}": "[[sha1]]", "{{'${PAIS}'_sha256}}": "[[sha256]]"}' > ${DATA_JSON}


rpl --backup "[[size]]" "`ls -lh gmapsupp.img | awk '{printf $5, " "'}`" ${DATA_JSON} 

rpl --backup "[[date]]" "`date +%d-%m-%y`" ${DATA_JSON} 

rpl --backup "[[md5]]" "`tail -n 1 gmapsupp.img.md5 | awk '{printf $1, " "'}`" ${DATA_JSON} 

rpl --backup "[[sha1]]" "`tail -n 1 gmapsupp.img.sha1 | awk '{printf $1, " "'}`" ${DATA_JSON} 

rpl --backup "[[sha256]]" "`tail -n 1 gmapsupp.img.sha256 | awk '{printf $1, " "'}`" ${DATA_JSON} 
