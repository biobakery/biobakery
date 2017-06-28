# Use the biobakery base image
FROM quay.io/biobakery/base

# Update the formulas, download with retry, install metaphlan2, and remove cache
RUN brew update && brew fetch biobakery/biobakery/metaphlan2 --retry --deps && brew install biobakery/biobakery/metaphlan2 && rm -rf $(brew --cache) 

