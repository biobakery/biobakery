
metaphlan $INPUT_FOLDER/SRS013951.fastq.bz2 --input_type fastq -s $OUTPUT_FOLDER/SRS013951.sam.bz2 --bowtie2out $OUTPUT_FOLDER/SRS013951.bowtie2.bz2 -o $OUTPUT_FOLDER/SRS013951_profile.tsv
metaphlan $INPUT_FOLDER/SRS014613.fastq.bz2 --input_type fastq -s $OUTPUT_FOLDER/SRS014613.sam.bz2 --bowtie2out $OUTPUT_FOLDER/SRS014613.bowtie2.bz2 -o $OUTPUT_FOLDER/SRS014613_profile.tsv
metaphlan $INPUT_FOLDER/SRS019161.fastq.bz2 --input_type fastq -s $OUTPUT_FOLDER/SRS019161.sam.bz2 --bowtie2out $OUTPUT_FOLDER/SRS019161.bowtie2.bz2 -o $OUTPUT_FOLDER/SRS019161_profile.tsv
metaphlan $INPUT_FOLDER/SRS022137.fastq.bz2 --input_type fastq -s $OUTPUT_FOLDER/SRS022137.sam.bz2 --bowtie2out $OUTPUT_FOLDER/SRS022137.bowtie2.bz2 -o $OUTPUT_FOLDER/SRS022137_profile.tsv
metaphlan $INPUT_FOLDER/SRS055982.fastq.bz2 --input_type fastq -s $OUTPUT_FOLDER/SRS055982.sam.bz2 --bowtie2out $OUTPUT_FOLDER/SRS055982.bowtie2.bz2 -o $OUTPUT_FOLDER/SRS055982_profile.tsv
metaphlan $INPUT_FOLDER/SRS064276.fastq.bz2 --input_type fastq -s $OUTPUT_FOLDER/SRS064276.sam.bz2 --bowtie2out $OUTPUT_FOLDER/SRS064276.bowtie2.bz2 -o $OUTPUT_FOLDER/SRS064276_profile.tsv

sample2markers.py -i $OUTPUT_FOLDER/*.sam.bz2 -o $OUTPUT_FOLDER --nprocs $THREADS

extract_markers.py -c s__Eubacterium_rectale -o $OUTPUT_FOLDER/clade_markers/

strainphlan -s $OUTPUT_FOLDER/*.pkl -m $OUTPUT_FOLDER/db_markers/t__SGB1877.fna -r $INPUT_FOLDER/reference_genomes/*.fna -o $OUTPUT_FOLDER/ -c t__SGB1877

# requires graphlan

add_metadata_tree.py -t $OUTPUT_FOLDER/RAxML_bestTree.t__SGB1877.tre -f $INPUT_FOLDER/metadata.txt -m subjectID --string_to_remove .fastq.bz2

plot_tree_graphlan.py -t $OUTPUT_FOLDER/RAxML_bestTree.t__SGB1877.metadata -m subjectID


