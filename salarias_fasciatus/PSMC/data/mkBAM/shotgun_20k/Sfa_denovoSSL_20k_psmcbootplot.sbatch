#!/bin/bash -l 

#SBATCH --job-name=Sfa_denovoSSL_20k_psmcbootplot
#SBATCH -o Sfa_denovoSSL_20k_psmcbootplot-%j.out 
#SBATCH --mem 6000
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

cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/PSMC/data/mkBAM/shotgun_20k/Sfa_denovoSSL_20k_PSMC

cat SfadenovoSSL20kall.psmc SfadenovoSSL20kround-*.psmc > SfadenovoSSL20kcombined.psmc
crun psmc_plot.pl -pY50 -g 4 SfadenovoSSL20kcombined SfadenovoSSL20kcombined.psmc
