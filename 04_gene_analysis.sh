#!/bin/bash

GENEFILE=genedata.csv
NATUREDIR=nature_bash

echo -e "\nWe have a simulated set of gene names and counts."
echo -e "We'll use bash commands to identify the most common gene and compute the average count."

read -p "Press enter to view the code: " key 

less $0

read -p "Press enter to continue: " key 

cd $NATUREDIR

# h/t Tom Ryder, https://sanctum.geek.nz/bash-quick-start-questionnaire.html
echo -e "\nFinding most common genes..."
read -p "Press enter to continue: " key 
cat $GENEFILE | cut -f1 -d, | sort | uniq -c | sort -k1,1nr | head
gene=$(cat $GENEFILE | cut -f1 -d, | sort | uniq -c | sort -k1,1nr | head -n1 | sed -e "s/^[[:space:]]*//" | cut -f2 -d' ')
count=$(cat $GENEFILE | cut -f1 -d, | sort | uniq -c | sort -k1,1nr | head -n1 | sed -e "s/^[[:space:]]*//" | cut -f1 -d' ')

echo -e "\nShowing 10 of $count readings for $gene..."
read -p "Press enter to continue: " key 
cat $GENEFILE | grep $gene | head -n10

avg=$(cat $GENEFILE | grep $gene | awk -F, '{ SUM = SUM + $2; COUNT = COUNT + 1 } END { print SUM/COUNT }')
echo -e "\nAverage reading: $avg"