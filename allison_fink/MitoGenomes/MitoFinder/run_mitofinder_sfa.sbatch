#!/bin/bash

#SBATCH --job-name=mitofinder
#SBATCH -o mitofinder-%j.out
#SBATCH --time=00:00:00
#SBATCH -p main
#SBATCH --cpus-per-task=1

#script for running mitofinder (implemented via mitofinder_p2.bash)

enable_lmod 

module load container_env mitofinder/1.4.1

export SINGULARITY_BIND=/home/e1garcia

SCAFFOLD_FILE=$1
SPECIES=$2
ASSEMBLY=$3
FAMILY=$4

OUT_DIR=/home/afink007/shotgun_PIRE/2022_PIRE_omics_workshop/allison_fink/MitoGenomes/MitoFinder/mitofinder_sfa

SPECIES_DIR=${OUT_DIR}/mitofinder_${SPECIES}_${ASSEMBLY}

NAME=${SPECIES}_${ASSEMBLY}_${FAMILY}

mkdir ${SPECIES_DIR}

cp /home/e1garcia/shotgun_PIRE/denovo_genome_assembly/mitofinder/mitofinder_refpanel/${FAMILY}.gb ${SPECIES_DIR}

cp ${SCAFFOLD_FILE} ${SPECIES_DIR}/scaffolds.fa

cd ${SPECIES_DIR}

crun mitofinder -j ${NAME} -a scaffolds.fa -r ${FAMILY}.gb -o 2

#cd ${OUT_DIR}
#CDS=$(grep '^     CDS' ${SPECIES_DIR}/${NAME}/${NAME}_MitoFinder_mitfi_Final_Results/${NAME}_mtDNA_conti*.gb | wc -l)
#tRNA=$(grep '^     tRNA' ${SPECIES_DIR}/${NAME}/${NAME}_MitoFinder_mitfi_Final_Results/${NAME}_mtDNA_conti*.gb | wc -l)
#rRNA=$(grep '^     rRNA' ${SPECIES_DIR}/${NAME}/${NAME}_MitoFinder_mitfi_Final_Results/${NAME}_mtDNA_conti*.gb | wc -l)
#echo "${NAME},${CDS},${tRNA},${rRNA}" >> completeness_sum.txt
#grep -A1 "COX1" ${SPECIES_DIR}/${NAME}/${NAME}_MitoFinder_mitfi_Final_Results/${NAME}_final_genes_NT.fasta >> COI_seqs.fasta

