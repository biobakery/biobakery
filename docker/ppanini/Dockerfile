# Use the biobakery base image
FROM quay.io/biobakery/base

# Update the formulas, install ppanini, and remove cache
RUN brew update && brew install biobakery/biobakery/ppanini && rm -rf $(brew --cache) 

