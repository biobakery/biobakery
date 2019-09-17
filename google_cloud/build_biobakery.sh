#! /usr/bin/env bash

# This file will provision an image of Ubuntu 16.04 (Xenial Xerus) with bioBakery.
# This is based on the core bioBakery provisions file used with vagrant.

# ---------------------------------------------------------------
# install and update required packages
# ---------------------------------------------------------------

# update all packages
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade --yes

# packages required for deb building and installation
sudo apt-get install -y mercurial git gdebi-core python-pip
sudo pip install setuptools --upgrade

# install dos2unix
sudo apt-get install dos2unix -y

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
( conda create -y -n "melonpann_env" && conda activate "melonpann_env" && \
  conda install r-base=3.5.0 r-devtools -y && \
  R -q -e "install.packages('BiocManager', repos='http://cran.r-project.org'); library('BiocManager'); BiocManager::install('ccrepe');" && \
  R -q -e "install.packages('glmnet', repos='http://cran.r-project.org')" && \
  R -q -e "install.packages('HDtweedie', repos='http://cran.r-project.org')" && \
  R -q -e "install.packages('getopt', repos='http://cran.r-project.org')" && \
  R -q -e "install.packages('doParallel', repos='http://cran.r-project.org')" && \
  R -q -e "install.packages('vegan', repos='http://cran.r-project.org')" && \
  wget https://cran.r-project.org/src/contrib/Archive/DatABEL/DatABEL_0.9-6.tar.gz && \
  R CMD INSTALL DatABEL_0.9-6.tar.gz && \
  rm DatABEL_0.9-6.tar.gz && \
  R -q -e "install.packages('data.table', repos='http://cran.r-project.org')" && \
  R -q -e "library('devtools'); devtools::install_version('GenABEL.data', version = '1.0.0', repos='http://cran.us.r-project.org')" && \
  R -q -e "library('devtools'); devtools::install_version('GenABEL', version = '1.8-0', repos='http://cran.us.r-project.org')" && \
  R -q -e "library('devtools'); devtools::install_github('biobakery/melonnpan')" && \
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
# install packages for vnc access
# ---------------------------------------------------------------

# install xfce4 desktop
sudo apt-get install xfce4 xfce4-goodies -y

# install vnc server
sudo apt-get install tightvncserver -y

# install tool for copy/paste
sudo apt-get install autocutsel -y

# install firefox browser
sudo apt-get install firefox -y

# update the wallpaper to use the biobakery image
sudo cp ../vagrant/biobakery-gui/bioBakeryWallpaper.png /usr/share/backgrounds/xfce/
sudo cp xfce4-desktop.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/

# update panel to set custom options (and resolve empty panel current ubuntu bug)
sudo cp xfce4-panel.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/

# update the default setup script for tightvnc to work with xfce (fixes broken images) and copy/paste
sudo sed -i '61 s/.*/       "xrdb \\$HOME\/.Xresources\\nautocutsel -fork\\n"./g' /usr/bin/vncserver
sudo sed -i '66 s/.*/       "\/etc\/X11\/Xsession\\n"./g' /usr/bin/vncserver
sudo sed -i '67 s/.*/       "export XKL_XMODMAP_DISABLE=1\\n");/g' /usr/bin/vncserver

# ---------------------------------------------------------------
# install R packages for visualization
# ---------------------------------------------------------------

# install R packages to root R library
R -q -e "install.packages('vegan',repos='http://cran.r-project.org')"
R -q -e "install.packages('ggplot2',repos='http://cran.r-project.org')"

# install dependencies of EBImage (a dependency of ggtree) and then install ggtree
sudo apt-get install libfftw3-dev libtiff5-dev -y
R -q -e "library('BiocManager'); BiocManager::install('EBImage'); BiocManager::install('ggtree')"

printf '\n\n\nbioBakery install complete.\n\nbioBakery dependencies that require licenses are not included. Refer to the instructions in the bioBakery doc
umentation for more information: https://bitbucket.org/biobakery/biobakery/wiki/biobakery_basic#rst-header-install-biobakery-dependencies .\n\n'

