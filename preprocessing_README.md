# Pre-Processing PIRE Data

List of steps to process raw `fq.gz` files from shotgun sequencing. Written specifically for the 2022 PIRE Omics Workshop.

---

## Before You Start, Read This

The purpose of this README is to provide the steps for processing raw fq files for [Shotgun Sequencing Libraries - SSL data](https://github.com/philippinespire/pire_ssl_data_processing) for probe development.

To run scripts you can add the full path (to the directory which already includes all of them) before the script's name.

```sh
#add this path when running scripts
/home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/<script's name>

#Example:
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh <script arguments>
```

---

## Overview

***Trim, deduplicate, decontaminate, and repair the raw `fq.gz` files***
*(few hours for each of the 2 trims and deduplication, decontamination can take 1-2 days; repairing is done in 1-2 hrs)*

Scripts to run

* [renameFQGZ.bash](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/renameFQGZ.bash)
* [Multi_FASTQC.sh](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/Multi_FASTQC.sh)
* [runFASTP_1st_trim.sbatch](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFASTP_1st_trim.sbatch)
* [runCLUMPIFY_r1r2_array.bash](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runCLUMPIFY_r1r2_array.bash)
* [runFASTP_2_ssl.sbatch](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFASTP_2_ssl.sbatch)
* [runFQSCRN_6.bash](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFQSCRN_6.bash)
* [runREPAIR.sbatch](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runREPAIR.sbatch)

	* open scripts for usage instructions
	* review the outputs from `fastp` and `fastq_screen` with `multiqc` output, which is already set to run after these steps

---

## **00. Set up directories and data**

Before we start running any jobs, we first need to make sure we have all the data! This means checking your raw files: given that we use paired-end sequencing, you should have one pair of files (1 forward and 1 reverse) per library. Thus, you should hav the same number of forward (1.fq.gz or f.fq.gz) and reverse squence files (2.fq.gz or r.fq.gz). If you don't have equal numbers for forward and reverse files, check with whoever provided the data to make sure there were no issues while transferring.

Create your `species dir` and subdirs `logs` and `shotgun_raw_fq`. Transfer your raw data into `shotgun_raw_fq` if necessary.
  * For the workshop, your `species dir` will just be your workshop directory (`2022_PIRE_omics_workshop/your_name`). You will not be transferring any raw data to this directory.

```
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name #normally this would be ~/shotgun_PIRE and then you would make your species dir here (mkdir species_name)

mkdir logs #normally this would be species_name/logs
mkdir shotgun_raw_fq

cp <source of files> ./shotgun_raw_fq #you will NOT do this for the workshop
```

Now create a `README` in the `shotgun_raw_fq` dir with the full path to the original copies of the raw files and necessary decoding info to find out from which individual(s) these sequence files came from.

This information is usually provided by Sharon Magnuson in the species slack channel.

```
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name/shotgun_raw_fq
cp ../../salarias_fasciatus/shotgun_raw_fq/README.md #for the workshop you will just copy this from the example salarias_fasicatus directory
```

---

## **0. Rename the raw fq.gz files (<1 minute run time)**

We need to rename the raw files from the sequencer to match our project naming convention. In the previous step, when you copied the raw `fq.gz` files over, you also copied the "decode" file (`*Decode.tsv`). This file tells us which species, population, extraction, etc. each library came from. We normally use this decode file to then rename the raw files. 

**FOR THE WORKSHOP, WE WILL DEMONSTRATE THIS STEP AS A GROUP. YOU DO NOT NEED TO DO THIS INDIVIDUALLY.**

Make sure you check and edit the decode file as necessary so that the following naming format is followed:

`PopSampleID_LibraryID` where,

`PopSampleID` = `3LetterSpeciesCode-CorA3LetterSiteCode`, and 

`LibraryID` = `IndiviudalID-Extraction-PlateAddress`  or just `IndividualID` if there is only 1 library for the individual. Do not use `_` in the LibraryID

Examples of compatible names:

`Sne-CTaw_051-Ex1-3F`  or `Sne-CTaw_051` or `Sne-CTaw_051b`

Then, use the decode file to rename your raw `fq.gz` files. If you make a mistake here, it could be catastrophic for downstream analyses.  [`renameFQGZ.bash`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/renameFQGZ.bash) allows you to view what the files will be named before renaming them and also stores the original and new file names in files that could be used to restore the original file names.

```bash
cd YOURSPECIESDIR/shotgun_raw_fq

#bash renameFQGZ.bash <decode file>
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash NAMEOFDECODEFILE.tsv 
```

After you are satisfied that the orginal and new file names are correct, then you can change the names.  This script will ask you twice whether you want to proceed with renaming.

```bash
cd YOURSPECIESDIR/shotgun_raw_fq

#bash renameFQGZ.bash <decode file> rename
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash NAMEOFDECODEFILE.tsv rename
#will need to say "yes" 2X
```

---

## **1. Check the quality of your data. Run `fastqc` (1-2 hours run time)**

Fastqc and then Multiqc can be run using the [`Multi_FASTQC.sh`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/Multi_FASTQC.sh) script. For the workshop **ONLY** we will run [`Multi_FASTQC_wkshp.sh`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/Multi_FASTQC_wkshp.sh) instead.

Execute `Multi_FASTQC_wkshp.sh` while providing, in quotations and in this order, 
(1) the FULL path to these files, (2) th FULL path to the directory you want the output files to go, and (3) a suffix that will identify the files to be processed. 

```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name/shotgun_raw_fq

#sbatch Multi_FASTQC_wkshp.sh "<indir>" "<outdir>" "<file extension>"
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC_wkshp.sh "/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/shotgun_raw_fq" "~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name/shotgun_raw_fq" "fq.gz"   
```

If you get a message about not finding "crun" then load the containers in your current session and run `Multi_FASTQC.sh` again

```bash
enable_lmod
module load parallel
module load container_env multiqc
module load container_env fastqc

sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC_wkshp.sh "/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/shotgun_raw_fq" "~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name/shotgun_raw_fq" "fq.gz" 
```

 Review the `multiqc` output (`shotgun_raw_fq/fastqc_report.html`).
  * How much duplication was there?
  * What is the GC content for each library? Does this look reasonable? (*Hint: typically we see GC content between 44-48%*)  
  * What is the % adaptor?
  * How many reads/library?

---

## **2. First trim. Execute [`runFASTP_1st_trim.sbatch`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFASTP_1st_trim.sbatch) (0.5-3 hours run time)**

Normally, you would have copied the raw files to the `shotgun_raw_fq` directory, renamed them, and then used that as the input for the first trim. For the workshop, we are not copying the raw files. Thus your input (indir) will point to the example *Salarias fasciatus* directory instead.

```bash
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

#sbatch runFASTP_1st_trim.sbatch <INDIR/full path to files> <OUTDIR/full path to desired outdir>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_1st_trim.sbatch /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/shotgun_raw_fq fq_fp1
```

Review the results with the `fastqc` output (`fq_fp1/1st_fastp_report.html`). You may have to come back to this step later on in the workshop.
  * Has the amount of duplication changed?
  * Has the GC content changed?  
  * What percentage of reads passed the first round of filtering?
  * How many reads/library now?

---

## **3. Remove duplicates. Execute [`runCLUMPIFY_r1r2_array.bash`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runCLUMPIFY_r1r2_array.bash) (0.5-3 hours run time)**

Normally, you would run this on the output from the first trim. However, to speed things up for the workshop, you will run this on the fq.gz files created from the first trim in the sample *Salarias fasciatus* directory.

The max # of nodes to use at once should **NOT** exceed the number of pairs of r1-r2 files to be processed. (Ex: If you have 3 pairs of r1-r2 files, you should only use 3 nodes at most.) If you have many sets of files, you might also limit the nodes to the current number of idle nodes to avoid waiting on the queue (run `sinfo` to find out # of nodes idle in the main partition).

```bash
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

#bash runCLUMPIFY_r1r2_array.bash <indir> <outdir> <tempdir> <max # of nodes to use at once>
#do not use trailing / in paths
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runCLUMPIFY_r1r2_array.bash /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/fq_fp1 fq_fp1_clmp /scratch/YOURUSERNAME 3
```

After completion, run `checkClumpify_EG.R` to see if any files failed. You may have to come back to this step later on in the workshop.

```bash
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

salloc #because R is interactive and takes a decent amount of memory, we want to grab an interactive node to run this
enable_lmod
module load container_env mapdamage2
crun R < checkClumpify_EG.R --no-save
exit #to relinquish the interactive node

#if the previous line returns an error that tidyverse is missing then do the following
crun R

#you are now in the R environment (there should be a > rather than $), install tidyverse
install.packages("tidyverse")
#when prompted, type "yes"

#when the install is complete, exit R with the following keystroke combo: ctrl-d
#type "no" when asked about saving the environment

#you are now in the shell environment and you should be able to run the checkClumpify script
crun R < checkClumpify_EG.R --no-save
```

If all files were successful, `checkClumpify_EG.R` will return "Clumpify successfully worked on all samples". 

If some failed, the script will also let you know. Try raising the number of nodes used (ex: "-c 20" to "-c 40") and run clumplify again.

Also look for this error *"OpenJDK 64-Bit Server VM warning:
INFO: os::commit_memory(0x00007fc08c000000, 204010946560, 0) failed; error='Not enough space' (errno=12)"*.

If the array set up doesn't work try running Clumpify on a Turing himem node (see the [cssl repo](https://github.com/philippinespire/pire_cssl_data_processing/tree/main/scripts) for details).

**STOP HERE FOR MERIENDA.**

---

## **4. Second trim. Execute `runFASTP_2_ssl.sbatch` (0.5-3 hours run time)**

Normally, you would run this on the output from clumpify. However, to speed things up for the workshop, you will run this on the fq.gz files created from clumpify in the sample *Salarias fasciatus* directory.

For pre-processing for genome assembly, use  [runFASTP_2_ssl.sbatch](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFASTP_2_ssl.sbatch).

```bash
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

#sbatch runFASTP_2_ssl.sbatch <indir> <outdir>
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_2_ssl.sbatch /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/fq_fp1_clmp fq_fp1_clmp_fp2
```

Review the results with the `fastqc` output (`fq_fp1_clmp_fp2/2nd_fastp_report.html`). You may have to come back to this step later on in the workshop.
  * Has the amount of duplication changed? Why do you think it is so much lower now than before?
  * Has the GC content changed?  
  * What percentage of reads passed the second round of filtering? Do you think this is a good percentage?
  * How many reads/library now? Why do you think this changed?

---

## **5. Decontaminate files. Execute [`runFQSCRN_6.bash`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFQSCRN_6.bash) (several hours run time)**

Normally, you would run this on the output from the second trim. However, to speed things up for the workshop, you will run this on the fq.gz files created from the second trim in the sample *Salarias fasciatus* directory. Y

Try running one node per fq.gz file if possible. Here, the number of nodes running simultaneously should **NOT** exceed the number of fq.gz files (ex: 3 r1-r2 fq.gz pairs = 6 nodes max).
  * ***NOTE: you are executing the bash not the sbatch script***

```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

#bash runFQSCRN_6.bash <indir> <outdir> <number of nodes running simultaneously>
#do not use trailing / in paths
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 6
```

Confirm that all files were successfully completed. You may have to come back to this later in the workshop.

```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

#fastqscreen generates 5 files (*tagged.fastq.gz, *tagged_filter.fastq.gz, *screen.txt, *screen.png, *screen.html) for each input fq.gz file
#check that all 5 files were created for each file: 
ls fq_fp1_clmp_fp2_fqscrn/*tagged.fastq.gz | wc -l
ls fq_fp1_clmp_fp2_fqscrn/*tagged_filter.fastq.gz | wc -l 
ls fq_fp1_clmp_fp2_fqscrn/*screen.txt | wc -l
ls fq_fp1_clmp_fp2_fqscrn/*screen.png | wc -l
ls fq_fp1_clmp_fp2_fqscrn/*screen.html | wc -l

#for each, you should have the same number as the number of input files (number of fq.gz files)

#You should also check for errors in the *out files:
#this will return any out files that had a problem

#do all *out files at once
grep 'error' slurm-fqscrn.*out
grep 'No reads in' slurm-fqscrn.*out

#or check individuals files <replace JOBID with your actual job ID>
grep 'error' slurm-fqscrn.JOBID*out
grep 'No reads in' slurm-fqscrn.JOBID*out
```

Once fastqscreen has **finished** running AND you have made sure there are no issues, run [`runMULTIQC.sbatch`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runMULTIQC.sbatch) to get the multiqc output.

Review the results with the `fastqc` output (`fq_fp1_clmp_fp2_fqscrn/fastqc_screen_report.html`). You may have to come back to this step later on in the workshop.
  * What percentage of reads hit to bacteria genomes?
  * What percentage of reads hit to virus genomes? Prokaryotes?
  * What percentage of reads hit to the human genome?

```
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

#sbatch runMULTIQC.sbatch <indir> <report name>
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runMULTIQC.sbatch fq_fp1_clmp_fp2_fqscrn fastqc_screen_report
```

If you see missing individuals or categories in the multiqc output, there was likely a RAM error. The "error" search term may not always catch it.

Run the files that failed again. This seems to work in most cases:

```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

#bash runFQSCRN_6.bash <indir> <outdir> <number of nodes to run simultaneously> <fq file pattern to process>
#do not use trailing / in paths. Example:
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 1 LlA01010*r1.fq.gz
```

---

## **6. Execute [`runREPAIR.sbatch`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runREPAIR.sbatch) (<1 hour run time)**

Normally, you would run this on the output from fastqscreen. However, to speed things up for the workshop, you will run this on the fq.gz files created from fastqscreen in the sample *Salarias fasciatus* directory.

```
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

#sbatch runREPAIR.sbatch <indir> <outdir> <threads>
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runREPAIR.sbatch /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/fq_fp1_clmp_fp2_fqscrn fq_fp1_clmp_fp2_fqscrn_repaired 40
```

Once repair has **finished**, run Fastqc-Multiqc separately.

```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name/fq_fp1_clmp_fp2_fqscrn_repaired

#sbatch Multi_FASTQC.sh <indir> <file extension>
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name/fq_fp1_clmp_fp2_fqscrn_repaired" "fq.gz"   
```

Review the results with the `fastqc` output (`fq_fp1_clmp_fp2_repaired/fastqc_report.html`). You may have to come back to this step later on in the workshop.
  * Has the amount of duplication changed?
  * Has the GC content changed?  
  * How many reads/library now?

**STOP HERE AT THE END OF DAY 1.**

---

## **7. Calculate the percent of reads lost in each step**

**WE WILL NOT DO THIS FOR THE WORKSHOP.**
 
Execute [read_calculator_ssl.sh](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/read_calculator_ssl.sh). **ALL jobs must be finished in order for this to work!!**

```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

#sbatch read_calculator_ssl.sh <Path to species home dir> 
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/read_calculator_ssl.sh "~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name"
```

`read_calculator_ssl.sh` counts the number of reads before and after each step of pre-process the ssl data and creates the dir `preprocess_read_change` with the following 2 tables:
1. `readLoss_table.tsv` which reports the step-specific percentage of reads lost and the final cumulative percentage of reads lost.
2. `readsRemaining_table.tsv` which reports the step-specific percentage of reads that remain and the final cumulative percentage of reads that remain.

Inspect these tables and revisit any steps where too much data was lost.
  * Which step lost the most reads?
  * Which step lost the least?

## **8. Clean Up

**WE WILL NOT DO THIS FOR THE WORKSHOP.**

Make sure all the `.out` files have been moved into the `logs` directory.

```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

mv *out logs/
```

Be sure to update your README file so that others know what happened in your directory. Ideally, somebody should be able to replicate what you did exactly.

---

# Review Your Output

For Day 2, we will go back and look at the output you created from all the jobs/steps you ran during Day 1. Basically, we are going to open up the MultiQC/FastQC output from each of the pre-processing steps and see what has changed each time. We will assess how levels of duplication changed, how many reads passed each of our filtering steps, and how much contamination we had, among other things.

As you are reviewing your output, you will also fill out this [google form](https://forms.gle/NWo9HSr3MdCoj2tW8). We will review these questions at the end of our session today!

If your jobs have finished running, you can either download the MultiQC/FastQC output you created OR use the "pre-cooked" MultiQC/FastQC output on GitHub if your jobs failed.

To transfer files to your own computer (from a Mac):

```
#open up Terminal

sftp your_user_name@wahab.hpc.odu:PATH_TO_YOUR_FILE  local_path
```

On a PC, use r-sync.

To use the pre-cooked files, just click on the link in the Google Form, click "View Raw", and then add [https://htmlpreview.github.io/?](https://htmlpreview.github.io/?) to the beginning of the URL to make it look beautiful on your browser.

If you finish early, you can also update your README on GitHub as well! Much of the information we ask for in the google form is the same as you enter on the README.
