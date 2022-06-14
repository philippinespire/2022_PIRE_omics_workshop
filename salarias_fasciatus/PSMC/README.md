# PSMC analysis pipeline
## Background and motivation
Genomic data contains a wealth of information regarding the demographic history of populations. One of the most interesting insights to emerge from the genomic revolution is that genomic data from just a few individuals or even a single individual can be used to estimate demographic trends for entire species or populations. A number of methods, summarized in [Mather et al.](https://doi.org/10.1002/ece3.5888), have been developed to take advantage of this information. We are going to use the method developed in 2011 by [Li and Durbin](https://doi.org/10.1038/nature10231) for this workshop.

Using the curated read data and the shotgun reference genome we have developed for *Salarias fasciatus*, as well as a published reference genome for the species, we will align reads to the genome, call genotypes and consensus sequences, and run the PSMC program to estimate a demographic trajectory for this species.
## Step 1. Prepare reference genomes.
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

## Step 2. Map reads to a reference genome.

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

Recall that we used a specific convention to name our reference genome files. We need to edit the config file in each directory to so that dDocent can find the reference.  

## Step 3. Assess depth of coverage.
## Step 4. Call genotypes and consensus sequences.
## Step 5. Convert files to PSMC format.
## Step 6. Run PSMC.
## Step 7. Create confidence intervals via bootstrapping.
## Step 8. Make plots.
