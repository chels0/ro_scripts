#!/bin/bash 

ls /data/Twist_Solid/DNA/bed/pool* > bed_files.txt

for file in $(cat bed_files.txt)
do
	awk '{print $4}' ${file} | sed 's/_.*//' | sort | uniq > test.txt
	word_count=$(wc -l test.txt)	
	echo ${file}	${word_count}
done

	
