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

echo -e "\n\n\n Ignore warnings saying symbolic symlinks, not so much of a problem"
sleep 10

#Update Ubuntu rootfs and install common softwares
yes | (apt update && apt upgrade)
yes | apt install sudo git net-tools

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

#Going into user
chmod 777 ssh-and-shit.sh
su $username -c "bash ssh-and-shit.sh"