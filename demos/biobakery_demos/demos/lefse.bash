# demo developed with lefse v1.0.0-dev-e3cabe9 (lefse does not have a version option)

# run lefse on the demo input file to format data
format_input.py $INPUT_FOLDER/hmp_small_aerobiosis.txt $OUTPUT_FOLDER/hmp_small_aerobiosis.in -c 1 -s 2 -u 3 -o 1000000

# run lefse
run_lefse.py $OUTPUT_FOLDER/hmp_small_aerobiosis.in $OUTPUT_FOLDER/hmp_small_aerobiosis.results

# plot the results
plot_res.py $OUTPUT_FOLDER/hmp_small_aerobiosis.results $OUTPUT_FOLDER/hmp_small_aerobiosis.png

# plot the cladogram
plot_cladogram.py $OUTPUT_FOLDER/hmp_small_aerobiosis.results $OUTPUT_FOLDER/hmp_small_aerobiosis.cladogram.png --format png

