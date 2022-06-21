#!/bin/bash -l 

#SBATCH --job-name=Sfa_genbank_100k_psmcboot
#SBATCH -o Sfa_genbank_100k_psmcboot-%j.out 
#SBATCH --mem 6000
#SBATCH --array=1-100
#SBATCH -p main 
#SBATCH -n 1 
#SBATCH -N 1  
#SBATCH --cpus-per-task=40 
#SBATCH --mail-user=br450@rutgers.edu 
#SBATCH --mail-type=begin 
#SBATCH --mail-type=END

enable_lmod 
module load container_env pire_genome_assembly/2021.07.01
export SINGULARITY_BIND=/home/e1garcia
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/PSMC/data/mkBAM/genbank_100k/Sfa_genbank_100k_PSMC

RD="${SLURM_ARRAY_TASK_ID}"

crun psmc -N25 -t15 -r5 -b -p "4+25*2+4+6" -o Sfagenbank100kround-$RD.psmc Sfagenbank100ksplit50k.psmcfa

mv ../*psmcboot*out joblog
