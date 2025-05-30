rm(list = ls())
library(ggplot2)

threshold <- 0.01
profile <- read.csv('animal_guts_profile.tsv', sep='\t')
profile <- profile[grepl("s__|sgb_|UNKNOWN", profile$Taxonomy) & 
                     !grepl("t__", profile$Taxonomy),]
profile[,-1][profile[,-1] < threshold] <- 0
profile[profile$Taxonomy == "UNKNOWN",-1] = profile[profile$Taxonomy == "UNKNOWN",-1] + 
  (100 - colSums(profile[,-1]))

# Plot an ECDF of unknown percentage by sample
unknownECDF <- function(profile) {
  df <- data.frame("abundance" = c(unlist(profile[profile$Taxonomy == "UNKNOWN",-1]),
                                   colSums(profile[grepl("s__", profile$Taxonomy),-1]),
                                   colSums(profile[grepl("sgb_", profile$Taxonomy),-1])),
                   "type" = c(rep("Unknown", ncol(profile) - 1),
                              rep("Known", ncol(profile) - 1),
                              rep("SGB", ncol(profile) - 1)),
                   "sample" = rep(colnames(profile)[-1], 3))
  
  df$sample <- factor(df$sample, levels = df$sample[df$type == "Unknown"][order(df$abundance[df$type == "Unknown"])])
  
  p1 <- ggplot(df, aes(fill=type, y=abundance, x = sample)) + 
    geom_bar(position="fill", stat="identity") + 
    theme(axis.text.x=element_blank()) + 
    ylab("Abundance") + xlab("Sample") + 
    labs(fill = "Abundance type")

  dir.create(file.path("figures/"), showWarnings = FALSE)
  ggsave("figures/ECDF.png", p1, width=18, height=10, units = 'cm', dpi=1000)
}

unknownECDF(profile)
