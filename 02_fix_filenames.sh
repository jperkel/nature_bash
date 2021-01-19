#!/bin/bash
set -euo pipefail 

NATUREDIR=nature_tmpdir

# test that the $NATUREDIR directory exists.
if [ ! -d "$NATUREDIR" ]; then
    echo -e "\nRequired set-up not performed. Run 01_init.sh first."
    exit 0
fi

# change to our working directory, $NATUREDIR
cd $NATUREDIR

# for each file in the directory whose name begins with 'datafile' and ends with '.txt'...
for file in datafile*.txt; do
    # use the sed (stream editor) command to extract and rearrange the DD, MM and YYYY components
    # the old files are formatted DD-MM-YYYY. So we capture each element and reorder them: \3\2\1
    newname=$(echo $file | sed -E 's/([0-9]{2})-([0-9]{2})-([0-9]{4})/\3\2\1/g')
    echo "Renaming $file to $newname."
    # mv ('move') the file from its original name to $newname
    mv $file $newname
done
