#! /usr/bin/env bash

# setup aws-specific biobakery pieces

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

sudo apt-get purge -y
sudo apt-get autoclean -y
