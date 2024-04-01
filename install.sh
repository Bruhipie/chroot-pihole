#!/bin/sh
export CURRDIR=$(pwd)
export UBUNTUDIR="/data/local/tmp/ubuntu"

mkdir $UBUNTUDIR
cd $UBUNTUDIR

#Downloading Ubuntu Base rootfs
echo -e "\nDOWNLOADING UBUNTU ROOTFS\n"
wget -O ubuntu.tar.gz https://cdimage.ubuntu.com/ubuntu-base/releases/22.04.4/release/ubuntu-base-22.04.4-base-arm64.tar.gz
tar xpvf ubuntu.tar.gz --numeric-owner
echo -e "\n\n Clearing the clutter" && sleep 5
clear

#Setting up Ubuntu for first login
mkdir sdcard && mkdir dev/shm && cd ..
cp $CURRDIR/setup.sh $UBUNTUDIR/root/setup.sh
cp $CURRDIR/startup.sh $(pwd)/startup.sh && chmod +x startup.sh
cp -R $CURRDIR/pam.d/ $UBUNTUDIR/etc/pam.d/ #To fix "Required key not found" while using groupadd

#First Login
sh startup.sh

cp $CURRDIR/startup-new.sh /data/local/tmp/startup.sh