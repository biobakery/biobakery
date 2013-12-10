#! /usr/bin/env bash

# configure a new image as a biobakery

# ---------------------------------------------------------------
# constants
# ---------------------------------------------------------------

FOLDER_SETUP="$HOME/biobakery_setup"
FOLDER_DESKTOP="$HOME/Desktop"
FOLDER_HGCLONE="build_img_gui"
URL_BITBUCKET="

# ---------------------------------------------------------------
# set up new directories
# ---------------------------------------------------------------

mkdir $SETUP
chmod 777 $SETUP
cd $SETUP

# ---------------------------------------------------------------
# remove unnecessary (large) software files
# ---------------------------------------------------------------

sudo apt-get autoremove libreoffice thunderbird

# ---------------------------------------------------------------
# apt-get items from default ubuntu repos
# ---------------------------------------------------------------

# add virtualbox guest additions
# **** see: http://askubuntu.com/questions/22743/how-do-i-install-guest-additions-in-virtualbox ****
apt-get install build-essential linux-headers-`uname -r` dkms
apt-get install apt-get install virtualbox-ose-guest-x11

# add dev utilities
apt-get install mercurial git gdebi-core emacs24 gnome-open

# ---------------------------------------------------------------
# use mercurial to clone down the gui config files
# ---------------------------------------------------------------

# ---------------------------------------------------------------
# aesthetics
# ---------------------------------------------------------------

# get/place the readme file
wget -P $DESKTOP https://dl.dropboxusercontent.com/u/1391730/biobakery.png

# get/set the wallpaper centered with a black background
wget -P $SETUP https://dl.dropboxusercontent.com/u/1391730/biobakery.png
sudo -u $USER gsettings set org.gnome.desktop.background picture-uri "file://$SETUP/biobakery.png"
sudo -u $USER gsettings set org.gnome.desktop.background picture-options "centered"
sudo -u $USER gsettings set org.gnome.desktop.background primary-color "#000000"

# simplify the ubuntu launcher
sudo -u $USER gsettings set com.canonical.Unity.Launcher favorites "['application://nautilus-home.desktop', 'application://firefox.desktop', 'application://gnome-control-center.desktop', 'unity://running-apps', 'application://gnome-terminal.desktop', 'unity://expo-icon', 'unity://devices']"

# ---------------------------------------------------------------
# apt-get biobakery debs
# ---------------------------------------------------------------

#

# ---------------------------------------------------------------
# gdebi custom linked debs
# ---------------------------------------------------------------

wget https://www.dropbox.com/s/h3yvymrddo3yjb7/graphlan_071213_all.deb
wget https://www.dropbox.com/s/hx7epdvr44rgqqb/picrust_071213_all.deb
wget https://www.dropbox.com/s/uv4hg2opngj5i3i/metaphlan_071213_all.deb
gdebi graphlan_071213_all.deb
gdebi picrust_071213_all.deb
gdebi metaphlan_071213_all.deb
