#!/bin/bash

# check for vagrant (if installed print version)
vagrant -v

# check for virtualbox (if install print version)
vboxmanage -v

# create a biobakery folder in the home directory if it does not already exist
mkdir -p $HOME/biobakery
cd $HOME/biobakery

printf "\n\n\nThanks for downloading the bioBakery! During the first execution, we'll download a fairly large virtual image with all of the software environment pre-installed. This may take a while depending on your Internet connection, but it only happens once. After that, simply run the bioBakery using this launcher. Thanks for using our software!\n\n"

# create biobakery vagrantfile, if it does not exist
[ -f $HOME/biobakery/Vagrantfile ] || vagrant init biobakery/biobakery

# start biobakery (and also install the first time command is run)
vagrant up --provider virtualbox

# keep terminal open for debugging purposes if needed
sleep 30
