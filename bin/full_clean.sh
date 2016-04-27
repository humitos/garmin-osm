#!/bin/bash
#
# full_clean.sh: script para eliminar mapas y archivos fuentes previamente
# generados y descargados (vuelve todo a 0)
#
# (C) 2016 Manuel Kaufmann <humitos@gmail.com>
# Distributed under the terms of the GNU General Public License v3
#



PAISES="south-america argentina bolivia brazil chile paraguay uruguay"


FECHA=$(date +%G%m%d)
WORKDIR=`pwd`


# Borra la informacíón
for pais in ${PAISES}; do

  if [ -e ${pais} ]; then
    rm -rf ${pais}
    rm -f ${pais}.o5m
  fi

done

rm -f state.txt.old  
rm -rf bounds
rm -rf mkgmap
rm -rf splitter
