# Use the biobakery base image
FROM biobakery/workflows:0.13.1

# Install additional tools not required by the workflows
RUN /opt/conda/bin/conda install maaslin shortbred 
RUN /opt/conda/bin/conda install bioconductor-sparsedossa ppanini lefse graphlan
RUN /opt/conda/bin/conda install micropita breadcrumbs halla panphlan waafle

