#! /usr/bin/env bash

# vagrant uses this file to provision core components of the
# biobakery vm family

# ---------------------------------------------------------------
# constants
# ---------------------------------------------------------------

URL_BITBUCKET="https://bitbucket.org/timothyltickle/biobakery"
URL_BIOBAKERY_REPO="http://huttenhower.sph.harvard.edu/biobakery-shop/deb-packages"

# ---------------------------------------------------------------
# core additions all versions will use
# ---------------------------------------------------------------

sudo apt-get update -y
sudo apt-get dist-upgrade --yes

# things required by virtualbox
sudo apt-get install -y build-essential linux-headers-`uname -r` dkms
sudo apt-get install -y virtualbox-ose-guest-x11
sudo apt-get install -y virtualbox-guest-dkms virtualbox-guest-x11

# things requires for deb building
sudo apt-get install -y mercurial git gdebi-core python-pip
sudo pip install setuptools --upgrade

# utilities
sudo apt-get install -y libgnome2-bin emacs24

# ---------------------------------------------------------------
# add biobakery deb files
# ---------------------------------------------------------------

# add custom repo to the sources lists
echo "deb $URL_BIOBAKERY_REPO ./" | sudo bash -c "cat - >> /etc/apt/sources.list "
sudo apt-get update

# install things from the repo (comment out packages to ignore)
sudo apt-get install -y --force-yes metaphlan
sudo apt-get install -y --force-yes graphlan
#sudo apt-get install -y --force-yes picrust
sudo apt-get install -y --force-yes qiimetomaaslin
sudo apt-get install -y --force-yes humann
sudo apt-get install -y --force-yes micropita
#sudo apt-get install -y --force-yes maaslin
sudo apt-get install -y --force-yes breadcrumbs 

# cleanup
sudo apt-get autoremove -y --force-yes
sudo apt-get purge -y --force-yes
sudo apt-get autoclean -y --force-yes
