metaphlan $INPUT_FOLDER/SRS014459-Stool.fasta.gz $OUTPUT_FOLDER/SRS014459-Stool_profile.txt --bowtie2out $OUTPUT_FOLDER/SRS014459-Stool.fasta.gz.bowtie2out.txt --input_type fasta --nproc $THREADS
metaphlan $INPUT_FOLDER/SRS014464-Anterior_nares.fasta.gz $OUTPUT_FOLDER/SRS014464-Anterior_nares_profile.txt --bowtie2out $OUTPUT_FOLDER/SRS014464-Anterior_nares.fasta.gz.bowtie2out.txt --input_type fasta --nproc $THREADS
metaphlan $INPUT_FOLDER/SRS014470-Tongue_dorsum.fasta.gz $OUTPUT_FOLDER/SRS014470-Tongue_dorsum_profile.txt --bowtie2out $OUTPUT_FOLDER/SRS014470-Tongue_dorsum.fasta.gz.bowtie2out.txt --input_type fasta --nproc $THREADS
metaphlan $INPUT_FOLDER/SRS014472-Buccal_mucosa.fasta.gz $OUTPUT_FOLDER/SRS014472-Buccal_mucosa_profile.txt --bowtie2out $OUTPUT_FOLDER/SRS014472-Buccal_mucosa.fasta.gz.bowtie2out.txt --input_type fasta --nproc $THREADS
metaphlan $INPUT_FOLDER/SRS014476-Supragingival_plaque.fasta.gz $OUTPUT_FOLDER/SRS014476-Supragingival_plaque_profile.txt --bowtie2out $OUTPUT_FOLDER/SRS014476-Supragingival_plaque.fasta.gz.bowtie2out.txt --input_type fasta --nproc $THREADS
metaphlan $INPUT_FOLDER/SRS014494-Posterior_fornix.fasta.gz $OUTPUT_FOLDER/SRS014494-Posterior_fornix_profile.txt --bowtie2out $OUTPUT_FOLDER/SRS014494-Posterior_fornix.fasta.gz.bowtie2out.txt --input_type fasta --nproc $THREADS

# merge the tables
merge_metaphlan_tables.py $OUTPUT_FOLDER/*_profile.txt > $OUTPUT_FOLDER/merged_abundance_table.txt

grep -E "s__|SRS" merged_abundance_table.txt grep -v "t__" sed "s/^.*|//g" sed "s/SRS[0-9]*-//g" > $OUTPUT_FOLDER/merged_abundance_table_species.txt

hclust2.py -i $OUTPUT_FOLDER/merged_abundance_table_species.txt -o $OUTPUT_FOLDER/abundance_heatmap_species.png --f_dist_f braycurtis --s_dist_f braycurtis --cell_aspect_ratio 0.5 --log_scale --flabel_size 10 --slabel_size 10 --max_flabel_len 100 --max_slabel_len 100 --minv 0.1 --dpi 300
