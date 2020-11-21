#!/bin/bash

BKGFILE=background.csv
GENEFILE=genedata.csv
NATUREDIR=nature_bash

declare -a days=(01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31)
# a list of months with 31 days 
declare -a months=(07 08)

echo -e "\nThis script creates a working directory and files for our simulated data analyses."

echo -e "\nLet's check out the code. Remember use arrow keys to scroll, and 'q' to quit.\n" 
read -p "Press enter to continue: " key 

less $0

read -p "Press enter to continue: " key 

echo -e "\nCreating working directory $NATUREDIR..."
mkdir $NATUREDIR
echo -e "Entering $NATUREDIR..."
cd $NATUREDIR

echo -e "\nCreating dummy data files..."
read -p "Press enter to continue: " key 
# create a set of files with nonstandard date stamps
for month in "${months[@]}"; do
    for day in "${days[@]}"; do 
        fname=datafile-$day-$month-2020.txt
        touch $fname
        echo "File $fname created."
    done
done

echo -e "\nCreating dummy gene expression data..."
read -p "Press enter to continue: " key 
echo "gene","count" > $GENEFILE
for i in {1..1000}; do
    echo GENE_$(($RANDOM % 20 + 1)),$(($RANDOM * 10)) >> $GENEFILE
done 

echo -e "\nCreating background readings..."
read -p "Press enter to continue: " key 
echo "sample","bkgd" > $BKGFILE
for i in {1..50}; do            
    echo $i,$(($RANDOM / 100)) >> $BKGFILE
done

echo -e "\nCreating data readings..."
read -p "Press enter to continue: " key 
for i in 01 02 03; do
    fname=reading$i.csv
    echo "sample","abs$i" > $fname 
    for j in {1..50}; do
        echo $j,$RANDOM >> $fname
    done
    echo "File $fname created."
done
