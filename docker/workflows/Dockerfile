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
