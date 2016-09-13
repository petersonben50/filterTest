# Mothur's Little Helper

# This script is to rename, move, and reformat files from our mothur folder to
# our dataEdited folder for classification by 16STaxAss. The only files we
# need are the shared files and the fasta files with the unique counts.
# We'll also need to convert the shared file to an OTU file.

# Move the final fasta files and the OTU tables to the project directory on my computer.
cp /Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.unique.precluster.pick.an.unique_list.0.03.rep.fasta dataEdited/mothur/filterTest.fasta
cp /Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.unique.precluster.pick.an.unique_list.shared dataEdited/mothur/filterTest.OTU.shared

# Let's also move them into the dataEdited folder on BDPLabHD and rename them
cp /Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.unique.precluster.pick.an.unique_list.0.03.rep.fasta /Volumes/BDPLabHD/data/filterTest/dataEdited/filterTest.fasta
cp /Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.unique.precluster.pick.an.unique_list.shared /Volumes/BDPLabHD/data/filterTest/dataEdited/filterTest.OTU.shared

# Edit the file on my computer so that it just has the OTU numbers as the fasta name.
sed 's/.*\(Otu[0-9]*\).*/>\1/' dataEdited/mothur/filterTest.fasta > dataEdited/mothur/filterTest.rename.fasta

# Remove hyphens from the fasta sequences
sed 's/-//g' dataEdited/mothur/filterTest.rename.fasta > dataEdited/mothur/filterTest.rename.hyphenless.fasta

# Rename edited file and remove intermediate file
mv dataEdited/mothur/filterTest.rename.hyphenless.fasta dataEdited/mothur/filterTest.fasta
rm dataEdited/mothur/filterTest.rename.fasta

# Run R script to convert shared table to a relative abundance table
Rscript code/R/convert_shared_file.R dataEdited/mothur/filterTest.OTU.shared dataEdited/mothur/filterTest.OTU.abund

# Move the relativized abundance table to BDPLabHD as well.
cp dataEdited/mothur/filterTest.OTU.abund /Volumes/BDPLabHD/data/filterTest/dataEdited/filterTest.OTU.abund
