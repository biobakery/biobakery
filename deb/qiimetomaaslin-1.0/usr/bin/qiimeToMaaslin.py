#!/usr/bin/env python

"""
Examples
~~~~~~~~

``metadata.txt``::

	-	Y	Z
	a	1	x
	b	0	y
	c		z

``data.pcl``::

	-	a	b	c
	A|B	1	2	3
	A|C	4	5	6
	D|E	7	8	9

``Examples``::

	$ merge_metadata.py metadata.txt < data.pcl
	sample	a	b	c
	Y	1	0
	Z	x	y	z
	A	0.416667	0.466667	0.5
	A|B	0.0833333	0.133333	0.166667
	A|C	0.333333	0.333333	0.333333
	D|E	0.583333	0.533333	0.5

	$ merge_metadata.py metadata.txt -t 0 < data.pcl
	sample	a	b	c
	Y	1	0
	Z	x	y	z
	A|B	0.0833333	0.133333	0.166667
	A|C	0.333333	0.333333	0.333333
	D|E	0.583333	0.533333	0.5

	$ merge_metadata.py metadata.txt -t 1 < data.pcl
	sample	a	b	c
	Y	1	0
	Z	x	y	z
	A	0.416667	0.466667	0.5
	D	0.583333	0.533333	0.5

	$ merge_metadata.py metadata.txt -t 0 -n < data.pcl
	sample	a	b	c
	Y	1	0
	Z	x	y	z
	A|B	1	2	3
	A|C	4	5	6
	D|E	7	8	9

	$ merge_metadata.py metadata.txt -t 0 -m 0.8 -s "-" < data.pcl
	sample	b	c
	Y	0	-
	Z	y	z
	A|B	0.133333	0.166667
	A|C	0.333333	0.333333
	D|E	0.533333	0.5

	$ merge_metadata.py -t 0 < data.pcl
	sample	a	b	c
	A|B	1	2	3
	A|C	4	5	6
	D|E	7	8	9

.. testsetup::

	from merge_metadata import *
"""

import argparse
import blist
import csv
import os
import re
import sys

c_dTarget = 1.0
c_fRound = False

c_strUnclassified = "unclassified"
c_strOTUID = "#OTU ID"
c_cOutputOTULineageDelim = "|"
c_strOutputDelimiter ="\t"

