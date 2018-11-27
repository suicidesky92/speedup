#!/bin/bash

swapon -s
free -m
df -h
read -p "input swap size in GB" sizes
fallocate -l $sizes /swapfile
chmod 600 /swapfile
ls -lh /swapfile
mkswap /swapfile
swapon /swapfile
swapon -sh
read -p "add its to fstab? Press y" fsauto
if [ "$fsauto" = "y" ];
then
    echo "/swapfile    none    swap    sw    0    0" >> /etc/fstab
fi
