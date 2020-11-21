#!/bin/bash

NATUREDIR=nature_bash

echo -e "\nOops! We accidentally named some datafiles using a DD-MM-YYYY datestamp."
echo -e "Here, we'll use a for-loop to rename those files to YYYYMMDD format.\n"

read -p "First, we'll view the code. Press enter to continue: " key 

less $0

read -p "Press enter to continue: " key 

# enter $NATUREDIR
cd $NATUREDIR

echo -e "\nRenaming files."
read -p "Press enter to continue: " key 
# for each file whose name matches 'datafile*.txt'...
for file in datafile*.txt; do
    # use the sed (stream editor) command to extract and rearrange the DD, MM and YYYY components
    # save the new name as $newname
    newname=$(echo $file | sed -E 's/([0-9]{2})-([0-9]{2})-([0-9]{4})/\3\2\1/g')
    echo "Renaming $file to $newname."
    # mv ('move') the file to its original name to $newname
    mv $file $newname
done
