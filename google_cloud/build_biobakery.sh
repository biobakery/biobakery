#! /usr/bin/env bash

# This file will provision an image of Ubuntu 16.04 (Xenial Xerus) with bioBakery.
# This is based on the core bioBakery provisions file used with vagrant.

# ---------------------------------------------------------------
# install and update required packages
# ---------------------------------------------------------------

# update all packages
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade --yes

# packages required for deb building and installation
sudo apt-get install -y mercurial git gdebi-core python-pip
sudo pip install setuptools --upgrade

# install dos2unix
sudo apt-get install dos2unix -y

# ---------------------------------------------------------------
# install biobakery suite with homebrew
# ---------------------------------------------------------------

# install dependencies for homebrew
sudo apt-get install -y ruby-full

# install the latest version of r
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu xenial/'
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -
sudo apt-get update
sudo apt-get install r-base -y


# install dependencies for numpy and matplotlib
sudo apt-get install -y python2.7-dev pkg-config

# install java openjdk for biobakery tools
sudo apt-get install -y openjdk-8-jre

# install homebrew, not as root as no longer allowed as of Nov 2016
# then update to get the latest version
# next move executable/library so install (plus Cellar when added) is in /usr/local/bin
# this is the location required to use bottles
sudo git clone https://github.com/Linuxbrew/linuxbrew.git /opt/linuxbrew
sudo /opt/linuxbrew/bin/brew update
sudo mv /opt/linuxbrew/bin/brew /usr/local/bin/
sudo mv /opt/linuxbrew/Library /usr/local/
sudo chown -R $(whoami) /usr/local/

# install freetype dependency which needs to be installed
# from source (instead of a bottle) for this platform
brew install freetype --build-from-source

# add the biobakery tool formulas
brew tap biobakery/biobakery

# download all tool suite resources prior to install
# this allows for a retry incase a download fails
# this prevents install errors due to download time out errors
# if an error occurs, exit form this script
brew fetch biobakery_tool_suite --retry --deps || exit 1

# install biobakery tool suite
brew install biobakery_tool_suite

# change local back to root owner
sudo chown -R root /usr/local/

# install humann2 utility mapping files and larger demo chocophlan database
sudo humann2_databases --download utility_mapping full /opt/humann2_databases/
sudo humann2_databases --download chocophlan DEMO /opt/humann2_databases/

# ---------------------------------------------------------------
# install packages for vnc access
# ---------------------------------------------------------------

# install xfce4 desktop
sudo apt-get install xfce4 xfce4-goodies -y

# install vnc server
sudo apt-get install tightvncserver -y

# install tool for copy/paste
sudo apt-get install autocutsel -y

# install firefox browser
sudo apt-get install firefox -y

# update the wallpaper to use the biobakery image
sudo cp ../vagrant/biobakery-gui/bioBakeryWallpaper.png /usr/share/backgrounds/xfce/
sudo cp xfce4-desktop.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/

# update panel to set custom options (and resolve empty panel current ubuntu bug)
sudo cp xfce4-panel.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/

# update the default setup script for tightvnc to work with xfce (fixes broken images) and copy/paste
sudo sed -i '61 s/.*/       "xrdb \\$HOME\/.Xresources\\nautocutsel -fork\\n"./g' /usr/bin/vncserver
sudo sed -i '66 s/.*/       "\/etc\/X11\/Xsession\\n"./g' /usr/bin/vncserver
sudo sed -i '67 s/.*/       "export XKL_XMODMAP_DISABLE=1\\n");/g' /usr/bin/vncserver

# ---------------------------------------------------------------
# install R packages for visualization
# ---------------------------------------------------------------

# install R packages to root R library
sudo R -q -e "install.packages('vegan',repos='http://cran.r-project.org')"
sudo R -q -e "install.packages('ggplot2',repos='http://cran.r-project.org')"

# install dependencies of EBImage (a dependency of ggtree) and then install ggtree
sudo apt-get install libfftw3-dev libtiff5-dev -y
sudo R -q -e "source('https://bioconductor.org/biocLite.R'); biocLite('EBImage'); biocLite('ggtree')"

printf '\n\n\nbioBakery install complete.\n\nbioBakery dependencies that require licenses are not included. Refer to the instructions in the bioBakery doc
umentation for more information: https://bitbucket.org/biobakery/biobakery/wiki/biobakery_basic#rst-header-install-biobakery-dependencies .\n\n'

