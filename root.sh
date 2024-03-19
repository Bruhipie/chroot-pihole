#!/bin/sh
export CURRDIR=$(pwd)
export UBUNTUDIR="/data/local/tmp/ubuntu"

mkdir $UBUNTUDIR
cd $UBUNTUDIR

#Downloading Ubuntu Base rootfs
curl -o ubuntu.tar.gz https://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/ubuntu-base-22.04-base-arm64.tar.gz
tar xpvf ubuntu.tar.gz

#Setting up Ubuntu for first login
mkdir sdcard && mkdir dev/shm && cd ..
mv $CURRDIR/setup.sh $UBUNTUDIR/root/setup.sh
mv $CURRDIR/startup.sh startup.sh && chmod +x startup.sh
mv $CURRDIR/pam.d $UBUNTUDIR/etc/pam.d      #To fix "Required key not found" while using groupadd

#First Login
echo "AS SOON AS YOU SEE "root@localhost", RUN "bash setup.sh""
sh startup.sh

mv $CURRDIR/startup-new.sh startup.sh