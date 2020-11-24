#!/bin/bash

# download a dataset from GEO
# from https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE161941
if [ ! -e GEOdataset.csv ]; then
    curl -o GEOdataset.csv.gz https://ftp.ncbi.nlm.nih.gov/geo/series/GSE161nnn/GSE161941/suppl/GSE161941_Processed_File-CBCB.csv.gz

    # use git hash-object to check the file is what we expect.
    # hash should equal: 4efe06f7b8b83269630188bb9c80d2f86548769b
    hash=$(git hash-object GEOdataset.csv.gz)
    if [[ ! $hash == "4efe06f7b8b83269630188bb9c80d2f86548769b" ]]; then
        echo -e "File appears to be corrupt."
        exit 0
    fi 

    # unzip the file
    gunzip -k GEOdataset.csv.gz
fi

# check for a given gene in the dataset
gene=$1
result=$(cat GEOdataset.csv | cut -f1 | sed -E 's/\"//' | grep $gene)

if [ -z $result ]; then
    echo -e "Gene $gene not found."
else
    echo -e "Gene $gene found."
fi

