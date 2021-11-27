FROM ubuntu:18.04

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y python python-dev python3 python3-dev python3-pip apt-transport-https software-properties-common wget
RUN pip3 install boto3 cloudpickle awscli

RUN pip3 install anadama2

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/' && \
    apt-get update -y && DEBIAN_FRONTEND="noninteractive" apt-get install r-base libcurl4-openssl-dev -y

RUN R -q -e "install.packages('BiocManager', repos='http://cran.r-project.org')" && \
    R -q -e "library(BiocManager); BiocManager::install('Maaslin2')"

# Install Maaslin2.R executable and reinstall Maaslin2 package so the versions of the exe and library are in sync
RUN R -q -e "install.packages(c('MuMIn', 'glmmTMB'), repos='http://cran.r-project.org')"
RUN wget https://github.com/biobakery/Maaslin2/archive/refs/tags/1.7.3.zip && \
    mv 1.7.3.zip  Maaslin2-1.7.3.zip && \
    unzip Maaslin2-1.7.3.zip && \
    R CMD INSTALL Maaslin2-1.7.3 && \
    cp Maaslin2-1.7.3/R/*.R /usr/local/bin/ && \
    rm -r Maaslin2-1.7.3

RUN apt-get install cd-hit bowtie2 samtools openjdk-8-jdk -y

# install diamond
RUN wget http://github.com/bbuchfink/diamond/releases/download/v0.9.24/diamond-linux64.tar.gz && \
    tar xzf diamond-linux64.tar.gz && \
    mv diamond /usr/local/bin/ && \
    rm diamond-linux64.tar.gz

# install usearch
RUN wget https://drive5.com/downloads/usearch9.0.2132_i86linux32.gz && \
    gunzip usearch9.0.2132_i86linux32.gz && \
    chmod +x usearch9.0.2132_i86linux32 && \
    mv usearch9.0.2132_i86linux32 /usr/local/bin/usearch

# install megahit
RUN wget https://github.com/voutcn/megahit/releases/download/v1.1.3/megahit_v1.1.3_LINUX_CPUONLY_x86_64-bin.tar.gz && \
    tar xzvf megahit_v1.1.3_LINUX_CPUONLY_x86_64-bin.tar.gz && \
    cp megahit_v1.1.3_LINUX_CPUONLY_x86_64-bin/megahit* /usr/local/bin/ && \
    rm -r megahit_v1.1.3_LINUX_CPUONLY_x86_64-bin*

# install prokka with lateast blastdb
RUN apt-get update && apt-get install libdatetime-perl libxml-simple-perl libdigest-md5-perl bioperl parallel git -y && \
    apt-get remove ncbi-blast+ -y && \
    git clone https://github.com/tseemann/prokka.git && \
    mv prokka /opt/ && \
    /opt/prokka/bin/prokka --setupdb && \
    ln -s /opt/prokka/bin/* /usr/local/bin/ && \
    ln -s /opt/prokka/binaries/linux/tbl2asn /usr/local/bin/ && \
    wget -O tbl2asn.gz ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz && \
    gunzip tbl2asn.gz && \
    chmod +x tbl2asn && \
    mv tbl2asn /usr/local/bin/ && \
    wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.8.1/ncbi-blast-2.8.1+-x64-linux.tar.gz && \
    tar xzvf ncbi-blast-2.8.1+-x64-linux.tar.gz && \
    cp ncbi-blast-2.8.1+/bin/* /usr/local/bin/ && \
    rm -r ncbi-blast-2.8.1+* && \
    /opt/prokka/bin/prokka --setupdb

# install prodigal
RUN wget https://github.com/hyattpd/Prodigal/releases/download/v2.6.3/prodigal.linux && \
    chmod +x prodigal.linux && \
    mv prodigal.linux /usr/local/bin/prodigal

# install featurecounts
RUN wget https://sourceforge.net/projects/subread/files/subread-2.0.1/subread-2.0.1-Linux-x86_64.tar.gz && \
    tar xzvf subread-2.0.1-Linux-x86_64.tar.gz && \
    cp -r subread-2.0.1-Linux-x86_64/bin/* /usr/local/bin/ && \
    cp -r subread-2.0.1-Linux-x86_64/bin/*/* /usr/local/bin/ && \
    rm -r subread-2.0.1*

# update env to allow for ascii reads
ENV LC_ALL C.UTF-8

RUN apt-get update && apt-get install -y python3-numpy python3-scipy python3-pandas vim 

RUN pip3 install metawibele==0.4.4
