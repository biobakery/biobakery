#!/usr/bin/env python

""" BioBakery Demos: A set of demos for the BioBakery tool suite """

import sys

try:
    import argparse
except ImportError:
    sys.exit("Please upgrade your version of Python to 2.7+")
    
import os
import shutil
import tempfile
import subprocess
    
VERSION="0.0.1"

BASH_EXTENSION=".bash"
ALL_TOOLS_SELECTION="all"

OUTPUT_ENV="OUTPUT_FOLDER"
THREADS_ENV="THREADS"
INPUT_ENV="INPUT_FOLDER"

OUTPUT_INDENT="    "

INSTALLED_SCRIPT_FOLDER=os.path.dirname(os.path.abspath(__file__))

def find_demos():
    """
    Find all of the demos installed for the biobakery tools
    """
    
    biobakery_demo_files={}
    demo_folder=os.path.join(INSTALLED_SCRIPT_FOLDER,"demos")
    for file in os.listdir(demo_folder):
        if file.endswith(BASH_EXTENSION):
            tool_name=file.replace(BASH_EXTENSION, "")
            biobakery_demo_files[tool_name]=os.path.join(demo_folder, file)
    
    return biobakery_demo_files

def test_demo_output(tool_name, output_folder, expected_output_folder):
    """
    Compare the output from the run with the expected output
    """
    
    print("\nTesting output of demo for "+tool_name+" ...")
    
    # check that the expected output files exist
    expected_output_files=os.listdir(expected_output_folder)
    output_files=os.listdir(output_folder)
    
    error_found=0
    for file in expected_output_files:
        print("Checking for expected demo output file: " + file)
        if file in output_files:
            # check the files have data
            expected_file_size=os.path.getsize(os.path.join(expected_output_folder, file))
            file_size=os.path.getsize(os.path.join(output_folder, file))
            
            # if the expected file is non-empty, check that the file created when
            # running the demo is also non-empty 
            if expected_file_size > 0:
                if file_size == 0:
                    print("ERROR: Output file is empty: " + file)
                    error_found=1
        else:
            print("ERROR: Missing expected output file: " + file)
            error_found=1
    
    print("Finished testing demo for "+tool_name)
    
    if error_found:
        sys.exit("One or more errors found when testing demo")

def run_demo_subprocess(tool_name, demo_bash_script, demo_env):
    """
    Create a subprocess to run the bash demo script
    """
    
    print("Running demo for "+tool_name+" (commands start with +) ...\n")
    
    try:
        # run bash demo with option to print each command executed to stdout
        demo_command=["bash","-x",demo_bash_script]
        subprocess.check_call(demo_command, env=demo_env)
    except (EnvironmentError, subprocess.CalledProcessError):
        sys.exit("ERROR: Unable to run demo for tool " + tool_name)    
    
    print("Finished running demo for " + tool_name)

def run_demo(biobakery_demo_files, mode, tool, threads, output_folder):
    """
    Run the demo selected
    """
    
    # if set to run all tools, add all tool names to set selected
    if tool == ALL_TOOLS_SELECTION:
        tools = biobakery_demo_files.keys()
    else:
        tools = [tool]

    # set the environment variables for the tool
    demo_env = os.environ.copy()
    demo_env[OUTPUT_ENV]=output_folder
    demo_env[THREADS_ENV]=str(threads)
    
    for tool_name in tools:
        print("\nDemo selected for tool: " + tool_name)
        # set the data folder for this tool
        demo_env[INPUT_ENV]=os.path.join(INSTALLED_SCRIPT_FOLDER,"data",tool_name,"input")
        
        # execute the demo based on the run mode
        print("Demo mode: "+mode+"\n")
        if mode == "view":
            # print the environment variables
            print("Demo environment variable settings:")
            for env_variable in [INPUT_ENV, OUTPUT_ENV, THREADS_ENV]:
                print(OUTPUT_INDENT+ env_variable + " = " + demo_env[env_variable])
            
            # read through and print demo to screen    
            print("\nDemo commands:")
            with open(biobakery_demo_files[tool_name]) as file_handle:
                for line in file_handle:
                    print(OUTPUT_INDENT+line.rstrip())
        elif mode == "run":
            run_demo_subprocess(tool_name, biobakery_demo_files[tool_name], demo_env)
        elif mode == "test":
            run_demo_subprocess(tool_name, biobakery_demo_files[tool_name], demo_env)
            expected_output_folder=os.path.join(INSTALLED_SCRIPT_FOLDER,"data",tool_name,"output")
            test_demo_output(tool_name, output_folder, expected_output_folder)
            

def parse_arguments(args, biobakery_tools):
    """ 
    Parse the arguments from the user
    """
    parser = argparse.ArgumentParser(
        description= "BioBakery Demos: A set of demos for the BioBakery tool suite\n",
        formatter_class=argparse.RawTextHelpFormatter,
        prog="biobakery_demos")
    parser.add_argument(
        "--version",
        action="version",
        version="%(prog)s v"+VERSION)
    parser.add_argument(
        "-m", "--mode",
        help="the demo run mode",
        required=True,
        choices=["view","run","test"])
    parser.add_argument(
        "-t", "--tool",
        help="the biobakery tool selected",
        required=True,
        choices=biobakery_tools+[ALL_TOOLS_SELECTION])
    parser.add_argument(
        "-o", "--output", 
        help="if provided, output files will be saved to this folder\n", 
        metavar="<output>")
    parser.add_argument(
        "--threads", 
        help="number of threads/processes\n[DEFAULT: 1]", 
        metavar="<1>", 
        type=int,
        default=1) 
    
    return parser.parse_args()
    
def main():
    # get the list of tools which have demos
    biobakery_demo_files=find_demos()
    
    # parse arguments from command line
    args=parse_arguments(sys.argv, biobakery_demo_files.keys())
    
    if args.output:
        # get the full path to the output folder
        output_folder = os.path.abspath(args.output)
        
        # if output folder does not exist, then create
        if not os.path.isdir(output_folder):
            try:
                os.makedirs(output_folder)
            except EnvironmentError:
                sys.exit("ERROR: Unable to create output directory: " + output_folder)
    else:
        # create a temp folder for the output
        output_folder=tempfile.mkdtemp(prefix="biobakery_demos_temp_output_")
    
    # run the demo selected
    run_demo(biobakery_demo_files, args.mode, args.tool, args.threads, output_folder)
    
    # remove the temp output folder if created
    if not args.output:
        try:
            shutil.rmtree(output_folder)
        except EnvironmentError:
            print("Warning: Unable to remove temp output folder: " + output_folder)
    
