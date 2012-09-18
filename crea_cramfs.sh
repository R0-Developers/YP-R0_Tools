#!/bin/bash
if [ "`whoami`" != "root" ]
then
echo "Devi eseguire lo script come root coglione!"
exit
fi
mv cramfs-fsl.rom cramfs-fsl.rom.old
mkfs.cramfs cramfs cramfs-fsl.rom
echo "Fatto."
exit
