FROM ubuntu:18.04

# also install python version 2 used by bowtie2
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y python python-dev python3 python3-dev python3-pip apt-transport-https openjdk-8-jre wget zip \
    python3-matplotlib pandoc texlive software-properties-common \
    python3-pandas python3-biopython python3-tk && \
    apt-get remove -y texlive-fonts-recommended-doc texlive-latex-base-doc \
        texlive-latex-recommended-doc \
        texlive-pictures-doc texlive-pstricks-doc

RUN pip3 install boto3 cloudpickle awscli

# install dependencies
RUN pip3 install kneaddata --no-binary :all:

RUN pip3 install humann==3.0.0.alpha.3 --no-binary :all:

RUN pip3 install numpy==1.14.5
RUN pip3 install scipy
RUN pip3 install cython
RUN apt-get install python3-pysam samtools zlib1g-dev libbz2-dev liblzma-dev -y
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

RUN pip3 install metaphlan==3.0.7
RUN metaphlan --install --nproc 24

# install hclust2 from source
RUN apt-get install -y python-pip python-matplotlib python-scipy python-pandas
RUN wget https://raw.githubusercontent.com/SegataLab/hclust2/master/hclust2.py && \
    mv hclust2.py /usr/local/bin/ && \
    chmod +x /usr/local/bin/hclust2.py

# install R with vegan
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' && \
    apt-get update -y && \
    apt-get install r-base-dev libcurl4-openssl-dev -y && \
    R -q -e "install.packages('vegan', repos='http://cran.r-project.org')"

# install workflows 16s dependencies
RUN wget https://drive5.com/downloads/usearch9.0.2132_i86linux32.gz && \
    gunzip usearch9.0.2132_i86linux32.gz && \
    chmod +x usearch9.0.2132_i86linux32 && \
    mv usearch9.0.2132_i86linux32 /usr/local/bin/usearch

RUN wget https://github.com/torognes/vsearch/releases/download/v2.14.2/vsearch-2.14.2-linux-x86_64.tar.gz && \
    tar xzvf vsearch-2.14.2-linux-x86_64.tar.gz && \
    cp vsearch-2.14.2-linux-x86_64/bin/vsearch /usr/local/bin/

# install clustalo and rename fasttree
RUN apt-get install -y clustalo
RUN ln -s /usr/bin/fasttree /usr/bin/FastTree

# install picrust2 and dependencies
RUN apt-get install hmmer -y
RUN pip3 install pandas --upgrade
RUN R -q -e "install.packages(c('castor'), repos='http://cran.r-project.org')"

RUN wget https://github.com/picrust/picrust2/archive/v2.3.0-b.tar.gz && tar xvzf v2.3.0-b.tar.gz && ( cd picrust2-2.3.0-b/ && pip3 install --editable . && cp -r picrust2/default_files /usr/local/lib/python3.6/dist-packages/picrust2/) && rm -r picrust2* && rm v2.3.0-b.tar.gz

RUN apt-get install autotools-dev libtool flex bison cmake automake autoconf -y

RUN wget https://github.com/Pbdas/epa-ng/archive/v0.3.6.tar.gz && tar xzvf v0.3.6.tar.gz
RUN cd epa-ng-0.3.6/ && make && cp bin/epa-ng /usr/local/bin/ && cd ../
RUN rm -r epa-ng* && rm v0.3.6.tar.gz

RUN wget https://github.com/lczech/gappa/archive/v0.6.0.tar.gz && tar xzvf v0.6.0.tar.gz
RUN cd gappa-0.6.0/ && make && cp bin/gappa /usr/local/bin/ && cd ../
RUN rm -r gappa* && rm v0.6.0.tar.gz

# Update to newer pandoc version (to work with latest engine options in anadama2)
RUN wget https://github.com/jgm/pandoc/releases/download/2.10/pandoc-2.10-1-amd64.deb && \
    dpkg -i pandoc-2.10-1-amd64.deb && \
    rm pandoc-2.10-1-amd64.deb

RUN pip install anadama2==0.7.9
RUN pip3 install biobakery_workflows==3.0.0-alpha.6

# install dada2 and dependencies
RUN R -q -e "install.packages('BiocManager', repos='http://cran.r-project.org')"
RUN R -q -e "library(BiocManager); BiocManager::install('dada2')"

RUN R -q -e "install.packages(c('gridExtra','seqinr','castor'), repos='http://cran.r-project.org')"

# install picrust1
RUN wget https://github.com/picrust/picrust/releases/download/v1.1.4/picrust-1.1.4.tar.gz && \
    tar -xzf picrust-1.1.4.tar.gz && cd picrust-1.1.4 && pip install .

