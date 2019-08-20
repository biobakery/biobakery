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
