# since this is on an external drive, can't just give it +x permissions
# so run it like this:
# 
# $ cat install.sh | sudo sh

# basic stuff
sudo apt update
mv /etc/apt/sources.list /etc/apt/sources.list.backup
cp /media/ubuntu/KEVIN/sources.list /etc/apt/sources.list
sudo apt install -y vim git curl htop

# node
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
sudo apt install -y nodejs

# get most recent versions of some git repos
cd ~
git config --global user.email 'keggsmurph21@gmail.com'
git config --global user.name 'Kevin Murphy'
git config --global credential.helper cache

git clone https://github.com/keggsmurph21/etc
sudo chmod 777 etc
#git clone https://github.com/jonorthwash/ud-annotatrix
#chmod 777 ud-annotatrix
#git clone https://github.com/keggsmurph21/catonline
#chmod 777 catonline
#git clone https://github.com/keggsmurph21/etc
#chmod 777 etc

# set up g-drive/music stuff
sudo add-apt-repository -y ppa:videolan/stable-daily
sudo apt install -y lame vlc
ln -s /media/ubuntu/b72752d1-28de-39d6-8156-5fa5eff84df2/music/iTunes/iTunes\ Music/Music/ library
sudo cp /media/ubuntu/KEVIN/vplay /usr/local/bin
sudo chmod +x /usr/local/bin/vplay

# keyboard bindings
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'custom-mute-volume'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding 'F10'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'amixer -D pulse sset Master 0%'

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'custom-decr-volume'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding 'F11'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'amixer set Master playback 3dB-'

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'custom-incr-volume'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding 'F12'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 'amixer set Master playback 3dB+'

