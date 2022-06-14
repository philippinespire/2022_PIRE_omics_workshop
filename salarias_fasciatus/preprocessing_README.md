# Pre-Processing PIRE Data

List of steps to take in raw fq files from shotgun

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
* [runFASTP_2_ssl.sbatch](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFASTP_2_ssl.sbatch) | [runFASTP_2_cssl.sbatch](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFASTP_2_cssl.sbatch)
* [runFQSCRN_6.bash](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFQSCRN_6.bash)
* [runREPAIR.sbatch](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runREPAIR.sbatch)

	* open scripts for usage instructions
	* review the outputs from `fastp` and `fastq_screen` with `multiqc` output, which is already set to run after these steps

---

## **00. Set up directories and data**

Check your raw files: given that we use paired-end sequencing, you should have one pair of files (1 forward and 1 reverse) per library. This means that you should hav the same number of forward (1.fq.gz or f.fq.gz) and reverse squence files (2.fq.gz or r.fq.gz). If you don't have equal numbers for forward and reverse files, check with whoever provided the data to make sure there were no issues while transferring.

Create your `species dir` and subdirs `logs` and `shotgun_raw_fq`. Transfer your raw data into `shotgun_raw_fq` if necessary.

```
#Example
cd pire_ssl_data_processing
mkdir spratelloides_gracilis
mkdir spratelloides_gracilis/logs
mkdir spratelloides_gracilis/shotgun_raw_fq

cp <source of files> spratelloides_gracilis/shotgun_raw_fq #scp | cp |mv
```

Now create a `README` in the `shotgun_raw_fq` dir with the full path to the original copies of the raw files and necessary decoding info to find out from which individual(s) these sequence files came from.

This information is usually provided by Sharon Magnuson in the species slack channel.

```
#Example
cd spratelloides_gracilis/shotgun_raw_fq
nano README.md
```

## 0. **Rename the raw fq.gz files (<1 minute run time)**


Make sure you check and edit the decode file as necessary so that the following naming format is followed:

`PopSampleID_LibraryID` where,

`PopSampleID` = `3LetterSpeciesCode-CorA3LetterSiteCode`, and 

`LibraryID` = `IndiviudalID-Extraction-PlateAddress`  or just `IndividualID` if there is only 1 library for the individual. Do not use `_` in the LibraryID

Examples of compatible names:

`Sne-CTaw_051-Ex1-3F`  or `Sne-CTaw_051` or `Sne-CTaw_051b`

Then, use the decode file to rename your raw `fq.gz` files. If you make a mistake here, it could be catastrophic for downstream analyses.  [`renameFQGZ.bash`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/renameFQGZ.bash) allows you to view what the files will be named before renaming them and also stores the original and new file names in files that could be used to restore the original file names.

```bash
cd YOURSPECIESDIR/shotgun_raw_fq

bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash NAMEOFDECODEFILE.tsv 
```

After you are satisfied that the orginal and new file names are correct, then you can change the names.  This script will ask you twice whether you want to proceed with renaming.

```bash
cd YOURSPECIESDIR/shotgun_raw_fq

bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash NAMEOFDECODEFILE.tsv rename
```

---

## **1. Check the quality of your data. Run `fastqc` (1-2 hours run time)**

Fastqc and then Multiqc can be run using the [Multi_FASTQC.sh](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/Multi_FASTQC.sh) script.

Execute `Multi_FASTQC.sh` while providing, in quotations and in this order, 
(1) the FULL path to these files and (2) a suffix that will identify the files to be processed. 

```sh
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "PATHTOYOURSPECIESDIR/shotgun_raw_fq" "fq.gz"   
```

If you get a message about not finding "crun" then load the containers in your current session and run `Multi_FASTQC.sh` again

```bash
enable_lmod
module load parallel
module load container_env multiqc
module load container_env fastqc

sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "PATHTOYOURSPECIESDIR/shotgun_raw_fq" "fq.gz"   
```

*(can take several hours)*
  * review results with `multiqc` output

---

## **2. First trim. Execute [`runFASTP_1st_trim.sbatch`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFASTP_1st_trim.sbatch) (0.5-3 hours run time)**

```bash
cd YOURSPECIESDIR

#sbatch runFASTP_1st_trim.sbatch <INDIR/full path to files> <OUTDIR/full path to desired outdir>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_1st_trim.sbatch shotgun_raw_fq fq_fp1
```

---

## **3. Remove duplicates. Execute [`runCLUMPIFY_r1r2_array.bash`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runCLUMPIFY_r1r2_array.bash) (0.5-3 hours run time)**

The max # of nodes to use at once should **NOT** exceed the number of pairs of r1-r2 files to be processed. (Ex: If you have 3 pairs of r1-r2 files, you should only use 3 nodes at most.) If you have many sets of files, you might also limit the nodes to the current number of idle nodes to avoid waiting on the queue (run `sinfo` to find out # of nodes idle in the main partition)

```bash
cd YOURSPECIESDIR

#runCLUMPIFY_r1r2_array.bash <indir;fast1 files > <outdir> <tempdir> <max # of nodes to use at once>
# do not use trailing / in paths. Example:
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmp /scratch/YOURUSERNAME 3
```

