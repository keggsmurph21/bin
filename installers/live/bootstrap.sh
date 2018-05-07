#!/bin/sh

set -e 

usage() {
	echo "unsupported distribution \"$1\", please choose one of (arch, debian, redhat)"
	exit 1
}

if [ -z $1 ]; then
	usage "<not set>"
elif [ $1 = arch ] || [ $1 = debian ] || [ $1 = redhat ]; then
	echo "bootstrapping installation for $1-based distribution"
else
	usage $1
fi

# get the install files
URL=https://raw.githubusercontent.com/keggsmurph21/etc/master/installers/live
mkdir ~/boot
cd ~/boot
wget -O - $URL/$1.sh > install.sh 2> /dev/null
wget -O - $URL/vplay.sh > vplay.sh 2> /dev/null
sudo chmod 0755 install.sh vplay.sh

# do the install
. install.sh

# clean up
cd ..
rm strap.sh

