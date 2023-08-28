#!/bin/bash 

run_program=$1


while getopts "i:o:hv" flag
do
    case $flag in
        i) input="$OPTARG" ;;
        o) out="$OPTARG";;
        h) echo "blanbla help";;
        v) echo version 1;;
    esac
done

source /home/lauri/miniconda3/etc/profile.d/conda.sh
conda activate 20221115_dev_Twist_Solid
twist_path=/home/lauri/Desktop/Twist_Solid-0.6.1
path=/home/lauri/Desktop/bcl2fastq
bcl2fastq_sif=/data/sifs/bcl2fastq/bcl2fastq-2_20_0_422.sif
scripts_path=/home/lauri/Documents/chelsea_test/scripts


main_smk=workflow/Snakefile
report=report.html

args=""
threads=92

date=$(date)
date2=$(date +%F)

echo input is: ${input}


if [ -z ${run_program} ]; then
    ask=`zenity --list --title="Run bcl2fastq+Twist_Solid or just TWist_Solid? " --column="0" "Bcl2fastq+Twist_Solid" "Twist_Solid" --width=100 --height=300 --hide-header`
elif [ ${run_program} == "bcl2fastq" ];
then
    ask="Bcl2fastq+Twist_Solid"
elif [ ${run_program} == "twist_solid" ]; 
then
    ask="Twist_Solid"
else
    echo "wrong params"
fi

if [ ${ask} == "Bcl2fastq+Twist_Solid" ];
then
    cd ${path}
    if ls -d */ ;
    then
        dir=$(ls -d */)
        count=$(ls -d */ | wc -l)
    else
        echo "No run directory found in bcl2fastq directory. Please put run folder in path: /home/lauri/Desktop/bcl2fastq"
        exit 1
    fi

    if [ ${count} -gt 1 ];
    then
        echo "ERROR: Multiple folders in bc2lfastq directory. Remove any existing folders"
        exit 1
    else
        echo "its runtime"
    fi


    if [ ! -f ${path}/${dir}SampleSheet.csv  ]; 
    then
        echo "No samplesheet in folder, check folder contents"
        exit 1
    fi
    
    experiment_name=$(awk -F ',' 'FNR==4 { print $2 }' ${path}/${dir}/SampleSheet.csv)
    
    if grep -q "DNA" ${path}/${dir}/SampleSheet.csv
    then
        sample_dir=DNA
        sample_type=T
    elif grep -q "RNA" ${path}/${dir}/SampleSheet.csv
    then
        sample_dir=RNA
        sample_type=R
    else
        echo "something is strange"
        exit 1
    fi

    echo teste ${experiment_name}

    singularity exec ${bcl2fastq_sif} bcl2fastq \
        --runfolder-dir ${path}/${dir} \
        --processing-threads ${threads} \
        --no-lane-splitting ${args}

    echo "Run started: ${date}" > run.log
    (singularity exec ${bcl2fastq_sif} bcl2fastq \
        --runfolder-dir ${path}/${dir} \
        --processing-threads ${threads} \
        --no-lane-splitting ${args}) &>> run.log
        echo "Run ended: ${date}" >> run.log
    
    mkdir /data/Twist_Solid/${sample_dir}/input/${date2}_${experiment_name}
    cp ${path}/${dir}/Data/Intensities/BaseCalls/*.fastq.gz /data/Twist_Solid/${sample_dir}/input/${date2}_${experiment_name}
    cp ${path}/${dir}SampleSheet.csv /data/Twist_Solid/${sample_dir}/input/${date2}_${experiment_name}
    rm /data/Twist_Solid/${sample_dir}/input/${date2}_${experiment_name}/Undetermined*
    #rm -r ${path}/${dir}
    fastq_input_dir=/data/Twist_Solid/${sample_dir}/input/${date2}_${experiment_name}
    

    cd ${twist_path}

    hydra-genetics create-input-files \
	-d ${fastq_input_dir} \
	--force \
	--sample-type ${sample_type}

    python ${scripts_path}/automate_samplesheet.py ${fastq_input_dir}


else
    if [ -z ${input} ];
    then
        dir=$(zenity  --file-selection --title="Choose a directory" --directory)
    else 
        dir=${input}
    fi
    echo ${dir}

    if [[ ${dir} == *"DNA"* ]];
    then
        sample_type=T
    fi

    if [[ ${dir} == *"RNA"* ]];
    then
        sample_type=R
    fi

    echo th sample is ${sample_type}

    #if [ ! -f ${dir}/SampleSheet.csv ] && [ -f samples.tsv ];
    #then
        #echo Wha
        #rows=$(awk -F '\t' ' { print $2 } ' /data/Twist_Solid/DNA/input/230531_test/tumor_content.tsv | awk 'NF > 0' | wc -l)
        #echo ${rows}
        #if [[ rows -le 1 ]];
        #then
        #    echo "tumor content has not been inputted into file tumor_content.tsv. Please input tumor content values under 'Description' and try agian"
        #    exit 1
        #fi
    #fi

    echo fastq_sample_dir is ${fastq_sample_dir}

    if [ ! -f ${dir}/SampleSheet.csv ] && [ ! -f samples.tsv ];
    then
        hydra-genetics create-input-files \
        -d ${dir} \
        --force \
        --sample-type ${sample_type}

        echo "No samplesheet in fastq input directory. Please fill in samples.tsv in this directory and rerun the same command as before"
        
        #number_of_lines=$(tail -n 2 samples.tsv | awk -F '\t' ' { print $2 } ' | wc -l)
        #total=$(tail -n 2 samples.tsv | awk -F '\t' ' { print $2 } ' | awk '{s+=$1} END {print s}')
        #average_tc=$(${total}/${number_of_lines})

        
        #echo "No samplesheet for these fasta files detected. Tumor content cannot be found. Please manually input tumor content into file 'tumor_content.tsv' and rerun"
        #cd ${dir}
        #echo -e "sample\ttumor_content" > ${dir}/tumor_content.tsv
        #ls *_R1* | sed 's/_.*//' >> ${dir}/tumor_content.tsv
        exit 1
    fi

    if [ -f ${dir}/SampleSheet.csv ];
    then
        if grep -q "DNA" ${dir}/SampleSheet.csv
        then
            sample_type=T
        elif grep -q "RNA" ${dir}/SampleSheet.csv
        then
            sample_type=R
        else
            echo "something is strange"
            exit 1
        fi
    fi

    echo "the sample type is:" ${sample_type}
    fastq_input_dir=${dir}
