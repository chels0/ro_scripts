#!/bin/bash 

run_program=$1

while getopts "i:o:hv" flag
do
    case $flag in
        i) input="$OPTARG" ;;
        o) out="$OPTARG";;
        h) echo "blanbla help";;
        v) echo version 1
    esac
done

echo ${input}
echo $run_program