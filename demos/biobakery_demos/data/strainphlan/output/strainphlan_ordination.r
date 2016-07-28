# Generate ordination plot from distance matrix calculated from StrainPhlAn multiple sequence alignment file

# These files need to be in your working directory:
# s__eubacterium_siraeum.distmat_4R.txt
# metadata.txt

# load libraries
library(ggplot2)
library(vegan)

# load triangular distance matrix 
e.sir.dist <- read.table( 's__eubacterium_siraeum.distmat_4R.txt', sep = "\t", row.names = 1, header = T )
# remove X from colnames
colnames( e.sir.dist ) <- gsub( "X", "", colnames( e.sir.dist ))
# make symmetric, add lower triangle to upper triangle
e.sir.dist[lower.tri(e.sir.dist)] <- t(e.sir.dist)[lower.tri(e.sir.dist)]
dim(e.sir.dist)  # should be 7 by 7 matrix
# ordinate on the distance matrix
e.sir.pcoa <- cmdscale( e.sir.dist, eig = T )
# variance explained 
head(eigenvals(e.sir.pcoa)/sum(eigenvals(e.sir.pcoa)))
# get scores for plotting
e.sir.scores <- as.data.frame( e.sir.pcoa$points )

# read in metadata file
e.sir.meta <- read.delim( 'metadata.txt', header = T, sep = "\t", row.names = 1 )
# append to e.sir.scores
e.sir.scores.meta <- merge( e.sir.scores, e.sir.meta, by = 'row.names' )
# set first column as rownames and remove it
rownames( e.sir.scores.meta ) <- e.sir.scores.meta[,1]
e.sir.scores.meta[,1] <- NULL
# change colnames
colnames(e.sir.scores.meta) <- c( "PCo1", "PCo2", "SubjectID" )

# plot ordination
png( 'strainphlan_ordination.png', width = 750, height = 600, res = 150 )

ggplot( e.sir.scores.meta, aes(PCo1, PCo2, color=SubjectID) ) + 
  geom_point(size = 4, alpha = 0.75) + theme_classic() + 
  theme(axis.line.x = element_line(colour = 'black', size=0.75, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.75, linetype='solid'),
        axis.ticks = element_blank(), axis.text = element_blank()) + 
  xlab("PCo1 (60% variance explained)") + ylab( "PCo2 (29% variance explained)" )

dev.off()
# NOTE that the two samples from subject 13530241 have identical strains, which in this case is an artefact of subsampling. 
