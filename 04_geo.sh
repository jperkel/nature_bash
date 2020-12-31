#!/bin/bash

NATUREDIR=nature_tmpdir

GEOFILE=GSE161941_Processed_File-CBCB.csv
GEOARCHIVE=GSE161941_Processed_File-CBCB.csv.gz 
URL=https://ftp.ncbi.nlm.nih.gov/geo/series/GSE161nnn/GSE161941/suppl/GSE161941_Processed_File-CBCB.csv.gz
# this is the sha-1 hash produced by `git hash-object`. If you prefer
# md5, use 7b1ff5664cbb27a56c2671eb6efa13c8
HASH="4efe06f7b8b83269630188bb9c80d2f86548769b"


if [ ! -d "$NATUREDIR" ]; then
    echo -e "\nRequired set-up not performed. Run 01_init.sh first."
    exit 0
fi

cd $NATUREDIR

# a gene name must be supplied on the command line
if [ "$#" -eq 0 ]; then
    echo "Error: No gene name supplied. (Try Cactin or Ccn)"
    exit 0
fi
gene=$1

# if you haven't already downloaded the dataset, do so now.
# from https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE161941
if [ ! -e $GEOFILE ]; then
    echo -e "Downloading gene expression dataset from GEO...\n"
    curl -o $GEOARCHIVE $URL 

    # use git hash-object to check the file is what we expect.
    # hash should equal: 4efe06f7b8b83269630188bb9c80d2f86548769b
    hash=$(git hash-object $GEOARCHIVE)
    if [[ ! $hash == $HASH ]]; then
        echo -e "File appears to be corrupt."
        exit 0
    fi 

    # unzip the file
    gunzip -k $GEOARCHIVE
else 
    echo -e "Using cached gene expression data in file $GEOFILE...\n"
fi

# check for a given gene in the dataset
result=$(cat $GEOFILE | cut -f1 | sed -E 's/\"//' | grep $gene)

if [[ -z $result ]]; then
    echo -e "\nGene '$gene' not found."
else
    echo ""
    # print the column heading and all rows that contain 'gene', cols 1-7.
    cat $GEOFILE | sed -E 's/\"//g' | awk -v gene="$gene" '{ if ($1 ~ gene || NR==1) print $0 }' | cut -f1,2,5,7,9 | column -tx
fi

# if you want to find all the genes in the list that have an ENSEMBL id in column 7, try
# cat nature_tmpdir/GSE161941_Processed_File-CBCB.csv | awk '{ if ($7 != "NA") print $0 }' | cut -f1,2,5,7,9 | sed -E 's/\"//'