class CClade:
	
  #Initialize CCClade
  #Dictionary to hold children nodes in tree
  #adValues is a list of the abundance values from the samples
  def __init__( self ):
    self.m_hashChildren = {}
    self.m_adValues = None
	
  #Recursively travel the length of a tree until you find the terminal node
  #(where astrClade == False or actually [])
  #or a dict key that matches the clade call.
  #If at any time a clade is given that is not currently know, return a new clade
  #which is set to the current Clade as a child.
  def get( self, astrClade ):
		
    return self.m_hashChildren.setdefault(
      astrClade[0], CClade( ) ).get( astrClade[1:] ) if astrClade else self

  #Set all the values given as a list in the same order given
  def set( self, adValues ):
		
    self.m_adValues = blist.blist( [0] ) * len( adValues )
    for i, d in enumerate( adValues ):
      if d:
        self.m_adValues[i] = d

  #This allows you to recursively impute values for clades without values given their children counts.
  #Assumably this should be called only once and after all clade abundances have been added.
  #If the m_adValues already exist return the stored m_adValues. (No imputation needed).
  #Otherwise call impute for all children and take the sum of the values from all the children by column
  #Not a sum of a list but summing a list with lists by element.
  def impute( self ):

    #If values do not exist
    if not self.m_adValues:
      #Call impute on all children
      #If the parent clade has no abundance values
      #Then take a copy of the child's
      #If they now have a copy of a child's but have other children
      #Sum their children with thier current values
      for pChild in self.m_hashChildren.values( ):
        adChild = pChild.impute( )
        if self.m_adValues:
          for i in range( len( adChild or [] ) ):
            if adChild[i]:
              self.m_adValues[i] += adChild[i]
        elif adChild:
          self.m_adValues = adChild[:] 
    #If values exist return			
    return self.m_adValues
	
  #Update the given hashValues dict with clade abudances given depth specifications
  #Return a set of integers returning an indicator of the structure of the tree preserved in the dict/hash
  #When the appropriate level of the tree is reached
  #Hashvalue is updated with the clade (including lineage) and the abundance. looks like {"clade":blist(["0.0","0.1"...])}
  def _freeze( self, hashValues, iTarget, astrClade, iDepth, fLeaves ):
		
    #fHit is true on atleast one of the following conditions:
    #iTarget is not 0 indicating no changes
    #Leaves are indicated to be only given and the target depth for the leaves is reached.
    #The required depth is reached.
    fHit = ( not iTarget ) or ( ( fLeaves and ( iDepth == iTarget ) ) or ( ( not fLeaves ) and ( iDepth <= iTarget ) ) )
    #Increment depth
    iDepth += 1
    #Returns a set
    setiRet = set()
    #If there are children build integer set indicating structure of the tree preserved in the dict
    if self.m_hashChildren:
      #Union all the results from freeze of all children
      #Call freeze but append the child clade to the clade in the call.
      #And give an incremented depth
      for strChild, pChild in self.m_hashChildren.items( ):
        setiRet |= pChild._freeze( hashValues, iTarget, astrClade + [strChild], iDepth, fLeaves )
      setiRet = set( ( i + 1 ) for i in setiRet )
    else:
      setiRet.add( 0 )
    #Indicate if the correct level is reached
    if iTarget < 0:
      if fLeaves:
        fHit = -( iTarget + 1 ) in setiRet
      else:
        fHit = -( iTarget + 1 ) <= max( setiRet )
    #if astrClade is not == [] (so you are actually in a clade of the tree)
    #And the clade has values (should be true, if not impute should have been callded before running this method)
    #And we are at the correct level of the tree then
    #Add to the dict the clade and the abundance values
    if astrClade and self.m_adValues and fHit:
      hashValues[c_cOutputOTULineageDelim.join( astrClade )] = self.m_adValues
    return setiRet
	
  #Call helper function setting the clade and depth to defaults (start positions)
  #The important result of this method is hashValues is updated with clade and abundance information
  def freeze( self, hashValues, iTarget, fLeaves ):
    self._freeze( hashValues, iTarget, [], 0, fLeaves )
	
  #Represent tree clade for debugging
  def _repr( self, strClade ):
    strRet = "<"
    if strClade:
      strRet += "%s %s" % (strClade, self.m_adValues)
      if self.m_hashChildren:
        strRet += " "
    if self.m_hashChildren:
      strRet += " ".join( p._repr( s ) for (s, p) in self.m_hashChildren.items( ) )
    return ( strRet + ">" )
		
  def __repr__( self ):
    return self._repr( "" )

"""
pTree = CClade( )
pTree.get( ("A", "B") ).set( [1, 2, 3] )
pTree.get( ("A", "C") ).set( [4, 5, 6] )
pTree.get( ("D", "E") ).set( [7, 8, 9] )
iTaxa = 0
if iTaxa:
	pTree.impute( )
hashFeatures = {}
pTree.freeze( hashFeatures, iTaxa )
sys.exit( 0 )
#"""

def funcDetectFormat(strFormatInQuestion):
  """ Detects which format to use for the strFormatInQuestion

      :param strFormatInQuestion: The consensus string to format
      :type strFormatInQuestion: String
  """

  # Given a string, a function is returned that will parse it or an error is given.
  lFormats = [[r'^k__(\w)+;\w',qiimeFormat1],[r'^Root',qiimeFormat2],
              [r'^k__(\w)+; ',qiimeFormat3],[r'[^;]',funcPass]]

  for strFormat,funcFormat in lFormats:
    if not re.match(strFormat, strFormatInQuestion) is None:
      return funcFormat
  return None

#Qiime Format 1
def qiimeFormat1(strConsensusLineage):
  """ Handles formatting matching k__Bacteria;p__Firmicutes;c__Clostridia;o__Clostridiales;f__Lachnospiraceae

      :param strConsensusLineage: The conensus lineage to format
      :type strConsensusLineage: String
  """

  #Format consensus lineage
  #Remove root
  strConsensusLineage = re.sub(r'^k__$',"k__"+c_strUnclassified,strConsensusLineage)
  #Change no end clade to unclassified
  strConsensusLineage = re.sub(r'__$',"__"+c_strUnclassified,strConsensusLineage)
  #Update Internal unclassified
  strConsensusLineage = re.sub(r'__;',"__"+c_strUnclassified+";",strConsensusLineage)
  #Remove root
  strConsensusLineage = re.sub(r';', c_cOutputOTULineageDelim,strConsensusLineage)
  return strConsensusLineage

