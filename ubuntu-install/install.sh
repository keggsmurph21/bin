# since this is on an external drive, can't just give it +x permissions
# so run it like this:
# 
# $ cat install.sh | sudo sh

# points to the directory containing install files
path=/media/ubuntu/KEVIN/ubuntu-install

# basic stuff
sudo mv /etc/apt/sources.list /etc/apt/sources.list.backup
sudo cp "${path}/sources.list" /etc/apt/sources.list
sudo apt update
sudo apt install -y vim git curl htop hexchat
cd ~

# node
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
sudo apt install -y nodejs

# git config
git config --global user.email 'keggsmurph21@gmail.com'
git config --global user.name 'Kevin Murphy'
git config --global credential.helper cache

# get some repos
git clone https://github.com/keggsmurph21/etc
git clone https://github.com/jonorthwash/ud-annotatrix
#git clone https://github.com/keggsmurph21/catonline

# hexchat config
cp -r "${path}/hexchat" ~/.config/hexchat
hexchat &

# set up g-drive/music stuff
sudo add-apt-repository -y ppa:videolan/stable-daily
sudo apt install -y lame vlc
ln -s /media/ubuntu/b72752d1-28de-39d6-8156-5fa5eff84df2/music/iTunes/iTunes\ Music/Music/ library
sudo cp "${path}/vplay" /usr/local/bin
sudo chmod +x /usr/local/bin/vplay

# keyboard bindings
CKB_PATH=org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings

gsettings set "${CKB_PATH}/custom0/" name 'custom-mute-vol'
gsettings set "${CKB_PATH}/custom0/" binding 'F10'
gsettings set "${CKB_PATH}/custom0/" command 'amixer -D pulse sset Master 0%'

gsettings set "${CKB_PATH}/custom1/" name 'custom-decr-vol'
gsettings set "${CKB_PATH}/custom1/" binding 'F11'
gsettings set "${CKB_PATH}/custom1/" command 'amixer set Master playback 3dB-'

gsettings set "${CKB_PATH}/custom2/" name 'custom-incr-vol'
gsettings set "${CKB_PATH}/custom2/" binding 'F12'
gsettings set "${CKB_PATH}/custom2/" command 'amixer set Master playback 3dB+'

