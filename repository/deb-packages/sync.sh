#!/bin/bash
user="$1"
test -z "${user}" && user=$(whoami)

rsync -avz "${user}"@huttenhower.rc.fas.harvard.edu:/usr/local/www/html/biobakery-shop/deb-packages/ ./
