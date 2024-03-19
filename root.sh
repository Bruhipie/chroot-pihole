#!/bin/sh
export CURRDIR=$(pwd)
export UBUNTUDIR="/data/local/tmp/ubuntu"

mkdir $UBUNTUDIR
cd $UBUNTUDIR

#Downloading Ubuntu Base rootfs
echo -e "\nDOWNLOADING UBUNTU ROOTFS\n"
curl -o ubuntu.tar.gz https://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/ubuntu-base-22.04-base-arm64.tar.gz
tar xpvf ubuntu.tar.gz

#Setting up Ubuntu for first login
mkdir sdcard && mkdir dev/shm && cd ..
cp $CURRDIR/ssh-and-shit.sh $UBUNTUDIR/root/ssh-and-shit.sh && chmod +x ssh-and-shit.sh
cp $CURRDIR/setup.sh $UBUNTUDIR/root/setup.sh && chmod 777 setup.sh
cp $CURRDIR/startup.sh startup.sh && chmod +x startup.sh
rsync -av --remove-source-files $CURRDIR/pam.d/ $UBUNTUDIR/etc/pam.d/ #To fix "Required key not found" while using groupadd

#First Login
echo "AS SOON AS YOU SEE "root@localhost", RUN "bash setup.sh""
sh startup.sh

cp $CURRDIR/startup-new.sh /data/local/tmp/startup.sh