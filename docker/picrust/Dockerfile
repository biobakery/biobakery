# Use the biobakery base image
FROM quay.io/biobakery/base

# Update the formulas, install picrust, and remove cache
RUN brew update && brew install biobakery/biobakery/picrust && rm -rf $(brew --cache) 

