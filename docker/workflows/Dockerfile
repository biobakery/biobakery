# Use the biobakery base image
FROM quay.io/biobakery/base

# Add image version and date
RUN echo "Image version 1.1, "$(date) > $HOME/image_version.txt

# Install dependencies not included with homebrew formula
USER root
# Update all installed packages
RUN apt-get -qq update && apt-get install pandoc texlive-full  -y

# Add paths for workflow and dependencies to be used as libraries
USER linuxbrew
ENV PYTHONPATH /home/linuxbrew/.linuxbrew/lib/python2.7/site-packages:$PYTHONPATH
ENV PYTHONPATH /home/linuxbrew/.linuxbrew/lib/python2.7/dist-packages:$PYTHONPATH
ENV PYTHONPATH /home/linuxbrew/.linuxbrew/lib64/python2.7/site-packages:$PYTHONPATH
ENV R_LIBS /home/linuxbrew/.linuxbrew/R/library:$R_LIBS

# Install all tools, each as individual layer
RUN brew update && brew fetch biobakery/biobakery/strainphlan --retry --deps && brew install biobakery/biobakery/strainphlan && rm -rf $(brew --cache) 
RUN brew update && brew install biobakery/biobakery/humann2 --without-metaphlan2 && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/kneaddata && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/picrust && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/hclust2 && rm -rf $(brew --cache)
RUN brew update && brew install biobakery/biobakery/workflows && rm -rf $(brew --cache)
RUN HOMEBREW_NO_AUTO_UPDATE=1 brew install glpk
