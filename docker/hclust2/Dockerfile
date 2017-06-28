# Use the biobakery base image
FROM quay.io/biobakery/base

# Update the formulas, install hclust2, and remove cache
RUN brew update && brew install biobakery/biobakery/hclust2 && rm -rf $(brew --cache) 

