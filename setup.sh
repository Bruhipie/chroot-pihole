#!/usr/bin/env bash

#To fix "apt cannot resolve hosts" error
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "127.0.0.1 localhost" > /etc/hosts

#Fix "Download is performed unsandboxed as root"
groupadd -g 3003 aid_inet
groupadd -g 3004 aid_net_raw
groupadd -g 1003 aid_graphics
usermod -g 3003 -G 3003,3004 -a _apt
usermod -G 3003 -a root

#Update Ubuntu rootfs and install common softwares
apt update && apt upgrade
apt install sudo git net-tools

#Setup Timezone and user
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
read -p "Enter your username: " username
read -sp "Enter password for that username: " pswd

#Setup user
groupadd storage
groupadd wheel
useradd -m -g users -G wheel,audio,video,storage,aid_inet -s /bin/bash $username
echo $pswd | passwd --stdin $username
echo '$username ALL=(ALL:ALL) ALL' | sudo EDITOR='tee -a' visudo

#Going into user
su $username && cd ~

#Generate locales
sudo apt install locales
sudo locale-gen en_US.UTF-8

#Installing SSH
sudo apt install openssh-client openssh-server
printf "\nChanging password for root user\n"
passwd root
ssh-keygen

#Disabling Snap packages
apt-get autopurge snapd

cat <<EOF | sudo tee /etc/apt/preferences.d/nosnap.pref
# To prevent repository packages from triggering the installation of Snap,
# this file forbids snapd from being installed by APT.
# For more information: https://linuxmint-user-guide.readthedocs.io/en/latest/snap.html
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

echo "Installation is complete!"
echo -e "Exit chroot once and then after run "sh startup.sh" from /data/local/tmp directory"