#!/bin/bash

BKGFILE=background.csv
CSVFILE=datatable.csv
NATUREDIR=nature_bash
SAMPLE_FILE=samples.cut

echo -e "\nOne of our instruments has generated a series of datafiles, one file per experiment."
echo -e "Here, we'll use bash commands to combine those files into one and process the data.\n"

read -p "Let's view the code. Press enter to continue: " key 

less $0

read -p "Press enter to continue: " key 

cd $NATUREDIR

echo -e "\nBacking up raw data..."
read -p "Press enter to continue: " key 
for f in *.csv; do
    cp $f $f.bak
    echo -e "Created $f.bak"
done

echo -e "\nExtracting sample numbers..."
read -p "Press enter to continue: " key 
cat $BKGFILE | cut -f1 -d, > $SAMPLE_FILE
echo -e "Created $SAMPLE_FILE"

echo -e "\nExtracting data columns..."
read -p "Press enter to continue: " key 
for f in *.csv; do 
    cat $f | cut -f2 -d, > $f.cut
    echo -e "Created $f.cut"
done

echo -e "\nLinking columns into a CSV..."
read -p "Press enter to continue: " key 
paste -d ',' $SAMPLE_FILE background.csv.cut reading01.csv.cut reading02.csv.cut reading03.csv.cut > $CSVFILE
echo -e "Created $CSVFILE"

echo -e "\nShowing the first 10 rows of $CSVFILE..."
read -p "Press enter to continue: " key 
cat $CSVFILE | head -n 11 | column -tx -s,

echo -e "\nAverage the readings, subtract baseline and convert to abs/sec..." 
read -p "Press enter to continue: " key 

# get the average background reading
bkgd=$(cat $BKGFILE | awk -F, '{ SUM+=$2; COUNT+=1; } END { print SUM/COUNT; }' )
echo -e "Average background reading: $bkgd\n"

cat $CSVFILE | 
    awk -F, -v OFS="," 'NR==1 { $(NF+1)="average"; print $0; } NR>1 { $(NF+1) = ($3+$4+$5)/3; print $0; }' |
    awk -F, -v OFS="," -v bkgd=$bkgd 'NR==1 { $(NF+1)="corrected"; print $0; } NR>1 { $(NF+1) = $NF - bkgd; print $0; }' | 
    awk -F, -v OFS="," 'NR==1 { $(NF+1)="abs/sec"; print $0; } NR>1 { $(NF+1) = $NF/60; print $0; }' > tmp && mv tmp $CSVFILE

echo -e "Showing first 10 rows of modified $CSVFILE..."
cat $CSVFILE | head -n 11 | column -tx -s,