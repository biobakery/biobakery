# Use the biobakery base image
FROM quay.io/biobakery/base

# Update the formulas, install lefse, and remove cache
RUN brew update && brew install biobakery/biobakery/lefse && rm -rf $(brew --cache)

