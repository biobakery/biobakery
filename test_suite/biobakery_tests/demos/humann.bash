
humann_test

humann --input $INPUT_FOLDER/demo.fastq.gz --output $OUTPUT_FOLDER --threads $THREADS

humann --input $INPUT_FOLDER/demo.sam --output $OUTPUT_FOLDER --threads $THREADS

humann --input $INPUT_FOLDER/demo.m8 --output $OUTPUT_FOLDER --threads $THREADS

humann --input $INPUT_FOLDER/demo.fastq.gz --output $OUTPUT_FOLDER --verbose --threads $THREADS --bypass-translated-search

humann_renorm_table --input $OUTPUT_FOLDER/demo_genefamilies.tsv --output $OUTPUT_FOLDER/demo_genefamilies-cpm.tsv --units cpm --update-snames

humann_regroup_table --input $OUTPUT_FOLDER/demo_genefamilies-cpm.tsv --output $OUTPUT_FOLDER/rxn-cpm.tsv --groups uniref90_rxn

humann_rename_table --input $OUTPUT_FOLDER/rxn-cpm.tsv --output $OUTPUT_FOLDER/rxn-cpm-named.tsv --names metacyc-rxn

humann -i $INPUT_FOLDER/763577454-SRS014459-Stool.fasta -o $OUTPUT_FOLDER/763577454 --threads $THREADS
humann -i $INPUT_FOLDER/763577454-SRS014464-Anterior_nares.fasta -o $OUTPUT_FOLDER/763577454 --threads $THREADS
humann -i $INPUT_FOLDER/763577454-SRS014470-Tongue_dorsum.fasta -o $OUTPUT_FOLDER/763577454 --threads $THREADS
humann -i $INPUT_FOLDER/763577454-SRS014472-Buccal_mucosa.fasta -o $OUTPUT_FOLDER/763577454 --threads $THREADS
humann -i $INPUT_FOLDER/763577454-SRS014476-Supragingival_plaque.fasta -o $OUTPUT_FOLDER/763577454 --threads $THREADS
humann -i $INPUT_FOLDER/763577454-SRS014494-Posterior_fornix.fasta -o $OUTPUT_FOLDER/763577454 --threads $THREADS

humann_join_tables -i $OUTPUT_FOLDER/763577454 -o $OUTPUT_FOLDER/763577454_genefamilies.tsv --file_name genefamilies

humann_renorm_table -i $OUTPUT_FOLDER/763577454_genefamilies.tsv -o $OUTPUT_FOLDER/763577454_genefamilies_cpm.tsv --units cpm

humann_barplot --input $INPUT_FOLDER/hmp_pathabund.pcl --focal-feature METSYN-PWY --focal-metadata STSite --last-metadata STSite --output $OUTPUT_FOLDER/plot1.png
humann_barplot --sort sum --input $INPUT_FOLDER/hmp_pathabund.pcl --focal-feature METSYN-PWY --focal-metadata STSite --last-metadata STSite --output $OUTPUT_FOLDER/plot2.png
humann_barplot --sort sum metadata --input $INPUT_FOLDER/hmp_pathabund.pcl --focal-feature METSYN-PWY --focal-metadata STSite --last-metadata STSite --output $OUTPUT_FOLDER/plot3.png --scaling logstack
humann_barplot --sort sum --input $INPUT_FOLDER/hmp_pathabund.pcl --focal-feature COA-PWY --focal-metadata STSite --last-metadata STSite --output $OUTPUT_FOLDER/plot4.png
humann_barplot --sort braycurtis --scaling logstack --as-genera --remove-zeros --input $INPUT_FOLDER/hmp_pathabund.pcl --focal-feature COA-PWY --focal-metadata STSite --last-metadata STSite --output $OUTPUT_FOLDER/plot5.png

