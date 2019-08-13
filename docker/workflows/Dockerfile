# Use the biobakery base image
FROM biobakery/base:1.0

# Install dependencies (texlive and pandoc needed for visualizations)
RUN apt-get update && \
    apt-get install -y texlive pandoc

RUN /opt/conda/bin/conda install biobakery_workflows==0.13.1
RUN /opt/conda/bin/conda install hclust2==1.0.0_3d589ab r-vegan
