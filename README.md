# Wellcome to the 2022 PIRE Omic's Workshop!

Message

![](https://github.com/Getterrobog/DipterygonotusBalteatus/blob/main/PPP_logo.png)

README for workshop 

[Schedule](https://docs.google.com/spreadsheets/d/17KVHAxO8ihgFinT20YejtroK7-l133fBxTAzXAmE8CM/edit#gid=1010648430)

* Make sure eveyone has access to the HPC

**Git**

Maybe drop files everyday, so they get used to git pull all the time

We will be following the [PIRE SSL pipeline](https://github.com/philippinespire/pire_ssl_data_processing)

[Pre-Processing pipeline](https://github.com/philippinespire/pire_fq_gz_processing)



List of Personnel
|Position |Name | Institution | Contact |
| --- | --- | --- | --- |
| Professor | Kent Carpenter | ODU | cbird@odu.edu |
| Professor | Chris Bird | TAMUCC | kcarpent@odu.edu |
| Postdoc | Eric Garcia | ODU | e1garcia@odu.edu |
| Postdoc | Brendan Reid | Rutgers | br450@sebs.rutgers.edu |
| PhD Student | Rene Clark | Rutgers | rdc129@scarletmail.rutgers.edu |


List of participants

|Position |Name | Institution | Contact |
| --- | --- | --- | --- |
| REU |Abigail Ethridge | ODU | aethr001@odu.edu |
| REU |Eryka Molino | ASU | emolino1230@gmail.com |
| REU |Rebecca Ruiz | TAMUCC | rruiz25@islander.tamucc.edu |
| REU |Allison Fink | Rutgers | agf63@scarletmail.rutgers.edu |
| REU |Marial Malabag | Rutgers | mjm751@scarletmail.rutgers.edu |
| RA | Kevin L. Labrador | UP Mindanao | kllabrador@up.edu.ph |
| RA | Maybelle A. Fortaleza | UP Mindanao | mafortaleza@up.edu.ph |
| RA | Joemarie L. Lanutan | UP Mindanao | jjlanutan@up.edu.ph |
| Professor | Cleto L. Nanola Jr. | UP Mindanao | clnanola@up.edu.ph |
| Ms. Student | Omar Mahadalle | Siliman University | omaramahadalle@su.edu.ph | 
| Ms Student | Abner Bucol | Siliman University | abnerbucol2013@gmail.com
| Ms Student |Chandy | ODU Jablonski | cjabl001@odu.edu |





# SHOTGUN DATA PROCESSING & ANALYSIS

---

The purpose of this repo is to document the processing and analysis of `Shotgun Sequencing Libraries - SSL data` for probe development which then will be processed according to the [Capture Shotgun Sequencing Libraries- CSSL repo](https://github.com/philippinespire/pire_cssl_data_processing). 
 Both SSL and CSSL pipelines use scripts from the [Pre-Processing PIRE Data](https://github.com/philippinespire/pire_fq_gz_processing) repo at the beginning of files processing. 

Each species will get it's own directory within this repo.  Try to avoing putting dirs inside dirs inside dirs. 

The Sgr dir will serve as the example to follow in terms of both directory structure and documentation of progress in `README.md`.

If this is your first time working on wahab/turing or want to check out some tips see the [Working on ODU's HPC repo](https://github.com/philippinespire/denovo_genome_assembly/tree/main/working_in_Turing-Wahab)

Contact Dr. Eric Garcia for questions or if you are having issues running scripts (e1garcia@odu.edu)

---

## Here we go! 

Start the workshop by cloning this repo to your working dir. I recommend setting up a `shotgun_PIRE` sub-dir in your home dir if you have not done something similar already

Example: `/home/youruserID/shotgun_PIRE/`

Clone this repo
```
cd ~ 	# this will take you to your home dir
cd shotgun_PIRE
git clone https://github.com/philippinespire/2022_PIRE_omics_workshop.git
```
*Now you have the files you need to start working!*

Organization is importanat, for the workshop each person will create and work on their own directory. 

**Please Note:** do not use spaces or special characters (such as *#$%^&*~"][)(+'\|=) in the names of files or directory. Stick to letters, numbers, dashes (-), and underscores (_) 

Make your own directory:
```
cd 2022_PIRE_omics_workshop
mkdir <your_name_with_no_spaces>
```

copy any files?


---

## Maintaining Git Repo

You must pull down the latest version of the repo everytime you sit down to work and push the changes you made everytime you walk away from the terminal.  The following order of operations when you sync the repo will minimize problems.

From your species directory, execute these commands manually or run the `runGit.sh` script (see bellow) 
```
git pull
git add --all
git commit -m "$1"
git push -u origin main
```

This code has been compiled into the script `runGIT.bash` thus you can just run this script BEFORE and AFTER you do anything in your species repo.

You will need to provide the message of your commit in the command line. Example:
```sh
bash ../runGIT.bash "initiated my directory"
```
You will need to enter your git credentials multiple times each time you run this script

If you should be met with a conflict screen, you are in the archane `vim` editor.  You can look up instructions on how to interface with it. I typically do the following:

* hit escape key twice
* type the following
  `:quit!`
 
If you had to delete files for whatever reason, 
these deletions occurred in your local directory but these files will remain in the git memory if they had already enter the system.

If you are in this situation, run these git commands manually, AFTER running the runGIT.bash as describe above.

`add -u` will stage your deleled files, then you can commit and push

Run this from the directory where you deleted files:
```sh
git add -u .
git commit -m "update deletions"
git push -u origin main
```

**gitignore**

There is a `.gitignore` file that lists files and directories to be ignored by git.  It includes large files that git cannot handle (fq.gz, bam, etc) 
 and other repos that might be downloaded into this repo.
For example, the BUSCO outdir contains several large files that will cause problems for git so `busco_*/` occurs in  `.gitignore` so that it is not uploaded to github in this repo.

Because large data files will not be saved to github, they will reside in an individual's copy of the repo or somewhere on the HPC.

___

## Data Processing Roadmap

### A. PRE-PRECESSING SEQUENCES

---

#### 1. Set up directories and data

Check your raw files: given that we use paired-end sequencing, you should have one pair of files (1 forward and 1 reverse) per library. This  means that you should have the same number of foward (1.fq.gz or f.fq.gz) and reverse sequence files (2.fq.gz or r.fq.gz).
 If you don't have equal numbers for foward and reverse files, check with whoever provided the data to make sure there was no issues while transferring.

You will likely get 2 or 3 libraries (4 or 6 files total). Sgr example:
```sh
ls -l /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/spratelloides_gracilis/fq

-rwxrwx--- 1 e1garcia carpenter         248 Jul 27 12:37 README
-rwxrwx--- 1 e1garcia carpenter 15652747635 Jul 22 17:19 SgC0072B_CKDL210013395-1a-5UDI294-AK7096_HF33GDSX2_L4_1.fq.gz
-rwxrwx--- 1 e1garcia carpenter 16902243089 Jul 22 17:27 SgC0072B_CKDL210013395-1a-5UDI294-AK7096_HF33GDSX2_L4_2.fq.gz
-rwxrwx--- 1 e1garcia carpenter 13765701672 Jul 22 17:32 SgC0072C_CKDL210013395-1a-AK9146-7UDI286_HF33GDSX2_L4_1.fq.gz
-rwxrwx--- 1 e1garcia carpenter 14786676970 Jul 22 17:39 SgC0072C_CKDL210013395-1a-AK9146-7UDI286_HF33GDSX2_L4_2.fq.gz
-rwxrwx--- 1 e1garcia carpenter 16465437932 Jul 22 17:46 SgC0072D_CKDL210013395-1a-AK5577-AK7533_HF33GDSX2_L4_1.fq.gz
-rwxrwx--- 1 e1garcia carpenter 17698149145 Jul 22 17:54 SgC0072D_CKDL210013395-1a-AK5577-AK7533_HF33GDSX2_L4_2.fq.gz
```

Make a copy of your raw files in the longterm carpenter RC dir **ONLY** if one doesn't exits already (if you copied your data from the RC, a long-term copy already exists)
```sh
cd /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_ssl_data_processing/
mkdir <species_name>
mkdir <species_name>/fq
cp <source of files> /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_ssl_data_processing/<species_name>/fq
```
*The RC drive is only available from the login node (you won't find it after getting a working node, i.e. `salloc`)*

Create your `species dir` and and subdirs `logs` and `fq`. Transfer your raw data into `fq`  (your data will most likely be avaliable in the RC)
*(can take several hours)*

```sh
cd pire_ssl_data_processing
mkdir spratelloides_gracilis 
mkdir spratelloides_gracilis/logs
mkdir spratelloides_gracilis/fq
cp <source of files> spratelloides_gracilis/fq  # scp | cp | mv
```

Now create a `README` in the `fq` dir with the full path to the original copies of the raw files and necessary decoding info to find out from which individual(s) these sequence files came from.


This information is usually provied by Sharon Magnuson in species [slack](https://app.slack.com/client/TMJJ06SH0/CMPKY5C81/thread/CQ9GAAYGY-1627263374.002300) channel

```sh
cd spratelloides_gracilis/fq
nano README.md
```

Example:
```sh
RC to e1garcia
scp <source of files> /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/spratelloides_gracilis/fq

All 3 library sets are from the same individual: Sgr-CMvi_007_Ex1
```

*I like to update my git repo regularly, especially before and after lengthly steps. This keeps a nice record of the commits and prevents loss of data/effor. Feel free to repeat this at any step*

```sh
bash ../../runGIT.bash "README of raw data"
```

***You are ready to start processing files***

---

#### 2. Initial processing

Complete the pre-processing of your files following the [pire_fq_gz_processing](https://github.com/philippinespire/pire_fq_gz_processing) repo, then return here
* This includes running FASTQC, FASTP1, CLUMPLIFY, FASTP2, FASTQ SCREEN, and file repair scripts from the pre-processing repo
___

### B. GENOME ASSEMBLY

---

#### 1. **Genome Properties**

##### 1a. Fetch the genome properties for your species
* From the literature or other sources
	* [genomesize.com](https://www.genomesize.com/)
	* [ncbi genome](https://www.ncbi.nlm.nih.gov/genome/)
	* search the literature
		* Record the size and other potentially important information in your species README if the genome of your species is available
* Estimate properties with `jellyfish` and `genomescope`
	* More details [here](https://github.com/philippinespire/denovo_genome_assembly/blob/main/jellyfish/JellyfishGenomescope_procedure.md)

##### 1b. **Execute [runJellyfish.sbatch](https://github.com/philippinespire/pire_ssl_data_processing/blob/main/scripts/runJellyfish.sbatch) using decontaminated files (couple of hours)**

```sh
cd YOURSPECIESDIR
#sbatch runJellyfish.sbatch <Species 3-letter ID> <indir>
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runJellyfish.sbatch "Sfa" "fq_fp1_clmp_fp2_fqscrn_repaired"
```

Check your queue!
```sh
squeue -u <your_user_ID>
```

Jellyfish will create a histogram file (.histo) with kmer frequencies. 

##### 1c. **Download this file into your local computer and upload it in [GenomeScope v1.0](http://qb.cshl.edu/genomescope/) and [Genomescope v2.0](http://qb.cshl.edu/genomescope/genomescope2.0/) (few minutes)**
* To download, sftp into wahab in a new terminal window and download the histogram file.
```sh
sftp your_user_ID@wahab.hpc.odu.edu
cd YOURSPECIESDIR/   
lpwd  #This is your local working  directory
get fq_fp1_clmp_fp2_fqscrn_repaired/<histofile.histo>
```
* Open the GenomeScope v1-2 and upload file.
* Add a proper description to both of your runs. Example "Sfa_fq_fp1_clmp_fp2_fqscrn_repaired_jfsh_v1" and  "Sfa_fq_fp1_clmp_fp2_fqscrn_repaired_jfsh_v2"
* For version 1, Adjust the read lenght to that of in the Fastp2 trimming, 140 (unless you had to modify this in Fastp2)
* Leave all other parameters with default settings for both versions. 
* Submit (takes only few minutes)
 
##### 1d. **Complete the following table in your Species README. You can copy and paste this table straight into your README (no need to enclose it with quotes, i.e. a code block) and just substitute values.**
```sh
Genome stats for Sfa from Jellyfish/GenomeScope v1.0 and v2.0, k=21 for both versions

version    |stat    |min    |max
------  |------ |------ |------
1  |Heterozygosity  |?%       |?%
2  |Heterozygosity  |?%       |?%
1  |Genome Haploid Length   |? bp |? bp 
2  |Genome Haploid Length   |? bp |? bp
1  |Model Fit       |? %       |? %
2  |Model Fit       |? %       |? %
```
* Provide a link to both reports in your README. See other species READMEs for examples. 

##### 1e. **Inspect your table and reports for red flags and choose a genome scope version.**
* In your table, check the heterozygosity (values around 1% or less are common) and check for good model fit (>90%) in the max values (sometimes the min value might have a low fit for version 2 but this is ok)
* In your reports, check for a tight relationship between the "observed", "full model" and "unique sequences" lines in the first graph.

If values in your table are relative similar for v1 and v2 and you found no red flags in reports, then use v2 estimates.

* **Please use the "Genome Haploid Length" max value rounded up or down to the nearest million** 

Most of the time v1-2 perform very similar. However, sometimes the two reports give contrasting values such as very different genome sizes or unrealistic estimates of heterozygosity.

For example:
* In Sob, the [Sob_GenScp_v1](http://qb.cshl.edu/genomescope/analysis.php?code=zQRfOkSqbDYAGYJrs7Ee) report estimates a genome of 532 Mbp and 0.965 for H. On the other hand,  [Sob_GenScp_v2](http://qb.cshl.edu/genomescope/genomescope2.0/analysis.php?code=5vZKBtdSgiAyFvzIusxT) reports a genome size of 259 Mbp (which is small for a fish) and it actually fails to estimate heterozygosity. Thus, version 1 was used for Sob. 

* In Hte, the [Hte_GenScp_v1](http://qb.cshl.edu/genomescope/analysis.php?code=tHzBW2RjBK00gQMUSfl4) appears to have no red flags with a genome size of 846 Mbp and 0.49 for H but inspecting the first graph, you can see that the "uniqu sequence" line behaves diffently from the others. In contrast, [Hte_GenScp_v2](http://qb.cshl.edu/genomescope/genomescope2.0/analysis.php?code=8eVzhAQ8zSenObScLMGC) restores a tight relationship between lines with no red flags in estimates either (H=2.1, GenSize= 457 Mbp)

***Note the Genome Scope version and rounded genome size estimate in your species README. You will use this info later***

---

#### 2. Assemble the Genomes with SPAdes

Congrats! You are now ready to assemble the genome of your species!

After a comparions of multiple assemblers with PIRE data, we decided to use **SPADES (noisolate and covcutoff-off)**. 

For the most part, we obtained better assemblies using single libraries (a library consists of one forward *r1.fq.gz and reverse file *r2.fq.gz) but in few instances using all the libraries was better.


##### **2a. You need to be in `turing.hpc.odu.edu` for this step.** SPAdes requires high memory nodes (only avail in Turing)

```bash
#from wahab.hpc.odu.edu
exit
ssh userID@turing.hpc.odu.edu
```

Check how many high memory nodes "himem" are available in Turing
```sh
sinfo
```
```sh
PARTITION     AVAIL  TIMELIMIT  NODES  STATE NODELIST
main*            up   infinite      2  inval coreV1-22-019,coreV2-25-005
main*            up   infinite     18  fail* coreV1-22-[006-009,017],coreV2-22-[006,012,033],coreV2-25-[003,008,012,023,025,039,043,055],coreV2-25-knc-[0
main*            up   infinite      2   fail coreV1-22-016,coreV2-25-017
main*            up   infinite      8  down* coreV1-22-028,coreV2-22-[018-020,026],coreV2-25-016,coreV2-25-knc-006,coreV3-23-017
main*            up   infinite     36    mix coreV1-22-[001-003,025,027],coreV2-22-[004,025,036],coreV2-25-[001,004,006,009,011,013-015,018-022,024,038,0
main*            up   infinite     62  alloc coreV1-22-[012-013,015,020-024],coreV2-22-[001-003,005,007-011,013-017,021-024,027-032,034],coreV2-25-[044-0
main*            up   infinite     70   idle coreV1-22-026,coreV2-22-035,coreV2-25-[002,007,010,026-037,048-054,056-073],coreV3-23-[008-016,041-050],core
main*            up   infinite      4   down coreV1-22-[004-005,014,018]
timed-main       up    2:00:00      2  inval coreV1-22-019,coreV2-25-005
timed-main       up    2:00:00     18  fail* coreV1-22-[006-009,017],coreV2-22-[006,012,033],coreV2-25-[003,008,012,023,025,039,043,055],coreV2-25-knc-[0
timed-main       up    2:00:00      2   fail coreV1-22-016,coreV2-25-017
timed-main       up    2:00:00      8  down* coreV1-22-028,coreV2-22-[018-020,026],coreV2-25-016,coreV2-25-knc-006,coreV3-23-017
timed-main       up    2:00:00     36    mix coreV1-22-[001-003,025,027],coreV2-22-[004,025,036],coreV2-25-[001,004,006,009,011,013-015,018-022,024,038,0
timed-main       up    2:00:00     62  alloc coreV1-22-[012-013,015,020-024],coreV2-22-[001-003,005,007-011,013-017,021-024,027-032,034],coreV2-25-[044-0
timed-main       up    2:00:00     70   idle coreV1-22-026,coreV2-22-035,coreV2-25-[002,007,010,026-037,048-054,056-073],coreV3-23-[008-016,041-050],core
timed-main       up    2:00:00      4   down coreV1-22-[004-005,014,018]
himem            up   infinite      1  fail* coreV4-21-himem-001
himem            up   infinite      1   fail coreV2-23-himem-001
himem            up   infinite      1  down* coreV2-23-himem-002
himem            up   infinite      4   idle coreV2-23-himem-[003-004],coreV4-21-himem-[002-003]
timed-himem      up    2:00:00      1  fail* coreV4-21-himem-001
timed-himem      up    2:00:00      1   fail coreV2-23-himem-001
timed-himem      up    2:00:00      1  down* coreV2-23-himem-002
timed-himem      up    2:00:00      4   idle coreV2-23-himem-[003-004],coreV4-21-himem-[002-003]
gpu              up   infinite      1  fail* coreV3-23-k40-006
gpu              up   infinite      1  drain coreV5-21-v100-003
gpu              up   infinite      6    mix coreV3-23-k40-[003-004],coreV4-24-v100-[001,003-004],coreV5-21-v100-002
gpu              up   infinite     12   idle coreV3-23-k40-[005,007-010],coreV4-21-k80-[001-005],coreV4-22-p100-[001-002]
timed-gpu        up    2:00:00      1  fail* coreV3-23-k40-006
timed-gpu        up    2:00:00      1  drain coreV5-21-v100-003
timed-gpu        up    2:00:00      6    mix coreV3-23-k40-[003-004],coreV4-24-v100-[001,003-004],coreV5-21-v100-002
timed-gpu        up    2:00:00      1  alloc coreV5-21-v100-001
timed-gpu        up    2:00:00     12   idle coreV3-23-k40-[005,007-010],coreV4-21-k80-[001-005],coreV4-22-p100-[001-002]
pire             up   infinite      4   idle coreV1-22-[010-011],coreV3-23-k40-[001-002]
reserved-gpu     up   infinite      2   idle coreV4-22-p100-[001-002]
reserved-khan    up   infinite      1  alloc coreV5-21-v100-001
phi              up   infinite      2  fail* coreV2-25-knc-[002,004]
phi              up   infinite      1  down* coreV2-25-knc-006
phi              up   infinite      4    mix coreV2-25-knc-[001,005,008,010]
phi              up   infinite      3  alloc coreV2-25-knc-[003,007,009]
timed-phi        up    2:00:00      2  fail* coreV2-25-knc-[002,004]
timed-phi        up    2:00:00      1  down* coreV2-25-knc-006
timed-phi        up    2:00:00      4    mix coreV2-25-knc-[001,005,008,010]
timed-phi        up    2:00:00      3  alloc coreV2-25-knc-[003,007,009]
MSIM715          up   infinite      4   idle coreV3-23-[001-003],coreV4-24-v100-002
```


##### **2b. Get the genome size of your species, or Jellyfish estimate, in bp from the previous step**
 

We produced 3 libraries (from the same individual) for each spp with ssl data. Sfa example:
```bash
ls /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/shotgun_raw_fq/*gz

Sfa-CBas_028-Ex1-1G_L4_1.fq.gz
Sfa-CBas_028-Ex1-1G_L4_2.fq.gz
Sfa-CBas_028-Ex1-1H_L4_1.fq.gz
Sfa-CBas_028-Ex1-1H_L4_2.fq.gz
Sfa-CBas_028-Ex1-2A_L4_1.fq.gz
Sfa-CBas_028-Ex1-2A_L4_2.fq.gz
```
Yet, every now and then one library can fail and you might end up with only 2 sets of files. 
Thus, the following SPAdes script is optimized to run the first 3 libraries independently and 2 or 3 libraries together for your "all" assembly as needed.
 
Note: If your species has 4 or more libraries, you will need to modify the script to run the 4th,5th,.. library and so on (you'll only need to add the necessary libraries to the SPAdes command).
 No changes necessary for running the first, second, thrid, or all the libraries together (i.e. if you have 2 or 3 libraries only).  

##### **2c. Run SPAdes and QUAST (multiple days)**

* Use the decontaminated files to run one assembly for each of your libraries independently and then one combining all.

Execute [runSPADEShimem_R1R2_noisolate.sbatch](https://github.com/philippinespire/pire_ssl_data_processing/blob/main/scripts/runSPADEShimem_R1R2_noisolate.sbatch). Example using the 1st library:
```bash
cd YOURSPECIESDIR

#runSPADEShimem_R1R2_noisolate.sbatch <your user ID> <3-letter species ID> <library: all_2libs | all_3libs | 1 | 2 | 3> <contam | decontam> <genome size in bp> <species dir> <fq data dir>
# do not use trailing / in paths. Example running contaminated data:
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runSPADEShimem_R1R2_noisolate.sbatch "your_user_ID" "Sfa" "1" "decontam" "?" "/home/your_user_ID/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus" "fq_fp1_clmp_fp2_fqscrn_repaired"
```

Run 2 more assemblies for the second, third, by replacing the "1", with "2" and "3" respectively.
 
Then, check the number of libraries you have and run a job combining all libraries together by choosing the appropiate "all_2libs" or "all_3libs" from the library options.

---

#### 3. Review the output of SPAdes and Info on Assembly Quality from Quast Output.

`runSPADEShimem_R1R2_noisolate.sbatch` names the output directories with the suffix A for the first, B for the second, and C for the third if any. Thus, in this case:
Assembly  |  Library
--- | --- 
A | 1G
B | 1H
C | 2A


For `SPAdes` check that you have:
1. k22-99 directories
2. contigs.fasta and scaffolds.fasta files
3. Open the params.txt files and check the settings ran in SPAdes

`QUAST` was automatically ran by the SPAdes script. Look for the `quast_results` dir and for each of your assemblies check the: 
1. Number of contigs in assembly (this is the last contig column in quast report with the name "# contigs")
2. the size of the largest contig
3. total length of assembly
4. N50
5. L50 

*Tip: you can align the columns of any .tsv for easy viewing with the comand `column` in bash. Example:
```sh
cd your_assembly_dir

bash
cat quast-reports/quast-report_scaffolds_Sgr_spades_contam_R1R2_21-99_isolate-off.tsv | column -ts $'\t' | less -S
```

---

#### 4. Run BUSCO (multiple hours)

Those are basic assembly statistics but we still need to run BUSCO to know how many expected (i.e. highly conserved) genes were recovered by the assembly. 

**Execute [runBUCSO.sh](https://github.com/philippinespire/pire_ssl_data_processing/blob/main/scripts/runBUSCO.sh) on the `contigs` and `scaffolds` files for each assembly**

```bash
cd YOURSPECIESDIR

#runBUSCO.sh <species dir> <SPAdes dir> <contigs | scaffolds>
# do not use trailing / in paths. Example using contigs:
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runBUSCO.sh "/home/your_user_ID/shotgun_PIRE/2022_PIRE_omics_workshop/spratelloides_gracilis" "SPAdes_decontam_R1R2_noIsolate" "contigs"
```

Repeat the comand using contigs and scaffolds for each SPAde assembly.

`runBUSCO.sh` will generate a new dir per run. Look for the `short_summary.txt` file and note the percentage of `Complete and single-copy BUSCOs (S)` genes

---




#### 5. Fill in this table with your QUAST and BUSCO values in your species README. 

Few notes:

* Library name can be obtained from file names
* No. of contigs is the last contig column in quast report with the name "# contigs"
* % Genome size completeness = "Total lenght"/genome size(or rounded genome max value) *100
* **For QUAST, only report the row for the actual assembly (i.e. report "scaffolds" not "scaffolds_broken"**
* **For BUSCO, only report the "Complete and single-copy BUSCOs (S)"**

```sh
Species    |Assembly    |DataType    |SCAFIG    |covcutoff    |genome scope v.    |No. of contigs    |Largest contig    |Total lenght    |% Genome size completeness    |N50    |L50    |Ns per 100 kbp    |BUSCO single copy
------  |------  |------ |------ |------ |------  |------ |------ |------ |------ |------  |------ |------ |------ 
Sgr  |A  |decontam       |contgs       |off       |2       |  ?  |  ?  |   ?  |   ? % |  ?  |  ?  |  ?  |  ? % 
Sgr  |A  |decontam       |scaffolds       |off       |2    |  ?  |  ?  |   ?  |   ? % |  ?  |  ?  |  ?  |  ? % 
Sgr  |B  |decontam       |contgs       |off       |2       |  ?  |  ?  |   ?  |   ? % |  ?  |  ?  |  ?  |  ? % 
Sgr  |B  |decontam       |scaffolds       |off       |2    |  ?  |  ?  |   ?  |   ? % |  ?  |  ?  |  ?  |  ? % 
Sgr  |C  |decontam       |contgs       |off       |2       |  ?  |  ?  |   ?  |   ? % |  ?  |  ?  |  ?  |  ? % 
Sgr  |C  |decontam       |scaffolds       |off       |2    |  ?  |  ?  |   ?  |   ? % |  ?  |  ?  |  ?  |  ? % 
Sgr  |allLibs  |decontam       |contigs       |off       |2    |  ?  |  ?  |   ?  |   ? % |  ?  |  ?  |  ?  |  ? %
Sgr  |allLibs  |decontam       |scaffolds       |off       |2   |  ?  |  ?  |   ?  |   ? % |  ?  |  ?  |  ?  |  ? %
```


---

#### 6. **Determine the best assembly**

We assess quality across multiple metrics since we don't use a golden rule/metric for determing the best assembly. 
Often, it is clear that single libray is relatively better than the others as it would have better results across metrics. Yet, sometimes this is not soo clear as different assemblies might be better in different metrics. Use the following table to help you decide:

Importance    |Metric    |Direction    |Description
------  |------  |------ |------ 
1st  |BUSCO  | Bigger is better  | % of expected genes observed in your assembly
2nd  |N50  |Bigger is better  | Lenght of the smaller contig from the set of contigs needed to reach half of your assembly
3rd  |Genome size completeness  |Bigger is better  |Lenght of assembly divided by estimated genome lenght
4th  |L50  | Smaller is better  | Number of contigs needed to reach half of your assembly
5th  |Largest contig  |Bigger is better  | Lenght of largest contig
 
If you are still undecided on which is the best assembly, post the best candidates on the species slack channel and ask for opinions

**Note what is your best assembly in your species README**


---

#### 7. Assemble contaminated data for best library 

```bash
cd YOURSPECIESDIR

#runSPADEShimem_R1R2_noisolate.sbatch <your user ID> <3-letter species ID> <library: all_2libs | all_3libs | 1 | 2 | 3> <contam | decontam> <genome size in bp> <species dir>
# do not use trailing / in paths. Example running contaminated data:
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runSPADEShimem_R1R2_noisolate.sbatch "e1garcia" "Sgr" "1" "contam" "854000000" "/home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/spratelloides_gracilis"
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runSPADEShimem_R1R2_noisolate.sbatch "your_user_ID" "Sfa" "1" "decontam" "?" "/home/your_user_ID/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus" "fq_fp1_clmp_fp2_fqscrn_repaired"

```

---

#### 9. Update the main assembly stats table with your species

Add a new record for your species/assembly to the [best_ssl_assembly_per_sp.tsv](https://github.com/philippinespire/pire_ssl_data_processing/blob/main/best_ssl_assembly_per_sp.tsv) file

Please note that you cannot paste a tab in nano as it interprets tabs as spaces. This means that you will have to manually enter each column one by one, or copy and paste multiple columns but then change the spaces by a single column to restore the tsv format.

Once done, push your changes to GitHub and confirm the that tsv format is correct by opening the [best_ssl_assembly_per_sp.tsv](https://github.com/philippinespire/pire_ssl_data_processing/blob/main/best_ssl_assembly_per_sp.tsv) that your browser is displaying code but a nice looking table (aligned columns, etc). 

```sh
cd YOURSPECIESDIR

# add your info in a new row
nano ../best_ssl_assembly_per_sp.tsv
```

Next, you need to determine the best assembly to use the decontaminated data. Go on and complete step 9 (below) and come back here after.

--- 

#### **10. Evaluate then either go back to step B2 or  move onto next step**

Assuming you have completed step 9, you now know what library(ies) produced the best assembly. Compare your BUSCO values with that other species (for example, you can check the ["best assembly table"](https://github.com/philippinespire/pire_ssl_data_processing/blob/main/best_ssl_assembly_per_sp.tsv).
If BUSCO values are too low, it might be worth trying the `covcutoff auto` (by changing the datatype variable from "contam" to "contam_covAUTO")

Example:
```bash
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runSPADEShimem_R1R2_noisolate.sbatch "e1garcia" "Sgr" "1" "contam_covAUTO" "854000000" "/home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/spratelloides_gracilis"
```

Finally, run one more assembly using the decontaminated data from the same library(or all together) that produced the best assembly (with or without the covcutoff flag). Sgr example:
```bash
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runSPADEShimem_R1R2_noisolate.sbatch "e1garcia" "Sgr" "3" "decontam" "854000000" "/home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/spratelloides_gracilis"
```

---

### C. PROBE DESIGN

In this section you will identify contigs and regions within contigs to be used as candidate regions to develop the probes from.

Among other output, you will create the following 4 files:
1. *.fasta.masked: The masked fasta file 
2. *.fasta.out.gff: The gff file created from repeat masking (identifies regions of genome that were masked)
3. *_augustus.gff: The gff file created from gene prediction (identifies putative coding regions)
4. *_per10000_all.bed: The bed file with target regions (1 set of 2 probes per target region).

This instructions have been modified from Rene's [de novo assembly probe repo](https://github.com/philippinespire/denovo_genome_assembly/tree/main/WGprobe_creation) 
to best fit this repo

#### 10 Identifying regions for probe development 

From your species directory, make a new dir for the probe design
```sh
mkdir probe_design
```

Copy necessary scripts and the best assembly (i.e. scaffolds.fasta from contaminated data of best assembly) into the probe_design dir (you had already selected the best assembly previously to run the decontaminated data) 

Example:
```sh
cp ../scripts/WGprobe_annotation.sb probe_design
cp ../scripts/WGprobe_bedcreation.sb probe_design
cp SPAdes_SgC0072C_contam_R1R2_noIsolate/scaffolds.fasta probe_design
```

Rename the assembly to reflect the species and parameters used. Format to follows:

<3-letter species code>_scaffolds_<library>_<cotam|decontam>_R1R2_noIsolate_<other treatments, if any>.fasta

To get this info, I usually copy and paste the parameter info from the busco directory:
```sh
# list the busco dirs
ls -d busco_*
# identify the busco dir of the best assembly, copy the treatments (starting with the library)
# Example,the busco dir for the best assembly for Sgr is `busco_scaffolds_results-SPAdes_SgC0072C_contam_R1R2_noIsolate`
# I then provide the species 3-letter code, scaffolds, and copy and paste the parameters from the busco dir after "SPAdes_" 
cd probe_design
mv scaffolds.fasta Sgr_scaffolds_SgC0072C_contam_R1R2_noIsolate.fasta
```

Execute the first script. Example for Sgr:
```sh
#WGprobe_annotation.sb <assembly name> 
sbatch WGprobe_annotation.sb "Sgr_scaffolds_SgC0072C_contam_R1R2_noIsolate.fasta"
```

This will create: 
1. a repeat-masked fasta and gff file (.fasta.masked & .fasta.out.gff)
2. a gff file with predicted gene regions (augustus.gff), and 
3. a sorted fasta index file that will act as a template for the .bed file (.fasta.masked.fai)

I have modified the bed script to set the upper limit automatically. The longest scaffold and upper limit will  printed in the out file after execution.


Execute the second script. Example for Sgr:
```sh
#WGprobe_annotation.sb <assembly name> 
sbatch WGprobe_bedcreation.sb "Sgr_scaffolds_SgC0072C_contam_R1R2_noIsolate.fasta"
```

This will create a .bed file that will be sent for probe creation.
 The bed file identifies 5,000 bp regions (spaced every 10,000 bp apart) in scaffolds > 10,000 bp long.


**Check Upper Limit**

Open your out file and check that the upper limit was set correctly. Record the longest contig, uppper limit used in loop, and the number of identified regions and scaffolds  in your species README. 

The upper limit should be XX7500 (just under longest scaffold length). Ex: if longest scaffold is 88,888, then the upper limit should be 87,500; if longest scaffold is 87,499, then the upper limit should be 77,500.  

Sgr example:
```sh
cat BEDprobes-415039.out


The longest scaffold is 105644
The uppper limit used in loop is 97500
A total of 13063 regions have been identified from 10259 scaffolds
```

Move out files into your species logs dir
```sh
mv *out ../logs
```

#### 11 Closest relatives with available genomes

The last thing to do is to create a text file with links to available genomes from the 5 most closely-related species.

Most likely there won't be genomes available for your targeted species or even genus thus, the easiest way to search is probably to start with the family.
Go to the [NCBI Genome repository](https://www.ncbi.nlm.nih.gov/genome/) and search for the family of your species. If you get more than 5 genomes then search for the genus, but if  you don't, search higher classifications till you get them (i.e. order, class, etc)

Once you get at least 5 genomes, you'll need to figure out the phylogenetic relationships to lists the genomes in order from closest to farthest. 

Seach for phylogenies especific to your group. 
I have uploaded the phylogenies from Betancur et al. BMC Evolutionary Biology (2017) 17:162 for [fish phyla](https://github.com/philippinespire/pire_ssl_data_processing/blob/main/scripts/Betancur2017_phyla.pdf)
 and [fish families](https://github.com/philippinespire/pire_ssl_data_processing/blob/main/scripts/Betancur2017_families.pdf)
 in the scripts repo for your convenience.
These are an excellent resource for high taxonomic groups but only a few species per family are represented. 
Thus, you should also seach for phylogenies especific to your group. If these are not available, use Betancur 


Once your list is ready, create a file in your `probe_design` dir. Example for Sgr:
```sh
nano closest_relative_genomes_Spratelloides_gracilis.txt

1.- Clupea harengus
https://www.ncbi.nlm.nih.gov/genome/15477
2.- Sardina pilchardus
https://www.ncbi.nlm.nih.gov/genome/8239
3.- Tenualosa ilisha
https://www.ncbi.nlm.nih.gov/genome/12362
4.- Coilia nasus
https://www.ncbi.nlm.nih.gov/genome/2646
5.- Denticeps clupeoides
https://www.ncbi.nlm.nih.gov/genome/7889
```

## Files to Send

Share the following files with Arbor Bio to aid in probe creation:

1. The repeat-masked fasta file (.fasta.masked)
2. The gff file with repeat-masked regions (.fasta.out.gff)
3. The gff file with predicted gene regions (.augustus.gff)
4. The bed file (.bed)
5. The text file with links to available genomes from the 5 most closely-related species.

Make a dir name "files_for_ArborSci" inside your probe_design dir and move these files there:
```sh
mkdir files_for_ArborSci
mv *.fasta.masked *.fasta.out.gff *.augustus.gff *bed closest* files_for_ArborSci
```

Finally, notify Eric by email (e1garcia@odu.edu)  saying that your files are ready and post a message in the slack species channel with the probe region and scaffold info (from your BEDprobe*out file), and the full path to your files. Sgr example:
```sh
Probe Design Files Ready

A total of 13063 regions have been identified from 10259 scaffolds. The longest scaffold is 105644. 

Files for Arbor Bio:
ls /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/spratelloides_gracilis/probe_design/files_for_ArborSci

Sgr_scaffolds_SgC0072C_contam_R1R2_noIsolate.fasta.augustus.gff
Sgr_scaffolds_SgC0072C_contam_R1R2_noIsolate.fasta.masked
Sgr_scaffolds_SgC0072C_contam_R1R2_noIsolate.fasta.out.gff
Sgr_scaffolds_SgC0072C_contam_R1R2_noIsolate_great10000_per10000_all.bed
closest_relative_genomes_Spratelloides_gracilis.txt
```

Eric will then share these with Arbor BioSciences.

#### **Finito!!!**

#### **Contrats! You have finished the ssl processing pipeline. Go ahead, give yourself a pat on the back!**

---

## Cleaning Up

The SSL pipeline creates multiple copies of your data in the form of intermediate files. Assuming that you have finished the pipeline
 (have checked your files and send probe info to Arbor Bio), it is now time to do some cleaning up

Document the size of directories and files before cleaning up and save this to a file name <your species 3-letter ID>_ssl_beforeDeleting_IntermFiles 

From your species dir:
```sh
du -h | sort -rh > <yourspecies>_ssl_beforeDeleting_IntermFiles
# Sgr example Sgr_ssl_beforeDeleting_IntermFiles
```

### Make a copy of important files 
Before deleting files, make a copy of important files in the RC (only available in the login node):

1. raw sequence files (this should had been done already but check again)
2. "contaminated" files (fq_fp1_clmp_fp2)
3. "decontaminated" files (fq_fp1_clmp_fp2_fqscrn_repaired)
4. best assembly (probably just the contigs.fasta and scaffolds.fasta for contam and decontam of best assembly)

Example for Sgr
```sh
# check for copy of raw files
ls /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_ssl_data_processing/spratelloides_gracilis/fq

# make copy of contaminated and decontaminated files
cp -R fq_fp1_clmp_fp2 /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_ssl_data_processing/<your species>/
cp -R fq_fp1_clmp_fp2_fqscrn_repaired /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_ssl_data_processing/<your species>/               

# make a copy of fasta files for best assembly (SgC0072C for Sgr)
mkdir /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_ssl_data_processing/<your species>/SPAdes_SgC0072C_contam_R1R2_noIsolate
mkdir /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_ssl_data_processing/<your species>/SPAdes_SgC0072C_decontam_R1R2_noIsolate
cp SPAdes_SgC0072C_contam_R1R2_noIsolate/[cs]*.fasta /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_ssl_data_processing/<your species>/SPAdes_SgC0072C_contam_R1R2_noIsolate
cp SPAdes_SgC0072C_decontam_R1R2_noIsolate/[cs]*.fasta /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_ssl_data_processing/<your species>/SPAdes_SgC0072C_decontam_R1R2_noIsolate
```

### Delete unneeded files
Delete raw sequence files and other sequence files (fq.gz | fastq.gz) from intermediate processes (Fastp1, Clumpify, and Fastq Screen; steps 0, 2, and 5). Keep files from fq_fp1_clmp_fp2 and fq_fp1_clmp_fp2_fqscrn_repaired for now.

It is a good idea to keep track of the files you are deleting

An easy way to do this is to list files to be deleted, copy the info and paste it into log file tracking the files you are deleting
```sh
ls -l fq/*fq.gz
# copy from the line of the command to the last file and paste it while creating the log file 
nano deleted_files_log
# paste
/home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/spratelloides_gracilis/fq/
-rwxr-x--- 1 e1garcia carpenter  15G Aug  2 12:12 SgC0072B_CKDL210013395-1a-5UDI294-AK7096_HF33GDSX2_L4_1.fq.gz
-rwxr-x--- 1 e1garcia carpenter  16G Aug  2 12:30 SgC0072B_CKDL210013395-1a-5UDI294-AK7096_HF33GDSX2_L4_2.fq.gz
-rwxr-x--- 1 e1garcia carpenter  13G Aug  2 12:45 SgC0072C_CKDL210013395-1a-AK9146-7UDI286_HF33GDSX2_L4_1.fq.gz
-rwxr-x--- 1 e1garcia carpenter  14G Aug  2 13:01 SgC0072C_CKDL210013395-1a-AK9146-7UDI286_HF33GDSX2_L4_2.fq.gz
-rwxr-x--- 1 e1garcia carpenter  16G Aug  2 13:19 SgC0072D_CKDL210013395-1a-AK5577-AK7533_HF33GDSX2_L4_1.fq.gz
-rwxr-x--- 1 e1garcia carpenter  17G Aug  2 13:36 SgC0072D_CKDL210013395-1a-AK5577-AK7533_HF33GDSX2_L4_2.fq.gz
```

Append the info of the rest of files to be deleted into the same file. At the end you'll have something similar to the Sgr [deleted_files_log]() 


Finally, document the new size of your directories

From your species dir:
```sh
du -h | sort -rh > <yourspecies>_ssl_afterDeleting_IntermFiles
```

For Sgr, I deleted about 1Tb of data! (I create many treatments while making the SSL pipeline. You will likely delete less than that but still a substancial amount)


Move the cleaning files into the logs dir
```sh
mv Sgr_ssl* logs
mv deleted_files_log logs
```

## Next steps: PSMC

Now that we have a reference genome, what can we do with it? Follow the [PSMC](https://github.com/philippinespire/2022_PIRE_omics_workshop/tree/main/salarias_fasciatus/PSMC) link to learn how we can use genomic data from a single individual to infer demographic history! 

