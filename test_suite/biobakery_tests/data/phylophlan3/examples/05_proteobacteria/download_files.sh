#!/bin/bash
# sets two variables for printing in bold and normal font
bold=$(tput bold)
normal=$(tput sgr0)
IFS='
'

# This function receives two arguments.
# The first one should be the context of the txt file to download files.
# The second argument should be the directory to which the files will be written.
download_all_files() {
    # iterate through file to curl all links
    for line in $1;
    do
        echo -e "${bold}Downloading from url: ${line}...\n${normal}"
	line2=${line##*/}
        curl $line -o ${2%/}/${line2/.fa/.fna}
        echo -e "\n"
    done

    echo "${bold}All downloads have finished!"
}


# Checks if required argument exist
if [ "$1" == "" ]; then
    echo -e "Required file for download is missing.\n"
    echo "Usage: $0 <download_file_from_opendata.txt> [optional_download_directory]"
    exit 1
fi

# Checks if optional argument for output folder is provided.
if [ "$2" == "" ]; then
    download_directory="examples/05_chlamydiae/downloaded_files"
else
    download_directory="$2"
fi

# Create output directory if it still doesn't exist
mkdir -p "$download_directory"

# fetches the file from the first provided argument
download_file=`cat $1`
echo -e "${bold}downloading files from: $download_file\n"

download_all_files "$download_file" "$download_directory"
