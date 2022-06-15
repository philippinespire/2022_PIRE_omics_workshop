# PSMC analysis pipeline
## Background and motivation
Genomic data contains a wealth of information regarding the demographic history of populations. One of the most interesting insights to emerge from the genomic revolution is that genomic data from just a few individuals or even a single individual can be used to estimate demographic trends for entire species or populations. A number of methods, summarized in [Mather et al.](https://doi.org/10.1002/ece3.5888), have been developed to take advantage of this information. We are going to use the method developed in 2011 by [Li and Durbin](https://doi.org/10.1038/nature10231) for this workshop.

Using the curated read data and the shotgun reference genome we have developed for *Salarias fasciatus*, as well as a published reference genome for the species, we will align reads to the genome, call genotypes and consensus sequences, and run the PSMC program to estimate a demographic trajectory for this species.
## Step 1. Preparing reference genomes.
The reference genomes we will be using are located in the `data` folder. The file `scaffolds.fasta` is the best shotgun assembly we created, while `GCF_902148845.1_fSalaFa1.1_genomic.fna.gz` is a more complete reference genome that was downloaded from [Genbank](https://www.ncbi.nlm.nih.gov/genome/7248?genome_assembly_id=609472).

Move to the `data` folder and rename our shotgun genome `Sfa_shotgun_assembly.fa`.

--> may need to rename dir to reflect student directory

```
cd /home/e1garcia/shotgun_PIRE/REUs/2022_REU/workshop/salarias_fasciatus/PSMC/data
mv scaffolds.fasta Sfa_shotgun_assembly.fa
```

Then, unzip the file downloaded from Genbank and rename it `Sfa_genbank_assembly.fa`.

```
gunzip -c GCF_902148845.1_fSalaFa1.1_genomic.fna.gz > Sfa_genbank_assembly.fa 
```

PSMC needs to have long chunks of contiguous sequence to make inferences, so want to use the larger scaffolds and filter out the small ones. We have a handy PERL-language script called `removesmalls` in the `scripts` folder that can do this. Run this on our two alternate reference genomes, keeping only scaffolds longer than 100kb (kilobases) or 20kb in length. We are going to name the output files in a specific way so they will be easy to work with later.

```
perl ../scripts/removesmalls.pl 100000 Sfa_shotgun_assembly.fa > reference.denovoSSL.Sfa100k.fasta
perl ../scripts/removesmalls.pl 100000 Sfa_genbank_assembly.fa > reference.genbank.Sfa100k.fasta
perl ../scripts/removesmalls.pl 20000 Sfa_shotgun_assembly.fa > reference.denovoSSL.Sfa20k.fa
perl ../scripts/removesmalls.pl 20000 Sfa_genbank_assembly.fa > reference.genbank.Sfa20k.fa
```

Now let's check the length of the filtered assemblies. This is a one-line script that will tell you the number of scaffolds left after filtering.

```
cat reference.denovoSSL.Sfa100k.fasta | grep "^>" | wc -l
cat reference.genbank.Sfa100k.fasta | grep "^>" | wc -l
cat reference.denovoSSL.Sfa20k.fasta | grep "^>" | wc -l
cat reference.genbank.Sfa20k.fasta | grep "^>" | wc -l
```

How many scaffolds did we keep for each genome?

reference.denovoSSL.Sfa100k.fasta = 130

reference.genbank.Sfa100k.fasta = 103

reference.denovoSSL.Sfa20k.fasta = 7488

reference.genbank.Sfa20k.fasta = 196

And here are scripts to calculate the total length of the filtered assemblies.

```
cat reference.denovoSSL.Sfa100k.fasta | grep -v "^>" | tr "\n" "\t" | sed 's/\t//g' | wc -c
cat reference.genbank.Sfa100k.fasta | grep -v "^>" | tr "\n" "\t" | sed 's/\t//g' | wc -c
cat reference.denovoSSL.Sfa20k.fasta | grep -v "^>" | tr "\n" "\t" | sed 's/\t//g' | wc -c
cat reference.genbank.Sfa20k.fasta | grep -v "^>" | tr "\n" "\t" | sed 's/\t//g' | wc -c
```

How long is each assembly?

reference.denovoSSL.Sfa100k.fasta = 16815789

reference.genbank.Sfa100k.fasta = 792843668

reference.denovoSSL.Sfa20k.fasta = 282010249

reference.genbank.Sfa20k.fasta = 797427707

Our shotgun assembly has shorter scaffolds in general than the Genbank assembly. If we use only scaffolds >100k we are using a fraction of the genome, however this may still be enough to make robust inferences about demographic history. We will assess this in the next steps.

Before we move forward, we need to change the names of the scaffolds to numerals (1,2,3...x). We can do that with another simple line of code.

```
awk -i inplace '/^>/{print ">" ++i; next}{print}' reference.denovoSSL.Sfa100k.fasta
awk -i inplace '/^>/{print ">" ++i; next}{print}' reference.genbank.Sfa100k.fasta
awk -i inplace '/^>/{print ">" ++i; next}{print}' reference.denovoSSL.Sfa20k.fasta
awk -i inplace '/^>/{print ">" ++i; next}{print}' reference.genbank.Sfa100k.fasta
```

Now we're ready to map to the reference!

## Step 2. Mapping reads to a reference genome and working with mapping (.bam) files.

We next need to map our shotgun reads to our reference genomes. This is a key step in many genomic workflows. We use a modified version of a pipeline called dDocent to do this mapping. We will use two steps in the dDocent pipeline, mkBAM (which creates .bam files that store mapping information) and fltrBAM (which filters out reads that mapped to the genome with low quality).

We first need to navigate back to our PSMC directory and clone the dDocent repo.

```
cd /home/e1garcia/shotgun_PIRE/REUs/2022_REU/workshop/salarias_fasciatus/PSMC
git clone https://github.com/cbirdlab/dDocentHPC.git
```

--> set up dirs with reads already

Folders containing the shotgun reads should be set up already. If you need to do this, use the following code. 

Do not run this if you don't have to, copying these files takes a long time!!

```
mkdir data/mkBAM
mkdir data/mkBAM/shotgun_100k
mkdir data/mkBAM/genbank_100k
mkdir data/mkBAM/shotgun_20k
mkdir data/mkBAM/genbank_20k
cp data/*.fq.gz data/mkBAM/shotgun_100k
cp data/*.fq.gz data/mkBAM/genbank_100k
cp data/*.fq.gz data/mkBAM/shotgun_20k
cp data/*.fq.gz data/mkBAM/genbank_20k
```

Now we need to copy some scripts and configuration files to our folders. Note that we need to use a modified version of the sbatch file that works with the ODU HPCC.

```
cp dDocentHPC/dDocentHPC.bash data/mkBAM/shotgun_100k
cp dDocentHPC/dDocentHPC.bash data/mkBAM/genbank_100k
cp dDocentHPC/dDocentHPC.bash data/mkBAM/shotgun_20k
cp dDocentHPC/dDocentHPC.bash data/mkBAM/genbank_20k
cp dDocentHPC/configs/config.5.cssl data/mkBAM/shotgun_100k
cp dDocentHPC/configs/config.5.cssl data/mkBAM/genbank_100k
cp dDocentHPC/configs/config.5.cssl data/mkBAM/shotgun_20k
cp dDocentHPC/configs/config.5.cssl data/mkBAM/genbank_20k
cp /home/e1garcia/dDocentHPC_ODU/dDocentHPC_ODU.sbatch data/mkBAM/shotgun_100k
cp /home/e1garcia/dDocentHPC_ODU/dDocentHPC_ODU.sbatch data/mkBAM/genbank_100k
cp /home/e1garcia/dDocentHPC_ODU/dDocentHPC_ODU.sbatch data/mkBAM/shotgun_20k
cp /home/e1garcia/dDocentHPC_ODU/dDocentHPC_ODU.sbatch data/mkBAM/genbank_20k
```

Move the reference genome files to the appropriate folders

```
mv data/reference.denovoSSL.Sfa100k.fasta data/mkBAM/shotgun_100k
mv data/reference.genbank.Sfa100k.fasta data/mkBAM/genbank_100k
mv data/reference.denovoSSL.Sfa20k.fasta data/mkBAM/shotgun_20k
mv data/reference.genbank.Sfa100k.fasta data/mkBAM/genbank_100k
```

Thus in each folder you must have: * reads to map (.R1.fq.gz/.R2.fq.gz) * reference genome (renamed scaffolds, with dDocent prefix reference.cutoff1.cutoff2.fasta) * dDocentHPC.bash * config file (currently config.5.cssl) * dDocentHPC_ODU.sbatch

Examine a `config.5.cssl` file - this file contains all of the setting that will be used to run dDocent. Most of these you can keep as they are. Recall that we used a specific convention to name our reference genome files - specifically the format is `reference.<cutoff1>.<cutoff2>.fasta`, where cutoff1 and cutoff2 refer to descriptive variables used by dDocent. We need to edit the config file `config.5.cssl` in each directory to so that dDocent can find the reference.  
--> Also, the default alignment score in config.5.cssl is 80, which is different from before and seems high! I am changing this to 30.

Here is an example:

```
----------mkREF: Settings for de novo assembly of the reference genome--------------------------------------------
PE              Type of reads for assembly (PE, SE, OL, RPE)                                    PE=ddRAD & ezRAD pairedend, non-overlapping reads; SE=singleend reads; OL=ddRAD & ezRAD overlapping reads, miseq; RPE=oregonRAD, restriction site + random shear
0.9             cdhit Clustering_Similarity_Pct (0-1)                                                   Use cdhit to cluster and collapse uniq reads by similarity threshold
denovoSSL               Cutoff1 (integer)     ### <--- change this value to either denovoSSL or genbank to match the reference ###
Aur-C_500_R1R2ORPHMRGD_decontam_noisolate               Cutoff2 (integer)    ### <--- change to either Sfa100k or Sfa20k to match your reference
0.05    rainbow merge -r <percentile> (decimal 0-1)                                             Percentile-based minimum number of seqs to assemble in a precluster
0.95    rainbow merge -R <percentile> (decimal 0-1)                                             Percentile-based maximum number of seqs to assemble in a precluster
------------------------------------------------------------------------------------------------------------------

----------mkBAM: Settings for mapping the reads to the reference genome-------------------------------------------
Make sure the cutoffs above match the reference*fasta!
1               bwa mem -A Mapping_Match_Value (integer)
4               bwa mem -B Mapping_MisMatch_Value (integer)
6               bwa mem -O Mapping_GapOpen_Penalty (integer)
80              bwa mem -T Mapping_Minimum_Alignment_Score (integer)     ### <--- change to 30
5       bwa mem -L Mapping_Clipping_Penalty (integer,integer)
------------------------------------------------------------------------------------------------------------------

```

Go through each config file and make these changes using a text editor.

--> current ODU sbatch file references config.4, change to config.5? Maybe we should have a more compact version in the scripts folder? 
--> also needs singularity bind for Eric's folder
--> export SINGULARITY_BIND=/home/e1garcia

Now you will need to edit each sbatch file in each directory. Notice that this file has a lot of lines commented out with hashtags - these will run different steps in the process when un-commented. Find the line starting with `crun bash dDocentHPC.bash mkBAM config`... and un-comment this line by removing the hashtag. The config file is the last argument in this line - make sure it is the correct file (config.5.ssl). Make sure all of the other lines starting with `crun` are still commented. You can also change the job-name and output SBATCH settings in the header to identify this job (something appropriate to each reference genome, like mkBAM_denovoSSL_Sfa100k), and change the email address so it emails you when finished. 

Your header, and the lines you are running, should read something like this:

```
#!/bin/bash -l

#SBATCH --job-name=mkBAM_denovoSSL_Sfa100k
#SBATCH -o mkBAM_denovoSLL_Sfa100k-%j.out
#SBATCH -p main
#SBATCH -c 4                                    # either < -c 4 > or < --ntasks=1 together withw --cpus-per-task=40 > We have been using -c 4 
##SBATCH --ntasks=1
##SBATCH --cpus-per-task=40                     # 40 for Wahab or 32 for Turing
#SBATCH --mail-user=br450@rutgers.edu
#SBATCH --mail-type=begin
#SBATCH --mail-type=END

enable_lmod
module load container_env ddocent
export SINGULARITY_BIND=/home/e1garcia

[...]

crun bash dDocentHPC.bash mkBAM config.5.cssl
```

If all of that is set you should be able to run dDocentHPC and map your reads by executing the sbatch file in each directory. Navigate to each directory and run the following.

```
sbatch dDocentHPC_ODU.sbatch
```



After we have generated the .bam files we need to filter them. This can be done just by editing the sbatch file to un-comment the appopriate line in your sbatch file and rerunning. 

Add a hashtag at the beginning on the mkBAM line (so you don't run that step again!), then find the next line with `crun bash dDocentHPC.bash fltrBAM`... and remove the hashtag from that one. Make sure it is pointing to the proper config file again. Change "mkBAM" to "fltrBAM" in the header. THe relevant lines should look like this.

```
#!/bin/bash -l

#SBATCH --job-name=fltrBAM_denovoSSL_Sfa100k
#SBATCH -o fltrBAM_denovoSSL_Sfa100k-%j.out
#SBATCH -p main
#SBATCH -c 4					# either < -c 4 > or < --ntasks=1 together withw --cpus-per-task=40 > We have been using -c 4 
##SBATCH --ntasks=1
##SBATCH --cpus-per-task=40			# 40 for Wahab or 32 for Turing
#SBATCH --mail-user=breid@rutgers.edu
#SBATCH --mail-type=begin
#SBATCH --mail-type=END

enable_lmod
module load container_env ddocent
export SINGULARITY_BIND=/home/e1garcia

[...]

crun bash dDocentHPC.bash fltrBAM config.5.cssl
```

If we have multiple sorted .bam files from the same individual, we can merge those .bam files into a single .bam file using thecommand  `samtools merge`. To call genotypes we also need to index this merged file first. The sbatch script `mergebams.sbatch` can be used to do both of these things. Copy it to your folder and execute.

```
cp /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/PSMC/scripts/mergebams.sbatch
sbatch mergebams.sbatch
```

## Step 3. Assessng depth of coverage.

For shotgun sequencing, we should theoretically have roughly the same depth of coverage across the whole genome. For real data this won't always be the case - some parts of the genome might have been difficult to sequence, and some repetitive regions could cause mapping issues that inflate our depth of coverage. We don't want to use these regions for calling genotypes that we will be using in the PSMC analysis later. For calling consensus sequences, PSMC documentation recommends using sites with minimum depth 1/3 of mean depth and maximum depth 2x mean depth.

We can calculate the mean depth using samtools. Let's use an interactive node to do this.

```
salloc
module load samtools
samtools depth Sfa_denovoSSL_100k.bam | awk '{sum+=$3} END { print "Average (covered sites) = ",sum/NR}'
```

What was the mean depth of coverage? What range of coverage should we use?

-->The mean coverage is 138, so we will use minimum depth 46 and maximum depth 276.

With this level of coverage we should be pretty confident in calling heterozygous sites.

We can also examine the mapping visually using a program called IGV (<ins>I</ins>ntegrative <ins>G</ins>enomics <ins>V</ins>iewer). We will take a closer look at our mapping results using this program while we are running some of the next steps.

## Step 4. Calling genotypes and consensus sequences.

This step uses scripts modified from [Harvard FAS Informatics tutorial](https://informatics.fas.harvard.edu/psmc-journal-club-walkthrough.html), [Applying PSMC to Neandertal data](http://willyrv.github.io/tutorials/bioinformatics/AltaiNea-psmc.html), & the [PSMC documentation](https://github.com/lh3/psmc) to call a "consensus sequence" from our .bam file. We use SLURM's array mode to parallelize the consensus calling, meaning that for each of the scaffolds in our reference genome we create a new processthat calls the sequence for that scaffold.

The script `mpileup.sbatch` uses a pipeline from samtools to bcftools to vcfutils.pl to create a consensus sequence.

Examine the script - it is configured to work with our Sfa_denovoSSL_100k bamfile. You may have to edit a few things in the sbatch for it to run properly.

1) Make sure all of the paths are correct, especially the DATAPATH (= the path to the folder containing your bamfile and reference assembly).

2) Check the `-d` and `-D` arguments after `crun vcfutils.pl vcf2fq`. These should reflect the minimum and maximum depth cutoffs you calculated in the previous step.


Execute the script using

```
sbatch Sfa_denovoSSL_100k_mpileup.sbatch
```

The maximum number of tasks the array can handle using this script is 1000. If you need to run more than that we also have a modified sbatch script `mpileup2.sbatch` that can run >1000.

Check some of the output files - do we have heterozygous sites?

## Step 5. Converting files to PSMC format.

Now that we have consensus sequences we need to convert these to a format PSMC understands. Again we can use an array script, `psmcfa.sbatch`, to do this over all of our sequence files.

Check again to make sure that all of the file paths are correct, then run the script. This script needs to be run from the directory containing all of your consensus sequences

```
sbatch Sfa_denovoSSL_100k_psmcfa.sbatch
```

If you need to convert >1000 files we again have a modified version of the script, `psmcfa2.sbatch'.

## Step 6. Running PSMC.

We are finally ready to run PSMC!

The psmc.sbatch script will run PSMC and generate a basic plot. Make sure all of the paths and the input/output file names are correct. To plot the demographic history on the scale of years we need to know generation time and mutation rate. We are assuming a default mutation rate (2.25x10^-8). Generation time is species-specific; for Sfa we can use 4 years, which is average for related species.

```
sbatch Sfa_denovoSSL_100k_psmc.sbatch

```  

After running PSMC you can download the plot (.eps file) to your local computer and see the estimated demographic history of your species.

## Step 7. Creating confidence intervals via bootstrapping.


We now have an idea of how our Sfa population may have changed over time. We don't know, however, how confident we should be in the estimate of population size at any given time. One source of error is our sampling of the genome - if we sampled a different selection of regions, would we get the same result?

PSMC has a built in bootstrapping feature that can create confidence intervals for our demographic history based on resampling chunks of the data.

Run this script (make sure to modify to match your paths/etc) to perform 100 rounds of bootstrapping.

```
sbatch Sfa_denovoSSL_100k_psmcboot.sbatch
```


## Step 8. Examining the outputs and making plots.

Let's take a look at our PSMC outputs.

To plot the bootstrap result, use the `pmscbootplot.sbatch` script. Since this will include confidence intervals you will have to increase the maximum Y-axis value - 'pY100' will change it to 200x10^4. You can change the X-axis scale too. Try pY100 - does that capture the maximum bootstrapped value? Change and rerun the script if not.

How does the confidence in our estimated demographic history change from the distant past to the recent past?

Take a look at the PSMC output files (.psmc and .par). These are the "raw" outputs from PSMC. Notably, the numbers are scaled to mutation rate and population size. How do we translate these to unscaled estimates of effective population size? 