After completion, run `checkClumpify.R` to see if any files failed
```bash
cd YOURSPECIESDIR

enable_lmod
module load container_env mapdamage2
crun R < checkClumpify_EG.R --no-save

# if the previous line returns an error that tidyverse is missing then do the following
crun R

# you are now in the R environment (there should be a > rather than $), install tidyverse
install.packages("tidyverse")
# when prompted, type "yes"

# when the install is complete, exit R with the following keystroke combo: ctrl-d
# type "no" when asked about saving the environment

# you are now in the shell environment and you should be able to run the checkClumpify script
crun R < checkClumpify_EG.R --no-save
```
If all files were successful, `checkClumpify_EG.R` will return "Clumpify Successfully worked on all samples". 

If some failed, the script will also let you know. Try raising "-c 20" to "-c 40" in `runCLUMPIFY_r1r2_array.bash` and run clumplify again

Also look for this error "OpenJDK 64-Bit Server VM warning:
INFO: os::commit_memory(0x00007fc08c000000, 204010946560, 0) failed; error='Not enough space' (errno=12)"

If the array set up doesn't work. Try running Clumpify on a turing himem node, see the [cssl repo](https://github.com/philippinespire/pire_cssl_data_processing/tree/main/scripts) for details.

---

## **4. Second trim. Execute `runFASTP_2.sbatch` (0.5-3 hours run time)**

If you are going to assemble a genome with this data, use  [runFASTP_2_ssl.sbatch](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFASTP_2_ssl.sbatch). Modify the script name in the code blocks below as necessary 

```bash
cd YOURSPECIESDIR

#sbatch runFASTP_2.sbatch <INDIR/full path to cumplified files> <OUTDIR/full path to desired outdir>
# do not use trailing / in paths. Example:
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_2_ssl.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```

---

## **5. Decontaminate files. Execute [`runFQSCRN_6.bash`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFQSCRN_6.bash) (several hours run time)**

Check the number of available nodes `sinfo` (i.e. nodes in idle in the main partition).
 Try running one node per fq.gz file if possilbe or how many nodes are available. Here, the number of nodes running simultaneously should **NOT** exceed the number of fq.gz files (ex: 3 r1-r2 fq.gz pairs = 6 nodes max).
* ***NOTE: you are executing the bash not the sbatch script***
* ***This can take up to several days depending on the size of your dataset. Plan accordingly***

```sh
cd YOURSPECIESDIR

#runFQSCRN_6.bash <indir> <outdir> <number of nodes running simultaneously>
# do not use trailing / in paths. Example:
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 6
```

Confirm that all files were successfully completed.

```sh
cd YOURSPECIESDIR

# fastqscreen generates 5 files (*tagged.fastq.gz, *tagged_filter.fastq.gz, *screen.txt, *screen.png, *screen.html) for each input fq.gz file
#check that all 5 files were created for each file: 
ls fq_fp1_clmp_fp2_fqscrn/*tagged.fastq.gz | wc -l
ls fq_fp1_clmp_fp2_fqscrn/*tagged_filter.fastq.gz | wc -l 
ls fq_fp1_clmp_fp2_fqscrn/*screen.txt | wc -l
ls fq_fp1_clmp_fp2_fqscrn/*screen.png | wc -l
ls fq_fp1_clmp_fp2_fqscrn/*screen.html | wc -l

# for each, you should have the same number as the number of input files (number of fq.gz files)

#You should also check for errors in the *out files:
# this will return any out files that had a problem

#do all out files at once
grep 'error' slurm-fqscrn.*out
grep 'No reads in' slurm-fqscrn.*out

# or check individuals files <replace JOBID with your actual job ID>
grep 'error' slurm-fqscrn.JOBID*out
grep 'No reads in' slurm-fqscrn.JOBID*out
```
If you see missing indiviudals or categories in the multiqc output, there was likely a ram error. I'm not sure if the "error" search term catches it.

Run the files that failed again. This seems to work in most cases

```sh
cd YOURSPECIESDIR

#runFQSCRN_6.bash <indir> <outdir> <number of nodes to run simultaneously> <fq file pattern to process>
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 1 LlA01010*r1.fq.gz
```

---

## **6. Execute [`runREPAIR.sbatch`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runREPAIR.sbatch) (<1 hour run time)**

```
cd YOURSPECISDIR

#runREPAIR.sbatch <indir> <outdir> <threads>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runREPAIR.sbatch fq_fp1_clmp_fp2_fqscrn fq_fp1_clmp_fp2_fqscrn_repaired 40
```

---

## **7. Calculate the percent of reads lost in each step**

Execute [read_calculator_ssl.sh](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/read_calculator_ssl.sh)
```sh
cd YOURSPECIESDIR

#read_calculator_ssl.sh <Path to species home dir> 
# do not use trailing / in paths. Example:
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/read_calculator_ssl.sh "/home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/spratelloides_gracilis"
```

`read_calculator_ssl.sh` counts the number of reads before and after each step in the pre-process of ssl data and creates the dir `reprocess_read_change` with the following 2 tables:
1. `readLoss_table.tsv` which reporsts the step-specific percent of read loss and final accumulative read loss
2. `readsRemaining_table.tsv` which reports the step-specific percent of read loss and final accumulative read loss

Inspect these tables and revisit steps if too much data was lost

## **8. Clean Up

Move the `.out` files into the `logs` dir after each step is completed:

```sh
mv *out /home/youruserID/shotgun_PIRE/pire_ssl_data_processing/YOURSPECIESDIR/logs
```

Be sure to update your readme file so that others know what happened in your directory. Ideally, somebody should be able to replicate what you did exactly.
