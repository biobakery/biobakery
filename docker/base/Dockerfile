# use the latest miniconda image (based on python 2.7)
FROM continuumio/miniconda

# set up the conda channels
RUN /opt/conda/bin/conda config --add channels defaults && \
    /opt/conda/bin/conda config --add channels bioconda && \
    /opt/conda/bin/conda config --add channels conda-forge && \
    /opt/conda/bin/conda config --add channels biobakery

# install anadama2 so the docker containers can be used with the AWS Batch workflow type
RUN /opt/conda/bin/conda install anadama2==0.6.3

# install biobakery demos for testing each package
RUN /opt/conda/bin/conda install biobakery_demos==1.6

# use the same commands as miniconda
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
