# get the version information (demo developed with humann2 v0.8.0)
humann2 --version

# run humann2 on the demo input file
humann2 --input $INPUT_FOLDER/demo.fastq --output $OUTPUT_FOLDER --verbose --threads $THREADS

# renorm the output files
humann2_renorm_table --input $OUTPUT_FOLDER/demo_genefamilies.tsv --output $OUTPUT_FOLDER/demo_genefamilies_renorm.tsv
humann2_renorm_table --input $OUTPUT_FOLDER/demo_pathabundance.tsv --output $OUTPUT_FOLDER/demo_pathabundance_renorm.tsv
