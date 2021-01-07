# NATURE-BASH

These scripts were written to accompany a *Nature* Toolbox article on what researchers can do at the command line. 

To try them out: 

1. Clone this GitHub repository. From the command line, execute `git clone https://github.com/jperkel/nature_bash.git`. 
2. Enter the newly created directory: `cd nature_bash`.
3. Make the scripts executable: `chmod +x *.sh`. 
4. Run the scripts in numeric order, being sure to prepend each file name with a period and slash (`./`) -- this tells the shell where to find these scripts when the current directory is not part of your existing file search `PATH` variable. 
5. There are five scripts in total:
- `./01_init.sh`: Creates a temporary directory (`nature_tmpdir`) and fills it with dummy files
- `./02_fix_filenames.sh`: In `01_init.sh` we created 217 files with date-stamped names using the pattern: DD-MM-YYYY, e.g., datafile-01-01-2020.txt, datafile-02-01-2020.txt, etc. This script uses the `sed` command a for-loop to rename them using the standard YYYYMMDD pattern. 
- `./03_process_data.sh`: In `01_init.sh` we created a four dummy data files, such as might be output from a spectrophotometer (3 files of "readings" and 1 "background" file). This script pulls those data into a single data file, averages the readings, subtracts the background, and divides by 60 to give a per-second value. The result is a spreadsheet, which is displayed on screen.
- `./04_geo.sh`: This script downloads a compressed gene expression datafile from the NCBI Gene Expression Omnibus database, extracts it, and searches for a gene name given on the command line. Try: `./04_geo.sh Cactin`. 
- `./05_filter_geo.sh`: This script uses `sed` and `awk` to filter the GEO datafile from `04_geo.sh` for records with a p-value < 0.05 and an ensembl_gene_id value other than NA.
- `./99_clean_sh.sh`: Deletes all temporary files. 
