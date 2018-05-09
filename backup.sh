#!/bin/sh -ex

timestamp() {
  date +%Y%m%d-%H%M%S
}

BACKUPDIR="/Volumes/ /backups"
cd "$BACKUPDIR"

# documents
sudo cp -r ~/docs/* docs

# make tiemstamped directory
CURRENT=`timestamp`
sudo mkdir $CURRENT
cd $CURRENT

# package managers
sudo mkdir pkg-managers
cd pkg-managers

sudo find /Library /System /Users /usr /Applications -name *.app 2>/dev/null | grep -v Cellar | sudo tee apps.txt > /dev/null
brew list | sudo tee brew.txt > /dev/null
pip2 freeze 2>/dev/null | sudo tee pip2.txt > /dev/null
pip3 freeze 2>/dev/null | sudo tee pip3.txt > /dev/null
npm ls -g --depth=0 | sudo tee npm.txt > /dev/null
cargo install --list | sudo tee cargo.txt > /dev/null
gem list | sudo tee gem.txt > /dev/null
port installed | sudo tee port.txt > /dev/null

# other stuff?
