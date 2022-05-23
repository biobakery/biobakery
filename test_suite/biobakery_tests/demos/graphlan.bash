# get the version information (demo developed with graphlan v0.9.7)
graphlan.py --version

# generate the tree structure and annotation file
export2graphlan.py --skip_rows 1,2 -i $INPUT_FOLDER/merged_abundance_table.txt --tree $OUTPUT_FOLDER/merged_abundance.tree.txt --annotation $OUTPUT_FOLDER/merged_abundance.annot.txt --most_abundant 100 --abundance_threshold 1 --least_biomarkers 10 --annotations 5,6 --external_annotations 7 --min_clade_size 1

# run graphlan annotate on the demo input files
graphlan_annotate.py --annot $OUTPUT_FOLDER/merged_abundance.annot.txt $OUTPUT_FOLDER/merged_abundance.tree.txt $OUTPUT_FOLDER/merged_abundance.xml

# run graphlan
graphlan.py --dpi 300 $OUTPUT_FOLDER/merged_abundance.xml $OUTPUT_FOLDER/merged_abundance.png --external_legends
