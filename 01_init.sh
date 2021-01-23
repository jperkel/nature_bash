#!/bin/bash

# This command makes the script safer by, eg, exiting on error
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euo pipefail 

NATUREDIR=nature_tmpdir

# a list of months with 31 days 
declare -a months=(01 03 05 07 08 10 12)

if [ ! -d "$NATUREDIR" ]; then
    echo -e "\nCreating working directory $NATUREDIR..."
    mkdir $NATUREDIR
fi 
cd $NATUREDIR

# create a set of files with nonstandard date stamps
# since we want a two-digit date, we add zeroes to 1-9
echo -e "Creating dummy data files..."
for month in "${months[@]}"; do
    for day in {1..31}; do 
        if [ "$day" -lt 10 ]; then
            fname=datafile-0$day-$month-2020.txt
        else 
            fname=datafile-$day-$month-2020.txt    
        fi 
        # the 'touch' command creates an empty file
        touch $fname
    done
done

echo -e "Creating dummy absorbance data..."
echo "sample","bkgd" > background.csv
for i in {1..50}; do   
    # create a bunch of random numbers...         
    echo $i,$(($RANDOM / 100)) >> background.csv
done

for i in {1..3}; do
    fname=reading0$i.csv
    echo "sample","abs0$i" > $fname 
    for j in {1..50}; do
        echo $j,$RANDOM >> $fname
    done
done

# 'pipe' the file listing command (ls) through 'wc' (word count) to count the number of files
# use sed (stream editor) to remove leading whitespace from the file count
echo -e "\nCreated $(ls | wc -l | sed -E 's/^[[:space:]]*//g') files."
echo -e "To view them, execute the file-list command, 'ls nature_tmpdir | less'."
