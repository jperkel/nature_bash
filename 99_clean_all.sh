#!/bin/bash

NATUREDIR=nature_tmpdir

if [ ! -d "$NATUREDIR" ]; then
    echo -e "\nRequired set-up not performed. Run 01_init.sh first."
    exit 0
fi

echo -e "\nThis script deletes the working files and directory we created."

cd $NATUREDIR

echo -e "Deleting files."
rm *.* 

echo -e "Removing directory $NATUREDIR."
# move up one directory level in order to delete $NATUREDIR.
cd ..
rmdir $NATUREDIR
echo -e "\nDone!"