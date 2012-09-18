#!/bin/bash
if [ "`whoami`" != "root" ]
then
echo "Devi eseguire lo script come root coglione!"
exit
fi
FILE="cramfs-fsl.rom"
CARTELLAMOUNTS="media"
PUNTOMOUNT="RootFS"
echo "Monto su /$CARTELLAMOUNTS/$PUNTOMOUNT/ il file $FILE..."
if [ ! -d $CARTELLAMOUNTS ]; then
mkdir /media/$PUNTOMOUNT
fi
sleep 2
mount -t cramfs -o loop,rw $FILE /$CARTELLAMOUNTS/$PUNTOMOUNT/
#mount -t cramfs -o loop $FILE /$CARTELLAMOUNTS/$PUNTOMOUNT/
echo "Fatto"
exit
