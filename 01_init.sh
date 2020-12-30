#!/bin/bash

NATUREDIR=nature_tmpdir
BKGFILE=background.csv

# a list of days of the month
declare -a days=(01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31)
# a list of months with 31 days 
declare -a months=(01 03 05 07 08 10 12)

echo -e "\nThis script creates a working directory and files for our simulated data analyses."

if [ ! -d "$NATUREDIR" ]; then
    echo -e "\nCreating working directory $NATUREDIR..."
    mkdir $NATUREDIR
fi 
cd $NATUREDIR

# create a set of files with nonstandard date stamps
echo -e "Creating dummy data files..."
for month in "${months[@]}"; do
    for day in "${days[@]}"; do 
        fname=datafile-$day-$month-2020.txt
        # the 'touch' command creates an empty file
        touch $fname
        # echo "File $fname created."
    done
done

echo -e "Creating dummy absorbance data..."
echo "sample","bkgd" > $BKGFILE
for i in {1..50}; do            
    echo $i,$(($RANDOM / 100)) >> $BKGFILE
done

for i in 01 02 03; do
    fname=reading$i.csv
    echo "sample","abs$i" > $fname 
    for j in {1..50}; do
        echo $j,$RANDOM >> $fname
    done
done

# 'pipe' the file listing command (ls) through 'wc' (word count) to count the number of files
# use sed (stream editor) to remove leading whitespace from the file count
echo -e "\nCreated $(ls | wc -l | sed -E 's/^[[:space:]]*//g') files."
read -p "Press enter to view the file listing, and 'q' when done:" key 
ls | less
