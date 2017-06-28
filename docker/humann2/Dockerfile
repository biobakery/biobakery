# Use the biobakery base image
FROM quay.io/biobakery/base

# Update the formulas, download with retry, install humann2, and remove cache
RUN brew update && brew fetch biobakery/biobakery/humann2 --retry --deps && brew install biobakery/biobakery/humann2 && rm -rf $(brew --cache) 

