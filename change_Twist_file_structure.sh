#!/bin/bash 
#___________________________________________________
#
#   Bash script to replace GMS paths with RO paths 
#___________________________________________________


result_folder2=$1
result_folder=${result_folder2}/results/dna

new_folder=${result_folder2}_restructured
mkdir $new_folder
mv ${result_folder}/biomarkers_and_fusion* ${new_folder}/.

ls $result_folder > folder.txt

awk -F '\t' '{print $1}' ${result_folder2}/samples.tsv | tail -n +2 > samples.txt

for sample in $(cat samples.txt)
do
    mkdir ${new_folder}/${sample}
    for dir in $(cat folder.txt)
    do
        echo $dir
        if [[ $dir == *"cnv"* ]]; then
            mkdir ${new_folder}/${sample}/${dir}
            cp ${result_folder}/${dir}/${sample}_T/* ${new_folder}/${sample}/${dir}/.

        elif [[ $dir == *"qc"* ]] || [[ $dir == *"vcf"* ]]; then
            mkdir ${new_folder}/${sample}/${dir}
            cp ${result_folder}/${dir}/${sample}* ${new_folder}/${sample}/${dir}/.

        else
            cp ${result_folder}/${dir}/${sample}* ${new_folder}/${sample}/.
        fi
    done
    
done

cp ${result_folder}/qc/multiqc_DNA.html ${new_folder}/.

rm folder.txt
rm samples.txt