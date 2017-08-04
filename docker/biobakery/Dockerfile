# Use the biobakery workflow image to reduce build time
FROM quay.io/biobakery/workflows

# Add image version and date
RUN echo "Image version 1.1, "$(date) > $HOME/image_version.txt

# Install all tools, each as individual layer
USER linuxbrew
RUN brew update && brew install biobakery/biobakery/maaslin && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/shortbred && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/sparsedossa && rm -rf $(brew --cache) 
RUN brew update && brew install biobakery/biobakery/ppanini && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/lefse && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/graphlan && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/micropita && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/breadcrumbs && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/halla && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/panphlan && rm -rf $(brew --cache)
