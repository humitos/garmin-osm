#!/bin/bash
#
# 02_getosmdata.sh: script para descargar datos desde OpenStreetMap.
#
# (C) 2012 - 2016 Martin Andres Gomez Gimenez <mggimenez@ingeniovirtual.com.ar>
# Distributed under the terms of the GNU General Public License v3
#

# Requiere los siguientes paquetes:
# bzip2: http://www.bzip.org/
# wget: http://www.gnu.org/software/wget/
# osmconvert: http://wiki.openstreetmap.org/wiki/osmconvert

# Uso:
# El script debe invocarse directamente sobre el directorio raíz de las siguientes
# maneras:
#
# bin/02_getosmdata.sh
#	Descarga y actualiza datos desde OpenStreetMap para el cono sur.
#
# bin/02_getosmdata.sh país
# 	Descarga y actualiza datos desde OpenStreetMap para el país seleccionado. El
#	valor de país puede ser uno de los siguientes:
#		argentina
#		bolivia
#		brazil
#		chile
#		colombia
#		ecuador
#		paraguay
#		peru
#		uruguay
#

set -e

WORKDIR=`pwd`
BUNZIP2="/bin/bunzip2 --force"
GET="/usr/bin/wget --continue"
OSMCONVERT="${WORKDIR}/bin/osmconvert"

# Datos desde OSM
URL="http://download.geofabrik.de"
URLGEONAMES="http://download.geonames.org/export/dump"
URLSEA="http://osm2.pleiades.uni-wuppertal.de/sea/latest/sea.tar.bz2"
PLANETOSM="http://planet.openstreetmap.org"
RDAY="${PLANETOSM}/replication/day"
OSMDAYSTATE="${RDAY}/state.txt"

# Uso de memoria: 128 MiB
HASH_MEM="--hash-memory=128"

# Colores
G='\E[1;32;40m'
Y='\E[1;33;40m'
W='\E[0;38;40m'
W='\e[0m'  # vuelve los colores a la normalidad

# Opciones para cortar el cono sur de América.
COORD="-77,-56,-49,-16"

# Función para seleccionar geoname a descargar por país.
geoname () {

  local PAIS="$1"

  case ${PAIS} in
    all )
      GEONAME="cities15000.zip"
      ;;

    argentina )
      GEONAME="AR.zip"
      ;;

    bolivia )
      GEONAME="BO.zip"
      ;;

    brazil )
      GEONAME="BR.zip"
      ;;

    chile )
      GEONAME="CL.zip"
      ;;

    colombia )
      GEONAME="CO.zip"
      ;;

    ecuador )
      GEONAME="EC.zip"
      ;;

    paraguay )
      GEONAME="PY.zip"
      ;;

    peru )
      GEONAME="PE.zip"
      ;;

    uruguay )
      GEONAME="UY.zip"
      ;;

  esac

}



# Datos desde OSM

# Selecciona el país, si no se pasan argumentos se procesan todos los países.
# PAIS = [all | argentina | bolivia | brazil | chile | paraguay | uruguay]
if [[ "${1}" == "" || "${1}" == "all" ]]; then
    PAIS="south-america"
    BOX="-b=${COORD}"
  else
    PAIS="${1}"
    BOX="-B=${PAIS}/${PAIS}.poly"
    URL="http://download.geofabrik.de/south-america"
fi

echo "------------------------------------------------------------------------"
echo "Descargando ${URL}/${PAIS}-latest.osm.bz2"
echo "------------------------------------------------------------------------"
echo

${GET} ${URL}/${PAIS}-latest.osm.bz2

echo "------------------------------------------------------------------------"
echo "Generando ${PAIS} con osmconvert desde: "
echo "${URL_PAIS}/${PAIS}-latest.osm.bz2"
echo "Area definida por: ${BOX}"
echo "------------------------------------------------------------------------"
echo

bzcat ${PAIS}-latest.osm.bz2 | ${OSMCONVERT} - ${HASH_MEM} \
      --verbose --out-o5m > ${PAIS}-latest.o5m

${OSMCONVERT} ${HASH_MEM} ${BOX} --drop-version --verbose \
${PAIS}-latest.o5m --out-o5m > ${PAIS}.o5m



# Descarga datos para el país seleccionado (por defecto para todos).
for pais in ${PAIS}; do
  geoname "${pais}"

  if [ ! -d ${WORKDIR}/${pais} ]; then
    mkdir --parents ${WORKDIR}/${pais}
    echo -e ">>> Creando directorio ${G}$pais${W}."
  fi

  cd ${WORKDIR}/${pais}

  if [ ! -e ${GEONAME} ]; then
    echo -e ">>> Descargando ${G}${GEONAME}${W}."
    ${GET} ${URLGEONAMES}/${GEONAME}
  fi
done


# Descarga de oceanos precompilados
if [ ! -d ${WORKDIR}/sea ]; then
  cd ${WORKDIR}
  ${GET} ${URLSEA}
  tar -jxvpf sea.tar.bz2
  SEADIR=$(ls */index.txt.gz | awk -F \/ //'{print $1}')
  mv ${SEADIR} sea
fi

