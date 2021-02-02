#!/bin/bash
set -euo pipefail 

NATUREDIR=nature_tmpdir

if [ ! -d "$NATUREDIR" ]; then
    echo -e "\nRequired set-up not performed. Run 01_init.sh first."
    exit 0
fi

# make sure user wants to delete files 
read -p "This operation will delete all files in $NATUREDIR. Continue? [n]: " answer 
if [[ "$answer" == "" ]]; then
    answer="n"
fi

if [[ "$answer" == "y" || "$answer" == "Y" ]]; then 
    cd $NATUREDIR

    # we could make this simpler, but this construction allows the
    # script to complete even if some files are missing, eg if one
    # earlier script was not executed. 
    echo -e "Deleting files."
    for file in *.txt *.csv *.bak *.cut *.gz; do 
        if [[ -f $file ]]; then 
            rm $file 
        fi
    done  

    echo -e "Removing directory $NATUREDIR."
    # move up one directory level in order to delete $NATUREDIR.
    cd ..
    rmdir $NATUREDIR
    echo -e "\nDone!"
else 
    echo -e "No files deleted."
fi 