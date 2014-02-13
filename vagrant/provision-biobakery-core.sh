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

# **** Note: all "non-core" scripts will make use of this
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

# install biobakery debs from the biobakery repo
# -- syntax is package_name=version_number
# -- version_number is the date the deb was built
sudo apt-get install -y --force-yes breadcrumbs=130114 
sudo apt-get install -y --force-yes graphlan=071213
sudo apt-get install -y --force-yes humann=060114
# sudo apt-get install -y --force-yes maaslin=160114
sudo apt-get install -y --force-yes metaphlan=280114
sudo apt-get install -y --force-yes micropita=081213
# sudo apt-get install -y --force-yes picrust=151213
sudo apt-get install -y --force-yes qiimetomaaslin=081213

# ---------------------------------------------------------------
# cleanup
# ---------------------------------------------------------------

# to be done by each "non-core" script at the end (once)
# sudo apt-get autoremove -y --force-yes
# sudo apt-get purge -y --force-yes
# sudo apt-get autoclean -y --force-yes
