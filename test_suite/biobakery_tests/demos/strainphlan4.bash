
for f in $INPUT_FOLDER/* ; do
    echo "Running metaphlan 3.0 on ${f}"
    bn=$(basename ${f%.fastq.bz2})
    metaphlan $f --input_type fastq -s $OUTPUT_FOLDER/${bn}.sam.bz2 --bowtie2out $OUTPUT_FOLDER/${bn}.bowtie2.bz2 -o $OUTPUT_FOLDER/${bn}_profile.tsv
done

sample2markers.py -i $OUTPUT_FOLDER/*.sam.bz2 -o $OUTPUT_FOLDER --nprocs $THREADS

extract_markers.py -c s__Eubacterium_rectale -o $OUTPUT_FOLDER/clade_markers/

strainphlan -s $OUTPUT_FOLDER/*.pkl -m $OUTPUT_FOLDER/db_markers/t__SGB1877.fna -r $INPUT_FOLDER/reference_genomes/*.fna -o $OUTPUT_FOLDER/ -c t__SGB1877

# requires graphlan

add_metadata_tree.py -t $OUTPUT_FOLDER/RAxML_bestTree.t__SGB1877.tre -f $INPUT_FOLDER/metadata.txt -m subjectID --string_to_remove .fastq.bz2

plot_tree_graphlan.py -t $OUTPUT_FOLDER/RAxML_bestTree.t__SGB1877.metadata -m subjectID


