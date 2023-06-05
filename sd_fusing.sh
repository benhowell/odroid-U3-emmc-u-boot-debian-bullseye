#
# Copyright (C) 2013 Samsung Electronics Co., Ltd.
#              http://www.samsung.com/
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
####################################
set -x

if [ -z $1 ]
then
    echo "usage: ./sd_fusing.sh <SD Reader's device file>"
    exit 0
fi

if [ -b $1 ]
then
    echo "$1 reader is identified."
else
    echo "$1 is NOT identified."
    exit 0
fi

if [ -d /sys/block/${1##*/}boot0 ]; then
    echo "$1 is an eMMC card, disabling ${1##*/}boot0 ro"
    if ! echo -n 0 | tee /sys/block/${1##*/}boot0/force_ro; then
        echo "Enabling r/w for $1boot0 failed"
        exit 1
    fi
    emmc=1
fi

####################################
# fusing images
if [ -n "$emmc" ]; then
    signed_bl1_position=0
    bl2_position=30
    uboot_position=62
    tzsw_position=2110
    device=$1boot0
else
    signed_bl1_position=1
    bl2_position=31
    uboot_position=63
    tzsw_position=2111
    device=$1
fi

# Get the U-Boot blob
if [ -f ./u-boot.bin ]; then
  uboot="./u-boot.bin"
elif [ -f ./u-boot.bin.hardkernel ]; then
  uboot="./u-boot.bin.hardkernel"
else
  echo "U-Boot blob not found."
  exit
fi

#<BL1 fusing>
echo "BL1 fusing"
dd iflag=dsync oflag=dsync if=./E4412_S.bl1.HardKernel.bin of=$device seek=$signed_bl1_position

#<BL2 fusing>
echo "BL2 fusing"
dd iflag=dsync oflag=dsync if=./bl2.signed.bin of=$device seek=$bl2_position

#<u-boot fusing>
echo "u-boot fusing"
dd iflag=dsync oflag=dsync if=$uboot of=$device seek=$uboot_position

#<TrustZone S/W fusing>
echo "TrustZone S/W fusing"
dd iflag=dsync oflag=dsync if=./E4412_S.tzsw.signed.bin of=$device seek=$tzsw_position

#<u-boot env default>
#echo "u-boot env erase"
#dd iflag=dsync oflag=dsync if=/dev/zero of=$device seek=$env_position count=32 bs=512

####################################
#<Message Display>
echo "U-boot image is fused successfully."
echo "Eject SD card and insert it again."
