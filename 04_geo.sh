#!/bin/bash

NATUREDIR=nature_tmpdir
GEOFILE=GEOdataset.csv
GEOARCHIVE=$GEOFILE".gz"
URL=https://ftp.ncbi.nlm.nih.gov/geo/series/GSE161nnn/GSE161941/suppl/GSE161941_Processed_File-CBCB.csv.gz
HASH="4efe06f7b8b83269630188bb9c80d2f86548769b"


if [ ! -d "$NATUREDIR" ]; then
    echo -e "\nRequired set-up not performed. Run 01_init.sh first."
    exit 0
fi

echo -e "\nThis script downloads a dataset from the NCBI Gene Expression Omnibus and"
echo -e "checks for the presence of a gene name given on the command line.\n"


cd $NATUREDIR

# a gene name must be supplied on the command line
if [ "$#" -eq 0 ]; then
    echo "Error: No gene name supplied."
    exit 0
fi
gene=$1

# download a dataset from GEO
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
    echo -e "Gene '$gene' not found."
else
    # print the column heading and all rows that contain 'gene', cols 1-7.
    cat $GEOFILE | sed -E 's/\"//g' | awk -v gene="$gene" '{ if ($1 ~ gene || NR==1) print $0 }' | cut -f1-7
fi