# demo developed with breadcrumbs 016fa31 (breadcrumbs does not have a version option)

# run breadcrumbs scripts on demo input files
scriptBiplotTSV.R STSite $INPUT_FOLDER/Test-Biplot.tsv -o $OUTPUT_FOLDER/Test2Biplot.pdf

scriptPcoa.py -i TID -l STSite -p STSite $INPUT_FOLDER/Test.pcl -o $OUTPUT_FOLDER/Pcoa.pdf

scriptManipulateTable.py -i TID -l STSite -s $INPUT_FOLDER/Test.pcl -o $OUTPUT_FOLDER/Sum.pcl

scriptPlotFeature.py $INPUT_FOLDER/Test.pcl STSite 'Bacteria|Firmicutes|Bacilli|Bacillales|Bacillaceae|unclassified|72' -o $OUTPUT_FOLDER/PlotFeature.png

scriptConvertBetweenBIOMAndPCL.py $INPUT_FOLDER/Test_no_metadata.pcl $OUTPUT_FOLDER/Test_no_metadata.biom

