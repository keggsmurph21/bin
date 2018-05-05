#!/bin/sh



# get the install files
URL=https://raw.githubusercontent.com/keggsmurph21/etc/master/boot
mkdir ~/boot
cd ~/boot
wget $URL/install.sh
wget $URL/vplay.sh
sudo chmod 0755 install.sh vplay.sh

# do the install
. install.sh

# clean up
cd ..
rm strap.sh

