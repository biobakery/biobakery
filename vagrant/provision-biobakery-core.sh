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

echo "deb $URL_BIOBAKERY_REPO /" | sudo bash -c "cat - >> /etc/apt/sources.list "
wget -O- -q "${URL_BIOBAKERY_REPO}/biobakery.asc" | sudo apt-key add -
sudo apt-get update

# ---------------------------------------------------------------
# install individual biobakery debs from the repo
# ---------------------------------------------------------------

# **** PLEASE INSERT NEW PACKAGES IN ALPHABETICAL ORDER ****
# * Syntax is "name=version"
# * Version is the date the deb was built
# ** This ties versions of tools to versions of biobakery
# ** Mitigates silent changes
# * You can comment out packages with "#"

export PACKAGES=$(cat <<EOF
breadcrumbs=20140324
graphlan=20140324
humann=20140421
#maaslin=20140324
metaphlan=20140324
micropita=20140324
#picrust=20140324
qiimetomaaslin=20140324
EOF
);

# install packages that aren't commented out
for p in `echo "$PACKAGES" | grep -v -P "^#"`
do
    sudo apt-get install -y --force-yes $p
done

# ---------------------------------------------------------------
# write versioning information
# ---------------------------------------------------------------

echo "This version of bioBakery was built on:" > $FOLDER_SETUP/$FILE_VERSION
date >> $FOLDER_SETUP/$FILE_VERSION
echo "The following packages were installed:" >> $FOLDER_SETUP/$FILE_VERSION
echo "$PACKAGES" | grep -v -P "^#" >> $FOLDER_SETUP/$FILE_VERSION

# ---------------------------------------------------------------
# cleanup
# ---------------------------------------------------------------

# **** cleanup commands should be included at the end of the
# second, image-specific provisioning scripts ****
