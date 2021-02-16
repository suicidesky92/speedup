#!/bin/bash

# if not in modprobe > sudo apt install -y linux-image-generic

if [ $EUID != 0 ]
then
    echo "ERROR: You have to be root to execute this script"
    exit 1
fi

CPUNUMBERS=$(grep -c processor /proc/cpuinfo)

MEMTOTAL=$(cat /proc/meminfo | head -n1 | awk '{print$2}')
let "MEMTOTAL=MEMTOTAL/1024"
let "SIZEDEV=MEMTOTAL/2/CPUNUMBERS"
echo "CPUs= $CPUNUMBERS, RAM= $MEMTOTAL MB"
echo -e "----------------------I think, need \033[5;36m $CPUNUMBERS \033[0m block devices in RAM, \033[5;32m $SIZEDEV \033[0m MB each. ----------------------"
let "SIZEDEV=SIZEDEV*1024*1024"


SWAPOFFI=$(swapon -s | grep dev | awk '{print$1}')

swapoff $SWAPOFFI

modprobe zram num_devices=$CPUNUMBERS
modprobe lz4

BLK=0
let "CPUNUMBERS--"
while [ $BLK -le $CPUNUMBERS ]
do
  echo $SIZEDEV > /sys/block/zram$BLK/disksize
  mkswap /dev/zram$BLK
  swapon /dev/zram$BLK -p 1
  ((BLK++))
done

echo "Yours swap's"
swapon -v
echo "All done"
