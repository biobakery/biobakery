# use the latest miniconda image (based on python 2.7)
FROM continuumio/miniconda3

# set up the conda channels
RUN /opt/conda/bin/conda config --add channels defaults && \
    /opt/conda/bin/conda config --add channels bioconda && \
    /opt/conda/bin/conda config --add channels conda-forge && \
    /opt/conda/bin/conda config --add channels biobakery
