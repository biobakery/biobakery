# use the latest miniconda image (based on python 2.7)
FROM continuumio/miniconda

# set up the conda channels
RUN /opt/conda/bin/conda config --add channels defaults && \
    /opt/conda/bin/conda config --add channels bioconda && \
    /opt/conda/bin/conda config --add channels conda-forge

# install dependencies
RUN /opt/conda/bin/conda install fastqc trimmomatic spades quast prokka eggnog-mapper

# install kneaddata plus trimmomatic jar
RUN /opt/conda/bin/pip install kneaddata --no-binary :all:

# update to version2 of eggnog mapper (version tag is 41a8498, v2 is not available as a release)
RUN git clone https://github.com/jhcepas/eggnog-mapper.git && \
    cd eggnog-mapper && \
    cp *.py bin/* /opt/conda/bin/ && \
    cp -r * /opt/conda/bin/

# install checkm
RUN /opt/conda/bin/conda install checkm-genome && \
    /opt/conda/bin/pip install checkm-genome --upgrade --no-deps && \
    mkdir /checkm && \
    cd /checkm && \
    curl -L -O curl -L -O https://data.ace.uq.edu.au/public/CheckM_databases/checkm_data_2015_01_16.tar.gz && \
    tar xzf checkm_data_2015_01_16.tar.gz && \
    /opt/conda/bin/checkm data setRoot /checkm
