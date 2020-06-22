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

# update all packages
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade --yes

# packages required for deb building and installation
sudo apt-get install -y git gdebi-core python3-dev python3-pip python-pip build-essential fastqc
sudo pip install setuptools --upgrade

# install libreoffice
sudo apt-get install libreoffice -y

# remove screensaver to remove startup message
sudo apt-get remove xscreensaver -y

# install dos2unix
sudo apt-get install dos2unix -y

# ---------------------------------------------------------------
# install biobakery suite with pypi and bioconductor
# ---------------------------------------------------------------

sudo pip3 install kneaddata --no-binary :all:
# install humann with python2 as library needed for workflows scripts
sudo pip install humann --no-binary :all:

# install v3 of phylophlan (case change in pypi package) plus dependencies
sudo apt-get install fasttree -y
sudo pip3 install PhyloPhlAn
wget https://github.com/scapella/trimal/archive/v1.4.1.tar.gz
tar xzvf v1.4.1.tar.gz
( cd trimal-1.4.1/source/ && make && sudo cp *al /usr/local/bin/ )
rm v1.4.1.tar.gz && rm -r trimal-1.4.1

# install metaphlan plus strainphlan with dependencies
sudo pip3 install metaphlan 
sudo pip3 install cython
sudo apt-get install python3-pysam samtools zlib1g-dev libbz2-dev liblzma-dev -y
sudo pip3 install cmseq

# install R and maaslin2
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/'
sudo apt update -y && sudo apt install r-base libcurl4-openssl-dev -y

sudo R -q -e "install.packages('BiocManager', repos='http://cran.r-project.org')"
sudo R -q -e "library(BiocManager); BiocManager::install('Maaslin2')"

# install workflows and visualization dependencies
# workflows includ two strainphlan visualization scripts used in the strainphlan tutorial
# using python2 currently as anadama2 document methods are not yet python3 compat in some sections
sudo apt-get install python-tk -y
sudo pip3 install biobakery_workflows==3.0.0a4
sudo R -q -e "install.packages('vegan', repos='http://cran.r-project.org')"
sudo pip3 install scipy pandas
sudo pip3 install hclust2

sudo R -q -e "library(BiocManager); BiocManager::install('ggtree')"
sudo R -q -e "library(BiocManager); BiocManager::install('Biostrings')"
sudo R -q -e "install.packages(c('optparse','ggplot2','RColorBrewer'), repos='http://cran.r-project.org')"

# install waafle
sudo pip3 install waafle
wget https://github.com/hyattpd/Prodigal/releases/download/v2.6.3/prodigal.linux
chmod +x prodigal.linux
sudo mv prodigal.linux /usr/local/bin/

# install dependencies for workflows (including vis)
sudo apt-get install -y texlive pandoc

# install workflows 16s dependencies
wget https://drive5.com/downloads/usearch9.0.2132_i86linux32.gz
gunzip usearch9.0.2132_i86linux32.gz
chmod +x usearch9.0.2132_i86linux32
sudo mv usearch9.0.2132_i86linux32 /usr/local/bin/usearch

wget https://github.com/torognes/vsearch/releases/download/v2.14.2/vsearch-2.14.2-linux-x86_64.tar.gz
tar xzvf vsearch-2.14.2-linux-x86_64.tar.gz
sudo cp vsearch-2.14.2-linux-x86_64/bin/vsearch /usr/local/bin/
rm -r vsearch*

# install panphlan
sudo pip3 install sklearn
sudo pip3 install panphlan
wget https://github.com/marbl/Mash/releases/download/v2.2/mash-Linux64-v2.2.tar
tar xvf mash-Linux64-v2.2.tar
sudo mv mash-Linux64-v2.2/mash /usr/local/bin/
rm -r mash-Linux64-v2.2*

# install shortbred (ncbi blast required, it is installed later with prokka section with version compatible with prokka/shortbred/phylophlan)
sudo apt-get install muscle cd-hit -y
sudo pip3 install shortbred

# install graphlan (currently python2)
# install 2.0.0 for workflows vis
sudo pip install matplotlib==2.0.0
git clone https://github.com/biobakery/graphlan.git
sudo cp graphlan/*.py /usr/local/bin/ && sudo cp graphlan/src/graphlan_lib.py /usr/local/bin/src/ && sudo cp graphlan/src/pyphlan.py /usr/local/bin/src/ 
rm -rf graphlan

git clone https://github.com/SegataLab/export2graphlan.git
sudo cp export2graphlan/*.py /usr/local/bin/
rm -rf export2graphan

# install mmuphin
sudo R -q -e "library(BiocManager); BiocManager::install('MMUPHin')"

# install banocc
sudo R -q -e "library(BiocManager); BiocManager::install('banocc')"

# install sparsedossa
sudo R -q -e "library(BiocManager); BiocManager::install('sparseDOSSA')"

# install melonnpan
sudo apt-get install libssl-dev libxml2-dev -y
sudo R -q -e "install.packages(c('devtools'), repos='http://cran.r-project.org')"
sudo R -q -e "library(devtools); devtools::install_version('GenABEL.data', version = '1.0.0', repos = 'http://cran.us.r-project.org')"
sudo R -q -e "library(devtools); devtools::install_version('GenABEL', version = '1.8-0', repos = 'http://cran.us.r-project.org')"
sudo R -q -e "library(devtools); devtools::install_github('biobakery/melonnpan')"

# install picrust2 and dependencies
sudo apt-get install hmmer -y
sudo R -q -e "install.packages(c('castor'), repos='http://cran.r-project.org')"
wget https://github.com/picrust/picrust2/archive/v2.3.0-b.tar.gz
tar xvzf v2.3.0-b.tar.gz
( cd picrust2-2.3.0-b/ && sudo pip3 install --editable . && sudo cp -r picrust2/default_files /usr/local/lib/python3.6/dist-packages/picrust2/)
sudo rm -r picrust2* && rm v2.3.0-b.tar.gz
sudo apt-get install autotools-dev libtool flex bison cmake automake autoconf -y
wget https://github.com/Pbdas/epa-ng/archive/v0.3.6.tar.gz
tar xzvf v0.3.6.tar.gz
( cd epa-ng-0.3.6/ && make && sudo cp bin/epa-ng /usr/local/bin/ )
rm -r epa-ng* && rm v0.3.6.tar.gz
wget https://github.com/lczech/gappa/archive/v0.6.0.tar.gz
tar xzvf v0.6.0.tar.gz
( cd gappa-0.6.0/ && make && sudo cp bin/gappa /usr/local/bin/ )
rm -r gappa* && rm v0.6.0.tar.gz

# install lefse
sudo pip install rpy2==2.8
wget https://github.com/SegataLab/lefse/archive/1.0.8.tar.gz
tar xzvf 1.0.8.tar.gz
sudo cp lefse-1.0.8/*.py /usr/local/bin/
rm 1.0.8.tar.gz
rm -r lefse*

sudo R -q -e "install.packages(c('coin','MASS','modeltools','mvtnorm','survival'), repos='http://cran.r-project.org')"

