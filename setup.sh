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

# "Lost Connection to API" fix for pi-hole
groupadd -g 3001 aid_bt
groupadd -g 3002 aid_bt_net
groupad -g 3005 aid_admin
usermod -a -G aid_bt,aid_bt_net,aid_inet,aid_net_raw,aid_admin root
usermod -a -G aid_bt,aid_bt_net,aid_inet,aid_net_raw,aid_admin www-data

echo -e "\n\n\n Ignore warnings saying symbolic symlinks, not so much of a problem"
sleep 10

#Update Ubuntu rootfs and install common softwares
yes | (apt update && apt upgrade)
yes | apt install curl sudo git net-tools openssh-client openssh-server

#Setup Timezone and user
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
read -p "Enter your username: " username
read -sp "Enter password for that username: " pswd

#Setup user
groupadd storage
groupadd wheel
useradd -m -g users -G wheel,audio,video,storage,aid_inet -s /bin/bash $username
echo "$username:$pswd" | chpasswd
echo "$username ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers

#Generate locales
apt install locales
locale-gen en_US.UTF-8
clear

#Change root password
printf "Changing password for root user\n"
read -sp "Enter password for root: " rootpaswd
echo "root:$rootpaswd" | chpasswd

#Disable snap beacuse it's Android
apt-get autopurge snapd

cat <<EOF | sudo tee /etc/apt/preferences.d/nosnap.pref
# To prevent repository packages from triggering the installation of Snap,
# this file forbids snapd from being installed by APT.
# For more information: https://linuxmint-user-guide.readthedocs.io/en/latest/snap.html
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

clear

# Pi-Hole installation
read -p "Do you want to install Pi-hole? (y/n): " answer
if [ "$answer" = "y" ]; then
    echo "TAP HERE AND MAKE SURE THAT YOUR KEYBOARD IS OPEN TO GIVE INPUT IN PI-HOLE INSTALLER" && sleep 10
    echo "Installing Pi-hole..."
    printf "When the installer asks for interface (eg: wlan0, ccni0, eth0 etc.) use termux's arrow keys to point at wlan0.\nThen press spacebar to select then continue."
    sleep 10
    curl -sSL https://install.pi-hole.net | bash
    usermod -a -G aid_bt,aid_bt_net,aid_inet,aid_net_raw,aid_admin pihole
elif [ "$answer" = "n" ]; then
    echo "Skipping Pi-hole installation."
else
    echo "Invalid response. Please enter 'y' or 'n'."
fi

su $username -c "ssh-keygen"
echo "Installation is complete!"
echo -e "Run "sh startup.sh" from /data/local/tmp directory"