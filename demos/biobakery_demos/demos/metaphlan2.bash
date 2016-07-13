# get the version information (demo developed with metaphlan2 v2.3.0-c07bede)
metaphlan2.py --version

# run metaphlan2 on the demo input files
metaphlan2.py $INPUT_FOLDER/SRS014459-Stool.fasta.gz $OUTPUT_FOLDER/SRS014459-Stool_profile.txt --bowtie2out $OUTPUT_FOLDER/SRS014459-Stool.fasta.gz.bowtie2out.txt --input_type fasta --nproc $THREADS
metaphlan2.py $INPUT_FOLDER/SRS014464-Anterior_nares.fasta.gz $OUTPUT_FOLDER/SRS014464-Anterior_nares_profile.txt --bowtie2out $OUTPUT_FOLDER/SRS014464-Anterior_nares.fasta.gz.bowtie2out.txt --input_type fasta --nproc $THREADS
metaphlan2.py $INPUT_FOLDER/SRS014470-Tongue_dorsum.fasta.gz $OUTPUT_FOLDER/SRS014470-Tongue_dorsum_profile.txt --bowtie2out $OUTPUT_FOLDER/SRS014470-Tongue_dorsum.fasta.gz.bowtie2out.txt --input_type fasta --nproc $THREADS
metaphlan2.py $INPUT_FOLDER/SRS014472-Buccal_mucosa.fasta.gz $OUTPUT_FOLDER/SRS014472-Buccal_mucosa_profile.txt --bowtie2out $OUTPUT_FOLDER/SRS014472-Buccal_mucosa.fasta.gz.bowtie2out.txt --input_type fasta --nproc $THREADS
metaphlan2.py $INPUT_FOLDER/SRS014476-Supragingival_plaque.fasta.gz $OUTPUT_FOLDER/SRS014476-Supragingival_plaque_profile.txt --bowtie2out $OUTPUT_FOLDER/SRS014476-Supragingival_plaque.fasta.gz.bowtie2out.txt --input_type fasta --nproc $THREADS
metaphlan2.py $INPUT_FOLDER/SRS014494-Posterior_fornix.fasta.gz $OUTPUT_FOLDER/SRS014494-Posterior_fornix_profile.txt --bowtie2out $OUTPUT_FOLDER/SRS014494-Posterior_fornix.fasta.gz.bowtie2out.txt --input_type fasta --nproc $THREADS

# merge the tables
merge_metaphlan_tables.py $OUTPUT_FOLDER/*_profile.txt > $OUTPUT_FOLDER/merged_abundance_table.txt
