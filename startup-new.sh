#!/bin/sh

# The path of Ubuntu rootfs
UBUNTUPATH="/data/local/tmp/ubuntu"
mkdir /dev/shm

# Fix setuid issue
busybox mount -o remount,dev,suid /data

busybox mount --bind /dev $UBUNTUPATH/dev
busybox mount --bind /sys $UBUNTUPATH/sys
busybox mount --bind /proc $UBUNTUPATH/proc
busybox mount -t devpts devpts $UBUNTUPATH/dev/pts

# /dev/shm for Electron apps
busybox mount -t tmpfs -o size=256M tmpfs $UBUNTUPATH/dev/shm

# Mount sdcard
busybox mount --bind /sdcard $UBUNTUPATH/sdcard

# chroot into Ubuntu
export username=$(cd $UBUNTUPATH/home && ls)
busybox chroot $UBUNTUPATH /bin/su - root -c "service lighttpd start && service ssh start && su $username && service pihole-FTL stop && service lighttpd stop && service ssh stop"

# Umount everything after exiting the shell. Because the graphical environment will be installed later, they are commented.
busybox umount $UBUNTUPATH/dev/shm
busybox umount $UBUNTUPATH/dev/pts
busybox umount $UBUNTUPATH/dev
busybox umount $UBUNTUPATH/proc
busybox umount $UBUNTUPATH/sys
busybox umount $UBUNTUPATH/sdcard
