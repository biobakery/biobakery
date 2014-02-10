#!/bin/bash

names_list=$(ls *.deb | sed -e 's/_.*.deb//' | sort | uniq)

echo "${names_list}" | while read name; do

    ls ${name}*.deb \
	| sed -e 's/.*_\([0-9][0-9]*\)_.*/\1/' \
	| python -c 'import datetime, sys; map( lambda val: sys.stdout.write(str(datetime.datetime.strptime(val.strip(), "%d%m%y").strftime("%s"))+"\n"), sys.stdin)' \
	| sort -rn \
	| sed -ne '2,$p' \
	| xargs -I%n date -d "@%n" "+${name}_%d%m%y_all.deb" \
	| xargs rm -vf

done
