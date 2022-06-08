waafle_search $INPUT_FOLDER/demo_contigs.fna $INPUT_FOLDER/demo_waafledb/demo_waafledb

waafle_genecaller $OUTPUT_FOLDER/demo_contigs.blastout
waafle_orgscorer \
	$INPUT_FOLDER/demo_contigs.fna \
	$OUTPUT_FOLDER/demo_contigs.blastout \
	$OUTPUT_FOLDER/demo_contigs.gff \
	$INPUT_FOLDER/demo_taxonomy.tsv
prodigal.linux \
    -i $INPUT_FOLDER/demo_contigs.fna \
    -f gff \
    -o $OUTPUT_FOLDER/demo_contigs.prodigal.gff
