#! /usr/bin/env bash

# Vagrant uses this file to provision core components of the
# biobakery vm family.
# =====
# Authors: 
# Eric Franzosa (eric.franzosa@gmail.com)
# Randall Schwager (randall.schwager@gmail.com)

# ---------------------------------------------------------------
# constants
# ---------------------------------------------------------------

FOLDER_SETUP="/vagrant"
FILE_VERSION="version.txt"

# ---------------------------------------------------------------
# core additions all versions will use
# ---------------------------------------------------------------

# **** Note: all downstream provisioning makes use of this update ****
# set non-interactive for the pc-grub update
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade --yes

# packages required for full virtualbox functionality
sudo apt-get install -y build-essential linux-headers-`uname -r`

# packages required for deb building and installation
sudo apt-get install -y mercurial git gdebi-core python-pip
sudo pip install setuptools --upgrade

# utilities
sudo apt-get install -y libgnome2-bin emacs24 

# ---------------------------------------------------------------
# install biobakery suite with homebrew
# ---------------------------------------------------------------

# install dependencies for homebrew
sudo apt-get install -y ruby-full

# install the latest version of r
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu xenial/'
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -
sudo apt-get update
sudo apt-get install r-base -y

# install dependencies for numpy and matplotlib
sudo apt-get install -y python2.7-dev pkg-config libfreetype6-dev
sudo ln -s /usr/include/freetype2/ft2build.h /usr/include/

# install java openjdk for biobakery tools
sudo apt-get install -y openjdk-8-jre

# install homebrew, not as root as no longer allowed, as of Nov 2016
git clone https://github.com/Linuxbrew/linuxbrew.git /home/vagrant/.linuxbrew

# update bashrc for homebrew install
cat - >> /home/vagrant/.bashrc <<EOF
# add paths to homebrew install
export PATH=/home/vagrant/.linuxbrew/bin:$PATH
export MANPATH=/home/vagrant/.linuxbrew/share/man:$MANPATH
export INFOPATH=/home/vagrant/.linuxbrew/share/info:$INFOPATH
EOF

# update current path
export PATH=/home/vagrant/.linuxbrew/bin:$PATH

# update the homebrew formulas
brew update

# add the biobakery tool formulas
brew tap biobakery/biobakery

# download all tool suite resources prior to install
# this allows for a retry incase a download fails
# this prevents install errors due to download time out errors
# if an error occurs, exit from this script
# fetch requires initial dependency tap
brew tap homebrew/science
brew tap homebrew/dupes
brew fetch biobakery_tool_suite --retry --deps || exit 1

# install biobakery tool suite
brew install biobakery_tool_suite

# remove the brew cache (this will free up ~2.5 GB)
rm -rf $(brew --cache)

# install packages that are not brew compatible
# these are pure R packages or tools that require
# running directly from the source folder 

# install ccrepe
sudo R -q -e "source('https://bioconductor.org/biocLite.R'); biocLite('ccrepe');"

# install melonpann and dependencies
sudo R -q -e "install.packages('glmnet', repos='http://cran.r-project.org')"
sudo R -q -e "install.packages('HDtweedie', repos='http://cran.r-project.org')"
sudo R -q -e "install.packages('getopt', repos='http://cran.r-project.org')"
sudo R -q -e "install.packages('doParallel', repos='http://cran.r-project.org')"
sudo R -q -e "install.packages('vegan', repos='http://cran.r-project.org')"
sudo R -q -e "install.packages('GenABEL', repos='http://cran.r-project.org')"
sudo R -q -e "install.packages('data.table', repos='http://cran.r-project.org')"
git clone https://github.com/biobakery/melonnpan.git && sudo R CMD INSTALL melonnpan && rm -r melonnpan

# install bannoc and dependencies
sudo R -q -e "install.packages('rstan', repos='http://cran.r-project.org')"
sudo R -q -e "install.packages('mvtnorm', repos='http://cran.r-project.org')"
sudo R -q -e "install.packages('coda', repos='http://cran.r-project.org')"
sudo R -q -e "install.packages('stringr', repos='http://cran.r-project.org')"
git clone https://bitbucket.org/biobakery/banocc.git && sudo R CMD INSTALL banocc && rm -r banocc

# install phylophlan and dependencies
(cd $HOME && hg clone https://bitbucket.org/nsegata/phylophlan)
sudo apt-get install muscle fasttree -y
sudo ln -s /usr/bin/fasttree /usr/bin/FastTree
sudo pip install numpy scipy biopython

# install arepa and dependencies
sudo apt-get install ant scons subversion curl wget java-common libssl-dev libxml2-dev libcairo2-dev -y
sudo R -q -e "install.packages('XML', repos='http://cran.r-project.org')"
sudo R -q -e "install.packages('httr', repos='http://cran.r-project.org')"
sudo R -q -e "source('https://bioconductor.org/biocLite.R'); biocLite('GEOquery');"
sudo R -q -e "source('https://bioconductor.org/biocLite.R'); biocLite('arrayQualityMetrics');"
sudo R -q -e "source('https://bioconductor.org/biocLite.R'); biocLite('affy');"
(cd $HOME && sudo hg clone https://bitbucket.org/biobakery/arepa)


# ---------------------------------------------------------------
# write versioning information
# ---------------------------------------------------------------

echo "This version of bioBakery was built on:" > $FOLDER_SETUP/$FILE_VERSION
date >> $FOLDER_SETUP/$FILE_VERSION
echo "The following packages were installed:" >> $FOLDER_SETUP/$FILE_VERSION

# record the biobakery packages installed with homebrew
brew list --versions | grep -E '(ppanini|shortbred|picrust|kneaddata|breadcrumbs|graphlan|sparsedossa|humann2|micropita|lefse|metaphlan2|maaslin)' >> $FOLDER_SETUP/$FILE_VERSION

