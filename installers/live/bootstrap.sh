#!/bin/sh -ex

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
wget -O - $URL/$1.sh > $1.sh 2> /dev/null
wget -O - $URL/scripts/vplay.sh | sudo tee /usr/local/bin/vplay > /dev/null
sudo chmod 0755 $1.sh /usr/local/bin/vplay

# do the install
sh $1.sh

# clean up
cd ..
rm -rf boot

