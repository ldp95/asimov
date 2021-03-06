#!/bin/bash
trap "exit 1" SIGINT SIGTERM

filename=~/stl/$(basename $1)
outname=$2
#remotehost=p_ester@pulsar.unizar.es
remotehost=$3
# Script para lanzar sliceado en remoto
#echo "Borrando .skeinforge remoto"
#ssh $remotehost 'rm -rf .skeinforge'
echo "Copiando .skeinforge"
rsync -azPL ~/.skeinforge ${remotehost}:
#scp -r ~/.skeinforge/ $remotehost:

# Copio el .stl al home de pulsar del usuario corresponiente
echo "Copiando fichero stl"
scp "$1" $remotehost:stl/

ssh $remotehost "python /opt/skeinforge/skeinforge_application/skeinforge_utilities/skeinforge_craft.py stl/$(basename $filename)" | strings

scp $remotehost:stl/$(basename "${filename%.*}_export.gcode") $outname
