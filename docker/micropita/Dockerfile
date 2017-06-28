# Use the biobakery base image
FROM quay.io/biobakery/base

# Update the formulas, install micropita, and remove cache
RUN brew update && brew install biobakery/biobakery/micropita && rm -rf $(brew --cache) 

