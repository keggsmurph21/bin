#!/bin/bash -e
#
# Kevin Murphy 
# install script for Debian-based systems
#

# get OS
if uname -a | grep debian >/dev/null; then
	OS=debian
elif uname -a | grep ubuntu >/dev/null; then
	OS=ubuntu
else
	echo "supported distributions: jessie (debian@8), artful (ubuntu@17)"
	exit 1
fi

# make sure we have a constistent base path
export BASE=/media/$(whoami)/live-rw
if [ ! -d $BASE ]; then
	# if we're here, we installed from boot/strap.sh
	BASE=~
else
	ln -sf $BASE ~/persistent
fi

# set up external drive
GDRIVE=/media/$(whoami)/gdrive
sudo mkdir -p $GDRIVE
echo "UUID=b72752d1-28de-39d6-8156-5fa5eff84df2 $GDRIVE hfsplus ro 0 0" | sudo tee -a /etc/fstab > /dev/null
ln -sf "$GDRIVE/music/iTunes/iTunes Music/Music/" ~/library

# basic apt setup
sudo apt update
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
wget -qO - http://download.videolan.org/pub/$OS/videolan-apt.asc | sudo apt-key add -
cat $BASE/config/sources.list | sudo tee -a /etc/apt/sources.list > /dev/null
sudo -E bash $BASE/config/install-npm@10.sh  # also gets the apt-transport-https
if [ "$OS" = "ubuntu" ]; then
	sudo add-apt-repository universe
#elif [ "$OS" = "debian" ]; then
fi
sudo apt update

# install stuff
sudo apt install -y `cat $BASE/config/apt-pkgs | tr "\n" " "`
sudo apt -y autoremove
pip install --upgrade pip

# various config stuff
sudo cp $BASE/boot/scripts/vplay.sh /usr/local/bin/vplay
mkdir -p ~/.config/hexchat
sudo cp $BASE/boot/config/hexchat.conf ~/.config/hexchat/
cat $BASE/config/.bashrc >> ~/.bashrc
. ~/.bashrc

# git stuff
git config --global credential.helper cache
git config --global user.email "keggsmurph21@gmail.com"
git config --global user.name "Kevin Murphy"

# desktop setup
if [ "$XDG_CURRENT_DESKTOP" = "XFCE" ]; then
	bash $BASE/desktops/xfce.sh
elif [ ! pgrep -f gnome ]; then
	bash $BASE/desktops/gnome.sh
else
	echo "unrecognized desktop environment"
	exit 1
fi

hexchat &
