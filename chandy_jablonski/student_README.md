# Sfa Shotgun Data Processing Log - SSL data

Copy and paste this into a new species dir and fill in as steps are accomplished.

Following the [pire_fq_gz_processing](https://github.com/philippinespire/pire_fq_gz_processing) and [pire_ssl_data_processing](https://github.com/philippinespire/pire_ssl_data_processing) roadmaps.

---

## **A. Pre-Processing Section**

## Step 0. Rename the raw fq.gz files

Used decode file from Sharon Magnuson. **We will do this together in the workshop as a demonstration.**

```
salloc
bash

cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus

#run renameFQGZ.bash first to make sure new names make sense
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Sfa_ProbeDevelopmentLibraries_SequenceNameDecode.tsv

#run renameFQGZ.bash again to actually rename files
#need to say "yes" 2X
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Sfa_ProbeDevelopmentLibraries_SequenceNameDecode.tsv rename
```

---

## Step 1. Check quality of data with fastqc

Ran [`Multi_FASTQC.sh`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/Multi_FASTQC.sh).
* **NOTE:** for the 2022 PIRE Omics workshop, run [`Multi_FASTQC_wkshp.sh`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/Multi_FASTQC_wkshp.sh) instead. Specify out directory to write the output to.

```
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/shotgun_raw_fq

#Multi_FastQC.sh "<indir>" "file extension"
#For workshop: Multi_FASTQC_wkshp.sh "<indir>" "<outdir>" "file extension"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/shotgun_raw_fq" "fq.gz"
```

[Report](https://github.com/philippinespire/2022_PIRE_omics_workshop/blob/main/salarias_fasciatus/shotgun_raw_fq/fastqc_report.html) written out to `shotgun_raw_fq` directory. *To visualize, click "view raw" and then add "[https://htmlpreview.github.io/?](https://htmlpreview.github.io/?)" to the beginning of the URL.*

Potential issues:  
  * % duplication - 
    * XX%
  * gc content - 
    * XX%
  * quality - 
    * XX%
  * % adapter - 
    * XX%
  * number of reads - 
    * XXM

---

## Step 2.  First trim with fastp

Ran [`runFASTP_1st_trim.sbatch`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFASTP_1st_trim.sbatch).

```
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus

#sbatch runFASTP_1st_trim.sbatch <INDIR/full path to files> <OUTDIR/full path to desired outdir>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_1st_trim.sbatch shotgun_raw_fq fq_fp1
```

[Report](https://github.com/philippinespire/2022_PIRE_omics_workshop/blob/main/salarias_fasciatus/fq_fp1/1st_fastp_report.html) written out to `fq_fp1` directory. *To visualize, click "view raw" and then add "[https://htmlpreview.github.io/?](https://htmlpreview.github.io/?)" to the beginning of the URL.*

Potential issues:  
  * % duplication -  
    * XX%
  * gc content - 
    * XX%
  * passing filter - 
    * XX%
  * % adapter -  
    * XX%
  * number of reads - 
    * XXM

---

## Step 3. Clumpify

Ran [`runCLUMPIFY_r1r2_array.bash`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runCLUMPIFY_r1r2_array.bash) in a 3 node array on Wahab.

```
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus

bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmp /scratch/r3clark 3
```

Checked the output with [`checkClumpify_EG.R`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/checkClumpify_EG.R).

```
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus

salloc
enable_lmod
module load container_env mapdamage2

crun R < /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/checkClumpify_EG.R --no-save
```

Clumpify worked succesfully!

Moved all `*out` files to the `logs` directory.

```
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus

mv *out logs
```

---

## Step 4. Run fastp2

Ran [`runFASTP_2_ssl.sbatch`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFASTP_2_ssl.sbatch).

```
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus

#runFASTP_2_ssl.sbatch <indir> <outdir> 
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_2_ssl.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```

[Report](https://github.com/philippinespire/2022_PIRE_omics_workshop/blob/main/salarias_fasciatus/fq_fp1_clmp_fp2/2nd_fastp_report.html) written out to `fq_fp1_clmp_fp2` directory. *To visualize, click "view raw" and then add "[https://htmlpreview.github.io/?](https://htmlpreview.github.io/?)" to the beginning of the URL.*

Potential issues:  
  * % duplication - 
    * XX%
  * gc content - 
    * XX%
  * passing filter - 
    * XX%
  * % adapter - 
    * XX%
  * number of reads
    * XXM

---

## Step 5. Run fastq_screen

Ran [`runFQSCRN_6.bash`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFQSCRN_6.bash).

```
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus

#runFQSCRN_6.bash <indir> <outdir> <number of nodes to run simultaneously>
#do not use trailing / in paths
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 6
```

Checked output for errors.

```
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus

ls fq_fp1_clmp_fp2_fqscrn/*tagged.fastq.gz | wc -l
ls fq_fp1_clmp_fp2_fqscrn/*tagged_filter.fastq.gz | wc -l 
ls fq_fp1_clmp_fp2_fqscrn/*screen.txt | wc -l
ls fq_fp1_clmp_fp2_fqscrn/*screen.png | wc -l
ls fq_fp1_clmp_fp2_fqscrn/*screen.html | wc -l

#checked for errors in all out files at once
grep 'error' slurm-fqscrn.*out
grep 'No reads in' slurm-fqscrn.*out

#No errors!
```

Have to run Multiqc separately.

```
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus

#runMULTIQC.sbatch <indir> <report name>
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runMULTIQC.sbatch fq_fp1_clmp_fp2_fqscrn fastqc_screen_report
```

[Report](https://github.com/philippinespire/2022_PIRE_omics_workshop/blob/main/salarias_fasciatus/fq_fp1_clmp_fp2_fqscrn/fastqc_screen_report.html) written out to `fq_fp1_clmp_fp2_fqscrn` directory. *To visualize, click "view raw" and then add "[https://htmlpreview.github.io/?](https://htmlpreview.github.io/?)" to the beginning of the URL.*

Potential issues:
  * one hit, one genome, no ID ~XX% - 
  * no one hit, one genome to any potential contaminators (bacteria, virus, human, etc)  ~XX% - good 

Cleaned-up logs again.

```
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus

mv *out logs/
```

---

## Step 6. Repair fastq_screen paired end files

Ran [`runREPAIR.sbatch`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runREPAIR.sbatch).

```sh
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus

#runREPAIR.sbatch <indir> <outdir> <threads>
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runREPAIR.sbatch fq_fp1_clmp_fp2_fqscrn fq_fp1_clmp_fp2_fqscrn_repaired 40
```

This went smoothly.

Have to run Fastqc-Multiqc separately.

```
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/fq_fp1_clmp_fp2_fqscrn_repaired

#Multi_FastQC.sh "<indir>" "file_extension"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/fq_fp1_clmp_fp2_fqscrn_repaired" "fq.gz" 
```

[Report](https://github.com/philippinespire/2022_PIRE_omics_workshop/blob/main/salarias_fasciatus/fq_fp1_clmp_fp2_fqscrn_repaired/fastqc_report.html) written out to `fq_fp1_clmp_fp2_fqscrn_repaired` directory. *To visualize, click "view raw" and then add "[https://htmlpreview.github.io/?](https://htmlpreview.github.io/?)" to the beginning of the URL.*

Potential issues:  
  * % duplication - 
    * XX%
  * gc content - 
    * XX%
  * number of reads
    * XX%

---

## Step 7. Calculate the percent of reads lost in each step

Ran [`read_calculator_ssl.sh`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/read_calculator_ssl.sh).

```sh
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus

#sbatch read_calculator_ssl.sh <species home dir> 
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/read_calculator_ssl.sh "/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus"
```

Generated the [percent_read_loss](https://github.com/philippinespire/2022_PIRE_omics_workshop/blob/main/salarias_fasciatus/preprocess_read_change/readLoss_table.tsv) and [percent_reads_remaining](https://github.com/philippinespire/2022_PIRE_omics_workshop/blob/main/salarias_fasciatus/preprocess_read_change/readsRemaining_table.tsv) tables.

Reads lost:
  * fastp1 dropped XX% of the reads
  * XX% of reads were duplicates and were dropped by clumpify
  * fastp2 dropped XX% of the reads after deduplication

Reads remaining:
  * Total reads remaining: XX% 

---

## **B. Genome Assembly Section**

## Step 1. Genome Properties

*Salarias fasciatus* has a genome available at both the genomesize.com (C-value= "0.83" pg) and NCBI Genome databases. 
 
However, we will still estimate the genome size of *Salarias fasciatus* using Jellyfish to remain consistent with all the other species.

Executed `runJellyfish.sbatch` using the decontaminated files.

```sh
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/yourname

#runJellyfish.sbatch <Species 3-letter ID> <indir>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runJellyfish.sbatch "Sfa" "fq_fp1_clmp_fp2_fqscrn_repaired"
```

The Jellyfish kmer-frequency [histogram file](https://github.com/philippinespire/2022_PIRE_omics_workshop/blob/main/salarias_fasciatus/fq_fp1_clmp_fp2_fqscrn_repaired/Sfa_all_reads.histo) 
was uploaded into [GenomeScope v1.0](http://qb.cshl.edu/genomescope/) and [GenomeScope v2.0](http://qb.cshl.edu/genomescope/genomescope2.0/) to generate the [v1.report](**insert file**) and [v2.report](**insert file**). 

Genome stats for Sfa from Jellyfish/GenomeScope v1.0 and v2.0, k=21 for both versions:

**insert table here**

No red flags. We will use the max value from V2 rounded up to ***insert value here*** bp.

---

## Step 2. Assemble the Genome Using [SPAdes](https://github.com/ablab/spades#sec3.2)

Executed [runSPADEShimem_R1R2_noisolate.sbatch](https://github.com/philippinespire/pire_ssl_data_processing/blob/main/scripts/runSPADEShimem_R1R2_noisolate.sbatch) for each library and for all the libraries combined.

```sh
#new window
ssh username@turing.hpc.odu.edu
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/yourname

#runSPADEShimem_R1R2_noisolate.sbatch <your user ID> <3-letter species ID> <contam | decontam> <genome size in bp> <species dir>
#do not use trailing / in paths

#1st library
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runSPADEShimem_R1R2_noisolate.sbatch "e1garcia" "Sfa" "1" "decontam" "635000000" "/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/yourname" "fq_fp1_clmp_fp2_fqscrn_repaired"

#2nd library
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runSPADEShimem_R1R2_noisolate.sbatch "e1garcia" "Sfa" "2" "decontam" "635000000" "/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/yourname" "fq_fp1_clmp_fp2_fqscrn_repaired"

#3rd library
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runSPADEShimem_R1R2_noisolate.sbatch "e1garcia" "Sfa" "3" "decontam" "635000000" "/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/yourname" "fq_fp1_clmp_fp2_fqscrn_repaired"

#all libraries combined
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runSPADEShimem_R1R2_noisolate.sbatch "e1garcia" "Sfa" "all_3libs" "decontam" "635000000" "/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/yourname" "fq_fp1_clmp_fp2_fqscrn_repaired"
```
 
JOB IDs:

```
[e1garcia@turing1 salarias_fasciatus]$ sq
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
           9767803     himem     Sp8s e1garcia  R       0:01      1 coreV4-21-himem-003
           9767802     himem     Sp8s e1garcia  R       0:16      1 coreV4-21-himem-002
           9767801     himem     Sp8s e1garcia  R       0:27      1 coreV2-23-himem-004
           9767800     himem     Sp8s e1garcia  R       1:11      1 coreV2-23-himem-003
```

Libraries for each assembly:

Assembly  |  Library
--- | ---
A | 1G
B | 1H
C | 2A

This SPAdes scripts automatically runs `QUAST` but have to run `BUSCO` separately.

## Step 3. Running BUSCO

Executed [runBUCSO.sh](https://github.com/philippinespire/pire_ssl_data_processing/blob/main/scripts/runBUSCO.sh) on both the `contigs` and `scaffolds` files.

```sh
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus

#runBUSCO.sh <species dir> <SPAdes dir> <contigs | scaffolds>
#do not use trailing / in paths

#1st library - contigs
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runBUSCO.sh "/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus" "SPAdes_Sfa-CBas-A_decontam_R1R2_noIsolate" "contigs"

#2nd library -contigs
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runBUSCO.sh "/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus" "SPAdes_Sfa-CBas-B_decontam_R1R2_noIsolate" "contigs"

#3rd library - contigs
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runBUSCO.sh "/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus" "SPAdes_Sfa-CBas-C_decontam_R1R2_noIsolate" "contigs"

#all libraries - contigs
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runBUSCO.sh "/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus" "SPAdes_allLibs_decontam_R1R2_noIsolate" "contigs"

#1st library -scaffolds
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runBUSCO.sh "/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus" "SPAdes_Sfa-CBas-A_decontam_R1R2_noIsolate" "scaffolds"

#2nd library - scaffolds
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runBUSCO.sh "/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus" "SPAdes_Sfa-CBas-B_decontam_R1R2_noIsolate" "scaffolds"

#3rd library - scaffolds
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runBUSCO.sh "/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus" "SPAdes_Sfa-CBas-C_decontam_R1R2_noIsolate" "scaffolds"

#all libraries - scaffolds
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runBUSCO.sh "/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus" "SPAdes_allLibs_decontam_R1R2_noIsolate" "scaffolds"
```

## Step 4. Fill in QUAST and BUSCO Values

You are not going to have the BUSCO output till few hours but you can copy the out files from the workshop:
```sh
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/your_name
pwd

cp -R /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/busco-results .
```

Now you can complete the table below

### Summary of QUAST (using GenomeScope v.2 <enter genome length> estimate) and BUSCO Results

Species    |Assembly    |DataType    |SCAFIG    |covcutoff    |genome scope v.    |No. of contigs    |Largest contig    |Total lenght    |% Genome size completeness    |N50    |L50    |Ns per 100 kbp    |BUSCO single copy
------  |------  |------ |------ |------ |------  |------ |------ |------ |------ |------  |------ |------ |------
Sfa  |A  |decontam       |contgs       |off       |2       |  67123  | 76658  | 485971358  | 77 % | 8294  |  17506  |  0  | 53.9 %
Sfa  |A  |decontam       |scaffolds       |off       |2    |  52432  |  129917  |   540390606  |  85 % | 14081  | 10678  | 687.92  | 68.5 %
Sfa  |B  |decontam       |contgs       |off       |2       |  66179  |  89863  |   503699552  |  79 % |  8954  |  16792  |  0  | 56.8 %
Sfa  |B  |decontam       |scaffolds       |off       |2    |  52101  |  155803  |   548869041  |  86 % |  14587  |  10542  |  580.13  | 70.8 %
Sfa  |C  |decontam       |contgs       |off       |2       |  65353  |  92853  |  489986080  | 77 % | 8743  | 16693  |  0  |  55.9 %
Sfa  |C  |decontam       |scaffolds       |off       |2    |  51239  |  176566  |   539924893  | 86 % |  14784  |  10318  | 641.53 | 69.5 %
Sfa  |allLibs  |decontam       |contigs       |off       |2    |  ? | ? |  ?  |  ? % |  ?  | ?  |  ?  | ? %
Sfa  |allLibs  |decontam       |scaffolds       |off       |2   | ? | ? |  ?  |  ? % | ?  |  ?  | ? | ? %

## Step 5. Identify Best Assembly

What is the best assembley? Note here. Include the assembly and the corresponding library.

Note additional remarks if necessary

## Step 6. Assemble Contaminated Data From the Best Library

```sh
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus

#runSPADEShimem_R1R2_noisolate.sbatch <your user ID> <3-letter species ID> <library: all_2libs | all_3libs | 1 | 2 | 3> <contam | decontam> <genome size in bp> <species dir>
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runSPADEShimem_R1R2_noisolate.sbatch "e1garcia" "Sfa" "2" "contam" "635000000" "/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus" "fq_fp1_clmp_fp2_fqscrn_repaired"
```

## Skipping Steps 7-8 for the workshop BUT please do clean-up  (Step 9):

Move your out files into the `logs` directory

```sh
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/yourname

mv *out logs
```

--- 

## **C. Probe Design - Regions for Probe Development**

From the species directory: made probe directory, renamed assembly, and copied scripts.

```sh
cd /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/yourname

mkdir probe_design
cp /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/WGprobe_annotation.sb probe_design
cp /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/WGprobe_bedcreation.sb probe_design
cp SPAdes_SgC0072C_contam_R1R2_noIsolate/scaffolds.fasta probe_design
# list the busco dirs
ls -d busco_*
# identify the busco dir of best assembly, copy the treatments (starting with the library)
# Example,the busco dir for the best assembly for Sgr is `busco_scaffolds_results-SPAdes_SgC0072C_contam_R1R2_noIsolate`
# I then provide the species 3-letter code, scaffolds, and copy and paste the parameters from the busco dir after "SPAdes_" 
cd probe_design
mv scaffolds.fasta Sgr_scaffolds_B_contam_R1R2_noIsolate.fasta
```

Execute the first script
```sh
#WGprobe_annotation.sb <assembly name> 
sbatch WGprobe_annotation.sb "Sgr_scaffolds_SgC0072C_contam_R1R2_noIsolate.fasta"
```

Execute the second script
```sh
#WGprobe_annotation.sb <assembly base name> 
sbatch WGprobe_bedcreation.sb "Sgr_scaffolds_SgC0072C_contam_R1R2_noIsolate"
```

The longest scaffold is 105644

The upper limit used in loop is 97500

A total of 13063 regions have been identified from 10259 scaffolds


Moved out files to logs
```sh
mv *out ../logs
```

## Step 12. Fetching genomes for closest relatives

```sh
nano closest_relative_genomes_salarias_fasciatus.txt

Closest genomes:
1. Salarias fascistus - https://www.ncbi.nlm.nih.gov/genome/7248
2. Parablennius parvicornis - https://www.ncbi.nlm.nih.gov/genome/69445
3. Petroscirtes breviceps - https://www.ncbi.nlm.nih.gov/genome/7247
4. Ecsenius bicolor - https://www.ncbi.nlm.nih.gov/genome/41373
5. Gouania willdenowi - https://www.ncbi.nlm.nih.gov/genome/76090

Used Betancour et al. 2017 (All Blenniiformes)
```

**NOTE:** Sfa has a genome available in GenBank.
