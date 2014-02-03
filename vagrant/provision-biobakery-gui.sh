#! /usr/bin/env bash

# set up gui-specific biobakery pieces

# ---------------------------------------------------------------
# constants
# ---------------------------------------------------------------

FOLDER_SETUP="/vagrant/"
FOLDER_DESKTOP="/home/vagrant/Desktop"
FOLDER_TERMINAL_CONFIG="/home/vagrant/.gconf/apps/gnome-terminal/profiles/Default/"
FOLDER_WALLPAPER="/usr/share/backgrounds"
FILE_WALLPAPER="bioBakeryWallpaper.png"
FILE_README="WELCOME.pdf"
FILE_TERMINAL_CONFIG="%gconf.xml"
HIDDEN_DIR="/vagrant/.biobakery_internals/"

# ---------------------------------------------------------------
# add gui-specific modules
# ---------------------------------------------------------------

sudo apt-get update -y
sudo apt-get dist-upgrade --yes
# allows use to "trash" rather than "rm" files at the terminal
sudo apt-get install -y trash-cli
# adds an "open terminal here" option when right-clicking on/in a folder
sudo apt-get install -y nautilus-open-terminal

# ---------------------------------------------------------------
# turn base ubuntu into a gui ubuntu
# **** deprecate if we start from a prebuilt gui box ****
# ---------------------------------------------------------------

sudo apt-get install -y ubuntu-desktop
sudo apt-get autoremove -y --purge rhythmbox gnome-games libreoffice* thunderbird* gstreamer* bluez*
sudo apt-get purge -y

# ---------------------------------------------------------------
# gui configuration
# ---------------------------------------------------------------

# **** NOTE: This requires some special operations since there
# is no active login at the time of provisioning; that is what
# lightdm is taking care of (?) ****

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

# ---------------------------------------------------------------
# change dconf settings
# ---------------------------------------------------------------

function dchange () { sudo -iu vagrant bash -c " DISPLAY=:0 dconf write $1 $2 "; }
# don't go idle
dchange /org/gnome/session/idle-delay 0
# don't both me about software updates
dchange /apps/update-manager/remind-reload false
# don't show the lock screen
dchange /org/gnome/desktop/screensaver/lock-enabled false
# don't lock on suspend
dchange /org/gnome/desktop/screensaver/ubuntu-lock-on-suspend false
# don't go to sleep on ac power
dchange /org/gnome/settings-daemon/plugins/power/sleep-display-ac 0

# ---------------------------------------------------------------
# configure the wallpaper (custom image with black background)
# ---------------------------------------------------------------

mkdir -pv $FOLDER_WALLPAPER
cp -v $FOLDER_SETUP/$FILE_WALLPAPER $FOLDER_WALLPAPER/
function gset () { sudo -iu vagrant bash -c " DISPLAY=:0 gsettings set $1 $2 $3 "; }
gset org.gnome.desktop.background picture-uri "file://$FOLDER_WALLPAPER/$FILE_WALLPAPER"
gset org.gnome.desktop.background picture-options "centered"
gset org.gnome.desktop.background primary-color "\#000000"

# ---------------------------------------------------------------
# simplify the unity launcher to only have a few icons
# ---------------------------------------------------------------

echo "['application://nautilus-home.desktop', 'application://firefox.desktop', 'application://gnome-control-center.desktop', 'unity://running-apps', 'application://gnome-terminal.desktop', 'unity://expo-icon', 'unity://devices']" >> /tmp/unity-bar.txt
sudo -iu vagrant bash -c 'DISPLAY=:0 gsettings set com.canonical.Unity.Launcher favorites "$(cat /tmp/unity-bar.txt)"'

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
# et cetera
# ---------------------------------------------------------------

# copy the readme to the desktop
cp $FOLDER_SETUP/$FILE_README $FOLDER_DESKTOP/$FILE_README

# change terminal settings
mkdir -pv $FOLDER_TERMINAL_CONFIG
cp $FOLDER_SETUP/$FILE_TERMINAL_CONFIG $FOLDER_TERMINAL_CONFIG/$FILE_TERMINAL_CONFIG

# ---------------------------------------------------------------
# cleanup
# ---------------------------------------------------------------

sudo apt-get purge -y
sudo apt-get autoclean -y
