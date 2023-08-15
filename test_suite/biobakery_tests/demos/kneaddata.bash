kneaddata --unpaired $INPUT_FOLDER/singleEnd.fastq --reference-db $INPUT_FOLDER/demo_db --output $OUTPUT_FOLDER/kneaddataOutputSingleEnd

kneaddata_read_count_table --input $OUTPUT_FOLDER/kneaddataOutputSingleEnd --output $OUTPUT_FOLDER/kneaddataOutputSingleEnd/kneaddata_read_count_table.tsv

kneaddata --unpaired $INPUT_FOLDER/SE_extra.fastq --reference-db $INPUT_FOLDER/demo_db --output $OUTPUT_FOLDER/kneaddataOutputFastQC --run-fastqc-start --run-fastqc-end
    
kneaddata --input1 $INPUT_FOLDER/seq1.fastq --input2 $INPUT_FOLDER/seq2.fastq --reference-db $INPUT_FOLDER/demo_db --output $OUTPUT_FOLDER/kneaddataOutputPairedEnd 

kneaddata --unpaired $INPUT_FOLDER/singleEnd.fastq --output $OUTPUT_FOLDER/kneaddataOutputTrimmomatic2 --reference-db $INPUT_FOLDER/demo_db --trimmomatic-options="ILLUMINACLIP:/TruSeq3-SE.fa:2:30:10 SLIDINGWINDOW:4:20 MINLEN:90"
kneaddata_read_count_table --input $OUTPUT_FOLDER/kneaddataOutputTrimmomatic2/ --output $OUTPUT_FOLDER/kneaddata_read_count_table3.tsv

kneaddata --unpaired $INPUT_FOLDER/singleEnd.fastq --reference-db $INPUT_FOLDER/demo_db --output $OUTPUT_FOLDER/kneaddataOutput --threads 4 --processes 4


