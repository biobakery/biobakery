
import argparse

# To run:
# gather_code_chunks.py --input wiki_page.md --output commands.bash

# run the script and answer "yes|y" or "no|n" to indicate if code should be included


parser = argparse.ArgumentParser(description="A utility script to search for code chunks on a tutorial page")

parser.add_argument(
    "-i", "--input",
    help="A markdown wiki page \n[REQUIRED]",
    metavar="<input.md>",
    required=True)
parser.add_argument(
    "-o", "--output",
    help="A file to write code chunks\n[REQUIRED]",
    metavar="<output.bash>",
    required=True)

args = parser.parse_args()


code=False
chunks=[]
current_chunk=""
for line in open(args.input):
    if line.startswith("```"):
        if code:
            chunks.append(current_chunk)
            code=False
            current_chunk=""
        else:
            code=True
    elif code:
        current_chunk+=line

with open(args.output,"wt") as file_handle:
    for code in chunks:
        answer=input("Include the following code?\n\n"+code+"\n\n")
        if "y" in answer.lower():
            file_handle.write(code)

