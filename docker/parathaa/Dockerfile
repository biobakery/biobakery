FROM ubuntu:18.04

# also install python version 2 used by bowtie2
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y python python-dev python3 python3-dev python3-pip apt-transport-https openjdk-8-jre wget zip zlib1g-dev libbz2-dev liblzma-dev libjpeg-dev
RUN pip3 install boto3 cloudpickle awscli

RUN pip3 install anadama2
RUN pip3 install taxtastic
# install parathaa and dependencies
RUN pip3 install parathaa==0.1.0 --no-binary :all:

WORKDIR /tmp
