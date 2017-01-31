# get the version information (demo developed with humann2 v0.8.1)
humann2 --version

# run humann2 on the demo input file
humann2 --input $INPUT_FOLDER/demo.fastq --output $OUTPUT_FOLDER --verbose --threads $THREADS --gap-fill on

# run with sam input file
humann2 --input $INPUT_FOLDER/demo.sam --output $OUTPUT_FOLDER --threads $THREADS --gap-fill on

# run with m8 input file
humann2 --input $INPUT_FOLDER/demo.m8 --output $OUTPUT_FOLDER --threads $THREADS --gap-fill on

# run humann2 on the demo input file with bypass translated search
humann2 --input $INPUT_FOLDER/demo.fastq --output $OUTPUT_FOLDER --verbose --threads $THREADS --gap-fill on --bypass-translated-search

# rename the table
humann2_rename_table --input $OUTPUT_FOLDER/demo_genefamilies.tsv --output $OUTPUT_FOLDER/demo_genefamilies-names.tsv --names uniref90

# renorm the gene families file
humann2_renorm_table --input $OUTPUT_FOLDER/demo_genefamilies.tsv --output $OUTPUT_FOLDER/demo_genefamilies-cpm.tsv --units cpm --update-snames

# regroup uniref90 to ec
humann2_regroup_table --input $OUTPUT_FOLDER/demo_genefamilies-cpm.tsv --output $OUTPUT_FOLDER/level4ec-cpm.tsv --groups uniref90_level4ec

# rename the regrouped file
humann2_rename_table --input $OUTPUT_FOLDER/level4ec-cpm.tsv --output $OUTPUT_FOLDER/level4ec-cpm-names.tsv --names ec

# run with sub-sampled input files (running with multiple samples section)
humann2 -i $INPUT_FOLDER/763577454-SRS014459-Stool.fasta -o $OUTPUT_FOLDER/763577454 --threads $THREADS
humann2 -i $INPUT_FOLDER/763577454-SRS014464-Anterior_nares.fasta -o $OUTPUT_FOLDER/763577454 --threads $THREADS
humann2 -i $INPUT_FOLDER/763577454-SRS014470-Tongue_dorsum.fasta -o $OUTPUT_FOLDER/763577454 --threads $THREADS
humann2 -i $INPUT_FOLDER/763577454-SRS014472-Buccal_mucosa.fasta -o $OUTPUT_FOLDER/763577454 --threads $THREADS
humann2 -i $INPUT_FOLDER/763577454-SRS014476-Supragingival_plaque.fasta -o $OUTPUT_FOLDER/763577454 --threads $THREADS
humann2 -i $INPUT_FOLDER/763577454-SRS014494-Posterior_fornix.fasta -o $OUTPUT_FOLDER/763577454 --threads $THREADS

# join tables
humann2_join_tables -i $OUTPUT_FOLDER/763577454 -o $OUTPUT_FOLDER/763577454_genefamilies.tsv --file_name genefamilies

# renorm table
humann2_renorm_table -i $OUTPUT_FOLDER/763577454_genefamilies.tsv -o $OUTPUT_FOLDER/763577454_genefamilies_cpm.tsv --units cpm

# associate and visualize results
humann2_associate --input $INPUT_FOLDER/hmp_pathabund.pcl --last-metadatum STSite --focal-metadatum STSite --focal-type categorical --output $OUTPUT_FOLDER/stats.txt

humann2_barplot --input $INPUT_FOLDER/hmp_pathabund.pcl --focal-feature METSYN-PWY --focal-metadatum STSite --last-metadatum STSite --output $OUTPUT_FOLDER/plot1.png
humann2_barplot --sort sum --input $INPUT_FOLDER/hmp_pathabund.pcl --focal-feature METSYN-PWY --focal-metadatum STSite --last-metadatum STSite --output $OUTPUT_FOLDER/plot2.png
humann2_barplot --sort sum metadata --input $INPUT_FOLDER/hmp_pathabund.pcl --focal-feature METSYN-PWY --focal-metadatum STSite --last-metadatum STSite --output $OUTPUT_FOLDER/plot3.png
humann2_barplot --sort sum --input $INPUT_FOLDER/hmp_pathabund.pcl --focal-feature COA-PWY --focal-metadatum STSite --last-metadatum STSite --output $OUTPUT_FOLDER/plot4.png
humann2_barplot --sort similarity --top-strata 12 --scaling normalize --input $INPUT_FOLDER/hmp_pathabund.pcl --focal-feature COA-PWY --focal-metadatum STSite --last-metadatum STSite --output $OUTPUT_FOLDER/plot5.png

