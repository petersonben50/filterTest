# Always start with a clean slate
##########################
rm(list = ls())
#####

# Receive command line inputs
##########################
userprefs <- commandArgs(trailingOnly = TRUE)
input.file <- userprefs[1]
output.file <- userprefs[2]
#####

# Convert the shared file to an abundance table.
##########################
# First, wrap it all in an if/else to ensure that it is fed 2 input 
if (length(userprefs) != 2) {
  # Gotta have two inputs
  stop("WTF dude?!?!?! You need to give me exactly two command line arguments. First I need an input file, then an output file. Didn't you read the documentation!?!?!?")
} else {
  # If there are two command arguments, allow user to pass.
  # This reads in the shared file that was generated in mothur
  OTU.table <- read.table(input.file,
                          header = TRUE,
                          sep = "\t",
                          stringsAsFactors = FALSE)
  
  # Save sample names in separate vector
  sampleID <- OTU.table[, 2]
  
  # Remove the first three columns
  # First column is a label of the clustering cutoff
  # Second column is sample name. 
  # Never fear, these will be added in as row names! 
  # Third column is the total number of OTUs
  OTU.table <- OTU.table[, -c(1:3)]
  
  # Add sample names as row names
  row.names(OTU.table) <- sampleID
  
  # Calculate relative abundances for each OTU.
  ##########################
  # Calculate the row sums for each 
  sums.of.rows <- rowSums(OTU.table)
  
  # Apply function to get the relative abundance table.
  REL.OTU.table <- apply(OTU.table, # We're applying this function the OTU.table variable
                         2, # function is applied over columns (cols = 2)
                         function(x) {
                           (x/sums.of.rows) # Want to divide the number of hits of a particular OTU in a sample by the total number of hits in that sample.
                         })
  #####
  
  # Make the sampleIDs a part of the tab-delimited file
  # Want to make sure there isn't a gap in top-left corner.
  REL.OTU.table.OTUs <- cbind(sampleID, REL.OTU.table)
  
  # Write out the OTU table to a tab-delimited file
  write.table(REL.OTU.table.OTUs,
              file = output.file,
              # Don't use quotes in the output file.
              quote = FALSE,
              # The OTU names are stored as the column names.
              # The sampleID column also has the sampleID header.
              col.names = TRUE,
              row.names = FALSE,
              # Separate with a tab.
              sep = "\t")
  print("Congrats, you successfully converted your shared file to a relativized abundance table!!! Alright alright, calm down.")
}
