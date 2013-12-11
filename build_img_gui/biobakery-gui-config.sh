#! /usr/bin/env bash

# running this turns a linux install into a gui'ed biobakery
# **** makes major changes; do not run on your main computer ****

# ---------------------------------------------------------------
# to-do list
# ---------------------------------------------------------------

# * Disable auto-update features
# * Make the terminal look nicer

# ---------------------------------------------------------------
# constants
# ---------------------------------------------------------------

URL_BITBUCKET="https://bitbucket.org/timothyltickle/biobakery"
FOLDER_SETUP="$HOME/biobakery/build_img_gui"
FOLDER_DESKTOP="$HOME/Desktop"
FOLDER_TERMINAL_CONFIG="$HOME/.gconf/apps/gnome-terminal/profiles/Default/"
FILE_WALLPAPER="bioBakeryWallpaper.png"
FILE_BASHRC="bashrc"
FILE_README="WELCOME.pdf"
FILE_TERMINAL_CONFIG="%gconf.xml"

# ---------------------------------------------------------------
# work with standard ubuntu repos
# ---------------------------------------------------------------

# remove built-ins that we don't want
sudo apt-get autoremove --purge libreoffice* thunderbird*

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

# change terminal settings
cp $FOLDER_SETUP/$FILE_TERMINAL_CONFIG $FOLDER_TERMINAL_CONFIG/$FILE_TERMINAL_CONFIG

# ---------------------------------------------------------------
# apt-get biobakery debs
# ---------------------------------------------------------------

# add custom repo to the sources lists
# **** note: special use of tee command to append to sources.list, since >> doesn't work in sudo context ****
echo "deb http://biobakery.bitbucket.org/deb-packages ./" | sudo tee -a /etc/apt/sources.list
sudo apt-get update

# install things from the repo
sudo apt-get install qiimetomaaslin
sudo apt-get install humann
sudo apt-get install micropita
# sudo apt-get install maaslin
# sudo apt-get install breadcrumbs 

# ---------------------------------------------------------------
# gdebi custom linked debs
# ---------------------------------------------------------------

# wget from dropbox
wget https://www.dropbox.com/s/6p3nbxp70ok1ww0/metaphlan_111213_all.deb
wget https://www.dropbox.com/s/77hlhwrziionidy/picrust_111213_all.deb
wget https://www.dropbox.com/s/3u8j5zvxseuc2hk/graphlan_111213_all.deb

# install with dependencies
sudo gdebi metaphlan_111213_all.deb
sudo gdebi graphlan_111213_all.deb
sudo gdebi picrust_111213_all.deb

# cleanup
rm *.deb
