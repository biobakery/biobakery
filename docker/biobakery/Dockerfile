# Use the biobakery base image
FROM quay.io/biobakery/base

# Add image version and date
RUN echo "Image version 1.0, "$(date) > $HOME/image_version.txt

# Install all tools, each as individual layer
RUN brew update && brew fetch biobakery/biobakery/strainphlan --retry --deps && brew install biobakery/biobakery/strainphlan && rm -rf $(brew --cache) 
RUN brew update && brew install biobakery/biobakery/humann2 --without-metaphlan2 && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/kneaddata && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/picrust && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/maaslin && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/shortbred && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/sparsedossa && rm -rf $(brew --cache) 
RUN brew update && brew install biobakery/biobakery/ppanini && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/lefse && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/graphlan && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/micropita && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/breadcrumbs && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/halla && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/hclust2 && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/panphlan && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/workflows && rm -rf $(brew --cache)
