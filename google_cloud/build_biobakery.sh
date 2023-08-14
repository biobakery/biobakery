#! /usr/bin/env bash

# This file will provision an image of Ubuntu 22.04 (Jammy Jellyfish) with bioBakery.
# This is based on the core bioBakery provisions file used with vagrant.

# Build with 124 Gb of disk space to include databases and lots of extra space.

# ---------------------------------------------------------------
# install and update required packages
# ---------------------------------------------------------------

# update all packages
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade --yes

# packages required for deb building and installation
sudo apt-get install -y git gdebi-core python3-dev python3-pip build-essential fastqc python2
sudo ln -s /usr/bin/python2 /usr/bin/python
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
wget https://github.com/Benson-Genomics-Lab/TRF/releases/download/v4.09.1/trf409.legacylinux64
chmod 755 trf409.legacylinux64 && mv trf409.legacylinux64 trf && sudo mv trf /usr/local/bin/

sudo pip3 install humann --no-binary :all:

# install v3 of phylophlan (case change in pypi package) plus dependencies
sudo apt-get install fasttree -y
sudo pip3 install PhyloPhlAn
wget https://github.com/scapella/trimal/archive/v1.4.1.tar.gz
tar xzvf v1.4.1.tar.gz
( cd trimal-1.4.1/source/ && make && sudo cp *al /usr/local/bin/ )
rm v1.4.1.tar.gz && rm -r trimal-1.4.1

# install metaphlan plus strainphlan with dependencies and databases
sudo pip3 install metaphlan 
sudo pip3 install cython
sudo apt-get install python3-pysam samtools zlib1g-dev libbz2-dev liblzma-dev -y
sudo pip3 install cmseq

# install latest bowtie2 version
wget http://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.2.3/bowtie2-2.2.3-linux-x86_64.zip
unzip bowtie2-2.2.3-linux-x86_64.zip
sudo cp bowtie2-2.2.3/bowtie2* /usr/local/bin/
rm -r bowtie2-2.2.3*

# install R and maaslin2
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo gpg --dearmor -o /usr/share/keyrings/r-project.gpg
echo "deb [signed-by=/usr/share/keyrings/r-project.gpg] https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" | sudo tee -a /etc/apt/sources.list.d/r-project.list
sudo apt update -y && sudo apt install r-base libcurl4-openssl-dev cmake -y

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
git clone https://github.com/biobakery/graphlan.git
sudo mkdir /usr/local/bin/src/
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

# install assembly packages
wget https://github.com/voutcn/megahit/releases/download/v1.1.3/megahit_v1.1.3_LINUX_CPUONLY_x86_64-bin.tar.gz
tar xzvf megahit_v1.1.3_LINUX_CPUONLY_x86_64-bin.tar.gz
sudo cp megahit_v1.1.3_LINUX_CPUONLY_x86_64-bin/megahit* /usr/local/bin/
rm -r megahit_v1.1.3_LINUX_CPUONLY_x86_64-bin*

sudo apt-get install openjdk-8-jdk -y
sudo pip install joblib
wget https://downloads.sourceforge.net/project/quast/quast-4.6.3.tar.gz
tar xzvf quast-4.6.3.tar.gz
( cd quast-4.6.3/ && sudo ./setup.py install_full )
sudo rm -r quast-4.6.3*

# install prokka (has some errors with latest package during install and requires manual input during install)
sudo apt-get install libdatetime-perl libxml-simple-perl libdigest-md5-perl bioperl parallel -y
sudo apt-get remove ncbi-blast+ -y
git clone https://github.com/tseemann/prokka.git
sudo mv prokka /opt/
sudo /opt/prokka/bin/prokka --setupdb
sudo ln -s /opt/prokka/bin/* /usr/local/bin/
# update to latest blast required
wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.8.1/ncbi-blast-2.8.1+-x64-linux.tar.gz
tar xzvf ncbi-blast-2.8.1+-x64-linux.tar.gz
sudo cp ncbi-blast-2.8.1+/bin/* /usr/local/bin/
rm -r ncbi-blast-2.8.1+*
# install/build databases (needs latest makeblastdb > v2.8)
sudo /opt/prokka/bin/prokka --setupdb

wget https://github.com/rrwick/Bandage/releases/download/v0.8.1/Bandage_Ubuntu_static_v0_8_1.zip
unzip Bandage_Ubuntu_static_v0_8_1.zip 
sudo mv Bandage /usr/local/bin/
rm Bandage_Ubuntu_static_v0_8_1.zip 
rm sample_LastGraph 

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

printf '\n\n\nbioBakery install complete.\n\nbioBakery dependencies that require licenses are not included. Refer to the instructions in the bioBakery doc
umentation for more information: https://github.com/biobakery/biobakery/wiki/biobakery_basic#13-install-biobakery-dependencies .\n\n'


# ---------------------------------------------------------------
# install files and databases for tutorials
# ---------------------------------------------------------------

#copying demo files in home location
mkdir -p $HOME/Tutorials && cp -R ../test_suite/biobakery_tests/data/. $HOME/Tutorials/

# installing full metaphlan database
sudo metaphlan --install --nproc 2


# ---------------------------------------------------------------
# install test suite
# ---------------------------------------------------------------

( cd ../test_suite/ && sudo python3 setup.py install )

printf '\n\n\nbioBakery install complete.\n\nbioBakery dependencies that require licenses are not included. Refer to the instructions in the bioBakery doc
umentation for more information: https://github.com/biobakery/biobakery/wiki/biobakery_basic#13-install-biobakery-dependencies .\n\n'
