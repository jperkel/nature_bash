#!/bin/bash

BKGFILE=background.csv
CSVFILE=datatable.csv
GENEFILE=genedata.csv
SAMPLE_FILE=samples.cut
NATUREDIR=nature_bash

echo -e "\nThis script deletes the working files and directory we created."

if [[ ! $1 == "--nocode" ]]; then
    read -p "Press enter to view the code: " key 

    less $0
fi 

read -p "Press enter to continue: " key 

cd $NATUREDIR

echo -e "Deleting files."
rm datafile-*.txt $BKGFILE $CSVFILE $GENEFILE $SAMPLE_FILE reading0?.csv *.bak *.csv.cut

echo -e "Removing directory $NATUREDIR."
# move up one directory level in order to delete $NATUREDIR.
cd ..
rmdir $NATUREDIR