# chroot-pihole
> **NOTE**: This is not an un-attended installation, you have to provide some inputs.

## Requirements
- A rooted Android Device
- Working brain and internet.
- [Magisk Busybox Module](https://github.com/Magisk-Modules-Alt-Repo/BuiltIn-BusyBox/releases)

## Installation
1. Install [termux](https://github.com/termux/termux-app/releases) and install git using:  
    `yes | pkg update && pkg install git`
2. Clone this repo:  
    `git clone https://github.com/Bruhipie/chroot-pihole.git`
3. Run the install.sh file inside the directory:  
    `cd chroot-pihole && su -c "sh install.sh"`
4. Wait, you may have to provide some inputs.
5. Profit.

## To-Do
1. Desktop Environment with VS-Code

## Credits
- [IvonBlogs](https://ivonblog.com/en-us/posts/termux-chroot-ubuntu/) :-
Almost all the code was written by him and i have just added some fix and removed desktop-environment part
- [BDHackers009](https://github.com/modded-ubuntu/modded-ubuntu) :-
For giving me an idea on using themes. (Not yet implemented)