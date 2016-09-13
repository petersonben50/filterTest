# This is to generate the V4 reference gene against which we can align our sequence.
# This is all stored on BDPLabHD

# Pull out the appropriate sequence from the alignment.
pcr.seqs(fasta=/Volumes/BDPLabHD/data/referenceDB/silva.bacteria/silva.bacteria.fasta, outputdir=/Volumes/BDPLabHD/data/referenceDB/, start=11894, end=25319, keepdots=F, processors=2)

# Rename it to a more informative name
system(mv /Volumes/BDPLabHD/data/referenceDB/silva.bacteria.pcr.fasta /Volumes/BDPLabHD/data/referenceDB/silva.v4.reference.fasta)
