#! /usr/bin/env bash

# This script will create an image to export of biobakery.
# The script requires the drives attached to be named "disk-temp"
# and "disk-biobakery-image". It also requires a bucket named 
# "biobakery_bucket".

# Create an empty temp disk and mount
sudo mkdir /mnt/tmp
sudo mkfs.ext4 -F /dev/disk/by-id/google-disk-temp
sudo mount -o discard,defaults /dev/disk/by-id/google-disk-temp /mnt/tmp

# Mount the image disk and remove ssh keys
sudo mkdir /mnt/image-disk
sudo mount /dev/disk/by-id/google-disk-biobakery-image-part1 /mnt/image-disk

# Securely delete (overwrite and rm) ssh keys for all users
sudo shred -u /mnt/image-disk/home/*/.ssh/authorized_keys
sudo shred -u /mnt/image-disk/root/.ssh/authorized_keys

# Securely delete host key pairs
sudo shred -u /mnt/image-disk/etc/ssh/*_key
sudo shred -u /mnt/image-disk/etc/ssh/*_key.pub

# Securely delete the history files of all users
sudo shred -u /mnt/image-disk/home/*/.*history

# Delete all user folders
sudo rm -r /mnt/image-disk/home/*

# Unmount the image disk
sudo umount /mnt/image-disk/

# Create an image to export
sudo dd if=/dev/disk/by-id/google-disk-biobakery-image of=/mnt/tmp/disk.raw bs=4096

# Move to the directory and then archive (as full paths cause errors in the archive)
( cd /mnt/tmp && sudo tar czvf biobakery_image_v1.0.tar.gz disk.raw )

# Copy the image to google storage bucket
gsutil cp /mnt/tmp/biobakery_image_v1.0.tar.gz gs://biobakery_bucket/

# Unmount the temp drive
sudo umount /mnt/tmp

