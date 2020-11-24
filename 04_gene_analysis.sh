#!/bin/bash

if [ -z "$NATUREDIR" ]; then
    echo -e "\nRequired global variables not set."
    echo -e "Execute '. ./set_vars.sh' to set."
    exit 0
fi

if [ ! -d "$NATUREDIR" ]; then
    echo -e "\nRequired set-up not performed. Run 01_init.sh first."
    exit 0
fi

echo -e "\nWe have a simulated set of gene names and counts."
echo -e "We'll use bash commands to identify the most common gene and compute the average count."

if [[ ! $1 == "--nocode" ]]; then
    read -p "Press enter to view the code: " key 

    less $0
fi 

read -p "Press enter to continue: " key 

cd $NATUREDIR

# h/t Tom Ryder, https://sanctum.geek.nz/bash-quick-start-questionnaire.html
echo -e "\nFinding most common genes..."
# read -p "Press enter to continue: " key 

# read $GENEFILE, grab field 1 (the gene name) with cut, sort alphabetically, 
# count the number of times each name appears (uniq -c), sort the resulting list from highest to lowest number,
# and show the first 10 rows of the output
cat $GENEFILE | cut -f1 -d, | sort | uniq -c | sort -k1,1nr | head
# save the most common gene name in $gene, and the the number of times it appears in $count
# use 'sed', the stream editor, to remove leading whitespace. 
gene=$(cat $GENEFILE | cut -f1 -d, | sort | uniq -c | sort -k1,1nr | head -n1 | sed -e "s/^[[:space:]]*//" | cut -f2 -d' ')
count=$(cat $GENEFILE | cut -f1 -d, | sort | uniq -c | sort -k1,1nr | head -n1 | sed -e "s/^[[:space:]]*//" | cut -f1 -d' ')

echo -e "\nShowing 10 of $count readings for $gene..."
read -p "Press enter to continue: " key 
# We use 'grep', the 'general regular expression parser' to select lines in $GENEFILE that contain our gene name
cat $GENEFILE | grep -E "^$gene," | head -n10

# From $GENEFILE, select rows containing $gene, and use awk to calculate the average count value in col2 of the file
avg=$(cat $GENEFILE | grep -E "^$gene," | awk -F, '{ SUM = SUM + $2; COUNT = COUNT + 1 } END { print SUM/COUNT }')
echo -e "\nAverage reading: $avg"