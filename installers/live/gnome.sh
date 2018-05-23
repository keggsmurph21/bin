#!/bin/bash -e

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
