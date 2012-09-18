#!/bin/bash
# Muon Platform
# Copyright (c) 2004-2009 Samsung Electronics, Inc.
# All rights reserved.
#
# Rom Packaging Script
# It needs sudoer privilege of rm, mkdir, cp, mkcramfs.
# You can configure it in the /etc/sudoer file.
# This script is very dangerous. Be careful to use.
#
# SangMan Sim<sangman.sim@samsung.com>
REVISION="RevisionInfo.txt"
CRAMFS="cramfs-fsl.rom"
SYSDATA="SYSDATA.bin"
MBOOT="MBoot.bin"
MBOOT_TMP="MBoot.tmp"
LINUX="zImage"
R1ROM="R1.ROM"

function WriteImage {
	#HEAD_STR=[`stat -c%s $1`/`md5sum $1 | cut -d " " -f 1`]
	#HEAD_SIZE=`echo $HEAD_STR | wc -c`
	#PACK_SIZE=`expr 44 - $HEAD_SIZE`

	#while [ $PACK_SIZE -gt 0 ]
	#do
		#PACK_SIZE=`expr $PACK_SIZE - 1`
		#echo -n 0
	#done

	./MuonEncrypt $1 >> $R1ROM
	#cat $MBOOT >> $R1ROM
}

function Pack4Byte {
	FILE_SIZE=`stat -c%s $R1ROM`
	PACK_SIZE=`expr 4 - $FILE_SIZE % 4`
	
	if [ $PACK_SIZE != 4 ]
	then
		while [ $PACK_SIZE -gt 0 ]
		do
			PACK_SIZE=`expr $PACK_SIZE - 1`
			echo -en $1 >> $R1ROM
		done
	fi
}

echo Make $R1ROM

cat $REVISION > $R1ROM
echo User : $USER >> $R1ROM
echo Dir : $PWD >> $R1ROM
echo BuildTime : `date "+%y/%m/%d %H:%M:%S"` >> $R1ROM
echo MBoot : size\(`stat -c%s $MBOOT`\),checksum\(`md5sum $MBOOT | cut -d " " -f 1`\) >> $R1ROM
echo Linux : size\(`stat -c%s $LINUX`\),checksum\(`md5sum $LINUX | cut -d " " -f 1`\) >> $R1ROM
echo RootFS : size\(`stat -c%s $CRAMFS`\),checksum\(`md5sum $CRAMFS | cut -d " " -f 1`\) >> $R1ROM
echo Sysdata : size\(`stat -c%s $SYSDATA`\),checksum\(`md5sum $SYSDATA | cut -d " " -f 1`\) >> $R1ROM

Pack4Byte "\\n"

dd if=$MBOOT of=$MBOOT_TMP bs=96 count=1 2> /dev/null

echo `stat -c%s $MBOOT`:`md5sum $MBOOT | cut -d " " -f 1` >> $MBOOT_TMP
echo `stat -c%s $LINUX`:`md5sum $LINUX | cut -d " " -f 1` >> $MBOOT_TMP
echo `stat -c%s $CRAMFS`:`md5sum $CRAMFS | cut -d " " -f 1` >> $MBOOT_TMP
echo `stat -c%s $SYSDATA`:`md5sum $SYSDATA | cut -d " " -f 1` >> $MBOOT_TMP

dd if=$MBOOT of=$MBOOT_TMP bs=1088 skip=1 seek=1 2> /dev/null
WriteImage $MBOOT_TMP

rm $MBOOT_TMP

Pack4Byte "0"

WriteImage $LINUX

Pack4Byte "0"

WriteImage $CRAMFS

Pack4Byte "0"

WriteImage $SYSDATA

echo $R1ROM : `stat -c%s $R1ROM`, `md5sum $R1ROM | cut -d " " -f 1`
#head -9 $R1ROM

echo "Done"
