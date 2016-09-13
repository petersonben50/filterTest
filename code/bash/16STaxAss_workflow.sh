# Directory: /Users/benjaminpeterson/Documents/gradSchool/research/greatLakes/filterTest/

# This script is entirely based on the 16STaxAss workflow that was built by Robin Rohwer
# I did not write the R or Python scripts for this. I merely organized it so that it fit
# with my directory structure.

# This script required a plots directory for the sanity check plot
# mkdir dataEdited/16STaxAss/plots

# Blast OTUs against FW blast database
blastn -query dataEdited/mothur/filterTest.fasta -task megablast -db /Volumes/BDPLabHD/data/referenceDB/FW_Robin.fasta.db -out /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/OTU.custom.blast -outfmt 11 -max_target_seqs 5

# Reformat blast results
blast_formatter -archive /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/OTU.custom.blast -outfmt "6 qseqid pident length qlen qstart qend" -out /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/OTU.custom.blast.table

# R script to calculate full length pident
Rscript code/R/calc_full_length_pident.R /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/OTU.custom.blast.table /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/OTU.custom.blast.table.modified

# Pull out sequence IDs that have greater than 98% identity to FW database entry
Rscript code/R/filter_seqIDs_by_pident.R /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/OTU.custom.blast.table.modified /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/ids.above.98 98 TRUE

# Pull out sequence IDs that have less than 98% identity to FW database entry
Rscript code/R/filter_seqIDs_by_pident.R /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/OTU.custom.blast.table.modified /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/ids.below.98 98 FALSE

# Run the R script to generate the sanity check plots
RScript code/R/plot_blast_hit_stats.R /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/OTU.custom.blast.table.modified 98 dataEdited/16STaxAss/plots

# Python code to pull out OTUs that hit nothing on the blast
python code/python/find_seqIDs_blast_removed.py dataEdited/mothur/filterTest.fasta /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/OTU.custom.blast.table.modified /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/ids.missing

# Concatonate that with the sequences that had blast hits less than 98% similarity
cat /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/ids.below.98 /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/ids.missing > /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/ids.below.98.all

# Create a fasta file with the sequences that correspond to each group (above or below 98%)
python code/python/create_fastas_given_seqIDs.py /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/ids.above.98 dataEdited/mothur/filterTest.fasta /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/otus.above.98.fasta
python code/python/create_fastas_given_seqIDs.py /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/ids.below.98.all dataEdited/mothur/filterTest.fasta /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/otus.below.98.fasta

# Classify each group of OTUs using mothur with the various databases.
mothur "#classify.seqs(fasta=/Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/otus.above.98.fasta, template=/Volumes/BDPLabHD/data/referenceDB/FW_Robin.fasta,  taxonomy=/Volumes/BDPLabHD/data/referenceDB/FW_Robin.taxonomy, method=wang, probs=T, processors=2)"
mothur "#classify.seqs(fasta=/Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/otus.below.98.fasta, template=/Volumes/BDPLabHD/data/referenceDB/Gg_Robin.fasta,  taxonomy=/Volumes/BDPLabHD/data/referenceDB/Gg_Robin.taxonomy, method=wang, probs=T, processors=2)"
# Store the output on my computer
cat /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/otus.above.98.FW_Robin.wang.taxonomy /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/otus.below.98.Gg_Robin.wang.taxonomy > dataEdited/16STaxAss/otus.taxonomy

# Move the sequence ID files to our dataEdited file.
cp /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/ids.below.98.all dataEdited/16STaxAss/ids.below.98.all
cp /Volumes/BDPLabHD/data/filterTest/dataEdited/16STaxAss/ids.above.98 dataEdited/16STaxAss/ids.above.98

# Now reformat so that taxonomy file is delimited by semicolons, not spaces/tabs.
sed 's/[[:blank:]]/\;/' <dataEdited/16STaxAss/otus.taxonomy >dataEdited/16STaxAss/otus.taxonomy.reformatted
mv dataEdited/16STaxAss/otus.taxonomy.reformatted dataEdited/16STaxAss/otus.taxonomy
