#!/usr/bin/bash


# Retrieve 369 Ethiopian MAGs
wget https://www.dropbox.com/s/fuafzwj67tguj31/ethiopian_mags.tar.bz2?dl=1 -O ethiopian_mags.tar.bz2;
mkdir -p input_metagenomic;
tar -xjf ethiopian_mags.tar.bz2 -C input_metagenomic/;

# Execute phylophlan_metagenomic
phylophlan_metagenomic.py \
    -i input_metagenomic \
    -o output_metagenomic \
    --nproc 4 \
    -n 1 \
    --verbose 2>&1 | tee logs/phylophlan_metagenomic.log

# Draw heatmaps
phylophlan_draw_metagenomic.py \
    -i output_metagenomic.tsv \
    --map bin2meta.tsv \
    -o output_heatmap \
    --top 20 \
    --verbose 2>&1 | tee logs/phylophlan_draw_metagenomic.log
