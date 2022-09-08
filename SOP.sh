# 1. Access the FulQuant-Cloned Github
# Clone the folder onto local or remore computer

cd ~
FulQuant_URL="https://github.com/SJayYang/FulQuant-cloned"
git clone ${FulQuant_URL}
mv FulQuant-Cloned FulQuant
cd FulQuant

# 2. Setup conda environment 
# Using environment.yml file, recreate the conda environment
# This can be recreated on any Google cloud instance 

conda env create -f environment.yml
conda activate fulquant_dev_4

R
# in R, run
# if (!require("BiocManager", quietly = TRUE))
#     install.packages("BiocManager")
# BiocManager::install(version = "3.8")
# Sys.setenv(TAR = "/bin/tar")
# remotes::install_github('Czhu/R_nanopore')

# 3. Setup input environment
# All the files must be placed in this format. 
# a. All files must be in fastq.gz format. 
# b. All files must be in the path: folder/fastq/demultiplexed

current_folder_name=""
mkdir -p ${current_folder_name}/fastq/demultiplexed
mv ${current_folder_name}/*.fastq.gz ${current_folder_name}/fastq/demultiplexed


# 4. Start running scripts. 
# The run_scripts.sh file contains all of the scripts run in sequential order 
# You can run all the scripts at once, just need to change the input folder to current_folder_name. (can also change so that it just takes input from command line)

bash run_scripts.sh

