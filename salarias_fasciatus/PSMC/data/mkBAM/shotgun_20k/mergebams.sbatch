#!/bin/bash -l

#SBATCH --job-name=merge_denovoSSL_Sfa100k
#SBATCH -o merge_denovoSSL_Sfa100k-%j.out
#SBATCH -p main
#SBATCH -c 4					# either < -c 4 > or < --ntasks=1 together withw --cpus-per-task=40 > We have been using -c 4 
##SBATCH --ntasks=1
##SBATCH --cpus-per-task=40			# 40 for Wahab or 32 for Turing
#SBATCH --mail-user=br450@rutgers.edu
#SBATCH --mail-type=begin
#SBATCH --mail-type=END

enable_lmod
module load container_env ddocent
export SINGULARITY_BIND=/home/e1garcia

#merging .bam files with samtools merge. syntax = <outfile> <infile1> <infile2> ... <infileN>
crun samtools merge Sfa_reduced_denovoSSL_20k.bam SfC0281G_CKDL210013395-1a-AK3911-AK845_HF33GDSX2_L4_clmp.fp2_repr.denovoSSL.Sfa20k-RG.bam SfC0281H_CKDL210013395-1a-5UDI245-GD07_HF33GDSX2_L4_clmp.fp2_repr.denovoSSL.Sfa20k-RG.bam SfC0282A_CKDL210013395-1a-AK8593-7UDI304_HF33GDSX2_L4_clmp.fp2_repr.denovoSSL.Sfa20k-RG.bam 
crun samtools index Sfa_reduced_denovoSSL_20k.bam
