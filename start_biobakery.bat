@echo off

REM check for vagrant (if installed print version else print error then wait 30 seconds and close window)
vagrant -v || echo ERROR: Please install vagrant && timeout 30>nul && exit /b

REM check for virtualbox (if installed print version else print error then wait 30 seconds and close window)
vboxmanage -v || echo ERROR: Please install virtualbox && timeout 30>nul && exit /b

REM create a biobakery folder in the home directory if it does not already exist
if not exist %HOMEPATH%\biobakery mkdir %HOMEPATH%\biobakery
cd %HOMEPATH%\biobakery

echo Thanks for downloading the bioBakery! During the first execution, we'll download a fairly large virtual image with all of the software environment pre-installed. This may take a while depending on your Internet connection, but it only happens once. After that, simply run the bioBakery using this launcher. Thanks for using our software!

REM create biobakery vagrantfile, if it does not exist
if not exist %HOMEPATH%\biobakery\Vagrantfile vagrant init biobakery/biobakery

REM start biobakery (and also install the first time command is run)
vagrant up --provider virtualbox

