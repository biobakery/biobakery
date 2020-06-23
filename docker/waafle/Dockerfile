FROM ubuntu:18.04

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y python python-dev python3 python3-dev python3-pip apt-transport-https openjdk-8-jre wget zip
RUN pip3 install boto3 cloudpickle awscli

RUN pip3 install anadama2

# install dependencies
RUN wget https://github.com/hyattpd/Prodigal/releases/download/v2.6.3/prodigal.linux && \
    chmod +x prodigal.linux && \
    mv prodigal.linux /usr/local/bin/

RUN apt-get install -y bowtie2 ncbi-blast+

RUN pip3 install numpy
RUN pip3 install waafle==0.1.0

