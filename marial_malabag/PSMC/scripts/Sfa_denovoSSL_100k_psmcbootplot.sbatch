#!/bin/bash -l 

#SBATCH --job-name=Sfa_denovoSSL_100k_psmcbootplot
#SBATCH -o Sfa_denovoSSL_100k_psmcbootplot-%j.out 
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

cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/PSMC/data/mkBAM/shotgun_100k/Sfa_denovoSSL_100k_PSMC

cat SfadenovoSSL100kall.psmc SfadenovoSSL100kround-*.psmc > SfadenovoSSL100kcombined.psmc
crun psmc_plot.pl -pY100 SfadenovoSSL100kcombined SfadenovoSSL100kcombined.psmc
