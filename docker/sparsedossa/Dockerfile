# Use the biobakery base image
FROM quay.io/biobakery/base

# Update the formulas, install sparsedossa, and remove cache
RUN brew update && brew install biobakery/biobakery/sparsedossa && rm -rf $(brew --cache) 

