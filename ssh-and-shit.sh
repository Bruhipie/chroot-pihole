#!/usr/bin/env bash

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