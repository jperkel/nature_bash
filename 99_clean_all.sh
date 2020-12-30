#!/bin/bash

NATUREDIR=nature_tmpdir
BKGFILE=background.csv
CSVFILE=datatable.csv
SAMPLE_FILE=samples.cut
GEOFILE=GEOdataset.csv
GEOARCHIVE=$GEOFILE".gz"

if [ ! -d "$NATUREDIR" ]; then
    echo -e "\nRequired set-up not performed. Run 01_init.sh first."
    exit 0
fi

echo -e "\nThis script deletes the working files and directory we created."

cd $NATUREDIR

echo -e "Deleting files."
rm datafile-*.txt $BKGFILE $CSVFILE $SAMPLE_FILE reading0?.csv *.bak *.csv.cut
rm $GEOFILE $GEOARCHIVE

echo -e "Removing directory $NATUREDIR."
# move up one directory level in order to delete $NATUREDIR.
cd ..
rmdir $NATUREDIR
