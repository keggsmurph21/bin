#!/bin/sh -ex

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
	BASE=~
else
	ln -s $BASE ~/persistent
fi

# set up external drive
GDRIVE=/media/$(whoami)/gdrive
sudo mkdir $GDRIVE
echo "UUID=b72752d1-28de-39d6-8156-5fa5eff84df2 $GDRIVE hfsplus ro 0 0" | sudo tee -a /etc/fstab > /dev/null
ln -s "$GDRIVE/music/iTunes/iTunes Music/Music/" ~/library

# basic apt tools
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt update
sudo apt install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee -a /etc/apt/sources.list > /dev/null
if [ "$OS" = "ubuntu" ]; then
	sudo add-apt-repository universe
#elif [ "$OS" = "debian" ]; then
fi

echo "
deb http://download.videolan.org/pub/$OS/stable/ /
deb-src http://download.videolan.org/pub/$OS/stable/ /
" | sudo tee -a /etc/apt/sources.list > /dev/null
wget -O - http://download.videolan.org/pub/$OS/videolan-apt.asc | sudo apt-key add -
sudo apt update

# install stuff
sudo apt install -y curl git htop gparted python3 nodejs curl telnet hexchat vim libdvdcss2 python-pip tree cmatrix lame sublime-text
pip install --upgrade pip
sudo cp $BASE/boot/scripts/vplay.sh /usr/local/bin/vplay
mkdir -p ~/.config/hexchat
sudo cp $BASE/boot/config/hexchat.conf ~/.config/hexchat/

# alias some stuff
echo "
# CUSTOM STUFF
alias node=nodejs
alias python=python3
alias inet=\"ip address | grep inet\"
alias vu=\"amixer sset Master 5%+ > /dev/null\"
alias vd=\"amixer sset Master 5%- > /dev/null\"
alias vm=\"amixer sset Master 0% > /dev/null\"
alias ls=\"ls -a\"
" >> ~/.bashrc
. ~/.bashrc

# more apt
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt install -y npm
sudo apt -y autoremove

# git stuff
git config --global credential.helper cache
git config --global user.email "keggsmurph21@gmail.com"
git config --global user.name "Kevin Murphy"

# desktop setup
#if [ "$XDG_CURRENT_DESKTOP" = "XFCE" ]; then

	# make our panel look nice :)
	#cp xfce4-panel.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/
	#pkill -KILL -u $(whoami)

exit
if [ ! pgrep -f gnome ]; then # not sure if need the ! or not ..?

	# set up some gnome keyboard bindings
	KB=org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings

	gsettings set "$KB/custom0/" name 'custom-mute-vol'
	gsettings set "$KB/custom0/" binding 'F10'
	gsettings set "$KB/custom0/" command 'amixer -D pulse sset Master 0%'

	gsettings set "$KB/custom1/" name 'custom-decr-vol'
	gsettings set "$KB/custom1/" binding 'F11'
	gsettings set "$KB/custom1/" command 'amixer set Master playback 3dB-'

	gsettings set "$KB/custom2/" name 'custom-incr-vol'
	gsettings set "$KB/custom2/" binding 'F12'
	gsettings set "$KB/custom2/" command 'amixer set Master playback 3dB+'

	gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/']"

fi

hexchat &
