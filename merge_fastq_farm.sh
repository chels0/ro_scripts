#!/bin/bash 


results=merged_fastq_files_correct

path=/home/lauri/Documents/farm/2211

cd 221107

ls *.gz > ../files.txt

cd ..
sed 's/_S.*//' files.txt > prefix.txt
mkdir ${results}

cat prefix.txt | sort | uniq > prefix2.txt
sed 's/Undetermined*//' prefix2.txt > prefix_uniq.txt

for prefix in $(cat prefix_uniq.txt)
do 
	zcat ${path}07/${prefix}_*_R1_001.fastq.gz > ${results}/${prefix}_R1_001.fastq
	zcat ${path}13/${prefix}_*_R1_001.fastq.gz >> ${results}/${prefix}_R1_001.fastq
	zcat ${path}07/${prefix}_*_R2_001.fastq.gz > ${results}/${prefix}_R2_001.fastq
	zcat ${path}13/${prefix}_*_R2_001.fastq.gz >> ${results}/${prefix}_R2_001.fastq
done

rm prefix*
rm path*
rm files*

