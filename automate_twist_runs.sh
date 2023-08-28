#!/bin/bash 
#___________________________________________________
#
#   Bash script to run several Twist Solid runs sequentially
#___________________________________________________

input_dir='/data/Twist_Solid/DNA/input/automate/'

#cd /home/lauri/Desktop/Twist_Solid-0.4.0

for dir in $(ls $input_dir)
do
    today=$(date +%F)
    sed -i "s/RESULTS_DIR =.*/RESULTS_DIR = ${today}_${dir}/" Makefile 
    sed -i "s:FASTQ_INPUT_DIR =.*:FASTQ_INPUT_DIR = ${input_dir}${dir}:" Makefile
    make create_inputs
    echo ${input_dir}${dir}
    python /home/lauri/Documents/chelsea_test/scripts/automate_samplesheet.py ${input_dir}${dir}
    make
    bash /home/lauri/Documents/chelsea_test/scripts/change_Twist_file_structure.sh ${today}_${dir}
done

