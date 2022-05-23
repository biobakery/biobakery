"""
BioBakery Tests setup

To run: python setup.py install

"""

import sys

from glob import glob

try:
    import setuptools
except ImportError:
    sys.exit("Please install setuptools.")
    
import os

VERSION = "0.0.1"

def get_data_files(package_name,folders):
    """ Get a list of all of the data files in 
        each folder, walking through all sub-folders """
    data_files=set()
    for folder in folders:
        for dirpath, dirnames, filenames in os.walk(os.path.join(package_name,folder)):
            for file in filenames:
                data_files.add(os.path.join(dirpath,file).replace(package_name+os.sep,"",1))
    return { package_name : list(data_files) }

setuptools.setup(
    name="biobakery_tests",
    version=VERSION,
    license="MIT",
    description="BioBakery Tests: A set of tests for the BioBakery tool suite",
    platforms=['Linux','MacOS'],
    classifiers=[
        "Programming Language :: Python",
        "Development Status :: 3 - Alpha",
        "Environment :: Console",
        "Operating System :: MacOS",
        "Operating System :: Unix",
        "Programming Language :: Python",
        "Programming Language :: Python :: 2.7",
        "Topic :: Scientific/Engineering :: Bio-Informatics"
        ],
    packages=setuptools.find_packages(),
    package_data=get_data_files("biobakery_tests",["data","demos"]),
    entry_points={
        'console_scripts': ['biobakery_tests = biobakery_tests.biobakery_tests:main']},
    scripts=glob('biobakery_tests/scripts/*py'),
    zip_safe = False
 )
