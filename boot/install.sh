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
GDRIVE=/media/$(whoami)/gdrive

# make directories
sudo mkdir $GDRIVE

# make some links
ln -s $BASE ~/persistent
ln -s "$GDRIVE/music/iTunes/iTunes Music/Music/" ~/library

# copy some files
sudo cp $BASE/boot/sources.list /etc/apt/sources.list
cp $BASE/boot/vplay /usr/local/bin

# basic apt tools
sudo apt update
sudo apt install -y git htop gparted python3 nodejs curl telnet hexchat vim

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
cd $BASE/git
git clone https://github.com/keggsmurph21/etc
git clone https://github.com/
