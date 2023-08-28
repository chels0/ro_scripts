#!/bin/bash 
#___________________________________________________
#
#   Bash script to replace GMS paths with RO paths 
#___________________________________________________


#Define RO paths to
twist_dna='/data/Twist_Solid/DNA/'
twist_rna='/data/Twist_Solid/RNA/'
ref='/data/reference_genomes/'
ref_rna='/data/Twist_Solid/RNA/'
star='STAR-Fusion/'
gtf='/data/Twist_Solid/RNA/hg19.refGene.gtf'
cnv='cnv_loh_genes'
vep='/data/Twist_Solid/DNA/VEP'
genome_index='/data/reference_genomes/star'
genefuse='genefuse/'
contamination='/data/Twist_Solid/DNA/contamination/'
fusioncatch='Fusioncatcher/human_v102/'

upps_twist_dna='/projects/wp1/nobackup/ngs/utveckling/Twist_DNA_DATA/'
upps_twist_rna='/projects/wp1/nobackup/ngs/utveckling/Twist_RNA_DATA/'
upps_ref_genome='/data/ref_genomes/'
upps_ref_data_rna='/data/ref_data/'
upps_star='star-fusion/'
upps_arriba='arriba_v2.3.0/database/'
upps_gtf='/data/ref_genomes/hg19/gtf/hg19.refGene.gtf'
upps_cnv='cnv_loh_uppsala_genes'
upps_vep='/data/ref_genomes/VEP'
upps_genome_index='/data/ref_data/star'
upps_genefuse='gene_fuse/'
upps_contamination='/data/reference_genomes/GNOMAD/'
upps_fusioncatch='fusioncatcher/human_v102/human_v102/'

bam='bwa/'

sed "s|${upps_arriba}||" config/config.yaml > ro_config.yaml
sed -i "s|${upps_ref_data_rna}|${ref_rna}|" ro_config.yaml

sed -i "s|${upps_star}|${star}|" ro_config.yaml
sed -i "s|${upps_gtf}|${gtf}|" ro_config.yaml
sed -i "s|${upps_vep}|${vep}|" ro_config.yaml
sed -i "s|${upps_genefuse}|${genefuse}|" ro_config.yaml
sed -i "s|${upps_twist_dna}|${twist_dna}|" ro_config.yaml
sed -i "s|${upps_ref_data_rna}|${ref_rna}|" ro_config.yaml
sed -i "s|${upps_ref_genome}|${ref}|" ro_config.yaml

sed -i "s|${upps_genome_index}|${genome_index}|" ro_config.yaml
sed -i  "s|${upps_twist_rna}|${twist_rna}|" ro_config.yaml
sed -i "s|${bam}||" ro_config.yaml
sed -i "s|${upps_cnv}|${cnv}|" ro_config.yaml
sed -i "s|${upps_contamination}|${contamination}|" ro_config.yaml
sed -i "s|${upps_fusioncatch}|${fusioncatch}|" ro_config.yaml

if [ -f config.yaml ];
then
    diff config.yaml ro_config.yaml > config_diff.txt
    if [ -s config_diff.txt ];
    then 
        echo "Changes have been made to the new config file compared to your old config file. Please view config_diff.txt to see if any files need to change"
    else
        echo "No new files have been added to the config file"
    fi
fi
