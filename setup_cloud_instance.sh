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
git clone https://github.com/Linuxbrew/linuxbrew.git $HOME/.linuxbrew

# update bashrc for homebrew install
cat - >> $HOME/.bashrc <<EOF
# add paths to homebrew install
export PATH=$HOME/.linuxbrew/bin:$PATH
export MANPATH=$HOME/.linuxbrew/share/man:$MANPATH
export INFOPATH=$HOME/.linuxbrew/share/info:$INFOPATH
EOF

# apply the updates to the current shell
source $HOME/.bashrc

# install biobakery tool suite
brew tap biobakery/biobakery
brew install biobakery_tool_suite

printf '\n\n\nbioBakery install complete.\n\nPlease install bioBakery dependencies that require licenses. Refer to the instructions in the bioBakery documentation for more information: https://bitbucket.org/biobakery/biobakery/wiki/biobakery_basic#rst-header-install-biobakery-dependencies .\n\n'

