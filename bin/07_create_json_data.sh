#!/bin/bash

DATA_JSON = /home/humitos/apps/argentinaenpython.com.ar/mapas-de-openstreetmap-para-garmin/osm-data.json

echo '{"{{size}}": "[[size]]", "{{date}}": "[[date]]", "{{md5}}": "[[md5]]", "{{sha1}}": "[[sha1]]", "{{sha256}}": [[sha256]]}' > ${DATA_JSON}

rpl --backup "[[size]]" "`ls -lh gmapsupp.img | awk '{printf $5, " "'}`" ${DATA_JSON} 
rpl --backup "[[date]]" "`date +%d-%m-%y`" ${DATA_JSON} 
rpl --backup "[[md5]]" "`cat gmapsupp.img.md5 | awk '{printf $1, " "'}`" ${DATA_JSON} 
rpl --backup "[[sha1]]" "`cat gmapsupp.img.sha1 | awk '{printf $1, " "'}`" ${DATA_JSON} 
rpl --backup "[[sha256]]" "`cat gmapsupp.img.sha256 | awk '{printf $1, " "'}`" ${DATA_JSON} 
