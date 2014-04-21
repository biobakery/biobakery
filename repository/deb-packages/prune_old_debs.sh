#!/bin/bash

names_list=$(ls *.deb | sed -e 's/_.*.deb//' | sort | uniq)

echo "${names_list}" | while read name; do

    ls ${name}*.deb \
	| sort -rn \
	| sed -ne '2,$p' \
	| xargs -r rm -vf 

done
