# Use the biobakery base image
FROM biobakery/base:1.1

# Install dependencies (texlive and pandoc needed for visualizations)
RUN apt-get update && \
    apt-get install -y texlive pandoc

RUN /opt/conda/bin/conda install biobakery_workflows==0.13.2
RUN /opt/conda/bin/conda install hclust2
RUN /opt/conda/bin/conda install r

# install vegan outside of conda as there are conflicts with other dependencies
RUN /opt/conda/bin/R -q -e "install.packages('vegan', repos='http://cran.r-project.org')"

# revert back to the samtools required for strainphlan
RUN /opt/conda/bin/conda install samtools=0.1.19

# symlink the databases to the prior location for metaphlan extract markers script
RUN ln -s /opt/conda/bin/metaphlan_databases /opt/conda/bin/db_v20
