
graphlan.py $INPUT_FOLDER/guide.txt step_0.png --dpi 300 --size 3.5
graphlan.py $INPUT_FOLDER/guide.txt step_0.svg --dpi 300 --size 3.5

graphlan_annotate.py --annot $INPUT_FOLDER/annot_0.txt $INPUT_FOLDER/guide.txt $OUTPUT_FOLDER/guide_1.xml
graphlan.py $OUTPUT_FOLDER/guide_1.xml $OUTPUT_FOLDER/step_1.png --dpi 300 --size 3.5
graphlan.py $OUTPUT_FOLDER/guide_1.xml $OUTPUT_FOLDER/step_1.svg --dpi 300 --size 3.5

graphlan_annotate.py --annot $INPUT_FOLDER/annot_1.txt $OUTPUT_FOLDER/guide_1.xml $OUTPUT_FOLDER/guide_2.xml
graphlan.py $OUTPUT_FOLDER/guide_2.xml $OUTPUT_FOLDER/step_2.png --dpi 300 --size 3.5
graphlan.py $OUTPUT_FOLDER/guide_2.xml $OUTPUT_FOLDER/step_2.svg --dpi 300 --size 3.5

graphlan_annotate.py --annot $INPUT_FOLDER/annot_2.txt $OUTPUT_FOLDER/guide_2.xml $OUTPUT_FOLDER/guide_3.xml
graphlan.py $OUTPUT_FOLDER/guide_3.xml $OUTPUT_FOLDER/step_3.png --dpi 300 --size 3.5
graphlan.py $OUTPUT_FOLDER/guide_3.xml $OUTPUT_FOLDER/step_3.svg --dpi 300 --size 3.5

graphlan_annotate.py --annot $INPUT_FOLDER/annot_3.txt $OUTPUT_FOLDER/guide_3.xml $OUTPUT_FOLDER/guide_4.xml
graphlan.py $OUTPUT_FOLDER/guide_4.xml $OUTPUT_FOLDER/step_4.png --dpi 300 --size 3.5 --pad 0.0
graphlan.py $OUTPUT_FOLDER/guide_4.xml $OUTPUT_FOLDER/step_4.svg --dpi 300 --size 3.5 --pad 0.0