fi

storage=$(df -h | awk 'FNR == 2 {print $4}' | sed 's/G//')

storage=$(df -h | awk 'FNR == 2 {print $4}' | sed 's/G//')
nr_of_files=$(ls -l ${fastq_input_dir} | awk -v nr="$(ls | wc -l)" '{ s+=$5 } END { print s/(nr*10000) } ' | sed 's/,/./')
is_rna=$(echo "${nr_of_files}/1" | bc)

echo ${storage}

if [ ${is_rna} -le 2 ] && [ ${sample_type} == 'T' ];
then
	printf '\033[0;31mYou have inputted that this is DNA but fastq file size indicate RNA. Continue anyway? (y/n)\033[0m\n'
	read -t 10 answer1
	if [ "${answer1}" != "${answer1#[Nn]}" ];
	then
		exit 1
	fi
fi

	if [ ${is_rna} -gt 2 ] && [ ${sample_type} == 'R' ];
	then
        printf '\033[0;31mYou have inputted that this is RNA but fastq file size indicate DNA. Continue anyway? Press Enter to continue or Ctrl+C to cancel\033[0m\n'
        read -t 10 answer1
	if [ "${answer1}" != "${answer1#[Nn]}" ];
	then
		exit 1
	fi
fi

if [ ${storage} -lt 250 ];
then
	printf '\033[0;31mStorage is less than 250GB, pipeline might fail if more than three samples are running. Continue anyway? Press Enter to continue or Ctrl+C to cancel\033[0m\n'
	read -t 10 answer1
	if [ "${answer1}" != "${answer1#[Nn]}" ];
	then
        exit 1
	fi
fi

printf '\033[34;1mIs the follwing samplesheet correct? Press Enter if correct Ctrl+C to cancel\033[0m \n'
cat samples.tsv

read -t 10 answer
if [ "${answer}" != "${answer#[Yy]}" ];
then
    echo Running pipeline
    snakemake --cores ${cpus} \
    --use-singularity \
    --singularity-args "--cleanenv --bind /data/Twist_Solid/ --bind /data/reference_genomes/" \
    -s ${main_smk} \
    --configfile config/config.yaml \
    ${args}

	snakemake \
	--cores ${cpus} \
	--report ${report} \
	-s ${main_smk} \
	--configfile config/config.yaml

    if [ -z ${output}];
    then
        results_dir=${output}
    else
        results_dir=${date2}_${experiment_namespace}_Twist_Solid-0.6.1_results
    fi

    mkdir -p ${results_dir}
    
    mv fusions \
    prealignment \
    alignment \
    qc \
    snv_indels \
    genefuse.json \
    annotation \
    bam_dna \
    bam_rna \
    biomarker \
    cnv_sv \
    gvcf_dna \
    results \
    samples.tsv \
    units.tsv \
    logs ${results_dir}/

    cp git_commit_number.txt Makefile env.yml config/config.yaml ${results_dir}

else
    exit 1

fi

conda deactivate


    #overrides, välja själv output namn, att man kan köra på andra sätt
    # en separat config fil? Mer spårbart och rimligt att aldrig behöva öppna wrappern







