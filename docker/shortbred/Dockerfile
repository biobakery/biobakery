FROM ubuntu:18.04

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y python python-dev python3 python3-dev python3-pip apt-transport-https openjdk-8-jre wget zip
RUN pip3 install boto3 cloudpickle awscli

RUN pip3 install anadama2

# install dependencies
RUN apt-get install -y muscle cd-hit ncbi-blast+

# install usearch
RUN wget https://drive5.com/downloads/usearch9.0.2132_i86linux32.gz && \
    gunzip usearch9.0.2132_i86linux32.gz && \
    chmod +x usearch9.0.2132_i86linux32 && \
     mv usearch9.0.2132_i86linux32 /usr/local/bin/usearch

RUN pip3 install shortbred==0.9.5

