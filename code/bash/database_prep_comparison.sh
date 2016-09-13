
#Generate the blast database from the FW database

makeblastdb -dbtype nucl -in /Volumes/BDPLabHD/data/referenceDB/FWonly_11Feb2016_1452_ready.fasta -input_type fasta -parse_seqids -out /Volumes/BDPLabHD/data/referenceDB/FWonly_11Feb2016_1452_ready.fasta.db

# Generate a blast DB from the FW DB fasta file that Robin sent to me.
makeblastdb -dbtype nucl -in /Volumes/BDPLabHD/data/referenceDB/FW_Robin.fasta -input_type fasta -parse_seqids -out /Volumes/BDPLabHD/data/referenceDB/FW_Robin.fasta.db
