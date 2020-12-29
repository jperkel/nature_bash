#!/bin/bash

filename=GEOdataset.csv
archive=$filename".gz"
url=https://ftp.ncbi.nlm.nih.gov/geo/series/GSE161nnn/GSE161941/suppl/GSE161941_Processed_File-CBCB.csv.gz

# a gene name must be supplied on the command line
if [ "$#" -eq 0 ]; then
    echo "Error: No gene name supplied."
    exit 0
fi
gene=$1

# download a dataset from GEO
# from https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE161941
if [ ! -e $filename ]; then
    echo "Downloading gene expression dataset from GEO..."
    curl -o $archive $url 
#    curl -o GEOdataset.csv.gz https://ftp.ncbi.nlm.nih.gov/geo/series/GSE161nnn/GSE161941/suppl/GSE161941_Processed_File-CBCB.csv.gz

    # use git hash-object to check the file is what we expect.
    # hash should equal: 4efe06f7b8b83269630188bb9c80d2f86548769b
    hash=$(git hash-object $archive)
    if [[ ! $hash == "4efe06f7b8b83269630188bb9c80d2f86548769b" ]]; then
        echo -e "File appears to be corrupt."
        exit 0
    fi 

    # unzip the file
    gunzip -k $archive
else 
    echo -e "Using cached gene expression data in file $filename...\n"
fi

# check for a given gene in the dataset
result=$(cat $filename | cut -f1 | sed -E 's/\"//' | grep $gene)

if [[ -z $result ]]; then
    echo -e "Gene '$gene' not found."
else
    # print the column heading and all rows that contain 'gene', cols 1-7.
    cat $filename | sed -E 's/\"//g' | awk -v gene="$gene" '{ if ($1 ~ gene || NR==1) print $0 }' | cut -f1-7
fi