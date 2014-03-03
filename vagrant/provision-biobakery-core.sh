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

URL_BITBUCKET="https://bitbucket.org/biobakery/biobakery"
URL_BIOBAKERY_REPO="http://huttenhower.sph.harvard.edu/biobakery-shop/deb-packages"

# ---------------------------------------------------------------
# core additions all versions will use
# ---------------------------------------------------------------

# **** Note: all downstream provisioning makes use of this update ****
sudo apt-get update -y
sudo apt-get dist-upgrade --yes

# packages required for full virtualbox functionality
sudo apt-get install -y build-essential linux-headers-`uname -r` dkms
sudo apt-get install -y virtualbox-ose-guest-x11
sudo apt-get install -y virtualbox-guest-dkms virtualbox-guest-x11

# permits user to mount shared folders
sudo adduser vagrant vboxsf

# packages required for deb building and installation
sudo apt-get install -y mercurial git gdebi-core python-pip
sudo pip install setuptools --upgrade

# utilities
sudo apt-get install -y libgnome2-bin emacs24

# ---------------------------------------------------------------
# add biobakery custom repo to the sources lists
# ---------------------------------------------------------------

echo "deb $URL_BIOBAKERY_REPO ./" | sudo bash -c "cat - >> /etc/apt/sources.list "
sudo apt-get update

# ---------------------------------------------------------------
# install individual biobakery debs from the repo
# ---------------------------------------------------------------

# * Syntax is package_name=version_number
# * Version_number is the date the deb was built
# * This ties versions of biobakery (as defined by the provisioning scripts) 
# to specific versions of tools, mitigating silent changes

# **** PLEASE INSERT NEW PACKAGES IN ALPHABETICAL ORDER ****

sudo apt-get install -y --force-yes breadcrumbs=130114 
sudo apt-get install -y --force-yes graphlan=200214
sudo apt-get install -y --force-yes humann=060114
# sudo apt-get install -y --force-yes maaslin=160114
sudo apt-get install -y --force-yes metaphlan=280114
sudo apt-get install -y --force-yes micropita=081213
# sudo apt-get install -y --force-yes picrust=151213
sudo apt-get install -y --force-yes qiimetomaaslin=081213

# ---------------------------------------------------------------
# cleanup
# ---------------------------------------------------------------

# **** cleanup commands should be included at the end of the
# second, image-specific provisioning scripts ****
