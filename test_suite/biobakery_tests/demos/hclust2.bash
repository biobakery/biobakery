# demo developed with hclust2 v1.0.0-277c0d (hclust2 does not have a version option)

# run hclust2 on the species only abundance table
hclust2.py -i $INPUT_FOLDER/merged_abundance_table_species.txt -o $OUTPUT_FOLDER/abundance_heatmap_species.png --skip_rows 1 --ftop 25 --f_dist_f braycurtis --s_dist_f braycurtis --cell_aspect_ratio 0.5 -l --flabel_size 6 --max_flabel_len 200 --max_slabel_len 100  --slabel_size 6 --minv 0.1 --dpi 300
