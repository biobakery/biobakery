FROM biobakery/biobakery
RUN apt-get install -y qiime-cmd
RUN apt-get install -y python-biopython
RUN apt-get install -y python-numpy
RUN apt-get install -y python-scipy
RUN pip install -e 'git+https://bitbucket.org/biobakery/anadama.git@master#egg=anadama-0.0.1'
RUN pip install -e 'git+https://bitbucket.org/biobakery/anadama_workflows.git@master#egg=anadama_workflows-0.0.1'
