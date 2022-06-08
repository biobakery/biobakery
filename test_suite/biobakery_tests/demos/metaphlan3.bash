metaphlan $INPUT_FOLDER/SRS014459-Stool.fasta.gz $OUTPUT_FOLDER/SRS014459-Stool_profile.txt --bowtie2out $OUTPUT_FOLDER/SRS014459-Stool.fasta.gz.bowtie2out.txt --input_type fasta --nproc $THREADS
metaphlan $INPUT_FOLDER/SRS014464-Anterior_nares.fasta.gz $OUTPUT_FOLDER/SRS014464-Anterior_nares_profile.txt --bowtie2out $OUTPUT_FOLDER/SRS014464-Anterior_nares.fasta.gz.bowtie2out.txt --input_type fasta --nproc $THREADS
metaphlan $INPUT_FOLDER/SRS014470-Tongue_dorsum.fasta.gz $OUTPUT_FOLDER/SRS014470-Tongue_dorsum_profile.txt --bowtie2out $OUTPUT_FOLDER/SRS014470-Tongue_dorsum.fasta.gz.bowtie2out.txt --input_type fasta --nproc $THREADS
metaphlan $INPUT_FOLDER/SRS014472-Buccal_mucosa.fasta.gz $OUTPUT_FOLDER/SRS014472-Buccal_mucosa_profile.txt --bowtie2out $OUTPUT_FOLDER/SRS014472-Buccal_mucosa.fasta.gz.bowtie2out.txt --input_type fasta --nproc $THREADS
metaphlan $INPUT_FOLDER/SRS014476-Supragingival_plaque.fasta.gz $OUTPUT_FOLDER/SRS014476-Supragingival_plaque_profile.txt --bowtie2out $OUTPUT_FOLDER/SRS014476-Supragingival_plaque.fasta.gz.bowtie2out.txt --input_type fasta --nproc $THREADS
metaphlan $INPUT_FOLDER/SRS014494-Posterior_fornix.fasta.gz $OUTPUT_FOLDER/SRS014494-Posterior_fornix_profile.txt --bowtie2out $OUTPUT_FOLDER/SRS014494-Posterior_fornix.fasta.gz.bowtie2out.txt --input_type fasta --nproc $THREADS

# merge the tables
merge_metaphlan_tables.py $OUTPUT_FOLDER/*_profile.txt > $OUTPUT_FOLDER/merged_abundance_table.txt

grep -E "s__|clade" $OUTPUT_FOLDER/merged_abundance_table.txt | sed 's/^.*s__//g'\ | cut -f1,3-8 | sed -e 's/clade_name/body_site/g' > $OUTPUT_FOLDER/merged_abundance_table_species.txt

hclust2.py -i $OUTPUT_FOLDER/merged_abundance_table_species.txt -o $OUTPUT_FOLDER/abundance_heatmap_species.png --f_dist_f braycurtis --s_dist_f braycurtis --cell_aspect_ratio 0.5 -l --flabel_size 10 --slabel_size 10 --max_flabel_len 100 --max_slabel_len 100 --minv 0.1 --dpi 300

tail -n +2 $OUTPUT_FOLDER/merged_abundance_table.txt | cut -f1,3- > $OUTPUT_FOLDER/merged_abundance_table_reformatted.txt
export2graphlan.py --skip_rows 1 -i $OUTPUT_FOLDER/merged_abundance_table_reformatted.txt --tree $OUTPUT_FOLDER/merged_abundance.tree.txt --annotation $OUTPUT_FOLDER/merged_abundance.annot.txt --most_abundant 100 --abundance_threshold 1 --least_biomarkers 10 --annotations 5,6 --external_annotations 7 --min_clade_size 1

graphlan_annotate.py --annot $OUTPUT_FOLDER/merged_abundance.annot.txt $OUTPUT_FOLDER/merged_abundance.tree.txt $OUTPUT_FOLDER/merged_abundance.xml
graphlan.py --dpi 300 $OUTPUT_FOLDER/merged_abundance.xml $OUTPUT_FOLDER/merged_abundance.png --external_legends
