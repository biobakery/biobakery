#!bin/env python

import ConfigParser
import glob

# Constants
c_sCommandLineScripts = "CommandlineScripts"
c_sCopyright = "Copyright"
c_sCopyrightYear = "CopyrightYear"
c_sDependencies = "Dependencies"
c_sDescription = "Description(<60char)"
c_sDescriptionLong = "Description(Longer)"
c_sEmail = "Email"
c_sRepository = "Repository"
c_cScriptDelimiter = ","
c_sSep = os.path.sep
c_sToolName = "Name"
c_sVersion = "Version(Tag)"
c_sWebpage = "Webpage"

# Configuration
c_sBiobakeryInstallLocation = c_sSep + "usr" + c_sSep + "share" + c_sSep

# Get all files with glob
lsConfigFiles = glob.glob()

# Config parser
cprsr = ConfigParser.ConfigParser(allow_no_value=True)

# Parse the Config files
for sConfigFile in lsConfigFiles:
  cprsr.read(sConfigFile)

  # Current tool name
  sToolName = cprsr.get( c_sToolName )

  # Get scripts to install / remove with the post scripts
  sScripts = cprsr.get( c_sCommandLineScripts )
  lsScripts = [ sScript.strip() for sScript in sScripts.split( c_cScriptDelimiter ) ]

  # Global variables
  sInstallDir = c_sBiobakeryInstallLocation +biobakery + c_sSep

  # Get the qiimetomaaslin directory
  # The whole directory is needed to get the .hgtags
  "hg clone " + cprsr.get( c_sRepository )

  # Go into the cloned repository and get the tag
  cd qiimetomaaslin
  VERSION=$(tail -1 .hgtags | cut -f2 -d' ')
  echo sVersion
  cd ..

  # Make the directory for the project
  sProjectDir = "-".join( [ sToolName, sVersion ] )
  "mkdir " + sProjectDir

  # Move the scripts into the package
  "mkdir " + sProjectDir + c_sSep + sToolName
  "mv " + sToolName + " " + sProjectDir + c_sSep + sToolName

  # Make a default project
  # -n program is debian native
  # -s package class is single
  # -e maintainer email address
  "cd " + sProjectDir
  "dh_make -n -s -e " + cprsr.get(c_sEmail)

  # Make the settings file
  with open( "debian"+ c_sSep + sToolName + ".install" ) as hndlInstall
    hndlInstall.write(sToolName + " " + c_sBiobakeryInstallLocation + sProjectDir)
    

  # Update dependencies
  "sed -i \'s/Build-Depends.*$/Build-Depends: python (>= 2.7), python-blist (>= 1.3.4)/\' debian" + c_sSep + "control"
  "sed -i \'s/Homepage.*$/Homepage: http:\/\/huttenhower.sph.harvard.edu\/maaslin/\' debian/control"
  "sed -i \'s/Description.*$/Description: Create PCL files from Qiime tables./\' debian/control"
  "sed -i \'s/ <insert long description.*$/ Create PCL files for MaAsLin using a OTU table from Qiime./\' debian" + c_sSep + "control"

  # Update the license information
  with open( "debian" + c_sSep + "copyright") as hndlCopyRight
    hndleCopyRight.write("Format: http://dep.debian.net/deps/dep5\n")
    hndleCopyRight.write("Upstream-Name: " + sProjectDir + "\n")
    hndleCopyRight.write("Source: <" + cprsr.get( c_sWebpage ) + ">\n\n")
    hndleCopyRight.write("Files: *\n")
    hndleCopyRight.write("Copyright: <years> <put author name and email here>\n")
    hndleCopyRight.write("           <years> <likewise for another author>\n")
    hndleCopyRight.write("License: GPL-3.0+\n\n")
    hndleCopyRight.write("Files: debian/*\n")
    hndleCopyRight.write("Copyright: " + cprsr.get( c_sCopyrightYear ) + " " + cprsr.get( c_sCopyright ) + "\n")
    hndleCopyRight.write("License: MIT\n\n")
    hndleCopyRight.write("#####################################################################################
    hndleCopyRight.write("#Copyright (C) <" + cprsr.get( c_sCopyrightYear ) + ">\n#\n")
    hndleCopyRight.write("#Permission is hereby granted, free of charge, to any person obtaining a copy of
    hndleCopyRight.write("#this software and associated documentation files (the "Software"), to deal in the
    hndleCopyRight.write("#Software without restriction, including without limitation the rights to use, copy,\n")
    hndleCopyRight.write("#modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,\n")
    hndleCopyRight.write("#and to permit persons to whom the Software is furnished to do so, subject to
    hndleCopyRight.write("#the following conditions:\n#\n")
    hndleCopyRight.write("#The above copyright notice and this permission notice shall be included in all copies\n")
    hndleCopyRight.write("#or substantial portions of the Software.\n#\n")
    hndleCopyRight.write("#THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,\n")
    hndleCopyRight.write("#INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A\n")
    hndleCopyRight.write("#PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT\n")
    hndleCopyRight.write("#HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION\n")
    hndleCopyRight.write("#OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE\n")
    hndleCopyRight.write("#SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."\n")
    hndleCopyRight.write("#####################################################################################")

  # Make the post install script
  if( len( lsScripts ) > 0 ):
    with open( "debian" + c_sSep + "postinst") as hndlPostInst
      hndleCopyRight.write("#!" + c_sSep + "bin" + c_sSep + "env bash\n")
      hndleCopyRight.write("set -e\n\n")
      hndleCopyRight.write("case "\$1" in\n")
      hndleCopyRight.write("    configure)\n")
      for sScript in lsScripts:
        hndleCopyRight.write("      ln -s " + c_sBiobakeryInstallLocation + sProjectDir + c_sSep + sScript + " " + c_sSep + "usr" + c_sSep + "bin" + c_sSep + sScript.split(os.path.sep)[-1] + " \n")
      hndleCopyRight.write("    ;;\n\n")
      hndleCopyRight.write("    abort-upgrade|abort-remove|abort-deconfigure)\n    ;;\n\n")
      hndleCopyRight.write("    *)\n")
      hndleCopyRight.write("        echo \"postinst called with unknown argument '\$1'\" >&2\n")
      hndleCopyRight.write("        exit 1\n    ;;\nesac") #TODO Start here
#DEBHELPER#

      hndleCopyRight.write("exit 0")

# Make the post remove script
cat << EOF > debian/postrm
#!/bin/env bash
set -e

case "\$1" in
    remove)
      rm /usr/bin/qiimeToMaaslin.py 
    ;;

    purge|upgrade|failed-upgrade|abort-install|abort-upgrade|disappear)
    ;;

    *)
        echo "postrm called with unknown argument '\$1'" >&2
        exit 1
    ;;
esac
#DEBHELPER#

exit 0
EOF

  # Build package
  dpkg-buildpackage -us -uc
