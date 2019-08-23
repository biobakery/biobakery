# use the latest miniconda image (based on python 2.7)
FROM continuumio/miniconda

# set up the conda channels
RUN /opt/conda/bin/conda config --add channels defaults && \
    /opt/conda/bin/conda config --add channels bioconda && \
    /opt/conda/bin/conda config --add channels conda-forge

# install dependencies
RUN /opt/conda/bin/conda install fastqc trimmomatic spades quast prokka eggnog-mapper

# install kneaddata plus trimmomatic jar
RUN /opt/conda/bin/pip install kneaddata --no-binary :all:

# update to version2 of eggnog mapper (version tag is 41a8498, v2 is not available as a release)
RUN git clone https://github.com/jhcepas/eggnog-mapper.git && \
    cd eggnog-mapper && \
    cp *.py bin/* /opt/conda/bin/ && \
    cp -r * /opt/conda/bin/

# install checkm
RUN /opt/conda/bin/conda install checkm-genome && \
    /opt/conda/bin/pip install checkm-genome --upgrade --no-deps && \
    mkdir /checkm && \
    cd /checkm && \
    curl -L -O curl -L -O https://data.ace.uq.edu.au/public/CheckM_databases/checkm_data_2015_01_16.tar.gz && \
    tar xzf checkm_data_2015_01_16.tar.gz && \
    /opt/conda/bin/checkm data setRoot /checkm

# install run_dbcan (some run commands from their dockerfile which we can't use in full because of the python version)
RUN /opt/conda/bin/pip install natsort

# Create signalP and run_dbcan2 environment
RUN git clone https://github.com/linnabrown/run_dbcan.git /app \
  && cd /app/tools/ && tar -xzvf signalp-4.1.tar.gz \
  && chmod +x /app/tools/signalp-4.1/signalp \
  && rm /app/tools/signalp-4.1.tar.gz
ENV PATH=/app/tools/signalp-4.1:${PATH}

# Download and make the database for run_dbcan
RUN mkdir /app/db && cd /app/db \
  && wget http://bcb.unl.edu/dbCAN2/download/Databases/CAZyDB.07312018.fa && diamond makedb --in CAZyDB.07312018.fa -d CAZy \
  && wget http://bcb.unl.edu/dbCAN2/download/Databases/dbCAN-HMMdb-V7.txt && mv dbCAN-HMMdb-V7.txt dbCAN.txt && hmmpress dbCAN.txt \
  && wget http://bcb.unl.edu/dbCAN2/download/Databases/tcdb.fa && diamond makedb --in tcdb.fa -d tcdb \
  && wget http://bcb.unl.edu/dbCAN2/download/Databases/tf-1.hmm && hmmpress tf-1.hmm \
  && wget http://bcb.unl.edu/dbCAN2/download/Databases/tf-2.hmm && hmmpress tf-2.hmm \
  && wget http://bcb.unl.edu/dbCAN2/download/Databases/stp.hmm && hmmpress stp.hmm

# install biobakery workflows
RUN apt-get update && apt-get install -y g++ && \
    /opt/conda/bin/pip install anadama2 && \
    hg clone https://biobakery@bitbucket.org/biobakery/biobakery_workflows && \
    cd biobakery_workflows && \
    hg update isolate && \
    python setup.py install
