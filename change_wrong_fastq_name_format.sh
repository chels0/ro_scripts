#!/bin/bash 
#___________________________________________________
#
#   Bash script to run several Twist Solid runs sequentially
#___________________________________________________

input_dir='/data/Twist_Solid/DNA/input/automate/'
#input_dir='/data/bcl2fastq/results/BC/test/'
#for dir in $(ls $input_dir)
#do
#    for file in $(ls $input_dir${dir})
#    do
#        unlink $input_dir${dir}/$file
#    done
#done

count=0
for dir in $(ls $input_dir)
do
    count=$[count+1]
    #if [ $count -eq 5 ]; 
    #then
    #    break 1
    #else
    for i in {1..2}
    do
        echo $dir
        for file in $(ls $input_dir${dir})
        do
            echo ${input_dir}${dir}/${file}
            cd ${input_dir}${dir}
            rename s/_/-/ ${file}
        done
    done
    #fi
done






