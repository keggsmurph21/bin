#!/bin/bash -e

usage() {
	echo "unsupported distribution \"$1\", please choose one of (arch, debian, redhat)" >&2
	exit 1
}

get_url() {
	echo " - getting file '$1'" >&2
	wget -qO - https://raw.githubusercontent.com/keggsmurph21/etc/master/installers/live/$1 > $1
}

if [ -z $1 ]; then
	usage "<not set>"
elif [ $1 = arch ] || [ $1 = debian ] || [ $1 = redhat ]; then
	echo "bootstrapping installation for distribution '$1'" >&2
else
	usage $1
fi

mkdir -p ~/boot/config ~/boot/scripts ~/boot/desktops
cd ~/boot

# get the install files
get_url "$1.sh"
get_url config/.bashrc
get_url config/apt-pkgs
get_url config/hexchat.conf
get_url config/install-npm@10.sh
get_url config/sources.list
get_url desktops/gnome.sh
get_url desktops/kde.sh
get_url desktops/xfce.sh
get_url desktops/xfce4-panel.xml
get_url scripts/vplay.sh
sudo chmod 755 config/*.sh desktops/*.sh scripts/*.sh

# do the install
echo "installing for distribution '$1'" >&2
bash $1.sh

# clean up
cd ..
rm -rf boot
