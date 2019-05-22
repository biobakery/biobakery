# Use the biobakery base image
FROM quay.io/biobakery/base

# Add image version and date
RUN echo "Image version 1.0, "$(date) > $HOME/image_version.txt

# Update the formulas, install kneaddata, and remove cache
RUN brew update && brew install biobakery/biobakery/kneaddata && rm -rf $(brew --cache)
