#!/bin/bash

find . -type f | xargs chmod 664
find . -type d | xargs chmod 775
cd ..
tar cz vagrant | ssh huttenhower.rc.fas.harvard.edu "umask 002; cd /usr/local/www/html/biobakery-shop/; rm -rf vagrant; tar -xvzf -" 2>&1 | egrep -v 'utime|failure'
cd -
