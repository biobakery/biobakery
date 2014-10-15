#!/bin/bash
user="$1"
test -z "${user}" && user=$(whoami)

chmod 664 *.deb *.gz
cd ..
tar cz deb-packages | ssh "${user}"@huttenhower.rc.fas.harvard.edu "umask 002; cd /usr/local/www/html/biobakery-shop/; rm deb-packages/*.{deb,gz}; tar -xvzf -" 2>&1 | egrep -v 'utime|failure'
cd -
