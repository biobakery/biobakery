#!/bin/bash

###
# Repository munging

sudo apt-get update -y
sudo apt-get dist-upgrade --yes

sudo apt-get install -y build-essential linux-headers-`uname -r` dkms
sudo apt-get install -y virtualbox-ose-guest-x11
sudo apt-get install -y virtualbox-guest-dkms virtualbox-guest-x11

sudo apt-get install -y mercurial git gdebi-core python-pip
sudo pip install setuptools --upgrade

sudo apt-get install -y trash-cli libgnome2-bin emacs24

cat - >> /home/vagrant/.bashrc <<EOF
# *** important ****
# this calls the trash program instead of rm, so you can get your work back!
alias rm="trash"
alias hardrm="/bin/rm"

# this prompts you if moving a file would replace existing file
alias mv="mv -i"
alias cp="cp -i"

# often used commands
alias open=gnome-open

# make emacs open in the terminal
alias emacs="emacs24 -nw"
EOF

# ---------------------------------------------------------------
# apt-get biobakery debs
# ---------------------------------------------------------------

# add custom repo to the sources lists
# **** note: special use of tee command to append to sources.list, since >> doesn't work in sudo context ****
echo "deb http://huttenhower.sph.harvard.edu/biobakery-shop/deb-packages ./" | sudo bash -c "cat - >> /etc/apt/sources.list "
sudo apt-get update

# install things from the repo
sudo apt-get install -y --force-yes metaphlan
sudo apt-get install -y --force-yes graphlan
#sudo apt-get install -y --force-yes picrust
sudo apt-get install -y --force-yes qiimetomaaslin
sudo apt-get install -y --force-yes humann
sudo apt-get install -y --force-yes micropita
# sudo apt-get install -y maaslin
sudo apt-get install -y --force-yes breadcrumbs 

# cleanup
sudo apt-get autoremove -y --force-yes
sudo apt-get purge -y --force-yes
sudo apt-get autoclean -y --force-yes

