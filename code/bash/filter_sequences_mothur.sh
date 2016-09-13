# Change directory to /Users/benjaminpeterson/Documents/gradSchool/research/greatLakes/filterTest/
# To run: mothur code/bash/filter_sequences_mothur.sh

# This mothur script is to line up the paired end sequences and
# filter out the low quality sequences. It also removes
# chimeras. This is all run on the files in BDPLabHD.

# This script requires a reference database generated from the Silva database.
# The database is a fasta file that contains an alignment of the 16S rRNA segment
# from all the genomes in the Silva database. This file is created in the
# code/bash/generate_v4_reference.sh script.

# Remove old mothur log files before starting
# Only needed if I'm rerunning the file.
# Can you tell I hate having unneeded files lying around?
system(rm /Volumes/BDPLabHD/data/filterTest/dataEdited/mothurmothur.*.logfile)

# Generate the paired file with the actual sample names
make.file(inputdir=/Volumes/BDPLabHD/data/filterTest/dataEdited/sequenceFiles, outputdir=/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur, type=gz)
# Output File Names:
# dataEdited/mothur/fileList.paired.file

# Rename the paired file so that it means something for your dataset.
system(mv /Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/fileList.paired.file /Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.file)

# Make contigs from the sequences generated from the forward and reverse primers.
make.contigs(file=/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.file, outputdir=/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/, processors=2)
#It took 205 secs to process 232655 sequences.
#
#Group count:
#Acro2	73524
#Acro3	57952
#Pall2	72725
#Pall3	28454
#
#Total of all groups is 232655
#
#Output File Names:
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.fasta
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.qual
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.contigs.report
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.scrap.contigs.fasta
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.scrap.contigs.qual
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.contigs.groups

# Initial filtering of sequences. Eliminate sequences longer than 275bp, those with homopolymers over 8bp, and those with any ambiguous basepairs.
screen.seqs(fasta=current, group=current, maxambig=0, maxlength=275, maxhomop=8)
#Output File Names:
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.fasta
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.bad.accnos
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.contigs.good.groups
#It took 4 secs to screen 232655 sequences.

# Retrieve unique sequences
unique.seqs(fasta=current)
#Output File Names:
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.names
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.fasta

# Generate a count table that lists the copy number of each unique sequence
count.seqs(name=current, group=current)
#Total number of sequences: 199228
#Output File Names:
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.count_table


# Align our sequences to the alignment from the Silva database previously generated.
# Silva database is stored on BDPLabHD.
# Path is /Volumes/BDPLabHD/data/referenceDB/
align.seqs(fasta=current, reference=/Volumes/BDPLabHD/data/referenceDB/silva.bacteria.pcr.fasta, flip=T)
#[WARNING]: Some of your sequences generated alignments that eliminated too many bases, a list is provided in dataEdited/mothur/filterTest.trim.contigs.good.unique.flip.accnos. If you set the flip parameter to true mothur will try aligning the reverse compliment as well.
#It took 44 secs to align 27628 sequences.
#Output File Names:
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.align
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.align.report
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.flip.accnos

# Trim the alignment. Must start before or at 1968, end at or after 11550
screen.seqs(fasta=current, count=current, summary=current, start=1968, end=11550)
#Output File Names:
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.summary
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.align
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.bad.accnos
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.good.count_table
#It took 32 secs to screen 27628 sequences.
# This removed 221 sequences


# Filter out the sequences to cut out ones with a period in them
filter.seqs(fasta=current, vertical=T, trump=.)
#Length of filtered alignment: 465
#Number of columns removed: 12960
#Length of the original alignment: 13425
#Number of sequences used to construct filter: 27407
#Output File Names:
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.filter
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.fasta

# Remake the unique sequence list with the filtered sequences
unique.seqs(fasta=current, count=current)
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.count_table
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.unique.fasta

# Precluster the data to denoise it. Speeds up computation
pre.cluster(fasta=current, count=current, diffs=2)
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.unique.precluster.fasta
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.unique.precluster.count_table
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.unique.precluster.Acro2.map
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.unique.precluster.Acro3.map
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.unique.precluster.Pall2.map
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.unique.precluster.Pall3.map

# Remove chimeras
chimera.uchime(fasta=current, count=current, dereplicate=t)
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.unique.precluster.denovo.uchime.pick.count_table
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.unique.precluster.denovo.uchime.chimeras
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.unique.precluster.denovo.uchime.accnos
remove.seqs(fasta=current, accnos=current)
#Removed 758 sequences from your fasta file.
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta

# Cluster the OTUs by distance.
# This is the slower, traditional way, but I don't want to calculate phylogeny yet.
# Alternative is to assign taxonomy with GreenGenes, cluster OTUs, then reclassify with 16STaxAss
dist.seqs(fasta=current, cutoff=0.20)
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.unique.precluster.pick.dist
#It took 63 seconds to calculate the distances for 7183 sequences.

cluster(column=current, count=current)
#changed cutoff to 0.0941005
#It took 54 seconds to cluster
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.unique.precluster.pick.an.unique_list.list

# Get a representative sequence for each OTU that can then be used to classify
# the OTU. Otherwise, this gets really messy.
get.oturep(column=current, name=current, list=current, fasta=current, label=0.03)
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.unique.precluster.pick.an.unique_list.0.03.rep.names
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.unique.precluster.pick.an.unique_list.0.03.rep.fasta

# Make a shared file, which is basically an OTU table, for use in the 16STaxAss workflow
make.shared(list=current, count=current, label=0.03)
#/Volumes/BDPLabHD/data/filterTest/dataEdited/mothur/filterTest.trim.contigs.good.unique.good.filter.unique.precluster.pick.an.unique_list.shared

summary.seqs(fasta=current, count=current)

get.current()
