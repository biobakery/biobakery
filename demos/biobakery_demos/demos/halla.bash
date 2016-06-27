# get the version information (demo developed with halla v0.6.1)
halla --version

# run halla on the demo input file
halla -X $INPUT_FOLDER/X_16_100.txt -Y $INPUT_FOLDER/Y_16_100.txt --output $OUTPUT_FOLDER --nproc $THREADS

