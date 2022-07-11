#!/bin/bash -l 

#SBATCH --job-name=Sfa_denovoSSL_100k_psmc
#SBATCH -o Sfa_denovoSSL_100k_psmc-%j.out 
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
cat Sfa_denovoSSL_100k*.psmcfa > SfadenovoSSL100kall.psmcfa
crun psmc -N25 -t15 -r5 -p "4+25*2+4+6" -o SfadenovoSSL100kall.psmc SfadenovoSSL100kall.psmcfa
crun psmc2history.pl SfadenovoSSL100kall.psmc | crun history2ms.pl > ms-cmd.sh
crun psmc_plot.pl -g 4 SfadenovoSSL100k SfadenovoSSL100kall.psmc
