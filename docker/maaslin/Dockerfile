# Use the biobakery base image
FROM quay.io/biobakery/base

# Update the formulas, install maaslin, and remove cache
RUN brew update && brew install biobakery/biobakery/maaslin && rm -rf $(brew --cache) 

