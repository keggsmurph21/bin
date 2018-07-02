#!/bin/bash -e

# NOTE: this script assumes no sudo privileges

clone_git_repo() {
	if [ ! -d $2 ]; then
		git clone https://github.com/$1/$2
	fi
}

cp ../config/.bash_profile ~

git config --global credential.helper cache
git config --global user.name "Kevin Murphy"
git config --global user.email "keggsmurph21@gmail.com"

mkdir -p ~/git ~/Applications ~/.bin
cd ~/git
clone_git_repo keggsmurph21 notatrix
clone_git_repo keggsmurph21 catonline
clone_git_repo keggsmurph21 etc
clone_git_repo jonorthwash ud-annotatrix

cd ~
if [ ! -d .nvm ]; then
	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
fi
. .bash_profile
nvm install v8.0

if [ ! -d ~/Applications/Sublime\ Text.app ]; then
	curl https://download.sublimetext.com/Sublime%20Tex%20Build%203176.dmg > /tmp/sublime.dmg
	open /tmp/sublime.dmg
	cp -r "/Volumes/Sublime Text/Sublime Text.app" ~/Applications
fi
ln -sf ~/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl ~/.bin/subl

