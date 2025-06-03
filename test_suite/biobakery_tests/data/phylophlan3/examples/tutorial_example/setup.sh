#!/bin/sh
mkdir tutorial_ethiopia
cd tutorial_ethiopia

# database and data download
wget http://cmprod1.cibio.unitn.it/databases/PhyloPhlAn/tutorial_ethiopia__mag2meta.tsv
wget http://cmprod1.cibio.unitn.it/databases/PhyloPhlAn/tutorial_ethiopia__mags.tar.bz2
tar -xjf tutorial_ethiopia__mags.tar.bz2

mkdir -p phylophlan_databases/
cd phylophlan_databases/
wget http://cmprod1.cibio.unitn.it/databases/PhyloPhlAn/tutorial_ethiopia.md5
#wget https://www.dropbox.com/s/br0yjonlk4bxyfc/tutorial_ethiopia.tar
wget http://cmprod1.cibio.unitn.it/databases/PhyloPhlAn/tutorial_ethiopia.txt.bz2
mkdir -p s__Escherichia_coli phylophlan_chlamydiae
cd s__Escherichia_coli/
wget https://www.dropbox.com/s/8quyu04fucl3dwj/s__Escherichia_coli.faa
cd ../phylophlan_chlamydiae/
wget https://www.dropbox.com/s/b1ykd7gh98n8fry/phylophlan_chlamydiae.faa

cd ..
cd ..
mkdir phylophlan_configs/
cd phylophlan_configs
wget https://github.com/biobakery/biobakery/releases/download/1.8/d_aa__i_nt.cfg

cd ..
mkdir ecoli chlamydiae
cd ecoli/
wget https://github.com/biobakery/biobakery/releases/download/1.8/ecoli_refgen.tar
tar -xf ecoli_refgen.tar
cd ../chlamydiae/
wget https://github.com/biobakery/biobakery/releases/download/1.8/chlamydiae_refgen.tar
tar -xf chlamydiae_refgen.tar

cd ../..
