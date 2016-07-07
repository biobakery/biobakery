#! /usr/bin/env bash

# This file will provision an image of Ubuntu 15.10 (Wily Werewolf) with bioBakery.
# This is based on the core bioBakery provisions file used with vagrant.

# ---------------------------------------------------------------
# install and update required packages
# ---------------------------------------------------------------

# update all packages
sudo apt-get update -y
sudo apt-get dist-upgrade --yes

# packages required for deb building and installation
sudo apt-get install -y mercurial git gdebi-core python-pip
sudo pip install setuptools --upgrade

# install dos2unix
sudo apt-get install dos2unix -y

# ---------------------------------------------------------------
# install biobakery suite with homebrew
# ---------------------------------------------------------------

# install dependencies for homebrew
sudo apt-get install -y ruby-full R-base

# install dependencies for numpy and matplotlib
sudo apt-get install -y python2.7-dev pkg-config

# install java openjdk for biobakery tools
sudo apt-get install -y openjdk-8-jre

# install homebrew
sudo git clone https://github.com/Linuxbrew/linuxbrew.git /opt/linuxbrew

# link brew to location in default path for all including sudo
sudo ln -s /opt/linuxbrew/bin/brew /usr/local/bin/brew

# install biobakery tool suite
sudo brew tap biobakery/biobakery
sudo brew install biobakery_tool_suite

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

