#!/bin/bash

function usage() {
    echo -e "\nUsage: $(basename $0) [COMMAND]"
    echo -e "\tCOMMANDS:"
    echo -e "\t  clean   -- delete dummy datafiles"
    echo -e "\t  create  -- create dummy datafiles"
    echo -e "\t  process -- process data table"
    echo -e "\t  rename  -- rename dummy datafiles"
}

# if no command provided, exit.
if [[ ! "$#" == 1 ]]; then
    echo -e "\nError: no command provided."
    usage
    exit 1
fi

COMMAND=$1
CSVFILE=datatable.csv

# a list of months with 31 days 
declare -a days=(01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31)
declare -a months=(01 03 05 07 08 10 12)
declare -a samples=("SAMPLE1" "SAMPLE2" "SAMPLE3" "SAMPLE4" "SAMPLE5")

case $COMMAND in
"clean")
    echo -e "\nDeleting dummy datafiles."
    rm datafile-*.txt $CSVFILE $CSVFILE.bak
    ;;

"create")
    echo -e "\nCreating dummy data files..."
    # create a set of files with nonstandard date stamps
    for month in "${months[@]}"; do
        for day in "${days[@]}"; do 
            fname=datafile-$day-$month-2020.txt
            touch $fname
            echo "File $fname created."
        done
    done

    echo "sample_no,sample,background,abs1,abs2,abs3" > $CSVFILE
    for i in {1..50}; do
        echo $i,"${samples[$(($RANDOM % 5))]}",$(($RANDOM / 100)),$RANDOM,$RANDOM,$RANDOM >> $CSVFILE
    done
    echo "File $CSVFILE created."
    ;;

"help")
    usage
    ;;

"process")
    echo -e "\nBacking up raw data."
    cp $CSVFILE $CSVFILE.bak

    echo -e "\nInitial data table (first 10 of 50 rows)"
    cat $CSVFILE | head -n 11 | column -tx -s,

    # echo -e "\nAverage 3 readings (first 10 of 50 rows)"
    # cat $CSVFILE | awk -F, -v OFS="," 'NR==1 { $(NF+1)="average"; print $0; } \
    #     NR>1 { $(NF+1) = ($3+$4+$5)/3; print $0; }' > tmp && mv tmp $CSVFILE
    # cat $CSVFILE | head -n 11 | column -tx -s,

    # echo -e "\nSubtract background"
    # cat $CSVFILE | 
    #     awk -F, -v OFS="," 'NR==1 { $(NF+1)="corrected"; print $0; } \
    #     NR>1 { $(NF+1) = $NF - $2; print $0; }' > tmp && mv tmp $CSVFILE
    # cat $CSVFILE | head -n 11 | column -tx -s,

    # echo -e "\nConvert to per second"
    # cat $CSVFILE | awk -F, -v OFS="," 'NR==1 { $(NF+1)="abs/sec"; print $0; } \
    #     NR>1 { $(NF+1) = $NF/60; print $0; }' > tmp && mv tmp $CSVFILE
    # cat $CSVFILE | head -n 11 | column -tx -s,

    echo -e "\nAverage the 3 readings, subtract baseline, convert to abs per sec," 
    echo -e "(Showing 10 of 50 rows)"
    cat $CSVFILE | 
        awk -F, -v OFS="," 'NR==1 { $(NF+1)="average"; print $0; } NR>1 { $(NF+1) = ($4+$5+$6)/3; print $0; }' |
        awk -F, -v OFS="," 'NR==1 { $(NF+1)="corrected"; print $0; } NR>1 { $(NF+1) = $NF - $3; print $0; }' | 
        awk -F, -v OFS="," 'NR==1 { $(NF+1)="abs/sec"; print $0; } NR>1 { $(NF+1) = $NF/60; print $0; }' > tmp && mv tmp $CSVFILE
    cat $CSVFILE | head -n 11 | column -tx -s,

    for sample in "${samples[@]}"; do
        echo -e "Creating output file: $sample.out..."
        cat $CSVFILE | awk -F, -v sample="$sample" 'NR==1 || $2==sample { print $0; }' > $sample.out        
    done 

    echo -e "\nOutput file for SAMPLE2:"
    cat SAMPLE2.out | column -tx -s,    

    ;;

"rename")
    echo -e "\nRenaming files."
    for file in datafile*.txt; do
        newname=$(echo $file | sed -E 's/([0-9]{2})-([0-9]{2})-([0-9]{4})/\3\2\1/g')
        echo "Renaming $file to $newname."
        mv $file $newname
    done
    ;;

*)
   echo "Error: Command '$COMMAND' not recognized."
   ;;
esac
