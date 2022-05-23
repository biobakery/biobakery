"""
BioBakery Tests setup

To run: python setup.py install

"""

import sys

# required python version
required_python_version_major = 2
required_python_version_minor = 7

# Check the python version
try:
    if (sys.version_info[0] != required_python_version_major or
        sys.version_info[1] < required_python_version_minor):
        sys.exit("CRITICAL ERROR: The python version found (version "+
            str(sys.version_info[0])+"."+str(sys.version_info[1])+") "+
            "does not match the version required (version "+
            str(required_python_version_major)+"."+
            str(required_python_version_minor)+"+)")
except (AttributeError,IndexError):
    sys.exit("CRITICAL ERROR: The python version found (version 1) " +
        "does not match the version required (version "+
        str(required_python_version_major)+"."+
        str(required_python_version_minor)+"+)")

try:
    import setuptools
except ImportError:
    sys.exit("Please install setuptools.")
    
# check setuptools version    
required_setuptools_version_major = 1
try:
    setuptools_version = setuptools.__version__
    setuptools_version_major = int(setuptools_version.split(".")[0])
    if setuptools_version_major < required_setuptools_version_major:
        sys.exit("CRITICAL ERROR: The setuptools version found (version "+
                 setuptools_version+") does not match the version required "+
                 "(version "+str(required_setuptools_version_major) +"+)."
                 " Please upgrade your setuptools version.")
except (ValueError, IndexError, NameError):
    sys.exit("CRITICAL ERROR: Unable to call setuptools version. Please upgrade setuptools.")
    
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
    zip_safe = False
 )
