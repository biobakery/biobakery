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

# update paths for homebrew install
sudo cat - >> linuxbrew.sh <<EOF
# add paths to homebrew install
export PATH=/opt/linuxbrew/bin:$PATH
export MANPATH=/opt/linuxbrew/share/man:$MANPATH
export INFOPATH=/opt/linuxbrew/share/info:$INFOPATH
EOF

sudo mv linuxbrew.sh /etc/profile.d/
source /etc/profile.d/linuxbrew.sh

# link brew to location in default path for all including sudo
sudo ln -s /opt/linuxbrew/bin/brew /usr/local/bin/brew

# install biobakery tool suite
sudo brew tap biobakery/biobakery
sudo brew install biobakery_tool_suite

printf '\n\n\nbioBakery install complete.\n\nPlease install bioBakery dependencies that require licenses. Refer to the instructions in the bioBakery doc
umentation for more information: https://bitbucket.org/biobakery/biobakery/wiki/biobakery_basic#rst-header-install-biobakery-dependencies .\n\n'

