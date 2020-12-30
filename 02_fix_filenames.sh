#!/bin/bash

NATUREDIR=nature_tmpdir

if [ ! -d "$NATUREDIR" ]; then
    echo -e "\nRequired set-up not performed. Run 01_init.sh first."
    exit 0
fi

echo -e "\nOops! We accidentally named some datafiles using the date-stamped format datafile-DD-MM-YYYY."
echo -e "We'll use a for-loop and the 'sed' command to rename those files to YYYYMMDD format.\n"

# change to our working directory, $NATUREDIR
cd $NATUREDIR

# echo -e "\nRenaming files."
# read -p "Press enter to continue: " key 
# for each file whose name matches 'datafile*.txt'...
for file in datafile*.txt; do
    # use the sed (stream editor) command to extract and rearrange the DD, MM and YYYY components
    # save the new name as $newname
    newname=$(echo $file | sed -E 's/([0-9]{2})-([0-9]{2})-([0-9]{4})/\3\2\1/g')
    echo "Renaming $file to $newname."
    # mv ('move') the file from its original name to $newname
    mv $file $newname
done
