FROM ubuntu:18.04

# also install python version 2 used by bowtie2
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y python python-dev python3 python3-dev python3-pip apt-transport-https openjdk-8-jre wget zip software-properties-common
RUN pip3 install -U pip
RUN pip3 install boto3 cloudpickle awscli

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/' && \
    apt-get update -y && DEBIAN_FRONTEND="noninteractive" apt-get install r-base libcurl4-openssl-dev -y

RUN R -q -e "install.packages('XICOR', repos='http://cran.r-project.org')" && \
R -q -e "install.packages('eva', repos='http://cran.r-project.org')"

RUN pip3 install scipy
RUN pip3 install Cython
RUN pip3 install anadama2
RUN pip3 install jinja2
RUN pip3 install threadpoolctl
RUN pip3 install patsy
RUN pip3 install halla==0.8.20