#Qiime Format 2
def qiimeFormat2(strConsensusLineage):
  """ Handles formatting matching Root;k__Bacteria;p__Firmicutes;c__Clostridia;o__Clostridiales;f__Lachnospiraceae

      :param strConsensusLineage: The conensus lineage to format
      :type strConsensusLineage: String
  """

  #Format consensus lineage
  #Remove rootby itself, make it unclassified as a root
  strConsensusLineage = re.sub(r'^Root$',c_strUnclassified,strConsensusLineage)
  #Remove root
  strConsensusLineage = re.sub(r'^Root;',"",strConsensusLineage)
  #Change no end clade to unclassified
  strConsensusLineage = re.sub(r'__$',"__"+c_strUnclassified,strConsensusLineage)
  #Update Internal unclassified
  strConsensusLineage = re.sub(r'__;',"__"+c_strUnclassified+";",strConsensusLineage)
  #Change otu delimiters
  strConsensusLineage = re.sub(r';',c_cOutputOTULineageDelim,strConsensusLineage)
  return strConsensusLineage

#Qiime Format 3
def qiimeFormat3(strConsensusLineage):
  """ Handles formatting matching k__Bacteria; p__Tenericutes; c__Mollicutes; o__RF39

      :param strConsensusLineage: The conensus lineage to format
      :type strConsensusLineage: String
  """

  #Format consensus lineage
  #Standardize unclassifieds
  strConsensusLineage = re.sub(r'__;',"__"+c_strUnclassified+";",strConsensusLineage)
  #Change no end clade to unclassified
  strConsensusLineage = re.sub(r'__$',"__"+c_strUnclassified,strConsensusLineage)
  #Update Internal unclassified
  strConsensusLineage = re.sub(r'__; ',"__"+c_strUnclassified+"; ",strConsensusLineage)
  #Replace delimiter
  strConsensusLineage = re.sub(r'; ',c_cOutputOTULineageDelim,strConsensusLineage)
  return strConsensusLineage

def funcPass(strConsensusLineage):
  """ If no formatting is needed use this function (for instance if no clade level is given k__Bacteria)

      :param strConsensusLineage: The conensus lineage to format (or not format in this case)
      :type strConsensusLineage: String
  """
  return strConsensusLineage

def funcFormatInput(strmInputFile):
  """ Formats the Qiime Table and returns the metadata (dict) and data (list of lists)

      :param strmInputFile: Input file stream
      :type strmInputFile: String
  """

  #Lines of data to output
  lstrOutputlines = []

  fDetectFormatter = True
  funcFormatter = None
  #Read through tab delimited qiime output
  for astrLine in strmInputFile:
    #Keep the sample header
    if astrLine[0][0] == c_strOTUID[0]:
      if astrLine[0][0:len(c_strOTUID)] == c_strOTUID:
        lstrOutputlines.append(astrLine[:-1])
    else:
      #Get otu and data
      strOTU, astrData, strConsensusLineage = astrLine[0], astrLine[1:-1], astrLine[-1]

      #Get formatter
      if fDetectFormatter:
        funcFormatter = funcDetectFormat(strConsensusLineage)
        if funcFormatter.__name__ != "funcPass":
          fDetectFormatter = False

      #Format consensus lineage
      strConsensusLineage = funcFormatter(strConsensusLineage)

      #Combine with qiime consensus lineages
      lstrOutputlines.append([c_strOutputDelimiter.join([c_cOutputOTULineageDelim.join([strConsensusLineage,strOTU])])]+astrData)

  if fDetectFormatter:
    print("qiimeToMaAsLin did not detect a specific format for your file, this could be due to using a new consensus lineage format, improper formatting, or having consensus lineages with no heirarchical relationship (if not using a heirarchical relationship, you may ignore this message). Please check your output file formatting and the read me for supported formats. If this is a standard format and needs to be supported please let us know!")

  #Return list of formatted otu and data
  return(lstrOutputlines)

