#!/bin/bash -e
#
# Kevin Murphy
# install script for Ubuntu-based systems
#

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
sudo apt install -y apt-transport-https
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
wget -qO - http://download.videolan.org/pub/$OS/videolan-apt.asc | sudo apt-key add -
cat $BASE/boot/config/sources.list | sed s/\$OS/$OS/g | sudo tee -a /etc/apt/sources.list > /dev/null
sudo -E bash $BASE/boot/config/install-npm@10.sh
sudo add-apt-repository universe
sudo apt update

# install stuff
sudo apt install -y `cat $BASE/boot/config/apt-pkgs | tr "\n" " "`
sudo apt install -y libdvdcss2
sudo apt -y autoremove
pip install --upgrade pip

# local bins
sudo cp $BASE/boot/scripts/vplay.sh /usr/local/bin/vplay

# hexchat config
mkdir -p ~/.config/hexchat
echo -n "IRC password: ";read -s password;echo
cat $BASE/boot/config/servlist.conf | sed s/\%\%PASSWORD\%\%/$password/g > ~/.config/hexchat/servlist.conf
cp $BASE/boot/config/hexchat.conf ~/.config/hexchat/

# bash config
cat $BASE/boot/config/.bashrc >> ~/.bashrc
. ~/.bashrc

# vim config
# nothing here yet :/

# git stuff
git config --global credential.helper cache
git config --global user.email "keggsmurph21@gmail.com"
git config --global user.name "Kevin Murphy"


hexchat &
