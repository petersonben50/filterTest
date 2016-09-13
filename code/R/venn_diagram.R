# Set working directory
##########################
setwd("~/Documents/gradSchool/research/greatLakes/filterTest")
#####

# Load up needed libraries
##########################
library(VennDiagram)
#####

# Read in relative abundance table
##########################
dataREL <- read.table("dataEdited/filterTest_relative.abund",
                   header = TRUE,
                   sep = "\t",
                   row.names = 1)
data <- as.matrix(data)

# Generate a presence/absence (P/A) table from the data file.
dataPA <- (dataREL > 0)*1 
#####

# 
##########################
#####

#