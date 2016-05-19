#! /usr/bin/env bash

# Vagrant uses this file to provision core components of the
# biobakery vm family.
# =====
# Authors: 
# Eric Franzosa (eric.franzosa@gmail.com)
# Randall Schwager (randall.schwager@gmail.com)

# ---------------------------------------------------------------
# constants
# ---------------------------------------------------------------

FOLDER_SETUP="/vagrant"
FILE_VERSION="version.txt"

# ---------------------------------------------------------------
# core additions all versions will use
# ---------------------------------------------------------------

# **** Note: all downstream provisioning makes use of this update ****
sudo apt-get update -y
sudo apt-get dist-upgrade --yes

# packages required for full virtualbox functionality
sudo apt-get install -y build-essential linux-headers-`uname -r`

# packages required for deb building and installation
sudo apt-get install -y mercurial git gdebi-core python-pip
sudo pip install setuptools --upgrade

# utilities
sudo apt-get install -y libgnome2-bin emacs24 

# ---------------------------------------------------------------
# install biobakery suite with homebrew
# ---------------------------------------------------------------

# install dependencies for homebrew
apt-get install -y ruby-full R-base

# install dependencies for numpy and matplotlib
apt-get install -y python2.7-dev pkg-config

# install java openjdk for biobakery tools
apt-get install -y openjdk-8-jre

# install homebrew
git clone https://github.com/Linuxbrew/linuxbrew.git /home/vagrant/.linuxbrew

# update bashrc for homebrew install
cat - >> /home/vagrant/.bashrc <<EOF
# add paths to homebrew install
export PATH=/home/vagrant/.linuxbrew/bin:$PATH
export MANPATH=/home/vagrant/.linuxbrew/share/man:$MANPATH
export INFOPATH=/home/vagrant/.linuxbrew/share/info:$INFOPATH
EOF

# install biobakery tool suite
/home/vagrant/.linuxbrew/bin/brew tap biobakery/biobakery
/home/vagrant/.linuxbrew/bin/brew install biobakery_tool_suite

# ---------------------------------------------------------------
# write versioning information
# ---------------------------------------------------------------

echo "This version of bioBakery was built on:" > $FOLDER_SETUP/$FILE_VERSION
date >> $FOLDER_SETUP/$FILE_VERSION
echo "The following packages were installed:" >> $FOLDER_SETUP/$FILE_VERSION

# record the biobakery packages installed with homebrew
/home/vagrant/.linuxbrew/bin/brew list --versions | grep -E '(ppanini|shortbred|picrust|kneaddata|breadcrumbs|graphlan|sparsedossa|humann2|micropita|lefse|metaphlan2|maaslin)' >> $FOLDER_SETUP/$FILE_VERSION

