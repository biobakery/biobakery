#! /usr/bin/env python

"""
WHAT IS THIS?
=============
<this> runs commands to build a deb package from a 
hutlab tool, using a <*.bread> file for configuration.

AUTHORS
=======
Timothy L. Tickle (timothyltickle@gmail.com)
Eric A. Franzosa (eric.franzosa@gmail.com)
"""

import sys, os, re, glob, argparse
import shutil
import datetime
import traceback
import ConfigParser
from subprocess import call, PIPE, Popen

# ---------------------------------------------------------------
# constants
# ---------------------------------------------------------------

# Controls if commandline also goes to screen (This will not include IO just commandline)
fLog  = True

c_sCommandLineScripts = "CommandlineScripts"
c_sCopyright = "Copyright"
c_sCopyrightYear = "CopyrightYear"
c_sDeleteDirectory = "DeleteFolder"
c_sDeleteFile = "DeleteFile"
c_sDependencies = "Dependencies"
c_sDescription = "Description(<60char)"
c_sDescriptionLong = "Description(Longer)"
c_sEmail = "Email"
c_sKeyGitHub = "github"
c_sRCMDFile = "R_CMD_INSTALL.R"
c_sRLibs = "R-Libs"
c_sRepository = "Repository"
c_cScriptDelimiter = ","
c_sScriptPostInst = "PostInst"
c_sScriptPostRM = "PostRemove"
c_sSep = os.path.sep
c_sSectionHeader = "Tool"
c_sTimeStampedDirectory = "###DIR###"
c_sToolName = "Name"
c_sVersion = "Version(Tag)"
c_sWebpage = "Webpage"
sBiobakeryInstallLocation = c_sSep + "usr" + c_sSep + "share" + c_sSep
c_lsTempSuffixes = ["_amd64.changes", ".dsc", ".tar.gz"]

# ---------------------------------------------------------------
# get list of bread (config) files and configure the run
# ---------------------------------------------------------------

# python argparse
parser = argparse.ArgumentParser()
parser.add_argument( "-i", "--input", nargs="+", help="one or more <*.bread> files [default: all]" )
parser.add_argument( "-k", "--keep_temp", action="store_true", help="keep temp files rather than deleting at the end [default: False]" )
parser.add_argument( "-d", "--duplicate", action="store_true", help="rebuild a deb, even if it's present [default: False]" )
args = parser.parse_args()
lsConfigFiles = args.input if args.input is not None else glob.glob( "*.bread" )

# unless forced, do not rebuild a deb if it exists
llsSkipped = []
if not args.duplicate:
    lsTemp = []
    for sFile in lsConfigFiles:
        lsMatchDeb = glob.glob( sFile.replace( ".bread", "*.deb" ) )
        if len( lsMatchDeb ) > 0:
            # we'll print this list at the end so it's obvious
            llsSkipped.append( [sFile] + lsMatchDeb )
        else:
            lsTemp.append( sFile )
    lsConfigFiles = lsTemp                   

# ---------------------------------------------------------------
# utility function for making complex command line calls
# ---------------------------------------------------------------

def funcDoCommands( aastrCommands, fVerbose = False, fForced = False, fPiped = False ):
  """ 
  Act on a list of commands. 
  If the handle is not a none then use it to write to a file / out. 
  Otherwise execute the commands. 
  =====
  Standard commands should be a list of lists with the internal lists each word of the command:
   -- [["mkdir","newDir"],["rm","-r","newDir"]]
  Forced commands should be a List of commands as strings:
   -- [["mkdir newDir"],["rm -r newDir"]]
  Piped commands which are forced should be List of lists which are pairs, 
   the first string command being piped into the second.
   This is very rudimentary but all that was needed. 
   -- [["cat newFile", "less -S"]]
  Piped commands which are not forced were not implemented because they are so far not needed.
  """
  #Run command
  try:
    for astrCommand in aastrCommands:
      if fVerbose:
        print( " ".join( astrCommand ) )
      ## The return code to indicate an error in the process.
      iReturnCode = None
      if fForced:
        if fPiped:
          subpPiped = Popen( astrCommand[1], stdin = PIPE, shell = True )
          iReturnCode, ignore = subpPiped.communicate( astrCommand[0] )
        else:
          iReturnCode = Popen(astrCommand, shell = True)
      elif fPiped:
          print("Piped and Forced calls not needed.")
      else:
        iReturnCode = call( astrCommand )
      if fVerbose:
        print "Return=" + str( iReturnCode )
      if iReturnCode > 0:
        print "Error:: Error during command call. Script stopped."
        print "Error:: Error Code " + str( iReturnCode ) + "."
        print "Error:: Command =" + str( astrCommand ) + "."
        return False
  except ( OSError, TypeError ), e: 
    print "Error:: Error during command call. Script stopped."
    print "Error:: Command =" + str( astrCommand ) + "."
    print "Error:: OS error: " + str( traceback.format_exc( e ) ) + "."
    return False
  return True

