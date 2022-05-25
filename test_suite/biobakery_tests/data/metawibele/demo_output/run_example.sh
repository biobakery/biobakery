metawibele preprocess --input raw_reads/ --output output/preprocess/ --output-basename demo --extension-paired "_R1.fastq.gz,_R2.fastq.gz" --extension ".fastq.gz" --local-jobs 4 >preprocess.log 2>preprocess.err


metawibele characterize --input-sequence input/demo_genecatalogs.centroid.faa --input-count input/demo_genecatalogs_counts.all.tsv --input-metadata input/demo_mgx_metadata.tsv --output output/characterization/ --local-jobs 4 --bypass-psortb > characterize.log 2>characterize.err

metawibele prioritize --input-annotation output/characterization/finalized/demo_proteinfamilies_annotation.tsv --input-attribute output/characterization/finalized/demo_proteinfamilies_annotation.attribute.tsv --output output/prioritization/ --local-jobs 4 > prioritize.log 2>prioritize.err
