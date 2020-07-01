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

RUN apt-get install python3-pysam samtools zlib1g-dev libbz2-dev liblzma-dev -y

# install v3 of phylophlan plus dependencies and setup default configuration
RUN apt-get install fasttree ncbi-blast+ mafft raxml -y
RUN pip3 install PhyloPhlAn
RUN wget https://github.com/scapella/trimal/archive/v1.4.1.tar.gz && \
    tar xzvf v1.4.1.tar.gz && \
    cd trimal-1.4.1/source/ && make && cp *al /usr/local/bin/ && \
    cd ../../ && \
    rm v1.4.1.tar.gz && rm -r trimal-1.4.1

# write config files
RUN mkdir -p /usr/local/lib/python3.6/dist-packages/phylophlan/phylophlan_configs
RUN phylophlan_write_config_file -o /usr/local/lib/python3.6/dist-packages/phylophlan/phylophlan_configs/supermatrix_nt.cfg \
    -d n --db_dna makeblastdb --map_dna blastn --msa mafft --trim trimal --tree1 fasttree --tree2 raxml --overwrite --verbose

RUN pip3 install metaphlan==3.0.1
RUN metaphlan --install --nproc 24

WORKDIR /tmp
