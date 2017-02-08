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
# set non-interactive for the pc-grub update
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade --yes

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

# install homebrew, not as root as no longer allowed, as of Nov 2016
git clone https://github.com/Linuxbrew/linuxbrew.git /home/vagrant/.linuxbrew

# update bashrc for homebrew install
cat - >> /home/vagrant/.bashrc <<EOF
# add paths to homebrew install
export PATH=/home/vagrant/.linuxbrew/bin:$PATH
export MANPATH=/home/vagrant/.linuxbrew/share/man:$MANPATH
export INFOPATH=/home/vagrant/.linuxbrew/share/info:$INFOPATH
EOF

# update current path
export PATH=/home/vagrant/.linuxbrew/bin:$PATH

# update the homebrew formulas
brew update

# install freetype dependency from source instead of a bottle
# because the bottle does not work with this platform
brew install freetype --build-from-source

# add the biobakery tool formulas
brew tap biobakery/biobakery

# download all tool suite resources prior to install
# this allows for a retry incase a download fails
# this prevents install errors due to download time out errors
# if an error occurs, exit from this script
# fetch requires initial dependency tap
brew tap homebrew/science
brew tap homebrew/dupes
brew fetch biobakery_tool_suite --retry --deps || exit 1

# install biobakery tool suite
brew install biobakery_tool_suite

# remove the brew cache (this will free up ~2.5 GB)
rm -rf $(brew --cache)

# ---------------------------------------------------------------
# write versioning information
# ---------------------------------------------------------------

echo "This version of bioBakery was built on:" > $FOLDER_SETUP/$FILE_VERSION
date >> $FOLDER_SETUP/$FILE_VERSION
echo "The following packages were installed:" >> $FOLDER_SETUP/$FILE_VERSION

# record the biobakery packages installed with homebrew
brew list --versions | grep -E '(ppanini|shortbred|picrust|kneaddata|breadcrumbs|graphlan|sparsedossa|humann2|micropita|lefse|metaphlan2|maaslin)' >> $FOLDER_SETUP/$FILE_VERSION

