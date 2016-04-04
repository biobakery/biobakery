#!/bin/bash

git clone https://github.com/Linuxbrew/linuxbrew.git ~/.linuxbrew

cat - >> ~/.bashrc <<EOF 
export PATH="\$HOME/.linuxbrew/bin:\$PATH"
export PATH="\$HOME/.linuxbrew/sbin:\$PATH"
export MANPATH="\$HOME/.linuxbrew/share/man:\$MANPATH"
export INFOPATH="\$HOME/.linuxbrew/share/info:\$INFOPATH"
EOF

source ~/.bashrc
brew install git
brew tap homebrew/dupes
brew tap homebrew/science https://github.com/schwager-hsph/homebrew-science.git
brew tap homebrew/python
brew tap biobakery/biobakery /vagrant
brew install gcc
brew install bowtie2 --without-tbb
brew install biobakery/biobakery/metaphlan2
brew install biobakery/biobakery/humann2
brew install biobakery/biobakery/picrust
brew install biobakery/biobakery/kneaddata

bash /vagrant/install_phylophlan.sh

