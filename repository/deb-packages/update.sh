#!/bin/bash

chmod 664 *.deb *.gz
cd ..
tar cz deb-packages | ssh huttenhower.rc.fas.harvard.edu "umask 002; cd /usr/local/www/html/biobakery-shop/; rm deb-packages/*.{deb,gz}; tar -xvzf -" 2>&1 | egrep -v 'utime|failure'
cd -
