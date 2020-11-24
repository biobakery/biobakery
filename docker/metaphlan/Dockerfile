FROM ubuntu:18.04

# also install python version 2 used by bowtie2
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y python python-dev python3 python3-dev python3-pip apt-transport-https openjdk-8-jre wget zip
RUN pip3 install boto3 cloudpickle awscli

RUN pip3 install anadama2

RUN apt-get install -y bowtie2
RUN pip3 install numpy
RUN pip3 install cython
RUN pip3 install biom-format

# install cmseq
RUN apt-get install -y git && \
    git clone https://github.com/SegataLab/cmseq.git && \
    cd cmseq && \
    python3 setup.py install && \
    cd ../ && \
    rm -r cmseq

RUN pip3 install metaphlan==3.0.6
RUN metaphlan --install --nproc 24

WORKDIR /tmp
