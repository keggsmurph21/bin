#!/bin/bash -ex

get_url() {
	file=`echo $1 | sed s_\"installers/live/__g | sed s_\"\,__g`
	echo " - getting file '$file'" >&2
	wget -qO - https://raw.githubusercontent.com/keggsmurph21/etc/master/installers/live/$file > $file
}

# get OS
if uname -a | grep debian >/dev/null; then
	OS=debian
elif uname -a | grep ubuntu >/dev/null; then
	OS=ubuntu
else
	echo "Note: you are trying to install from an unsupported distribution ..."
	echo "  available distros: arch*, debian, redhat*, ubuntu" >&2
	exit 1
fi

# get DE
if [ "$XDG_CURRENT_DESKTOP" = "XFCE" ]; then
	DE=xfce
elif [ ! pgrep -f gnome ]; then
	DE=gnome
else
	echo "Note: you are trying to install from an unsupported desktop environment ..." >&2
	echo "  available DEs: gnome, kde*, xfce" >&2
	exit 2
fi

mkdir -p ~/boot/config ~/boot/scripts
cd ~/boot

# get the install files
get_url "$OS.sh"
get_url "$DE.sh"

# get the config files
wget -qO - https://api.github.com/repos/keggsmurph21/etc/git/trees/master?recursive=1 > /tmp/git-etc
for line in `cat /tmp/git-etc`; do
	if echo "$line" | grep installers/config/ >/dev/null; then
		get_url $line
	elif echo "$line" | grep installers/scripts/ >/dev/null; then
		get_url $line
	fi
done;

# add exec permissions
sudo chmod 755 scripts/*.sh

# do the install
echo "installing for '$OS:$DE'" >&2
. $OS.sh && . $DE.sh

# clean up
cd ..
rm -rf boot