def merge_metadata( aastrMetadata, aastrData, ostm, fNormalize, strMissing, astrExclude, dMin, iTaxa, fLeaves ):
	"""
	Joins and outputs a data matrix with a metadata matrix, optionally normalizing and filtering it.
	A pipe-delimited taxonomy hierarchy can also be dynamically added or removed.
	
	:param	aastrMetadata:	Split lines from which metadata are read.
	:type	aastrMetadata:	collection of string collections
	:param	aastrData:		Split lines from which data are read.
	:type	aastrData:		collection of string collections
	:param	ostm:			Output stream to which joined rows are written.
	:type	ostm:			output stream
	:param	fNormalize:		If true, divide data values by column sums.
	:type	fNormalize:		bool
	:param	strMissing:		Representation for missing metadata values.
	:type	strMissing:		str
	:param	astrExclude:	Lines from which excluded IDs are read.
	:type	astrExclude:	collection of strings
	:param	dMin:			Minimum fraction of maximum value for per-column quality control.
	:type	dMin:			bool
	:param	iTaxa:			Depth of taxonomy to be computed, -1 = leaves only, 0 = no change
	:type	iTaxa:			int
	:param	fLeaves:		Output only leaves, not complete taxonomy; ignored if taxa = 0
	:type	fLeaves:		bool

	Metadata are optional; if not provided, data will be optionally normalized or its taxonomy
	modified as requested.  Metadata are provided one row per sample, data one column per
	sample, both files tab-delimited text with one header row and one header column.
	
	Metadata IDs that do not match data IDs are discarded, and data IDs without corresponding
	metadata IDs are given missing values.  Missing data values are always treated (and output)
	as zero.
	
	Per-column quality control is performed if the requested minimum fraction is greater than
	zero.  Specifically, for each column i, the row j containing the maximum value d is
	identified.  If d is less than the minimum fraction of row j's maximum value over all columns,
	the entire column i is removed.
	
	A taxonomy hierarchy will be calculated by default if row IDs are pipe-delimited, i.e. of
	the form A|B|C.  All parent clades are computed by default, e.g. A|B and A, save when
	they would be identical to a more specific child clade.  Negative values are counted from the
	bottom (right) of the hierarchy rather than the top.  The special value of 0 deactivates
	hierarchy calculation.
	
	>>> aastrMetadata = [[t.strip( ) for t in s] for s in ("-YZ", "a1x", "b0y", "c z")]
	>>> aastrData = [s.split( ) for s in ( \
		"-	a	b	c",		\
		"A|B	1	2	3",	\
		"A|C	4	5	6",	\
		"D|E	7	8	9")]
	>>> merge_metadata( aastrMetadata, aastrData, sys.stdout, True, "", [], 0.01, -1, False ) #doctest: +NORMALIZE_WHITESPACE
	sample	a	b	c
	Y	1	0
	Z	x	y	z
	A	0.416667	0.466667	0.5
	A|B	0.0833333	0.133333	0.166667
	A|C	0.333333	0.333333	0.333333
	D|E	0.583333	0.533333	0.5

	>>> merge_metadata( aastrMetadata, aastrData, sys.stdout, True, "", [], 0.01, -1, True ) #doctest: +NORMALIZE_WHITESPACE
	sample	a	b	c
	Y	1	0
	Z	x	y	z
	A|B	0.0833333	0.133333	0.166667
	A|C	0.333333	0.333333	0.333333
	D|E	0.583333	0.533333	0.5

	>>> merge_metadata( aastrMetadata, aastrData, sys.stdout, True, "", [], 0, 0, True ) #doctest: +NORMALIZE_WHITESPACE
	sample	a	b	c
	Y	1	0
	Z	x	y	z
	A|B	0.0833333	0.133333	0.166667
	A|C	0.333333	0.333333	0.333333
	D|E	0.583333	0.533333	0.5

	>>> merge_metadata( aastrMetadata, aastrData, sys.stdout, True, "", [], 0, 1, False ) #doctest: +NORMALIZE_WHITESPACE
	sample	a	b	c
	Y	1	0
	Z	x	y	z
	A	0.416667	0.466667	0.5
	D	0.583333	0.533333	0.5

	>>> merge_metadata( aastrMetadata, aastrData, sys.stdout, True, "", [], 0, -1, True ) #doctest: +NORMALIZE_WHITESPACE
	sample	a	b	c
	Y	1	0
	Z	x	y	z
	A|B	0.0833333	0.133333	0.166667
	A|C	0.333333	0.333333	0.333333
	D|E	0.583333	0.533333	0.5

	>>> merge_metadata( aastrMetadata, aastrData, sys.stdout, False, "", [], 0, 0, True ) #doctest: +NORMALIZE_WHITESPACE
	sample	a	b	c
	Y	1	0
	Z	x	y	z
	A|B	1	2	3
	A|C	4	5	6
	D|E	7	8	9

	>>> merge_metadata( aastrMetadata, aastrData, sys.stdout, True, "-", [], 0.8, 0, True ) #doctest: +NORMALIZE_WHITESPACE
	sample	b	c
	Y	0	-
	Z	y	z
	A|B	0.133333	0.166667
	A|C	0.333333	0.333333
	D|E	0.533333	0.5

	>>> merge_metadata( None, aastrData, sys.stdout, False, "", [], 0, 0, True ) #doctest: +NORMALIZE_WHITESPACE
	sample	a	b	c
	A|B	1	2	3
	A|C	4	5	6
	D|E	7	8	9

	>>> merge_metadata( aastrMetadata, aastrData, sys.stdout, True, "", ["b"], 0.01, -1, False ) #doctest: +NORMALIZE_WHITESPACE
	sample	a	c
	Y	1
	Z	x	z
	A	0.416667	0.5
	A|B	0.0833333	0.166667
	A|C	0.333333	0.333333
	D|E	0.583333	0.5
	"""

        #Put metadata in a dictionary
        #{"First line element",["line element 2","line element 3","line element 4"]}
	astrMetadata = None
	hashMetadata = {}
	for astrLine in ( aastrMetadata or [] ):
		if astrMetadata:
			hashMetadata[astrLine[0]] = astrLine[1:]
		else:
			astrMetadata = astrLine[1:]
	
        #Read in the data
        #Find the header column (iCol) assumed to be 1 or 2 depending on the location of "NAME"
        #Create a list (adSeq) that will eventually hold the sum of the columns of data
	astrHeaders = adSeqs = iCol = None
	pTree = CClade( )
	aastrRaw = []
	for astrLine in aastrData:
		if astrHeaders:
                        #Skip EWEIGHT, total, or data without values
			if ( astrLine[0] == "EWEIGHT" ) or ( astrLine[0] == "total" ) or \
				( len( astrLine ) < 2 ):
				continue
                        #Parse the data values as floats (default value = 0)
			try:
				adCounts = [( float(strCur) if len( strCur.strip( ) ) else 0 ) for
					strCur in astrLine[iCol:]]
                        #If a data row can not be parsed then hold in list and
                        #Eventually print at the end of the output file as is.
                        #This being the case thier abundance will not be added to the sample
                        #Summaries and will not be used in normalization.
			except ValueError:
				aastrRaw.append( astrLine )
				continue
                        #Add to the sum of the columns (samples)
			for i in range( len( adCounts ) ):
				adSeqs[i] += adCounts[i]
                        #
			if ( iCol > 1 ) and ( astrLine[0] != astrLine[1] ):
				if astrLine[1].find( astrLine[0] ) >= 0:
					astrLine[0] = astrLine[1]
				else:
					astrLine[0] += " " + astrLine[1]
			pTree.get( astrLine[0].split( c_cOutputOTULineageDelim ) ).set( adCounts )
                #There are 2 formats one can have depending on "NAME" location
                #Set the column header index
		else:
			iCol = 2 if ( astrLine[1].upper( ) == "NAME" ) else 1
			astrHeaders = [strCur.replace( " ", "_" ) for strCur in astrLine[iCol:]]
			adSeqs = [0] * len( astrHeaders )

        #Create tree of data
        #Input missing data
        #Fill hashFeatures with the clade name (key) and a blist of values (value) of the specified level interested.		
	if iTaxa:
		pTree.impute( )
	hashFeatures = {}
	pTree.freeze( hashFeatures, iTaxa, fLeaves )
	setstrFeatures = hashFeatures.keys( )
	afOmit = [False] * len( astrHeaders )
	if dMin > 0:
		aadData = list(hashFeatures.values( ))
		for i in range( len( astrHeaders ) ):
			iMax = max( range( len( aadData ) ), key = lambda j: aadData[j][i] )
			dMaxUs = aadData[iMax][i]
			dMaxThem = max( aadData[iMax][j] for j in ( range( i ) + range( i + 1, len( astrHeaders ) ) ) )
			if dMaxUs < ( dMin * dMaxThem ):
				sys.stderr.write( "Omitting: %s\n" % astrHeaders[i] )
				afOmit[i] = True
	
	if astrExclude:
		setstrExclude = set(s.strip( ) for s in astrExclude)
		for i in range( len( astrHeaders ) ):
			if ( not afOmit[i] ) and ( astrHeaders[i] in setstrExclude ):
				afOmit[i] = True
	
	adMult = [( ( c_dTarget / d ) if ( fNormalize and ( d > 0 ) ) else 1 ) for d in adSeqs]
	for strFeature, adCounts in hashFeatures.items( ):
		for i in range( len( adCounts ) ):
			if adCounts[i]:
				adCounts[i] *= adMult[i]
				if c_fRound:
					adCounts[i] = round( adCounts[i] )
	for strFeature, adCounts in hashFeatures.items( ):
		astrFeature = strFeature.strip( ).split( c_cOutputOTULineageDelim )
		while len( astrFeature ) > 1:
			astrFeature = astrFeature[:-1]
			strParent = c_cOutputOTULineageDelim.join( astrFeature )
			adParent = hashFeatures.get( strParent )
			if adParent == adCounts:
				del hashFeatures[strParent]
				setstrFeatures.remove( strParent )
	
	if astrMetadata:
		for i in range( len( astrMetadata ) ):
			hashFeatures[astrMetadata[i]] = astrCur = []
			for strSubject in astrHeaders:
				astrSubject = hashMetadata.get( strSubject )
				if not astrSubject:
					strSubject = re.sub( '_.*$', "", strSubject )
					astrSubject = hashMetadata.get( strSubject, [] )
				astrCur.append( astrSubject[i] if ( i < len( astrSubject ) ) else "" )
	
	astrFeatures = sorted( astrMetadata or [] ) + sorted( setstrFeatures )
	aiHeaders = filter( lambda i: not afOmit[i], range( len( astrHeaders ) ) )

        #Write data to CSV
	csvw = csv.writer( sys.stdout, csv.excel_tab )
        #Automatically set key metadata header id as "sample"
	csvw.writerow( ["sample"] + [astrHeaders[i] for i in aiHeaders] )


	for iFeature in range( len( astrFeatures ) ):
		strFeature = astrFeatures[iFeature]
		adFeature = hashFeatures[strFeature]
		astrValues = [adFeature[i] for i in aiHeaders]
		for i in range( len( astrValues ) ):
			strValue = astrValues[i]
			if type( strValue ) in (int, float):
				astrValues[i] = "%g" % astrValues[i]
			elif ( not strValue ) or ( ( type( strValue ) == str ) and
				( len( strValue ) == 0 ) ):
				astrValues[i] = strMissing
		csvw.writerow( [strFeature] + astrValues )
        #Write data that errored
	for astrRaw in aastrRaw:
		csvw.writerow( [astrRaw[i] for i in aiHeaders] )

