#!/bin/bash
#
# build_mkgmap.sh: script descargar y compilar mkgmap.jar
#
# (C) 2012 - 2015 Martin Andres Gomez Gimenez <mggimenez@ingeniovirtual.com.ar>
# Distributed under the terms of the GNU General Public License v3
#

# Requiere los siguientes paquetes:
# gcc: http://gcc.gnu.org/


WORKDIR=`pwd`

# http://wiki.openstreetmap.org/wiki/Osmconvert
OSMCONVERT_URL="http://m.m.i24.cc/osmconvert32"
OSMFILTER_URL="http://m.m.i24.cc/osmfilter32"
PBFTOOSM_URL="http://m.m.i24.cc/pbftoosm32"

OSMCONVERT="${WORKDIR}/bin/osmconvert"
OSMFILTER="${WORKDIR}/bin/osmfilter"
PBFTOOSM="${WORKDIR}/bin/pbftoosm"



rm -rf ${WORKDIR}/mkgmap
rm -rf ${WORKDIR}/splitter


svn export http://svn.mkgmap.org.uk/mkgmap/trunk mkgmap

# Se compila mkgmap
cd ${WORKDIR}/mkgmap
ant


cd ${WORKDIR}
svn export http://svn.mkgmap.org.uk/splitter/trunk splitter

# Se compila splitter
cd ${WORKDIR}/splitter
ant

# Descargar version pre-compilada
wget -O ${OSMCONVERT} ${OSMCONVERT_URL}
wget -O ${OSMFILTER} ${OSMFILTER_URL}
wget -O ${PBFTOOSM} ${PBFTOOSM_URL}

# Permisos de ejecución
chmod +x ${OSMCONVERT}
chmod +x ${OSMFILTER}
chmod +x ${PBFTOOSM}
