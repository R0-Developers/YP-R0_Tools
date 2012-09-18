#!/bin/bash
if [ "`whoami`" != "root" ]
then
echo "Devi eseguire lo script come root coglione!"
exit
fi
CARTELLAMOUNTS="media"
PUNTOMOUNT="RootFS"
echo "Smonto /$CARTELLAMOUNTS/$PUNTOMOUNT/..."
umount -a -t cramfs /$CARTELLAMOUNTS/$PUNTOMOUNT/
sleep 2
#rmdir /media/$PUNTOMOUNT
echo "Fatto"
exit
