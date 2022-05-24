
import os
import sys
import argparse
import subprocess


# To run:
# gather_data_files.py --input wiki_page.md --output download_folder

# run the script and answer "yes|y" or "no|n" to indicate if the file should be downloaded

parser = argparse.ArgumentParser(description="A utility script to search for and download files on a tutorial page")

parser.add_argument(
    "-i", "--input", 
    help="A markdown wiki page \n[REQUIRED]", 
    metavar="<input.md>", 
    required=True)
parser.add_argument(
    "-o", "--output", 
    help="A directory to store downloaded files\n[REQUIRED]", 
    metavar="<output>", 
    required=True)

args = parser.parse_args()

if not os.path.isdir(args.output):
    os.mkdir(args.output)

for line in open(args.input):
    if "(" in line and "[" in line:
        name=line.split("[")[1].split("]")[0]
        url=line.split("(")[1].split(")")[0]
        filename=os.path.basename(url)
        if name and url and "http" in url and "." in filename:
            answer=input("Would you like to download "+url+" ? ")
            if "y" in answer.lower():
                downloaded_file=os.path.join(args.output,filename)
                subprocess.check_call("wget "+url+" -O "+downloaded_file,shell=True)
                print("Downloaded: "+downloaded_file)


