# Use the biobakery base image
FROM quay.io/biobakery/base

# Update the formulas, install kneaddata, and remove cache
RUN brew update && brew install biobakery/biobakery/kneaddata && rm -rf $(brew --cache)
