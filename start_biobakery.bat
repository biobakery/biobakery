@echo off

REM check for vagrant (if installed print version)
vagrant -v

REM check for virtualbox (if install print version)
vboxmanage -v

REM create a biobakery folder in the home directory if it does not already exist
if not exist %HOMEPATH%\biobakery mkdir %HOMEPATH%\biobakery
cd %HOMEPATH%\biobakery

REM create biobakery vagrantfile, if it does not exist
if not exist %HOMEPATH%\biobakery\Vagrantfile vagrant init biobakery/biobakery

REM start biobakery (and also install the first time command is run)
vagrant up --provider virtualbox

