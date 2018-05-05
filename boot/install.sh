#!/bin/sh

# install script for Debian-based systems

# get OS
OS=unknown
if uname -a | grep debian 1>/dev/null; then
	OS=debian
elif uname -a | grep ubuntu 1>/dev/null; then
	OS=ubuntu
fi

BASE=/media/$(whoami)/live-rw
if [ ! -d $BASE ]; then
	# if we're here, we installed from boot/strap.sh
	$BASE=~/boot
else
	ln -s $BASE/git/etc/boot $BASE/boot
	ln -s $BASE ~/persistent
fi
GDRIVE=/media/$(whoami)/gdrive

# make directories
sudo mkdir $GDRIVE

# make some links
ln -s "$GDRIVE/music/iTunes/iTunes Music/Music/" ~/library

# copy some files

# basic apt tools
if [ $OS=ubuntu ]; then
	sudo add-apt-repository universe
fi
sudo apt update
sudo apt install -y curl git htop gparted python3 nodejs curl telnet hexchat vim

# alias some stuff
echo "
# CUSTOM STUFF
alias node=nodejs
alias python=python3
alias vplay=$BASE/boot/vplay.sh
alias inet=\"ip address | grep inet\"" >> ~/.bashrc

# more apt
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt install -y npm

# git stuff
git config --global credential.helper cache
git config --global user.email "keggsmurph21@gmail.com"
git config --global user.name "Kevin Murphy"

