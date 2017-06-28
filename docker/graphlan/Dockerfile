# Use the biobakery base image
FROM quay.io/biobakery/base

# Update the formulas, install graphlan, and remove cache
RUN brew update && brew install biobakery/biobakery/graphlan && rm -rf $(brew --cache) 

