#!/bin/bash 
#___________________________________________________
#
#   Bash script to run several Twist Solid runs sequentially
#___________________________________________________

#input_dir='/data/bcl2fastq/results/BC/test/'
#for dir in $(ls $input_dir)
#do
#    for file in $(ls $input_dir${dir})
#    do
#        unlink $input_dir${dir}/$file
#    done
#done

for i in {1..2}
do
    echo $dir
    for file in $(ls)
    do
        rename s/_/-/ ${file}
    done
done




