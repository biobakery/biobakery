#!/bin/bash

# Check dependencies
deps=$(cat - <<EOF
readlink sed dpkg-scanpackages tee gzip bzip2
apt-ftparchive gpg
EOF
)
for dep in $deps; do
    if ! which $dep >/dev/null; then
	echo "Missing required program: $dep" >&2
	missing_deps="True"
    fi
done
if ! test -z $missing_deps; then
    echo "Unable to continue without the above programs" >&2
    exit 1
fi


# create the Packages file
cd $( readlink -f "$0" | sed -e 's/\(.*\)\/.*/\1/g' )
dpkg-scanpackages . | tee Packages | gzip -9c > Packages.gz
bzip2 -9c < Packages > Packages.bz2

# create the Translation file
sed -ne '/^MD5sum:/p; /^Package:/p; /^Description:/,/^[ \t]*$/p' Packages \
    | sed -e 's|^MD5sum|Description-md5|; s|^Description:|Description-en|' \
    | tee Translation-en \
    | tee Translation-en_US \
    | gzip -9c > Translation-en.gz
gzip -9c < Translation-en > Translation-en_US.gz
bzip2 -9c < Translation-en > Translation-en.bz2
bzip2 -9c < Translation-en > Translation-en_US.bz2

###
# finally, create the Release file
###
echo \
"Origin: biobakery
Label: biobakery
Suite: stable
Codename: stable
Date: $(date -u '+%A, %d %b %Y %H:%M:%S %Z')
Architectures: all amd64 i386" > Release
apt-ftparchive release . >> Release

# encrypt the Release file
gpg -abs -o - Release > Release.gpg

cd - >/dev/null 2>&1
