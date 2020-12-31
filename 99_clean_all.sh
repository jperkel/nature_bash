#!/bin/bash

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

    echo -e "Deleting files."
    rm *.txt *.csv *.bak *.cut *.gz 

    echo -e "Removing directory $NATUREDIR."
    # move up one directory level in order to delete $NATUREDIR.
    cd ..
    rmdir $NATUREDIR
    echo -e "\nDone!"
else 
    echo -e "No files deleted."
fi 