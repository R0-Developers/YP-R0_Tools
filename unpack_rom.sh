#To unpack the firmware, save the following script (named here unpack_rom.sh) in a directory together with MuonEncrypt and the rom and execute it: ./unpack_rom.sh R0.ROM
#!/bin/bash

ROM=$1
MBOOT="MBoot.bin"
MBOOT_TMP="MBoot.tmp"
LINUX="zImage"
CRAMFS="cramfs-fsl.rom"
SYSDATA="SYSDATA.bin"
MD5SUMS="MD5SUMS"
TMP="TMP"

function ExtractAndDecrypt {
	START=$(expr $START - $2)
	echo "Extracting $1..."
	dd if=$ROM of=$TMP bs=1 skip=$START count=$2 2>/dev/null
	echo "Decrypt $1..."
	./MuonEncrypt $TMP > $1
}

size=( `head -n 9 $ROM | tail -n 4 | while read LINE; do echo $LINE | cut -d\( -f 2 | cut -d\) -f 1; done`)
checksum=( `head -n 9 $ROM | tail -n 4 | while read LINE; do echo $LINE | cut -d\( -f 3 | cut -d\) -f 1; done`)

echo "${checksum[0]}  $MBOOT" > $MD5SUMS
echo "${checksum[1]}  $LINUX" >> $MD5SUMS
echo "${checksum[2]}  $CRAMFS" >> $MD5SUMS
echo "${checksum[3]}  $SYSDATA" >> $MD5SUMS

START=`stat -c%s $ROM`

ExtractAndDecrypt $SYSDATA ${size[3]}
ExtractAndDecrypt $CRAMFS ${size[2]}
ExtractAndDecrypt $LINUX ${size[1]}
ExtractAndDecrypt $MBOOT_TMP ${size[0]}

rm $TMP
echo "Create $MBOOT..."
dd if=$MBOOT_TMP of=$MBOOT bs=96 count=1 2>/dev/null
dd if=$MBOOT_TMP of=$MBOOT bs=1088 skip=1 seek=1 2>/dev/null
rm $MBOOT_TMP

echo "Check integrity:"
md5sum -c $MD5SUMS