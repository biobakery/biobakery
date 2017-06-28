# Use the biobakery base image
FROM quay.io/biobakery/base

# Update the formulas, install halla, and remove cache
RUN brew update && brew install biobakery/biobakery/halla && rm -rf $(brew --cache) 
