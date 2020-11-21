#!/bin/bash

echo -e "\nThis script uses a for loop to run all the files in our exercise one by one."
echo -e "This way, we can add another file to the exercise, and it will still run in order."
echo -e "\nLet's check out the code, using the bash command 'less'."
echo -e "With 'less', you scroll using the arrow keys, spacebar, or enter. Use 'q' to quit the program.\n"

read -p "Press enter to continue: " key 

less $0

read -p "Press enter to continue: " key 

for f in $(ls [0-9]*.sh | sort); do 
    echo -e "\n\nRunning script $f..."
    read -p "Press enter to continue or 'x' to exit: " key 
    if [ "$key" == "x" ]; then
        exit 0
    fi 
    ./$f 
done