# ---------------------------------------------------------------
# loop over breads and deb each one (**** convert this to function call ****)
# ---------------------------------------------------------------

# Parse the Config files
for sConfigFile in lsConfigFiles:

  # Create config parser and read in file
  cprsr = ConfigParser.ConfigParser( allow_no_value=True )
  cprsr.readfp( open( sConfigFile ) )

  print( "Making Bread: "+sConfigFile )

  # Current tool name
  sToolName = cprsr.get( c_sSectionHeader, c_sToolName)

  # Get the version
  sVersion = ""
  if cprsr.has_option( c_sSectionHeader, c_sVersion ):
    sVersion = cprsr.get( c_sSectionHeader, c_sVersion )

  # Get scripts to install / remove with the post scripts
  sScripts = cprsr.get( c_sSectionHeader, c_sCommandLineScripts )
  lsScripts = [ sScript.strip() for sScript in sScripts.split( c_cScriptDelimiter ) ]

  # Global variables
  sInstallDir = sBiobakeryInstallLocation + "biobakery" + c_sSep

  # Get the project directory given the tag specified by the version
  sCodeRepository = cprsr.get( c_sSectionHeader, c_sRepository )
  fSuccess = False
  lsCommand = []
  if c_sKeyGitHub in sCodeRepository:
    lsCommand.extend( [ "git", "clone"] )
    if sVersion : lsCommand.extend( ["-b", sVersion] )
  else:
    lsCommand.extend( [ "hg", "clone"] )
    if sVersion: lsCommand.extend( [ "-r", sVersion ] )
  fSuccess = funcDoCommands( [ lsCommand + [ sCodeRepository ] ], fVerbose = fLog )
  if not fSuccess: exit( 1 )

  # If it is mercurial, remove the mercurial database
  if c_sKeyGitHub in sCodeRepository:
    shutil.rmtree( sToolName + c_sSep + ".git" )
  else:
    shutil.rmtree( sToolName + c_sSep +".hg" )

  # If requested, remove a file or directory from the repository
  if cprsr.has_option( c_sSectionHeader, c_sDeleteDirectory ):
    for sDeleteDir in cprsr.get( c_sSectionHeader, c_sDeleteDirectory).split( c_cScriptDelimiter ):
      if sDeleteDir:
        shutil.rmtree( sToolName + c_sSep + sDeleteDir )
  if cprsr.has_option( c_sSectionHeader, c_sDeleteFile ):
    for sDeleteFile in cprsr.get( c_sSectionHeader, c_sDeleteFile).split( c_cScriptDelimiter ):
      if sDeleteFile:
        os.remove( sToolName + c_sSep + sDeleteFile )

  # If no version was request indicate the date
  sVersion = datetime.date.today().strftime("%Y%m%d")

  # Make the directory for the project
  sProjectDir = "-".join( [ sToolName, re.sub("[A-Za-z]","",sVersion) ] )
  fSuccess = funcDoCommands( [[ "mkdir", sProjectDir ]], fVerbose = fLog )
  if not fSuccess: exit( 1 )

  fSuccess = funcDoCommands( [[ "mv", sToolName, sProjectDir + c_sSep + sToolName ]], fVerbose = fLog )
  if not fSuccess: exit( 1 )

  # Make a default project
  # -n program is debian native
  # -s package class is single
  # -e maintainer email address
  os.chdir( sProjectDir )
  fSuccess = funcDoCommands( [[ "yes", "dh_make -n -s -e " + cprsr.get( c_sSectionHeader, c_sEmail ) ]], fForced = True, fPiped = True, fVerbose = fLog)
  if not fSuccess: exit( 1 )

  # Make the settings file
  with open( "debian"+ c_sSep + sToolName + ".install", "w" ) as hndlInstall:
    hndlInstall.write(sToolName + " " + sInstallDir + sProjectDir)

  # Update dependencies
  fSuccess = funcDoCommands( [[ "sed", "-i", "s/^Depends.*$/Depends: " + cprsr.get( c_sSectionHeader, c_sDependencies ) + "/", "debian" + c_sSep + "control" ],
                    [ "sed", "-i", "s/Maintainer.*$/Maintainer: " + cprsr.get( c_sSectionHeader, c_sEmail ) + "/", "debian/control" ],
                    [ "sed", "-i", "s/Architecture.*$/Architecture: all/", "debian/control" ],
                    [ "sed", "-i", "s/Homepage.*$/Homepage: " + cprsr.get( c_sSectionHeader, c_sWebpage ).replace("/","\\/") + "/", "debian/control" ],
                    [ "sed", "-i", "s/Description.*$/Description: " + cprsr.get( c_sSectionHeader, c_sDescription ).replace("/","\\/") + "/", "debian/control" ],
                    [ "sed", "-i", "s/ <insert long description.*$/ " + cprsr.get( c_sSectionHeader, c_sDescriptionLong ).replace("/","\\/") + "/", "debian" + c_sSep + "control" ]], fVerbose = fLog )
  if not fSuccess: exit( 1 )
  
  # Update the license information
  sOut = """Format: http://dep.debian.net/deps/dep5
Upstream-Name: " + sProjectDir
Source: <%s>

Files: *
Copyright: <years> <put author name and email here>
           <years> <likewise for another author>
License: GPL-3.0

Files: debian/*
Copyright: %s %s
License: MIT

#####################################################################################
#Copyright (C) <%s>
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of
#this software and associated documentation files (the \"Software\"), to deal in the
#Software without restriction, including without limitation the rights to use, copy,
#modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
#and to permit persons to whom the Software is furnished to do so, subject to
#the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies
#or substantial portions of the Software."+os.linesep+"#
#THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
#INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
#PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
#OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
#SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#####################################################################################""" % (cprsr.get( c_sSectionHeader, c_sWebpage ), cprsr.get( c_sSectionHeader, c_sCopyrightYear ), cprsr.get( c_sSectionHeader, c_sCopyright ), cprsr.get( c_sSectionHeader, c_sCopyrightYear ))

  # Make a R install batch file and place it in the deb package
  if cprsr.has_option( c_sSectionHeader, c_sRLibs ):
    lsPackages = [ sPackage.strip()  for sPackage in cprsr.get( c_sSectionHeader, c_sRLibs ).split(",") ]
    sInstallRPackages = "install.packages(pkgs=c(\"" + "\",\"".join( lsPackages ) + "\"), repos=\"http://cran.us.r-project.org\")"
    with open( c_sSep.join( [ sToolName, c_sRCMDFile ] ),'w' ) as hndlRCMD:
      hndlRCMD.write( sInstallRPackages )

  with open( "debian" + c_sSep + "copyright", "w") as hndlCopyRight:
    hndlCopyRight.write( sOut )

  # Make the post install script
  sOut = "#!" + c_sSep + "usr" + c_sSep + "bin" + c_sSep + "env bash" + os.linesep + "set -e" + os.linesep + os.linesep + "case \"$1\" in" + os.linesep + "    configure)" + os.linesep
  if( len( lsScripts ) > 0 ):

    # Add in custom scripting (optional)
    # There can be a keyword in the postinstall script ###Dir###
    # This is replaced with the directory that is time stamped when the deb is created.
    # The keyword must be used to that the location (that is dynamic during generation ) is static afterwards.
    if cprsr.has_option( c_sSectionHeader, c_sScriptPostInst ):
      sCustomPostScripts = cprsr.get( c_sSectionHeader, c_sScriptPostInst )
      sCustomPostScripts = sCustomPostScripts.replace( c_sTimeStampedDirectory, sInstallDir + sProjectDir )
      for sCustomPostScript in sCustomPostScripts.splitlines():
        sOut = sOut + "        " + sCustomPostScript + os.linesep

    if cprsr.has_option( c_sSectionHeader, c_sRLibs ):
      # Install R libraries with batch command
      sOut = sOut + "        cd " + sInstallDir + sProjectDir + c_sSep + sToolName + os.linesep
      sOut = sOut + "        R CMD BATCH " + c_sRCMDFile + os.linesep

    # Link in scripts to path
    for sScript in lsScripts:
      sOut = sOut + "        ln -s " + sInstallDir + sProjectDir + c_sSep + sScript + " " + c_sSep + "usr" + c_sSep + "bin" + c_sSep + sScript.split(os.path.sep)[-1] + os.linesep

    # Finish off section
    sOut = sOut + "    ;;"+os.linesep+os.linesep+"    abort-upgrade|abort-remove|abort-deconfigure)"+os.linesep+"    ;;"+os.linesep+os.linesep+"    *)"+os.linesep
    sOut = sOut + "          echo \"postinst called with unknown argument \\`$1'\" >&2"+os.linesep+"          exit 1"+os.linesep+"    ;;"+os.linesep+"esac"+os.linesep
    sOut = sOut + "#DEBHELPER#"+os.linesep+os.linesep+"exit 0"

    with open( "debian" + c_sSep + "postinst", "w") as hndlPostInst:
      hndlPostInst.write(sOut)

    # Make the post remove script
    sOut = "#!" + c_sSep + "usr" + c_sSep + "bin" + c_sSep + "env bash" + os.linesep+os.linesep + "set -e" + os.linesep + os.linesep
    sOut = sOut + "case \"$1\" in"+os.linesep+"    remove|purge|upgrade|failed-upgrade|abort-install|abort-upgrade|disappear)"

    # Add in custom scripting (optional)
    if cprsr.has_option( c_sSectionHeader, c_sScriptPostRM ):
      sCustomRMScripts = cprsr.get( c_sSectionHeader, c_sScriptPostRM )
      sCustomRMScripts = sCustomRMScripts.replace( c_sTimeStampedDirectory, sInstallDir + sProjectDir )
      for sCustomRMScript in sCustomRMScripts.splitlines():
          sOut = sOut + "        "  + sCustomRMScript +os.linesep

    # Remove links
    for sScript in lsScripts:
        sOut = sOut + "        rm " + c_sSep + "usr" + c_sSep + "bin" + c_sSep + sScript.split(os.path.sep)[-1] +os.linesep
    sOut = sOut + "    ;;"+os.linesep+os.linesep+"    *)"+os.linesep
    sOut = sOut + "          echo \"postrm called with unknown argument \\`$1'\" >&2"+os.linesep
    sOut = sOut + "          exit 1"+os.linesep+"    ;;"+os.linesep+"esac"+os.linesep+"#DEBHELPER#"+os.linesep+os.linesep+"exit 0"
    with open( "debian" + c_sSep + "postrm", "w") as hndlPostRM:
      hndlPostRM.write( sOut )

  # Build package
  fSuccess = funcDoCommands( [[ "dpkg-buildpackage", "-us", "-uc", "-d" ]], fVerbose = fLog )
  if not fSuccess: exit(1)

  # Reset directory to build new package
  os.chdir( ".." )

  # Remove temp files
  if not args.keep_temp:
      shutil.rmtree( sProjectDir )
      for sSuffix in c_lsTempSuffixes:
          sPath = "%s_%s%s" % ( sToolName, sVersion, sSuffix )
          os.remove( sPath )

# ---------------------------------------------------------------
# warn the user about skipped debs
# ---------------------------------------------------------------

for lsItems in llsSkipped:
    print "skipped", lsItems[0], "due to", lsItems[1:]
