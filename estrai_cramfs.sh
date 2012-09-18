#!/bin/bash
if [ "`whoami`" != "root" ]
then
echo "Devi eseguire lo script come root coglione!"
exit
fi
DIRACT=`pwd`
MNTPT=/media/RootFS
if [ ! -d "cramfs" ]; then
mkdir $DIRACT/cramfs
fi
cd $MNTPT
sudo tar -mcf - . | sudo tar -C $DIRACT/cramfs -mxpf -
cd $DIRACT
echo "Fatto."
exit
