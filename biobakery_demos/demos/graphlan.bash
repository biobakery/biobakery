# get the version information (demo developed with graphlan v0.9.7)
graphlan.py --version

# run graphlan annotate on the demo input files
graphlan_annotate.py $INPUT_FOLDER/hmptree.xml $OUTPUT_FOLDER/hmptree.annot.xml --annot $INPUT_FOLDER/annot.txt

# run graphlan
graphlan.py $OUTPUT_FOLDER/hmptree.annot.xml $OUTPUT_FOLDER/hmptree.png --dpi 150 --size 14

