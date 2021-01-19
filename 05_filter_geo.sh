#!/bin/bash
set -euo pipefail 

NATUREDIR=nature_tmpdir
GEOFILE=GSE161941_Processed_File-CBCB.csv

if [ ! -d "$NATUREDIR" ]; then
    echo -e "\nRequired set-up not performed. Run 01_init.sh first."
    exit 0
fi

cd $NATUREDIR

if [ ! -e "$GEOFILE" ]; then
    echo -e "\n$GEOFILE not found. Run 04_geo.sh first."
    exit 0
fi 

echo -e "\nShowing records with p-value < 0.05 and an ensembl_gene_id value other than NA\n"
cat $GEOFILE | sed -E 's/\"//g' | awk '{ if (NR==1 || ($5 < 0.05 && $7 != "NA")) print $0 }' | cut -f1,2,5,7,9 | column