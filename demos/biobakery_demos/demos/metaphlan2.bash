# get the version information (demo developed with metaphlan2 v2.3.0-c07bede)
metaphlan2.py --version

# run metaphlan2 on the demo input file
metaphlan2.py $INPUT_FOLDER/demo.fastq $OUTPUT_FOLDER/profiled_metagenome.txt --bowtie2out $OUTPUT_FOLDER/metagenome.bowtie2.bz2 --input_type multifastq --nproc $THREADS

