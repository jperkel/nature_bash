#!/bin/bash

function usage() {
    echo -e "\nUsage: $(basename $0) [COMMAND]"
    echo -e "\tCOMMANDS:"
    echo -e "\t  clean_all        -- delete all created files"
#    echo -e "\t  clean_tables     -- delete data tables, backup & temp files"
#    echo -e "\t  clean_txtfiles   -- delete datafile-*.txt"
#    echo -e "\t  create_bad_names -- create badly named datafiles"
#    echo -e "\t  create_gene_data -- create dummy gene dataset"
#    echo -e "\t  create_raw_data  -- create dummy datatables"
    echo -e "\t  gene_analysis    -- find most popular gene"
    echo -e "\t  init             -- prepare all dummy files"
    echo -e "\t  help             -- show this message"
    echo -e "\t  fix_names        -- rename badly named datafiles"
    echo -e "\t  process_data     -- process data tables"
}

# if no command provided, exit.
if [[ "$#" == 0 ]]; then
    echo -e "\nError: no command provided."
    usage
    exit 1
fi

COMMAND=$1

BKGFILE=background.csv
CSVFILE=datatable.csv
GENEFILE=genedata.csv
SAMPLE_FILE=samples.cut

declare -a days=(01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31)
# a list of months with 31 days 
declare -a months=(07 08)
# declare -a samples=("SAMPLE1" "SAMPLE2" "SAMPLE3" "SAMPLE4" "SAMPLE5")

case $COMMAND in
"clean_all")
    echo -e "Deleting all files."
    rm datafile-*.txt $BKGFILE $CSVFILE $GENEFILE $SAMPLE_FILE reading0?.csv *.bak *.csv.cut
    ;;

"clean_tables")
    echo -e "Deleting data tables, backup and temp files."
    rm $BKGFILE $CSVFILE $SAMPLE_FILE reading0*.csv *.bak *.csv.cut
    ;;

"clean_txtfiles")
    echo -e "Deleting datafile-*.txt."
    rm datafile-*.txt
    ;;

"create_bad_names")
    echo -e "\nCreating dummy data files..."
    # create a set of files with nonstandard date stamps
    for month in "${months[@]}"; do
        for day in "${days[@]}"; do 
            fname=datafile-$day-$month-2020.txt
            touch $fname
            echo "File $fname created."
        done
    done
    ;;

"create_gene_data")
    echo -e "\nCreating dummy gene expression data..."
    echo "gene","count" > $GENEFILE
    for i in {1..1000}; do
        echo GENE_$(($RANDOM % 20 + 1)),$(($RANDOM * 10)) >> $GENEFILE
    done 
    ;;

"create_raw_data")
    echo -e "\nCreating database files..."
    echo -e "\nCreating background readings..."
    echo "sample","bkgd" > $BKGFILE
    for i in {1..50}; do            
        echo $i,$(($RANDOM / 100)) >> $BKGFILE
    done

    echo -e "\nCreating data readings..."
    for i in 01 02 03; do
        fname=reading$i.csv
        echo "sample","abs$i" > $fname 
        for j in {1..50}; do
            echo $j,$RANDOM >> $fname
        done
        echo "File $fname created."
    done

    # echo "sample_no,sample,background,abs1,abs2,abs3" > $CSVFILE
    # for i in {1..50}; do
    #     echo $i,"${samples[$(($RANDOM % 5))]}",$(($RANDOM / 100)),$RANDOM,$RANDOM,$RANDOM >> $CSVFILE
    # done
    ;;

"fix_names")
    echo -e "\nRenaming files."
    for file in datafile*.txt; do
        newname=$(echo $file | sed -E 's/([0-9]{2})-([0-9]{2})-([0-9]{4})/\3\2\1/g')
        echo "Renaming $file to $newname."
        mv $file $newname
    done
    ;;

"gene_analysis")
    # h/t Tom Ryder, https://sanctum.geek.nz/bash-quick-start-questionnaire.html
    echo -e "\nFinding most common genes..."
    cat $GENEFILE | cut -f1 -d, | sort | uniq -c | sort -k1,1nr | head
    gene=$(cat $GENEFILE | cut -f1 -d, | sort | uniq -c | sort -k1,1nr | head -n1 | sed -e "s/^[[:space:]]*//" | cut -f2 -d' ')
    count=$(cat $GENEFILE | cut -f1 -d, | sort | uniq -c | sort -k1,1nr | head -n1 | sed -e "s/^[[:space:]]*//" | cut -f1 -d' ')
    echo -e "\nShowing 10 of $count readings for $gene..."
    cat $GENEFILE | grep $gene | head -n10
    avg=$(cat $GENEFILE | grep $gene | awk -F, '{ SUM = SUM + $2; COUNT = COUNT + 1 } END { print SUM/COUNT }')
    echo -e "\nAverage reading: $avg"
    ;;

"help")
    usage
    ;;

"init")
    $0 create_bad_names
    $0 create_gene_data
    $0 create_raw_data
    ;;

"process_data")
    echo -e "\nBacking up raw data..."
    for f in *.csv; do
        cp $f $f.bak
        echo -e "Created $f.bak"
    done

    echo -e "\nExtracting sample numbers..."
    cat $BKGFILE | cut -f1 -d, > $SAMPLE_FILE
    echo -e "Created $SAMPLE_FILE"

    echo -e "\nExtracting data columns..."
    for f in *.csv; do 
        cat $f | cut -f2 -d, > $f.cut
        echo -e "Created $f.cut"
    done

    echo -e "\nLinking columns into a CSV..."
    paste -d ',' $SAMPLE_FILE background.csv.cut reading01.csv.cut reading02.csv.cut reading03.csv.cut > $CSVFILE
    echo -e "Created $CSVFILE"

    echo -e "\nShowing the first 10 rows of $CSVFILE..."
    cat $CSVFILE | head -n 11 | column -tx -s,

    echo -e "\nAverage the readings, subtract baseline and convert to abs/sec..." 

    # get the average background reading
    bkgd=$(cat $BKGFILE | awk -F, '{ SUM+=$2; COUNT+=1; } END { print SUM/COUNT; }' )
    echo -e "Average background reading: $bkgd\n"

    cat $CSVFILE | 
        awk -F, -v OFS="," 'NR==1 { $(NF+1)="average"; print $0; } NR>1 { $(NF+1) = ($3+$4+$5)/3; print $0; }' |
        awk -F, -v OFS="," -v bkgd=$bkgd 'NR==1 { $(NF+1)="corrected"; print $0; } NR>1 { $(NF+1) = $NF - bkgd; print $0; }' | 
        awk -F, -v OFS="," 'NR==1 { $(NF+1)="abs/sec"; print $0; } NR>1 { $(NF+1) = $NF/60; print $0; }' > tmp && mv tmp $CSVFILE

    echo -e "Showing first 10 rows of modified $CSVFILE..."
    cat $CSVFILE | head -n 11 | column -tx -s,

    # for sample in "${samples[@]}"; do
    #     echo -e "Creating output file: $sample.out..."
    #     cat $CSVFILE | awk -F, -v sample="$sample" 'NR==1 || $2==sample { print $0; }' > $sample.out        
    # done 

    # echo -e "\nOutput file for SAMPLE2:"
    # cat SAMPLE2.out | column -tx -s,    

    ;;

*)
   echo "Error: Command '$COMMAND' not recognized."
   ;;
esac
