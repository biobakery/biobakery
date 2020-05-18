#! /usr/bin/env bash

# This file will provision an image of Ubuntu 18.04 (Bionic Beaver) with bioBakery.
# This is based on the core bioBakery provisions file used with vagrant.

# ---------------------------------------------------------------
# install and update required packages
# ---------------------------------------------------------------

# update all packages
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade --yes

# packages required for deb building and installation
sudo apt-get install -y git gdebi-core python3-dev python3-pip build-essential fastqc
sudo pip install setuptools --upgrade

# install dos2unix
sudo apt-get install dos2unix -y

# ---------------------------------------------------------------
# install biobakery suite with pypi and bioconductor
# ---------------------------------------------------------------

sudo pip3 install kneaddata --no-binary :all:
sudo pip3 install humann --no-binary :all:
sudo pip3 install phylophlan

# install metaphlan plus strainphlan with dependencies and databases
sudo pip3 install metaphlan 
sudo metaphlan --install --nproc 2
sudo pip3 install cython
sudo apt-get install python3-pysam samtools zlib1g-dev libbz2-dev liblzma-dev -y
sudo pip3 install cmseq

sudo pip3 install biobakery_workflows==3.0.0a1

# install waafle
sudo pip3 install waafle
sudo mkdir /opt/waafle && sudo chmod 755 /opt/waafle
sudo wget http://huttenhower.sph.harvard.edu/waafle_data/waafledb.tar.gz --directory-prefix=/opt/waafle/
(cd /opt/waafle/ && sudo tar xzvf waafledb.tar.gz )
sudo wget http://huttenhower.sph.harvard.edu/waafle_data/waafledb_taxonomy.tsv --directory-prefix=/opt/waafle/


# install dependencies for workflows and dependencies
sudo apt-get install -y texlive pandoc

# install panphlan (to be replaced with pypi later)
sudo pip install numpy
wget https://github.com/SegataLab/panphlan/archive/1.2.tar.gz
tar xzvf 1.2.tar.gz
sudo cp panphlan-1.2/*.py /usr/local/bin/
rm 1.2.tar.gz
rm -r panphlan-1.2

# install shortbred (to be replaced with pypi later)
sudo apt-get install ncbi-blast+ muscle cd-hit -y
sudo pip install biopython
wget https://bitbucket.org/biobakery/shortbred/get/702e3ef41be4.tar.gz
tar xzvf 702e3ef41be4.tar.gz
( cd biobakery-shortbred-702e3ef41be4 && sudo cp *.py /usr/local/bin/ && sudo cp -r src /usr/local/bin/ )
rm -r biobakery-shortbred-702e3ef41be4
rm 702e3ef41be4.tar.gz

# install graphlan (to be replaced with pypi later)
# please note, this shares a src folder like shortbred does
sudo pip install matplotlib
git clone https://github.com/biobakery/graphlan.git
( cd graphlan && sudo cp graphlan/*.py /usr/local/bin/ && sudo cp graphlan/src/graphlan_lib.py /usr/local/bin/src/ && sudo cp graphlan/src/pyphlan.py /usr/local/bin/src/ && sudo cp -r graphlan/export2graphlan/ /usr/local/bin/ )
rm -r graphlan

# install R and maaslin2
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/'
sudo apt update -y && sudo apt install r-base libcurl4-openssl-dev -y

sudo R -q -e "install.packages('BiocManager', repos='http://cran.r-project.org')"
sudo R -q -e "library(BiocManager); BiocManager::install('Maaslin2')"

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
rm -r quast-4.6.3*

# install prokka (has some errors with latest package during install and requires manual input during install)
sudo apt-get install libdatetime-perl libxml-simple-perl libdigest-md5-perl bioperl -y
sudo cpan Bio::Perl
git clone https://github.com/tseemann/prokka.git
sudo mv prokka /opt/
sudo /opt/prokka/bin/prokka --setupdb
sudo ln -s /opt/prokka/bin/* /usr/local/bin/

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
umentation for more information: https://bitbucket.org/biobakery/biobakery/wiki/biobakery_basic#rst-header-install-biobakery-dependencies .\n\n'

