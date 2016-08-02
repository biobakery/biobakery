# Generate dendrograms from StrainPhlAn outputs
# Execute script from within working directory that contains these three input files:

# RAxML_bestTree.s__Eubacterium_siraeum.tree
# metadata.txt
# s__Eubacterium_siraeum.fasta

# load library ggtree
library(ggplot2)
library(ggtree)


# read newick tree
e.sir.tre <- read.tree( 'RAxML_bestTree.s__Eubacterium_siraeum.tree' )
# create ggtree object
e.sir.gg <- ggtree( e.sir.tre )
# read in metadata file
e.sir.meta <- read.delim( 'metadata.txt', header = T, sep = "\t" )
# add metadata to dendrogram plot
e.sir.gg <- e.sir.gg %<+% e.sir.meta

# plot with color terminal edges and sample names with SubjectID and add tiplabels
png( 'strainphlan_tree_1.png', width = 750, height = 300, res = 120 )
# strainphlan_tree_1.pdf
e.sir.gg +  
  #geom_tiplab(size = 1.75, aes( color = SubjectID ) ) + 
  geom_tippoint( size = 3, aes( color = SubjectID ) ) + 
  aes( branch.length = 'length' ) +
  theme_tree2() + theme(legend.position="right")
dev.off()
# visualize tree with multiple sequence alignment (MSA)

# load RColorBrewer library
library(RColorBrewer)

# path to alignment file
e.sir.fasta <- ("s__Eubacterium_siraeum.fasta")
# plot tree with slice of MSA
png( 'strainphlan_tree_2.png', width = 750, height = 300, res = 120 )
# strainphlan_tree_2.pdf
msaplot( e.sir.gg + geom_tippoint( size = 3, aes( color = SubjectID ) ), 
         e.sir.fasta, window = c( 490,540 ), 
         color = brewer.pal(4, "Set3") ) + 
  theme( legend.position = 'right' )
dev.off()


