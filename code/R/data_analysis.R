# Using the vegan package
##########################
library("vegan")
#####

# Set WD
setwd("~/Documents/gradSchool/research/greatLakes/filterTest")

# Reading data in.
# This is a relative abundance table generated from the shared table from mothur. 
##########################
data <- read.table("dataEdited/filterTest_relative.abund",
                   header = TRUE,
                   sep = "\t",
                   row.names = 1)
data <- as.matrix(data)
dim(data)
#####

# Create a PCoA graph from unweighted data
##########################
# Generate a presence/absence (P/A) table from the data file.
dataPA <- (data > 0)*1 

# Generate distance matrix using the P/A table.
samplePA.dist <- vegdist(dataPA,
                         method = "jaccard")

# Calculate the PCoA from the distance table.
samplePA.pcoa <- cmdscale(samplePA.dist)

# Visualize P/A data
# Sets up the plot, but doesn't add the points
plot(samplePA.pcoa[, 1],
     samplePA.pcoa[, 2],
     cex = 0,
     main = "PA sample PCOA")
# Adds the points as numbers representing each sample
text(samplePA.pcoa[, 1],
     samplePA.pcoa[, 2],
     attr(samplePA.pcoa, "dimnames")[[1]],
     cex = 1)
#####

# Visualize relative data
##########################
# Generate distance matrix using the relative abundance table.
sampleREL.dist <- vegdist(data,
                         method = "jaccard")

# Calculate the PCoA from the distance table.
sampleREL.pcoa <- cmdscale(sampleREL.dist)

# Sets up the plot, but doesn't add the points
plot(sampleREL.pcoa[, 1],
     sampleREL.pcoa[, 2],
     cex = 0,
     main = "Relativized sample PCOA")
# Adds the points with the sample name
text(sampleREL.pcoa[, 1],
     sampleREL.pcoa[, 2],
     attr(samplePA.pcoa, "dimnames")[[1]],
     cex = 0.8)
#####

