# Use the biobakery base image
FROM quay.io/biobakery/base

# Update the formulas, install breadcrumbs, and remove cache
RUN brew update && brew install biobakery/biobakery/breadcrumbs && rm -rf $(brew --cache) 

