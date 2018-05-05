#!/bin/sh

# install script for Debian-based systems

# get OS
OS=unknown
if uname -a | grep debian 1>/dev/null; then
	OS=debian
elif uname -a | grep ubuntu 1>/dev/null; then
	OS=ubuntu
fi

# make sure we have a constistent base path
BASE=/media/$(whoami)/live-rw
if [ ! -d $BASE ]; then
	# if we're here, we installed from boot/strap.sh
	BASE=~/boot
else
	ln -s $BASE/git/etc/boot $BASE/boot
	ln -s $BASE ~/persistent
fi

# set up external drive
GDRIVE=/media/$(whoami)/gdrive
sudo mkdir $GDRIVE
echo "UUID=b72752d1-28de-39d6-8156-5fa5eff84df2 $GDRIVE hfsplus ro 0 0" | sudo tee -a /etc/fstab > /dev/null
ln -s "$GDRIVE/music/iTunes/iTunes Music/Music/" ~/library 

# basic apt tools
if [ $OS=ubuntu ]; then
	sudo add-apt-repository universe
fi

echo "
deb http://download.videolan.org/pub/$OS/stable/ /
deb-src http://download.videolan.org/pub/$OS/stable/ /
" | sudo tee -a /etc/apt/sources.list > /dev/null
wget -O - http://download.videolan.org/pub/$OS/videolan-apt.asc | sudo apt-key add -

sudo apt update
sudo apt install -y curl git htop gparted python3 nodejs curl telnet hexchat vim libdvdcss2 python-pip tree
pip install --upgrade pip

# alias some stuff
echo "
# CUSTOM STUFF
alias node=nodejs
alias python=python3
alias vplay=$BASE/boot/vplay.sh
alias inet=\"ip address | grep inet\"
alias vu=\"amixer sset Master 5%+ 1>/dev/null\"
alias vd=\"amixer sset Master 5%- 1>/dev/null\"
alias vm=\"amixer sset Master 0% 1>/dev/null\"
alias la=\"ls -a\"
" >> ~/.bashrc
. ~/.bashrc

# more apt
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt install -y npm
sudo apt autoremove

# git stuff
git config --global credential.helper cache
git config --global user.email "keggsmurph21@gmail.com"
git config --global user.name "Kevin Murphy"

