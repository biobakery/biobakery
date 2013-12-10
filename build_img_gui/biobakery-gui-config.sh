#! /usr/bin/env bash

# running this turns a linux install into a gui'ed biobakery

# ---------------------------------------------------------------
# constants
# ---------------------------------------------------------------

UNAME=$USER
FOLDER_SETUP="$HOME/biobakery_setup"
FOLDER_DESKTOP="$HOME/Desktop"
FOLDER_BUILD="build_img_gui"
URL_BITBUCKET="https://bitbucket.org/timothyltickle/biobakery/src/$FOLDER_BUILD"
FILE_WALLPAPER="$FOLDER_SETUP/$FOLDER_BUILD/bioBakeryWallpaper.png"
FILE_BASHRC="$FOLDER_SETUP/$FOLDER_BUILD/bashrc"

# ---------------------------------------------------------------
# set up new directories
# ---------------------------------------------------------------

mkdir $SETUP
chmod 777 $SETUP
cd $SETUP

# ---------------------------------------------------------------
# work with standard ubuntu repos
# ---------------------------------------------------------------

# remove unnecessary big installs
sudo apt-get autoremove libreoffice thunderbird

# add virtualbox guest additions
# **** see: http://askubuntu.com/questions/22743/how-do-i-install-guest-additions-in-virtualbox ****
apt-get install build-essential linux-headers-`uname -r` dkms
apt-get install apt-get install virtualbox-ose-guest-x11

# add dev utilities
apt-get install mercurial git gdebi-core 

# add general linux utilities
apt-get install emacs24 gnome-open trash-cli

# ---------------------------------------------------------------
# gui configuration
# ---------------------------------------------------------------

# clone down files
hg clone $URL_BITBUCKET

# get/place the readme file
# wget -P $DESKTOP https://dl.dropboxusercontent.com/u/1391730/biobakery.png

# get/set the wallpaper centered with a black background
# wget -P $SETUP https://dl.dropboxusercontent.com/u/1391730/biobakery.png
sudo -iu $UNAME sh -c 'gsettings set org.gnome.desktop.background picture-uri "file://$FILE_WALLPAPER"'
sudo -iu $UNAME sh -c 'gsettings set org.gnome.desktop.background picture-options "centered"'
sudo -iu $UNAME sh -c 'gsettings set org.gnome.desktop.background primary-color "#000000"'

# simplify the ubuntu launcher
LAUNCHER="['application://nautilus-home.desktop', 'application://firefox.desktop', 'application://gnome-control-center.desktop', 'unity://running-apps', 'application://gnome-terminal.desktop', 'unity://expo-icon', 'unity://devices']"
sudo -iu $UNAME sh -c "gsettings set com.canonical.Unity.Launcher favorites $LAUNCHER"

# replace the buildin bashrc file
mv $FILE_BASHRC $HOME/.bashrc
source $HOME/.bashrc

# ---------------------------------------------------------------
# apt-get biobakery debs
# ---------------------------------------------------------------

# add custom repo to the sources lists
# echo "deb http://biobakery.bitbucket.org/deb-packages ./" >> /etc/apt-sources.list

#

# ---------------------------------------------------------------
# gdebi custom linked debs
# ---------------------------------------------------------------

#wget https://www.dropbox.com/s/h3yvymrddo3yjb7/graphlan_071213_all.deb
#wget https://www.dropbox.com/s/hx7epdvr44rgqqb/picrust_071213_all.deb
#wget https://www.dropbox.com/s/uv4hg2opngj5i3i/metaphlan_071213_all.deb
#gdebi graphlan_071213_all.deb
#gdebi picrust_071213_all.deb
#gdebi metaphlan_071213_all.deb
