# get the version information (demo developed with shortbred v0.9.3)
shortbred_identify.py --version

# run shortbred on the demo input files to identify markers
shortbred_identify.py --goi  $INPUT_FOLDER/input_prots.faa --ref $INPUT_FOLDER/ref_prots.faa --markers $OUTPUT_FOLDER/markers.faa --tmp $OUTPUT_FOLDER/identify_tmp --threads $THREADS

# run shortbred on the demo input file and marker file to quantify markers
shortbred_quantify.py --markers $OUTPUT_FOLDER/markers.faa --wgs $INPUT_FOLDER/wgs.fna  --results $OUTPUT_FOLDER/results.txt --tmp $OUTPUT_FOLDER/quantify_tmp --threads $THREADS

