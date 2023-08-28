#!/bin/bash 

pwd > path.txt
results=merged_fastq

sample=$1

ls *.gz > files.txt

mkdir ${results}

for file in $(cat files.txt)
do
	echo ${file%%_*} >> prefix.txt
done

cat prefix.txt | sort | uniq > prefix2.txt
sed 's/Undetermined*//' prefix2.txt > prefix_uniq.txt

for prefix in $(cat prefix_uniq.txt)
do 
	zcat ${prefix}_R1_001.fastq.gz >> ${results}/${sample}_R1_001.fastq
	zcat ${prefix}_R2_001.fastq.gz >> ${results}/${sample}_R2_001.fastq

done


rm prefix*
rm path*
rm files*

