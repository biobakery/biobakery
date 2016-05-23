@echo off

echo check for vagrant (if installed print version)
vagrant -v

echo check for virtualbox (if install print version)
vboxmanage -v

echo create a biobakery folder in the home directory if it does not already exist
if not exist %HOMEPATH%\biobakery mkdir %HOMEPATH%\biobakery
cd %HOMEPATH%\biobakery

echo create biobakery vagrantfile, if it does not exist
if not exist %HOMEPATH%\biobakery\Vagrantfile vagrant init biobakery/biobakery

echo start biobakery (and also install the first time command is run)
vagrant up --provider virtualbox

