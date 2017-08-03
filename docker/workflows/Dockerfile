# Use the biobakery base image
FROM quay.io/biobakery/base

# Add image version and date
RUN echo "Image version 1.0, "$(date) > $HOME/image_version.txt

# Install dependencies not included with homebrew formula
USER root
# Update all installed packages
RUN apt-get -qq update && apt-get install pandoc texlive-full  -y

# Install all tools, each as individual layer
USER linuxbrew
RUN brew update && brew fetch biobakery/biobakery/strainphlan --retry --deps && brew install biobakery/biobakery/strainphlan && rm -rf $(brew --cache) 
RUN brew update && brew install biobakery/biobakery/humann2 --without-metaphlan2 && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/kneaddata && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/picrust && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/hclust2 && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/workflows && rm -rf $(brew --cache)

