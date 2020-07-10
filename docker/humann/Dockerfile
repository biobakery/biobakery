FROM ubuntu:18.04

# also install python version 2 used by bowtie2
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y python python-dev python3 python3-dev python3-pip apt-transport-https openjdk-8-jre wget zip
RUN pip3 install boto3 cloudpickle awscli

RUN pip3 install anadama2

# install kneaddata and dependencies
RUN pip3 install humann==3.0.0.alpha.4 --no-binary :all:
RUN pip3 install numpy cython
RUN pip3 install biom-format
RUN pip3 install metaphlan

WORKDIR /tmp
