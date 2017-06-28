# Use the biobakery base image
FROM quay.io/biobakery/base

# Update the formulas, install shortbred, and remove cache
RUN brew update && brew install biobakery/biobakery/shortbred && rm -rf $(brew --cache) 

