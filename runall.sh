#!/bin/bash

# define some variables that we'll need throughout these exercises
export BKGFILE=background.csv
export CSVFILE=datatable.csv
export GENEFILE=genedata.csv
export SAMPLE_FILE=samples.cut
export NATUREDIR=nature_tmpdir

echo -e "\nThis script uses a for loop to run all the files in our exercise one by one."
echo -e "This way, we can add another file to the exercise, and it will still run in order."

# if invoked with '--nocode' on the command line, these scripts will skip this step
if [[ ! $1 == "--nocode" ]]; then
    echo -e "\nLet's check out the code, using the bash command 'less'."
    echo -e "With 'less', you scroll using the arrow keys, spacebar, or enter. Use 'q' to quit the program.\n"

    read -p "Press enter to continue: " key 

    less $0
fi

    read -p "Press enter to continue: " key 

# iterate over files whose name matches '[number][any_character]_*.sh' 
# Because the directory command, ls, returns an alphabetized list, this is equivalent to
# ie 01_init.sh 02_fix_filenames.sh 03_process_data.sh ...
for f in $(ls [0-9]?_*.sh); do
    echo -e "\n\nRunning script $f..."
    read -p "Press enter to continue or 'x' to exit: " key 
    if [ "$key" == "x" ]; then
        exit 0
    fi 
    # and run the script. If --nocode was specified on the command line, pass that argument to each script
    ./$f $1
done
