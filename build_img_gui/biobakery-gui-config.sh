#! /usr/bin/env bash

# running this turns a linux install into a gui'ed biobakery

# ---------------------------------------------------------------
# constants
# ---------------------------------------------------------------

URL_BITBUCKET="https://bitbucket.org/timothyltickle/biobakery"
FOLDER_SETUP="$HOME/biobakery/build_img_gui"
FOLDER_DESKTOP="$HOME/Desktop"
FILE_WALLPAPER="bioBakeryWallpaper.png"
FILE_BASHRC="bashrc"
FILE_README="README.html"

# ---------------------------------------------------------------
# work with standard ubuntu repos
# ---------------------------------------------------------------

# remove built-ins that we don't want
sudo apt-get autoremove libreoffice* thunderbird* update-manager

# add virtualbox guest additions
# **** see: http://askubuntu.com/questions/22743/how-do-i-install-guest-additions-in-virtualbox ****
sudo apt-get install build-essential linux-headers-`uname -r` dkms
sudo apt-get install virtualbox-ose-guest-x11

# add dev utilities
sudo apt-get install mercurial git gdebi-core python-pip

# add general linux utilities
sudo apt-get install trash-cli libgnome2-bin emacs24

# ---------------------------------------------------------------
# gui configuration
# ---------------------------------------------------------------

# hg clone bitbucket repo to get config files (e.g., wallpaper)
cd $HOME
hg clone $URL_BITBUCKET

# get/set the wallpaper centered with a black background
gsettings set org.gnome.desktop.background picture-uri "file://$FOLDER_SETUP/$FILE_WALLPAPER"
gsettings set org.gnome.desktop.background picture-options "centered"
gsettings set org.gnome.desktop.background primary-color "#000000"

# simplify the ubuntu launcher
gsettings set com.canonical.Unity.Launcher favorites "['application://nautilus-home.desktop', 'application://firefox.desktop', 'application://gnome-control-center.desktop', 'unity://running-apps', 'application://gnome-terminal.desktop', 'unity://expo-icon', 'unity://devices']"

# copy the readme to the desktop
cp $FOLDER_SETUP/$FILE_README $FOLDER_DESKTOP/$FILE_README

# replace the builtin bashrc file
# **** won't take effect until terminal restart ****
cp $FOLDER_SETUP/$FILE_BASHRC $HOME/.bashrc

# ---------------------------------------------------------------
# apt-get biobakery debs
# ---------------------------------------------------------------

# add custom repo to the sources lists
# **** note: special use of tee command to append to sources.list, since >> doesn't work in sudo context ****
echo "deb http://biobakery.bitbucket.org/deb-packages ./" | sudo tee -a /etc/apt/sources.list
sudo apt-get update

# install things from the repo
sudo apt-get install qiimetomaaslin
sudo apt-get install breadcrumbs 
sudo apt-get install graphlan
sudo apt-get install humann
sudo apt-get install micropita

# ---------------------------------------------------------------
# gdebi custom linked debs
# ---------------------------------------------------------------

#wget https://www.dropbox.com/s/h3yvymrddo3yjb7/graphlan_071213_all.deb
#wget https://www.dropbox.com/s/hx7epdvr44rgqqb/picrust_071213_all.deb
#wget https://www.dropbox.com/s/uv4hg2opngj5i3i/metaphlan_071213_all.deb
#gdebi graphlan_071213_all.deb
#gdebi picrust_071213_all.deb
#gdebi metaphlan_071213_all.deb
