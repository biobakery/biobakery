
import os
import sys
import subprocess

# To run:
# python gather_data_files.py wiki_page.md download_folder

# run the script and answer "yes|y" or "no|n" to indicate if the file should be downloaded

infile = sys.argv[1]
outfolder = sys.argv[2]

if not os.path.isdir(outfolder):
    os.mkdir(outfolder)

for line in open(infile):
    if "(" in line and "[" in line:
        name=line.split("[")[1].split("]")[0]
        url=line.split("(")[1].split(")")[0]
        filename=os.path.basename(url)
        if name and url and "http" in url and "." in filename:
            answer=input("Would you like to download "+url+" ? ")
            if "y" in answer.lower():
                downloaded_file=os.path.join(outfolder,filename)
                subprocess.check_call("wget "+url+" -O "+downloaded_file,shell=True)
                print("Downloaded: "+downloaded_file)


