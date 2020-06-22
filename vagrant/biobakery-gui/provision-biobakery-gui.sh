#! /usr/bin/env bash

# set up gui-specific biobakery pieces
# =======
# Authors:
# Randall Schwager (randall.schwager@gmail.com)
# Eric Franzosa (eric.franzosa@gmail.com)

# update all packages
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade --yes

# ---------------------------------------------------------------
# constants
# ---------------------------------------------------------------

FOLDER_SETUP="/vagrant/"
FOLDER_DESKTOP="/home/vagrant/Desktop"
FOLDER_TERMINAL_CONFIG="/home/vagrant/.gconf/apps/gnome-terminal/profiles/Default/"
FOLDER_WALLPAPER="/usr/share/backgrounds"

FILE_WALLPAPER="bioBakeryWallpaper.png"
FILE_WELCOME="WELCOME.pdf"

DCONF_USER="user"
DCONF_DB="00-background"
GDM_CONFIG="custom.conf"

HIDDEN_DIR="/vagrant/.biobakery_internals/"

# ---------------------------------------------------------------
# add/remove gui-specific modules
# ---------------------------------------------------------------

# the actual desktop (commented out if we're starting from a custom box)
sudo apt-get install -y ubuntu-desktop
# allows use to "trash" rather than "rm" files at the terminal
sudo apt-get install -y trash-cli
# remove unnecessary components
sudo apt-get autoremove -y --purge rhythmbox gnome-games libreoffice* thunderbird* gstreamer* bluez*
# add pdf viewer
sudo apt-get install evince -y

# ---------------------------------------------------------------
# username/hostname configuration
# ---------------------------------------------------------------

sudo sh -c 'echo "biobakery" > /etc/hostname'
hostname 'biobakery'
sudo sed -i.bac -e 's| vagrant.*| biobakery|g' /etc/hosts
sudo sh -c 'echo "127.0.0.1 biobakery" >> /etc/hosts'

# ---------------------------------------------------------------
# gnome configuration:
# configure the wallpaper (custom image with black background)
# and other custom gui settings
# ---------------------------------------------------------------

mkdir -pv $FOLDER_WALLPAPER
cp -v $FOLDER_SETUP/$FILE_WALLPAPER $FOLDER_WALLPAPER/

sudo cp -v $FOLDER_SETUP/$DCONF_USER /etc/dconf/profile/
sudo mkdir -p /etc/dconf/db/local.d
sudo cp -v $FOLDER_SETUP/$DCONF_DB /etc/dconf/db/local.d/
sudo dconf update
sudo cp -v $FOLDER_SETUP/$GDM_CONFIG /etc/gdm3/

sudo service gdm3 start

# ---------------------------------------------------------------
# place custom files
# ---------------------------------------------------------------

# copy the readme to the desktop 
sudo -u vagrant mkdir -p $FOLDER_DESKTOP
sudo -u vagrant cp $FOLDER_SETUP/$FILE_WELCOME $FOLDER_DESKTOP/$FILE_WELCOME

# ---------------------------------------------------------------
# configure the user's .bashrc (controls terminal functions) 
# ---------------------------------------------------------------

cat - >> /home/vagrant/.bashrc <<EOF
# this calls the trash program instead of rm, so you can get your work back!
alias rm="trash"
alias hardrm="/bin/rm"

# this prompts you if moving a file would replace existing file!
alias mv="mv -i"
alias cp="cp -i"

# open a file in whatever its default opener would be (e.g. *.pdf -> pdf viewer)
alias open=gnome-open

# make emacs open in the terminal
alias emacs="emacs24 -nw"
EOF

# ---------------------------------------------------------------
# cleanup
# ---------------------------------------------------------------

sudo apt-get autoremove -y
sudo apt-get purge -y
sudo apt-get autoclean -y
