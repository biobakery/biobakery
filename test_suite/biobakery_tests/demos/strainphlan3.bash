
for f in $INPUT_FOLDER/*
do
    echo "Running metaphlan 3.0 on ${f}"
    bn=$(basename ${f%.fastq.bz2})
    metaphlan $f --input_type fastq -s $OUTPUT_FOLDER/${bn}.sam.bz2 --bowtie2out $OUTPUT_FOLDER/${bn}.bowtie2.bz2 -o $OUTPUT_FOLDER/${bn}_profile.tsv
done

sample2markers.py -i $OUTPUT_FOLDER/*.sam.bz2 -o $OUTPUT_FOLDER --nprocs $THREADS

extract_markers.py -c s__Eubacterium_rectale -o $OUTPUT_FOLDER/clade_markers/

strainphlan -s $OUTPUT_FOLDER/*.pkl -m $OUTPUT_FOLDER/clade_markers/s__Eubacterium_rectale.fna -r $INPUT_FOLDER/reference_genomes/*.fna -o $OUTPUT_FOLDER/ -c s__Eubacterium_rectale --phylophlan_mode fast --nproc 4

# requires graphlan

add_metadata_tree.py --ifn_trees $OUTPUT_FOLDER/RAxML_bestTree.s__Eubacterium_rectale.StrainPhlAn3.tre --ifn_metadata $INPUT_FOLDER/metadata.txt

plot_tree_graphlan.py --ifn_tree $OUTPUT_FOLDER/RAxML_bestTree.s__Eubacterium_rectale.StrainPhlAn3.tre.metadata  --colorized_metadata Country --leaf_marker_size 60 --legend_marker_size 60

strainphlan_ggtree_vis.R $OUTPUT_FOLDER/RAxML_bestTree.s__Eubacterium_rectale.StrainPhlAn3.tre $INPUT_FOLDER/metadata.txt $OUTPUT_FOLDER/s__Eubacterium_rectale.StrainPhlAn3_concatenated.aln $OUTPUT_FOLDER/strainphlan_tree_1.png $OUTPUT_FOLDER/strainphlan_tree_2.png

# requires biobakery workflows
distmat
strainphlan_ordination_vis.R $OUTPUT_FOLDER/strainphlan3_concatenated.distmat $INPUT_FOLDER/metadata.txt $OUTPUT_FOLDER/strainphlan_ordination.png

