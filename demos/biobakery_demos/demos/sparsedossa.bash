# demo developed with sparsedossa 1.0-dev-3629f13 (sparsedossa does not have a version option)

# run sparsedossa on the demo input file (move to output folder as output written to current directory)
# brackets create subshell enviroment to execute command so user does not change directories
( cd $OUTPUT_FOLDER && synthetic_datasets_script.R -c $INPUT_FOLDER/prism.tsv )

