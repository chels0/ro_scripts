#!/bin/bash 

pwd > path.txt
path='/data/bcl2fastq/input/221107_M00668_0596_000000000-DHRGR/Data/Intensities/BaseCalls'
here=$(cat path.txt)
cd ${path}
results=merged_fastq_files

mkdir ${results}

ls *.gz > ${here}/files.txt

cd ${here}
mkdir ${results}

for file in $(cat files.txt)
do
	echo ${file%%_*} >> prefix.txt
done

cat prefix.txt | sort | uniq > prefix2.txt
sed 's/Undetermined*//' prefix2.txt > prefix_uniq.txt

for prefix in $(cat prefix_uniq.txt)
do 
	zcat ${path}/${prefix}_*_R1_001.fastq.gz > ${results}/${prefix}_R1_001.fastq
	gzip ${results}/${prefix}_R1_001.fastq
	rm ${results}/${prefix}_R1_001.fastq
	zcat ${path}/${prefix}_*_R2_001.fastq.gz > ${results}/${prefix}_R2_001.fastq
	gzip ${results}/${prefix}_R2_001.fastq
	rm ${results}/${prefix}_R1_001.fastq
done

rm prefix*
rm path*
rm files*

