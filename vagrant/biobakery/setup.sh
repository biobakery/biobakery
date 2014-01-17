#!/bin/bash

# ---------------------------------------------------------------
# to-do list
# ---------------------------------------------------------------

# * Disable auto-update features
# * Make the terminal look nicer

# ---------------------------------------------------------------
# constants
# ---------------------------------------------------------------

URL_BITBUCKET="https://bitbucket.org/timothyltickle/biobakery"
FOLDER_SETUP="/vagrant/"
FOLDER_DESKTOP="/home/vagrant/Desktop"
FOLDER_TERMINAL_CONFIG="/home/vagrant/.gconf/apps/gnome-terminal/profiles/Default/"
FOLDER_WALLPAPER="/usr/share/backgrounds"
FILE_WALLPAPER="bioBakeryWallpaper.png"
FILE_README="WELCOME.pdf"
FILE_TERMINAL_CONFIG="%gconf.xml"
HIDDEN_DIR="/vagrant/.biobakery_internals/"

###
# Repository munging

sudo apt-get update -y
sudo apt-get dist-upgrade --yes

sudo apt-get install -y build-essential linux-headers-`uname -r` dkms
sudo apt-get install -y virtualbox-ose-guest-x11
sudo apt-get install -y virtualbox-guest-dkms virtualbox-guest-x11

sudo apt-get install -y mercurial git gdebi-core python-pip
sudo pip install setuptools --upgrade

sudo apt-get install -y trash-cli libgnome2-bin emacs24

# ---------------------------------------------------------------
# gui configuration
# ---------------------------------------------------------------

# transform the base box into a ubuntu desktop
#   get the package, then populate lightdm.conf
#   ensure proper permissions
#   then start up lightdm
sudo apt-get install -y ubuntu-desktop
sudo apt-get autoremove -y --purge rhythmbox gnome-games libreoffice* thunderbird* gstreamer* bluez*
sudo apt-get purge -y


f="/etc/lightdm/lightdm.conf"
mkdir -pv /etc/lightdm
sudo bash -c "cat - >> ${f}" <<EOF
[SeatDefaults]
greeter-session=unity-greeter
user-session=ubuntu
autologin-user=vagrant
EOF
chmod -v 644 "${f}"
chown -v root.root "${f}"

sudo service lightdm start

# copy the readme to the desktop
cp $FOLDER_SETUP/$FILE_README $FOLDER_DESKTOP/$FILE_README

# copy background image to appropriate place
mkdir -pv $FOLDER_WALLPAPER
cp -v $FOLDER_SETUP/$FILE_WALLPAPER $FOLDER_WALLPAPER/


# change terminal settings
mkdir -pv $FOLDER_TERMINAL_CONFIG
cp $FOLDER_SETUP/$FILE_TERMINAL_CONFIG $FOLDER_TERMINAL_CONFIG/$FILE_TERMINAL_CONFIG

# Change some settings with dconf
# Specifically: don't go idle, 
#               don't bother me with software updates, 
#               don't show the lock screen, 
#               don't lock on suspend, 
#               and don't go to sleep on AC power
function dchange () { sudo -iu vagrant bash -c " DISPLAY=:0 dconf write $1 $2 "; }
dchange /org/gnome/session/idle-delay                             0
dchange /apps/update-manager/remind-reload                        false
dchange /org/gnome/desktop/screensaver/lock-enabled               false
dchange /org/gnome/desktop/screensaver/ubuntu-lock-on-suspend     false
dchange /org/gnome/settings-daemon/plugins/power/sleep-display-ac 0

# Change some settings with gsettings
# get/set the wallpaper centered with a black background
# and simplify the ubuntu launcher
function gset () { sudo -iu vagrant bash -c " DISPLAY=:0 gsettings set $1 $2 $3 "; }
gset org.gnome.desktop.background picture-uri     "file://$FOLDER_WALLPAPER/$FILE_WALLPAPER"
gset org.gnome.desktop.background picture-options "centered"
gset org.gnome.desktop.background primary-color   "\#000000"

echo "['application://nautilus-home.desktop', 'application://firefox.desktop', 'application://gnome-control-center.desktop', 'unity://running-apps', 'application://gnome-terminal.desktop', 'unity://expo-icon', 'unity://devices']" >> /tmp/unity-bar.txt

sudo -iu vagrant bash -c 'DISPLAY=:0 gsettings set com.canonical.Unity.Launcher favorites "$(cat /tmp/unity-bar.txt)"'


cat - >> /home/vagrant/.bashrc <<EOF
# *** important ****
# this calls the trash program instead of rm, so you can get your work back!
alias rm="trash"
alias hardrm="/bin/rm"

# this prompts you if moving a file would replace existing file
alias mv="mv -i"
alias cp="cp -i"

# often used commands
alias open=gnome-open

# make emacs open in the terminal
alias emacs="emacs24 -nw"
EOF

# ---------------------------------------------------------------
# apt-get biobakery debs
# ---------------------------------------------------------------

# add custom repo to the sources lists
# **** note: special use of tee command to append to sources.list, since >> doesn't work in sudo context ****
echo "deb http://huttenhower.sph.harvard.edu/biobakery-shop/deb-packages ./" | sudo bash -c "cat - >> /etc/apt/sources.list "
sudo apt-get update

# install things from the repo
sudo apt-get install -y --force-yes metaphlan
sudo apt-get install -y --force-yes graphlan
#sudo apt-get install -y --force-yes picrust
sudo apt-get install -y --force-yes qiimetomaaslin
sudo apt-get install -y --force-yes humann
sudo apt-get install -y --force-yes micropita
# sudo apt-get install -y maaslin
sudo apt-get install -y --force-yes breadcrumbs 

# cleanup
sudo apt-get autoremove -y --force-yes
sudo apt-get purge -y --force-yes
sudo apt-get autoclean -y --force-yes

