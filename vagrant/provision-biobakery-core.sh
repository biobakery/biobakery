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
# install biobakery suite with conda
# ---------------------------------------------------------------

# install dependencies for workflows
sudo apt-get install -y texlive pandoc

# install conda in opt with automatic install for all users
sudo mkdir /opt/anaconda
sudo chmod -R 777 /opt/anaconda/
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /opt/anaconda/miniconda.sh
bash /opt/anaconda/miniconda.sh -b -p /opt/anaconda/miniconda/
sudo cp /opt/anaconda/miniconda/etc/profile.d/conda.sh /etc/profile.d/
. /opt/anaconda/miniconda/etc/profile.d/conda.sh

# add the biobakery tool packages
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --add channels biobakery

conda create -y -n workflows_env python=2.7 && conda activate workflows_env && conda install -y biobakery_workflows=0.13.2 -c biobakery && conda install -y samtools=0.1.19 && conda deactivate

for info in "humann2 2.8.1" "metaphlan2 2.7.7" "kneaddata 0.7.2" "waafle 0.1.0" "shortbred 0.9.3_dev_702e3ef" "ppanini 0.7.4" "panphlan 1.2.1.3_a25bc29" "micropita 8.1" "maaslin2 0.99.1" "lefse 1.0.0_dev_e3cabe9" "halla 0.8.17" "graphlan 1.1.3" "breadcrumbs 0.93"
do
  tool=( $info )
  ( conda create -y -n "${tool[0]}_env" python=2.7 && conda activate "${tool[0]}_env" && conda install -y "${tool[0]}=${tool[1]}" -c biobakery && conda deactivate ) || { echo "ERROR: Conda install of tool ${tool[0]} failed"; exit 1; }
done

# install packages that are not conda compatible (ie pure R packages)
# do not install packages that require running locally since
# build home directory location in cloud is user dependent

# install ccrepe
( conda create -y -n "ccrepe_env" && conda activate "ccrepe_env" && \
  conda install r-base -y && \
  R -q -e "install.packages('BiocManager', repos='http://cran.r-project.org'); library('BiocManager'); BiocManager::install('ccrepe');" && conda deactivate ) || { echo "ERROR: Conda ccrepe install failed"; exit 1; }

# install melonpann and dependencies
sudo ln -s /bin/tar /bin/gtar
( conda create -y -n "melonpann_env" && conda activate "melonpann_env" && \
  conda install r-base=3.5.0 r-devtools r-fbasics -y && \
  R -q -e "install.packages('BiocManager', repos='http://cran.r-project.org'); library('BiocManager'); BiocManager::install('ccrepe');" && \
  R -q -e "install.packages('optparse', repos='http://cran.r-project.org')" && \
  R -q -e "install.packages('AssocTests', repos='http://cran.r-project.org')" && \
  R -q -e "install.packages('glmnet', repos='http://cran.r-project.org')" && \
  R -q -e "install.packages('HDtweedie', repos='http://cran.r-project.org')" && \
  R -q -e "install.packages('getopt', repos='http://cran.r-project.org')" && \
  R -q -e "install.packages('doParallel', repos='http://cran.r-project.org')" && \
  R -q -e "install.packages('vegan', repos='http://cran.r-project.org')" && \
  R -q -e "install.packages('data.table', repos='http://cran.r-project.org')" && \
  R -q -e "library('devtools'); devtools::install_url('https://cran.r-project.org/src/contrib/Archive/DatABEL/DatABEL_0.9-6.tar.gz')" && \
  R -q -e "library('devtools'); devtools::install_url('https://cran.r-project.org/src/contrib/Archive/GenABEL.data/GenABEL.data_1.0.0.tar.gz')" && \
  R -q -e "library('devtools'); devtools::install_url('https://cran.r-project.org/src/contrib/Archive/GenABEL/GenABEL_1.8-0.tar.gz')" && \
  git clone https://github.com/biobakery/melonnpan.git && R CMD INSTALL melonnpan && rm -rf melonnpan && \
  conda deactivate ) || { echo "ERROR: Conda melonpann install failed"; exit 1; }

# install bannoc and dependencies
( conda create -y -n "bannoc_env" && conda activate "bannoc_env" && \
  conda install r-base -y && \
  R -q -e "install.packages('rstan', repos='http://cran.r-project.org')" && \
  R -q -e "install.packages('mvtnorm', repos='http://cran.r-project.org')" && \
  R -q -e "install.packages('coda', repos='http://cran.r-project.org')" && \
  R -q -e "install.packages('stringr', repos='http://cran.r-project.org')" && \
  git clone https://bitbucket.org/biobakery/banocc.git && R CMD INSTALL banocc && rm -rf banocc && \
  conda deactivate ) || { echo "ERROR: Conda bannoc install failed"; exit 1; }

# ---------------------------------------------------------------
# write versioning information
# ---------------------------------------------------------------

echo "This version of bioBakery was built on:" > $FOLDER_SETUP/$FILE_VERSION
date >> $FOLDER_SETUP/$FILE_VERSION
echo "The following packages were installed:" >> $FOLDER_SETUP/$FILE_VERSION
