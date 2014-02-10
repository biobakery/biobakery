#!/bin/bash
cd $( readlink -f "$0" | sed -e 's/\(.*\)\/.*/\1/g' )
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz


cd -