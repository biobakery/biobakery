#! /usr/bin/env bash

# set up aws-specific biobakery pieces
# =======
# Authors:                                                                                                                         
# Randall Schwager (randall.schwager@gmail.com)
# Eric Franzosa (eric.franzosa@gmail.com)

# ---------------------------------------------------------------
# add aws-specific packages
# ---------------------------------------------------------------

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
