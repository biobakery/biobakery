halla -x $INPUT_FOLDER/X_16_100.txt -y $INPUT_FOLDER/Y_16_100.txt -m spearman -o $OUTPUT_FOLDER/synthetic_output 
halla -x $INPUT_FOLDER/otu_299.txt -y $INPUT_FOLDER/gene_200.txt -o $OUTPUT_FOLDER/pouchitis_output -m spearman --fdr_alpha 0.05
hallagram \
    -i $OUTPUT_FOLDER/synthetic_output/ \
    --cbar_label 'Pairwise Spearman' \
    --x_dataset_label X \
    --y_dataset_label Y \
    --block_border_width 2
hallagram \
    -i $OUTPUT_FOLDER/pouchitis_output/ \
    --cbar_label 'Pairwise Spearman' \
    --x_dataset_label 'Microbial OTUs' \
    --y_dataset_label 'Gene expression' \
    -n 30 \
    --block_border_width 2
hallagnostic -i $OUTPUT_FOLDER/pouchitis_output/ -n 8
halla -x $INPUT_FOLDER/X_16_100.txt -y $INPUT_FOLDER/Y_16_100.txt \
    -o $OUTPUT_FOLDER/synthetic_output_fnr_thresh_30_percent \
    -m spearman --fnr_thresh 0.3
hallagram \
    -i $OUTPUT_FOLDER/synthetic_output_fnr_thresh_30_percent \
    --cbar_label 'Pairwise Spearman' \
    --x_dataset_label X \
    --y_dataset_label Y \
    --block_border_width 2
halla -x $INPUT_FOLDER/X_16_100.txt -y $INPUT_FOLDER/Y_16_100.txt \
    -o $OUTPUT_FOLDER/synthetic_output_mi \
    -m mi
halla -x $INPUT_FOLDER/X_16_100.txt -y $INPUT_FOLDER/Y_16_100.txt \
    -o $OUTPUT_FOLDER/synthetic_output_bonferroni \
    -m spearman \
    --fdr_method bonferroni
halla -x $INPUT_FOLDER/X_16_100.txt -y $INPUT_FOLDER/Y_16_100.txt \
    -o $OUTPUT_FOLDER/synthetic_output_alla \
    -m spearman \
    --alla
halladata -n 100 -xf 32 -yf 32 -a mixed -o $OUTPUT_FOLDER/halla_data_f32_n100_mixed
halla \
    -x $OUTPUT_FOLDER/halla_data_f32_n100_mixed/X_mixed_32_100.txt \
    -y $OUTPUT_FOLDER/halla_data_f32_n100_mixed/Y_mixed_32_100.txt \
    -o $OUTPUT_FOLDER/halla_output_f32_n100_mixed \
    -m spearman
halla \
    -x $OUTPUT_FOLDER/halla_data_f32_n100_mixed/X_mixed_32_100.txt \
    -y $OUTPUT_FOLDER/halla_data_f32_n100_mixed/Y_mixed_32_100.txt \
    -o $OUTPUT_FOLDER/halla_output_f32_n100_mixed \
    -m nmi
halladata -n 50 -xf 32 -yf 32 -a line --o $OUTPUT_FOLDER/halla_data_f32_n50_line
halla \
    -x $OUTPUT_FOLDER/halla_data_f32_n50_line/X_line_32_50.txt \
    -y $OUTPUT_FOLDER/halla_data_f32_n50_line/Y_line_32_50.txt \
    -o $OUTPUT_FOLDER/halla_output_f32_n50_line_spearman \
    -m spearman
hallagram \
    -i $OUTPUT_FOLDER/halla_output_f32_n50_line_spearman \
    --cbar_label 'Pairwise Spearman' \
    --x_dataset_label X --y_dataset_label Y \
    --block_border_width 2
halla \
    -x $OUTPUT_FOLDER/halla_data_f32_n50_line/X_line_32_50.txt \
    -y $OUTPUT_FOLDER/halla_data_f32_n50_line/Y_line_32_50.txt \
    -o $OUTPUT_FOLDER/halla_output_f32_n50_line_nmi \
    -m nmi
    
hallagram \
    -i $OUTPUT_FOLDER/halla_output_f32_n50_line_nmi \
    --cbar_label 'Pairwise NMI' \
    --x_dataset_label X \
    --y_dataset_label Y \
    --block_border_width 2
