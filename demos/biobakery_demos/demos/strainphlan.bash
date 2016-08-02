# get the version information (demo developed with metaphlan2 v2.5.0-6462147)
metaphlan2.py --version

# run metaphlan2 on the demo sample input files
metaphlan2.py $INPUT_FOLDER/13530241_SF05.fasta.gz $OUTPUT_FOLDER/13530241_SF05_profile.txt --bowtie2out $OUTPUT_FOLDER/13530241_SF05_bowtie2.txt --samout $OUTPUT_FOLDER/13530241_SF05.sam.bz2 --input_type multifasta --nproc $THREADS
metaphlan2.py $INPUT_FOLDER/13530241_SF06.fasta.gz $OUTPUT_FOLDER/13530241_SF06_profile.txt --bowtie2out $OUTPUT_FOLDER/13530241_SF06_bowtie2.txt --samout $OUTPUT_FOLDER/13530241_SF06.sam.bz2 --input_type multifasta --nproc $THREADS
metaphlan2.py $INPUT_FOLDER/19272639_SF05.fasta.gz $OUTPUT_FOLDER/19272639_SF05_profile.txt --bowtie2out $OUTPUT_FOLDER/19272639_SF05_bowtie2.txt --samout $OUTPUT_FOLDER/19272639_SF05.sam.bz2 --input_type multifasta --nproc $THREADS
metaphlan2.py $INPUT_FOLDER/19272639_SF06.fasta.gz $OUTPUT_FOLDER/19272639_SF06_profile.txt --bowtie2out $OUTPUT_FOLDER/19272639_SF06_bowtie2.txt --samout $OUTPUT_FOLDER/19272639_SF06.sam.bz2 --input_type multifasta --nproc $THREADS
metaphlan2.py $INPUT_FOLDER/40476924_SF05.fasta.gz $OUTPUT_FOLDER/40476924_SF05_profile.txt --bowtie2out $OUTPUT_FOLDER/40476924_SF05_bowtie2.txt --samout $OUTPUT_FOLDER/40476924_SF05.sam.bz2 --input_type multifasta --nproc $THREADS
metaphlan2.py $INPUT_FOLDER/40476924_SF06.fasta.gz $OUTPUT_FOLDER/40476924_SF06_profile.txt --bowtie2out $OUTPUT_FOLDER/40476924_SF06_bowtie2.txt --samout $OUTPUT_FOLDER/40476924_SF06.sam.bz2 --input_type multifasta --nproc $THREADS

# run sample to markers on all of the samples
sample2markers.py --ifn_samples $OUTPUT_FOLDER/13530241_SF05.sam.bz2 --input_type sam --output_dir $OUTPUT_FOLDER --nprocs $THREADS
sample2markers.py --ifn_samples $OUTPUT_FOLDER/13530241_SF06.sam.bz2 --input_type sam --output_dir $OUTPUT_FOLDER --nprocs $THREADS
sample2markers.py --ifn_samples $OUTPUT_FOLDER/19272639_SF05.sam.bz2 --input_type sam --output_dir $OUTPUT_FOLDER --nprocs $THREADS
sample2markers.py --ifn_samples $OUTPUT_FOLDER/19272639_SF06.sam.bz2 --input_type sam --output_dir $OUTPUT_FOLDER --nprocs $THREADS
sample2markers.py --ifn_samples $OUTPUT_FOLDER/40476924_SF05.sam.bz2 --input_type sam --output_dir $OUTPUT_FOLDER --nprocs $THREADS
sample2markers.py --ifn_samples $OUTPUT_FOLDER/40476924_SF06.sam.bz2 --input_type sam --output_dir $OUTPUT_FOLDER --nprocs $THREADS

# the markers reference genome was created running the following commands
# bowtie2-inspect ../db_v20/mpa_v20_m200 > all_markers.fasta
# extract_markers.py --mpa_pkl ../db_v20/mpa_v20_m200.pkl --ifn_markers all_markers.fasta --clade s__Eubacterium_siraeum --ofn_markers s__Eubacterium_siraeum.markers.fasta

# run metaphlan2 strainer on all samples (add the flag to reduce the default as these are subsampled)
strainphlan.py --ifn_samples $OUTPUT_FOLDER/*.markers --ifn_markers $INPUT_FOLDER/s__Eubacterium_siraeum.markers.fasta --ifn_ref_genomes $INPUT_FOLDER/GCF_000154325.fna.bz2 --output_dir $OUTPUT_FOLDER --nprocs_main $THREADS --clades s__Eubacterium_siraeum --marker_in_clade 0.2 --keep_alignment_files

