# Use the biobakery base image
FROM quay.io/biobakery/base

# Update the formulas, download with retry, install strainphlan, and remove cache
RUN brew update && brew fetch biobakery/biobakery/strainphlan --retry --deps && brew install biobakery/biobakery/strainphlan && rm -rf $(brew --cache) 

