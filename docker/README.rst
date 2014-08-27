###################
bioBakery on Docker
###################

Building
========
The build system uses waf.
Build all containers::
  $ ./waf configure build

Note: On Ubuntu, docker requires sudo privileges in order to run. If
you build the bioBakery docker containers on Ubuntu, use waf with
sudo::
  # ./waf configure build
  # OR
  $ sudo ./waf configure build


Pushing the images to the docker hub
------------------------------------
Use the ``--push`` option::
  $ ./waf --push configure build


Saving built images to tar files
--------------------------------
There's an option for that, too::
  $ ./waf --save configure build

Tar files will be gzipped and saved in the 'containers' directory.


Contributing new tools in three easy steps
------------------------------------------
1. Add a new Dockerfile appropriate for building the tool in a new
   directory within this directory.
2. Add an appropriate line into the ``wscript`` file. The
   ``dockerbuild`` convenience function may be of some use to
   you. 
3. ``$ ./waf --push configure build``