argp = argparse.ArgumentParser( prog = "qiimeToMaaslin.py",
	description = "Join a qiime otu table with a metadata matrix, optionally normalizing and filtering it.\n\n" +
	"A pipe-delimited taxonomy hierarchy can also be dynamically added or removed." )
argp.add_argument( "-n",		dest = "fNormalize",	action = "store_false",
	help = "Don't normalize data values by column sums" )
argp.add_argument( "-s",		dest = "strMissing",	metavar = "missing",
	type = str,		default = " ",
	help = "String representing missing metadata values" )
argp.add_argument( "-m",		dest = "dMin",			metavar = "min",
	type = float,	default = 0.00,
	help = "Per-column quality control, minimum fraction of maximum value" )
argp.add_argument( "-t",		dest = "iTaxa",			metavar = "taxa",
	type = int,		default = -1,
	help = "Depth of taxonomy to be computed, negative = from right, 0 = no change" )
argp.add_argument( "-l",		dest = "fLeaves",		action = "store_true",
	help = "Output only leaves, not complete taxonomy" )
argp.add_argument( "-x",		dest = "istmExclude",	metavar = "exclude.txt",
	type = file,
	help = "File from which sample IDs to exclude are read" )
argp.add_argument( "istmMetadata",	metavar = "metadata.txt",
	type = file,	nargs = "?",
	help = "File from which metadata is read" )
__doc__ = "::\n\n\t" + argp.format_help( ).replace( "\n", "\n\t" ) + __doc__

def _main( ):
  # Read Arguments
  args = argp.parse_args( )

  # Format input
  lstrExtractedData = funcFormatInput(csv.reader( sys.stdin, csv.excel_tab ))

  # Merge the metadata, optionally summing and normalizing
  merge_metadata( args.istmMetadata and csv.reader( args.istmMetadata, csv.excel_tab ),
    lstrExtractedData, sys.stdout, args.fNormalize, args.strMissing,
    args.istmExclude, args.dMin, args.iTaxa, args.fLeaves )
	
if __name__ == "__main__":
	_main( )
