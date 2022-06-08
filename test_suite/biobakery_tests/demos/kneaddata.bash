kneaddata --unpaired $INPUT_FOLDER/singleEnd.fastq --reference-db $INPUT_FOLDER/demo_db --output $OUTPUT_FOLDER/kneaddataOutputSingleEnd

kneaddata_read_count_table --input $OUTPUT_FOLDER/kneaddataOutputSingleEnd --output $OUTPUT_FOLDER/kneaddataOutputSingleEnd/kneaddata_read_count_table.tsv

kneaddata --unpaired $INPUT_FOLDER/SE_extra.fastq --reference-db $INPUT_FOLDER/demo_db --output $OUTPUT_FOLDER/kneaddataOutputFastQC --run-fastqc-start --run-fastqc-end
    
kneaddata --input1 $INPUT_FOLDER/seq1.fastq --input2 $INPUT_FOLDER/seq2.fastq --reference-db $INPUT_FOLDER/demo_db --output $OUTPUT_FOLDER/kneaddataOutputPairedEnd 
    
kneaddata --unpaired $INPUT_FOLDER/singleEnd.fastq --output $OUTPUT_FOLDER/kneaddataOutputTrimmomatic --reference-db $INPUT_FOLDER/demo_db --trimmomatic-options="MINLEN:90"

kneaddata_read_count_table --input $OUTPUT_FOLDER/kneaddataOutputTrimmomatic/ --output $OUTPUT_FOLDER/kneaddataOutputTrimmomatic/kneaddata_read_count_table2.tsv

kneaddata --unpaired $INPUT_FOLDER/singleEnd.fastq --output $OUTPUT_FOLDER/kneaddataOutputBowtie2 --reference-db $INPUT_FOLDER/demo_db --bowtie2-options="--very-fast" --bowtie2-options="-p 2"

kneaddata --unpaired $INPUT_FOLDER/singleEnd.fastq --reference-db $INPUT_FOLDER/demo_db --run-bmtagger --output $OUTPUT_FOLDER/kneaddataOutputBMTagger

kneaddata --input1 $INPUT_FOLDER/seq1.fastq --input2 $INPUT_FOLDER/seq2.fastq -db $INPUT_FOLDER/demo_db --run-bmtagger --output $OUTPUT_FOLDER/kneaddataOutputBMTagger

kneaddata --unpaired $INPUT_FOLDER/singleEnd.fastq --reference-db $INPUT_FOLDER/demo_db --output $OUTPUT_FOLDER/kneaddataOutput --quality-scores phred64


