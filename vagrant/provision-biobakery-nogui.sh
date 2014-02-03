#! /usr/bin/env bash

# setup nogui-specific biobakery pieces

# ---------------------------------------------------------------
# add aws-specific packages
# ---------------------------------------------------------------

sudo apt-get update -y
sudo apt-get dist-upgrade --yes

# ---------------------------------------------------------------
# update .bashrc
# ---------------------------------------------------------------

cat - >> /home/vagrant/.bashrc <<EOF
# add new bashrc functions here
EOF

# ---------------------------------------------------------------
# cleanup
# ---------------------------------------------------------------

sudo apt-get autoremove -y --force-yes
sudo apt-get purge -y --force-yes
sudo apt-get autoclean -y --force-yes
