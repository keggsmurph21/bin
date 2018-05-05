#!/bin/sh



# get the install files
URL=https://raw.githubusercontent.com/keggsmurph21/etc/master/boot
mkdir ~/boot
cd ~/boot
wget $URL/install.sh
wget $URL/vplay.sh

# do the install
. install.sh

