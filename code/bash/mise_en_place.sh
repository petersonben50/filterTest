# This is a clean up file to prep the directory.
# Before this is run, we need a dataEdited and a dataRaw directory.
# The dataRaw directory should contain the raw zipped sequencing files.
# This data is stored on BDPLabHD

# Directory: /Users/benjaminpeterson/Documents/gradSchool/research/mercury/WAVES
# Run script: bash code/bash/mise_en_place.sh

cp $(find /Volumes/BDPLabHD/data/filterTest/dataRaw/ -name *.gz) /Volumes/BDPLabHD/data/filterTest/dataEdited/sequenceFiles

# Remove any ._ files in the dataEdited file
rm /Volumes/BDPLabHD/data/filterTest/dataEdited/sequenceFiles/._*

# Need to replace hyphens with underscores or mothur doesn't working
for x in /Volumes/BDPLabHD/data/filterTest/dataEdited/sequenceFiles/*"-"*; do
  mv -- "$x" "${x//-/}";
done
