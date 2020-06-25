FROM continuumio/miniconda3:4.8.2

RUN apt-get update
RUN conda config --add channels defaults
RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge

RUN conda install -y -c bioconda metaphlan

RUN metaphlan --install

WORKDIR /tmp