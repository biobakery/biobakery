metawibele preprocess --input $INPUT_FOLDER/ --output $OUTPUT_FOLDER/preprocess/ \
--output-basename demo --extension-paired "_R1.fastq.gz,_R2.fastq.gz" --extension ".fastq.gz" --local-jobs $THREADS

metawibele characterize --input-sequence $INPUT_FOLDER/demo_genecatalogs.centroid.faa \
--input-count $INPUT_FOLDER/demo_genecatalogs_counts.all.tsv \
--input-metadata $INPUT_FOLDER/demo_mgx_metadata.tsv \
--output $OUTPUT_FOLDER/characterization/ --local-jobs $THREADS --bypass-psortb

metawibele prioritize \
--input-annotation $OUTPUT_FOLDER/characterization/finalized/demo_proteinfamilies_annotation.tsv \
--input-attribute $OUTPUT_FOLDER/characterization/finalized/demo_proteinfamilies_annotation.attribute.tsv \
--output $OUTPUT_FOLDER/prioritization/ --local-jobs $THREADS
