#!/bin/bash

brew install fasttree
brew install muscle

pip install --upgrade pip
pip install --upgrade setuptools
pip install biopython
wget -O- 'https://bitbucket.org/nsegata/phylophlan/get/1.1.0.tgz' | tar -xvzf -
mv nsegata-phylophlan* phylophlan

cat - > phylophlan/WHERE_IS_USEARCH.txt <<EOF 
Due to licensing restrictions, you'll have to download usearch yourself.
Head on over to http://www.drive5.com/usearch/download.html .
Download version 5.2.32, put it into the sharing directory of biobakery,
then copy it into ~/.linuxbrew/bin with the following command:

cp -iv /vagrant/usearch $HOME/.linuxbrew/bin/
EOF
     
