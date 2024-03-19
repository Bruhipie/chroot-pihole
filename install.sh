#!/bin/sh

#Initializing updates and chroot folder
yes | pkg update && pkg install tsu
su -c "sh root.sh"