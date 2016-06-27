# get the version information (demo developed with picrust v1.0.0-dev-ab009a3)
normalize_by_copy_number.py --version

# normalize the demo input file
normalize_by_copy_number.py -i $INPUT_FOLDER/closed_picked_otus.biom -o $OUTPUT_FOLDER/normalized_otus.biom

# predict metagenomes from normalized data
predict_metagenomes.py -i $OUTPUT_FOLDER/normalized_otus.biom -o $OUTPUT_FOLDER/metagenome_predictions.biom

# identify contributions from normalized data
metagenome_contributions.py -i $OUTPUT_FOLDER/normalized_otus.biom -o $OUTPUT_FOLDER/metagenome_contributions.tab
