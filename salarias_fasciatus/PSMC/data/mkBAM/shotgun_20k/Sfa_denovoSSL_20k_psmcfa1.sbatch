#!/bin/bash -l 

#SBATCH --job-name=Sfa_denovoSSL_20k_psmcfa1
#SBATCH -o Sfa_denovoSSL_20k_psmcfa1-%j.out 
#SBATCH --mem 2000 #most runs should be under 1 GB but we'll add a buffer
#SBATCH --array=1-1000
#SBATCH -p main 
#SBATCH -n 1 #each chromosome will be processed on a single core (-n 1)  
#SBATCH -N 1 #on one machine (-N 1)  
#SBATCH --cpus-per-task=40 
#SBATCH --mail-user=br450@rutgers.edu 
#SBATCH --mail-type=begin 
#SBATCH --mail-type=END 

enable_lmod 

module load container_env pire_genome_assembly/2021.07.01

export SINGULARITY_BIND=/home/e1garcia

CHR="${SLURM_ARRAY_TASK_ID}"
DATAPATH="/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/PSMC/data/mkBAM/shotgun_20k/Sfa_denovoSSL_20k_PSMC"

gzip $DATAPATH/Sfa_denovoSSL_20k.$CHR.fq

crun fq2psmcfa -q 20 $DATAPATH/Sfa_denovoSSL_20k.$CHR.fq.gz > $DATAPATH/Sfa_denovoSSL_20k.$CHR.psmcfa

mv *psmcfa*out $DATAPATH/joblog
