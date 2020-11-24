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

echo -e "\nOne of our instruments has generated a series of datafiles, one file per experiment."
echo -e "Here, we'll use bash commands to combine those files into one and process the data.\n"

if [[ ! $1 == "--nocode" ]]; then
    read -p "Let's view the code. Press enter to continue: " key 

    less $0
fi 

read -p "Press enter to continue: " key 

cd $NATUREDIR

echo -e "\nBacking up raw data..."
# read -p "Press enter to continue: " key 
# for each file whose name ends in '.csv', make a backup copy to '<filename>.csv.bak'
for f in *.csv; do
    cp $f $f.bak
    echo -e "Created $f.bak"
done

echo -e "\nExtracting sample numbers..."
# read -p "Press enter to continue: " key 
# 'Pipe' the text of $BKGFILE to the 'cut' command and extract the first column of text (-f1)
# CSV files separate fields using commas. We let cut know that this is a CSV file using the 'delimiter' flag ('-d,')
# copy the resulting text to $SAMPLE_FILE
cat $BKGFILE | cut -f1 -d, > $SAMPLE_FILE
echo -e "Created $SAMPLE_FILE"

echo -e "\nExtracting data columns..."
# read -p "Press enter to continue: " key 
# As above, we use cut to extract the second field from each CSV file and save as <filename>.cut
for f in *.csv; do 
    cat $f | cut -f2 -d, > $f.cut
    echo -e "Created $f.cut"
done

echo -e "\nLinking columns into a CSV..."
# read -p "Press enter to continue: " key 
# The 'paste' command links columns into tables. We use the delimiter flag (-d ',') to indicate we want to produce a CSV.
# Save the table to $CSVFILE
paste -d ',' $SAMPLE_FILE background.csv.cut reading01.csv.cut reading02.csv.cut reading03.csv.cut > $CSVFILE
echo -e "Created $CSVFILE"

echo -e "\nShowing the first 10 rows of $CSVFILE..."
# read -p "Press enter to continue: " key 
# The 'head' command shows the first few lines of a longer file. In this case, the first 11 lines
# 'column' formats the table for viewing. The '-s,' flag indicates we are viewing a CSV file
cat $CSVFILE | head -n 11 | column -tx -s,

echo -e "\nAverage the readings, subtract baseline and convert to abs/sec..." 
read -p "Press enter to continue: " key 

# get the average background reading
# Here we use the 'awk' command to 1) count the number of lines in the file, 2) sum the values in column 2 ($2),
# and 3) calculate the average. We save that number in the variable $bkgd
bkgd=$(cat $BKGFILE | awk -F, '{ SUM+=$2; COUNT+=1; } END { print SUM/COUNT; }' )
echo -e "\nAverage background reading: $bkgd\n"

# Now we run awk multiple times to 1) add a column for the average of columns 3-5; 
# 2) substract the average background calculated above, making a new column; and 
# 3) divide that adjusted reading by 60 to get a per-second number, creating the final column
# Finally, save the new table in a temp file, and then rename that file as $CSVFILE
# Note that this is all a single command, linked by bash 'pipes' (|)
cat $CSVFILE | 
    awk -F, -v OFS="," 'NR==1 { $(NF+1)="average"; print $0; } NR>1 { $(NF+1) = ($3+$4+$5)/3; print $0; }' |
    awk -F, -v OFS="," -v bkgd=$bkgd 'NR==1 { $(NF+1)="corrected"; print $0; } NR>1 { $(NF+1) = $NF - bkgd; print $0; }' | 
    awk -F, -v OFS="," 'NR==1 { $(NF+1)="abs/sec"; print $0; } NR>1 { $(NF+1) = $NF/60; print $0; }' > tmp && mv tmp $CSVFILE

echo -e "Showing first 10 rows of modified $CSVFILE..."
cat $CSVFILE | head -n 11 | column -tx -s,