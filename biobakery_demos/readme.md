# BioBakery Demos #

BioBakery Demos is a collection of demos for the BioBakery Tool Suite.

## Install ##

* ``$ brew tap biobakery/biobakery``
* ``$ brew install biobakery_demos``

Biobakery demos is also installed if you install the biobakery tool suite.

## Run ##

Demos are available for the following tools:

1. [HUMAnN2](http://huttenhower.sph.harvard.edu/humann2)
2. [KneadData](http://huttenhower.sph.harvard.edu/kneaddata)
3. [PICRUSt](http://picrust.github.io/)
4. [MaAsLin](http://huttenhower.sph.harvard.edu/maaslin)
5. [MetaPhlAn2](http://huttenhower.sph.harvard.edu/metaphlan2)
6. [SparseDOSSA](http://huttenhower.sph.harvard.edu/sparsedossa)
7. [ShortBRED](https://huttenhower.sph.harvard.edu/shortbred)
8. [PPANINI](http://huttenhower.sph.harvard.edu/ppanini)
9. [LEfSe](http://huttenhower.sph.harvard.edu/lefse)
10. [MicroPITA](http://huttenhower.sph.harvard.edu/micropita)
11. [GraPhlAn](http://huttenhower.sph.harvard.edu/graphlan)
12. [BreadCrumbs](http://huttenhower.sph.harvard.edu/breadcrumbs)
13. [HAllA](http://huttenhower.sph.harvard.edu/halla)

There are options to view, run, and test each demo. Also demos for one or all tools can be selected.

* To view the humann2 demo:
    * ``$ biobakery_demos --mode view --tool humann2``
* To run the kneaddata demo:
    * ``$ biobakery_demos --mode run --tool kneaddata``
* To run the kneaddata demo and save output (by default output is not saved):
    * ``$ biobakery_demos --mode run --tool kneaddata --output kneaddata_output``
* To test all tools:
    * ``$ biobakery_demos --mode test --tool all``

To run demos with threads, add the option "--threads <1>".

## Add a new demo ##

Follow these instructions to add a new demo to biobakery demos. You will only need to add input files, output files, and a bash script to add a new demo. You will not need to edit the biobakery demos software. The software will discover any new demos that are added to its sub-folders and make them available as new tool options.

1. Make new data folders for your tool (replace NEWTOOL with tool name)
    * ``$ mkdir biobakery_demos/data/NEWTOOL/input``
    * ``$ mkdir biobakery_demos/data/NEWTOOL/output``
2. Add the input files for the demo to the folder ``biobakery_demos/data/NEWTOOL/input``
3. Add the output files from running the demo to the folder ``biobakery_demos/data/NEWTOOL/output``
4. Create a bash script with demo commands for your tool (see ``biobakery_demos/demos/kneaddata.bash`` as an example)
    * This bash script should be added to the folder ``biobakery_demos/demos/``
    * This bash script should be named ``NEWTOOL.bash`` (replace NEWTOOL with tool name)
    * Note in the bash script ``$INPUT_FOLDER`` and ``$OUTPUT_FOLDER`` will be replaced with the full paths to these folders.
5. Reinstall biobakery_demos (this will add the new files to the install folder)
    * ``$ python setup.py install``
6. Test running your new demo (replace NEWTOOL with tool name)
    * ``$ biobakery_demos --tool NEWTOOL --mode test``

