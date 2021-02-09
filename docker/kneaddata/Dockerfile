FROM ubuntu:18.04

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y python3 python3-dev python3-pip apt-transport-https openjdk-8-jre wget zip
RUN pip3 install boto3 cloudpickle awscli

RUN pip3 install anadama2

# install kneaddata and dependencies
RUN pip3 install kneaddata==0.10.0 --no-binary :all:

# install fastqc
RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip && \
    unzip fastqc_v0.11.9.zip && \
    chmod 755 FastQC/fastqc && \
    mv FastQC /usr/local/bin/ && \
    ln -s /usr/local/bin/FastQC/fastqc /usr/local/bin/fastqc && \
    rm fastqc_v0.11.9.zip 

WORKDIR /tmp

