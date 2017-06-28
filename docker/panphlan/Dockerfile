# Use the biobakery base image
FROM quay.io/biobakery/base

# Update the formulas, install panphlan, and remove cache
RUN brew update && brew install biobakery/biobakery/panphlan && rm -rf $(brew --cache) 

