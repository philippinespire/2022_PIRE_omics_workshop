# **Welcome to the 2022 PIRE Omics Workshop!**

![](https://github.com/Getterrobog/DipterygonotusBalteatus/blob/main/PPP_logo.png)

This is the README for the 2022 PIRE Omics Workshop. It contains a link to the daily schedule, information on the workshop participants and personnel, links and installation directions for necessary software/programs, and a guide to preparing, processing, and analyzing shotgun data. During this workshop, we will be following the [PIRE SSL](https://github.com/philippinespire/pire_ssl_data_processing) and [PIRE Pre-Processing](https://github.com/philippinespire/pire_fq_gz_processing) pipelines, although both have been modified slightly for the purposes of the workshop.

---

## Schedule

Here is a link to the daily [schedule](https://docs.google.com/spreadsheets/d/17KVHAxO8ihgFinT20YejtroK7-l133fBxTAzXAmE8CM/edit#gid=1010648430).

---

## List of Personnel

|Position |Name | Institution | Contact |
| --- | --- | --- | --- |
| Professor | Kent Carpenter | ODU | cbird@odu.edu |
| Professor | Chris Bird | TAMUCC | kcarpent@odu.edu |
| Postdoc | Eric Garcia | ODU | e1garcia@odu.edu |
| Postdoc | Brendan Reid | Rutgers | br450@sebs.rutgers.edu |
| PhD Student | Rene Clark | Rutgers | rdc129@scarletmail.rutgers.edu |

## List of Participants

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
| Ms Student | Omar Mahadalle | Siliman University | omaramahadalle@su.edu.ph | 
| Ms Student | Abner Bucol | Siliman University | abnerbucol2013@gmail.com
| Ms Student | Chandy Jablonski | ODU | cjabl001@odu.edu |

---

## Required Software for the Workshop

In order to run the SSL pipeline and follow along with the workshop exercises, you will need to make sure you have the following accounts set-up and programs installed on your local computer (if you intend on using one of the computers in the computer lab, you only need to complete step 1).

1. Create a free [GitHub account](https://github.com/). 
    * Once you have your account, set up [two-factor authentification](https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa).
    * You will also need a personal access token (PAT) to use GitHub on the HPC cluster. To set this up, follow [these instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token). **MAKE SURE TO SAVE THIS TOKEN SOMEWHERE ON YOUR COMPUTER SO YOU CAN COPY-AND-PASTE!**
2. **WINDOWS ONLY:** Install a Linux Distribution on Windows using the Windows Subsystem for Linux. Follow these steps:
    * Update Windows to the newest version (Windows 10 version 2004 and higher are required, you do not need Windows 11). To update, type "Check for Updates" in the taskbar search bar.
    * Open "Windows PowerShell". You can search for it in the same location where you typed "Check for Updates". Open Windows PowerShell by right-clicking and then left-clicking "Run as Administrator".
    * In the PowerShell Terminal, run the following command (do NOT copy and paste): `wsl --install`.
    * After the command finishes, restart your computer. Once it has restarted, an Ubuntu terminal will open and finish the installation. The installation will take a bit.
    * The terminal will ask for a Username and a Password. Use whatever Username you would like, it will become the name of the User directory. A password is not necessary if you do not want to use one, just enter nothing for both the "New Password" and "Retype Password" prompts.
    * After installation is complete, download [Windows Terminal](https://apps.microsoft.com/store/detail/windows-terminal/9N0DX20HK701?hl=en-us&amp%3Bgl=US).
    * Windows Terminal will open PowerShell automatically. Click the "v" symbol next to the "+" (new tab) button and go to "Settings".
    * The first option under "Startup" is "Default Profile". Change this to "Ubuntu" and save your changes.
    * To open again, just type "Terminal" in the taskbar search bar and open the App.
4. Install a text editor. Our recommended free editors:
    * For Macs: the free version of [BBEdit](https://www.barebones.com/products/bbedit/)
    * For Windows (PCs): [Notepad++](https://notepad-plus-plus.org/downloads/)
5. Install [R (v4.2.0 or 4.2.1)](https://www.r-project.org).
6. Install [RStudio](https://www.rstudio.com/products/rstudio/download/)
    * Once R and RStudio are installed, install the following packages (with all dependencies): tidyverse & adegenet.

The workshop goes straight into analyzing genomic data and assumes participants already have a basic understanding of UNIX, the command line, and HPC environments. If you don't have this background, please check out this [page](https://github.com/philippinespire/2022_PIRE_omics_workshop/blob/main/preworkshop_material.md) with links to a few brief, introductory online modules.

If this is your first time working on Wahab/Turing (ODU's HPC and the computer cluster we will be using for the workshop), or want to check out some cool tips, see the [Working on ODU's HPC Repository](https://github.com/philippinespire/denovo_genome_assembly/tree/main/working_in_Turing-Wahab).

---

# GUIDE TO SHOTGUN DATA PROCESSING & ANALYSIS

Here we go!

## Some Basic Set-up

Start the workshop by cloning this repository to your working directory. We recommend setting up a `shotgun_PIRE` directory in your home directory first and then cloning this repository as a subdirectory of that.
  * Example: `/home/youruserID/shotgun_PIRE/`

Clone this repository.

```
cd ~ 	#this will take you to your home directory

mkdir shotgun_PIRE
cd shotgun_PIRE

git clone https://github.com/philippinespire/2022_PIRE_omics_workshop.git
#you will be prompted for your username and password. The username is your GitHub username. The password is a PAT (personal access token) associated with your GitHub account.
```

***Now you have the files you need to start working!***

*Organization is important* - for the workshop, each person will create and work in their own sub-directory in this repository. 

Make your own directory:

```
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop

mkdir <your_name_with_no_spaces>
```

**Please Note:** do not use spaces or special characters (*#$%^&~"[])(+'\|=*) in the names of files or directories. Stick to letters, numbers, dashes (-), and underscores (_).

Next, you are going to copy the `README.md` file from the  `2022_PIRE_omics_workshop/salarias_fasciatus` directory to your own directory. The `README.md` serves as a log where you record the code you ran for each step, as well as any important notes (errors you ran into, data quality assessment, etc.). You will modify this README to match your code and results as you run each step of the pipeline.
  * During the workshop, all participants will be running data from the same species (*Salarias faciatus*) through the SSL pipeline. Thus, everyone's output should look the same at each step! The `salarias_fasciatus` directory serves as a template for you to check your results against. You will also be reading data in from this directory at various steps throughout the workshop, to speed up the process.

```
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name #this should be the full path to the directory you just created

cp ../salarias_fasciatus/README.md .
```

---

## Maintaining Your Git Repository

As you start processing your data and making changes, you will need to continuously update your progress to GitHub (so that others can see your work)! To do this, you will always (1) **PULL** down the latest version of the repo everytime you begin work and (2) **PUSH** any changes you make everytime you walk away from the computer. **ALWAYS PULLING BEFORE YOU PUSH** will help keep your GitHub repository updated and minimize problems with merge conflicts, etc.

**NOTE:** Every time you push (and sometimes when you pull), you will be prompted for your username and password. The username is your GitHub username. The password is a PAT (personal access token) associated with your GitHub account.

To push and pull, from your workshop directory (`2022_PIRE_omics_workshop/your_name`), execute these commands manually or run the `runGit.bash` script (see below):

```
#to make sure your version of the repository matches what is on GitHub (ALWAYS do before running anything OR pushing)
git pull

#to add any of your own changes
git add ./*
git commit -m "" #in "" write a short message describing what you did
git push -u

chmod -R 770 * #gives everyone access to your files
```

This code has also been compiled into the script [`runGIT.bash`](https://github.com/philippinespire/2022_PIRE_omics_workshop/blob/main/runGIT.bash). Thus, you can just run this script BEFORE and AFTER you do anything in your workshop directory. Copy this to your workshop dir if you would like to run it:

```
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

cp ../runGIT.bash .
```

When running `runGIT.bash`, you will need to provide the message of your commit in the command line. Example:

```sh
bash ../runGIT.bash "initiated my directory"
```

Other things to know:

1. If you should ever meet a merge conflict screen, you are in the archane `vim` editor.  You can look up instructions on how to interface with it, but the following should typically work:

    * hit escape key twice
    * type `:quit!`
 
2. If you ever have to delete files for whatever reason, these deletions will occur in your local directory (on the HPC) but will remain in the git memory if they had previously been pushed. If you are in this situation, run these git commands manually, AFTER running `runGIT.bash` as described above (run from the directory where you deleted the files):

```sh
git add -u . #this will stage your deleted files
git commit -m "update deletions"
git push -u origin main
```

3. **gitignore**: There is a `.gitignore` file that lists files and directories to be ignored by git. It includes large files that git cannot handle (fq.gz, bam, etc.) 
 and other repositories that might be cloned/created in this repository during the pipeline. For example, the BUSCO directory contains several large files that will cause problems for git, so `busco_*/` occurs in  `.gitignore` so that it is not ever pushed to GitHub. Because large data files will never be pushed to GitHub, they will reside in an individual's local directory or somewhere else on the HPC.

---

## Data Processing Roadmap

---

## A. PRE-PROCESSING SEQUENCES

Complete the pre-processing of your files following the [pire_fq_gz_processing](https://github.com/philippinespire/2022_PIRE_omics_workshop/blob/main/preprocessing_README.md) insructions, then return here.
  * This includes running FASTQC, FASTP1, CLUMPLIFY, FASTP2, FASTQSCREEN, and the re-pair scripts.

---

## B. GENOME ASSEMBLY

---

## **1. Genome Properties**

### 1a. Fetch the genome properties for your species. You can do this two ways:

  * From the literature or other sources.
    * [genomesize.com](https://www.genomesize.com/)
    * [ncbi genome](https://www.ncbi.nlm.nih.gov/genome/)
    * search the literature
      * Record the size and other potentially important information in your species README if the genome of your species is already available.
  * Estimate properties with `jellyfish` and `genomescope`.
    * More details [here](https://github.com/philippinespire/denovo_genome_assembly/blob/main/jellyfish/JellyfishGenomescope_procedure.md).

### **1b. Execute [runJellyfish.sbatch](https://github.com/philippinespire/pire_ssl_data_processing/blob/main/scripts/runJellyfish.sbatch) using the decontaminated files (couple of hours)**

```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

#sbatch runJellyfish.sbatch <Species 3-letter ID> <indir>
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runJellyfish.sbatch "Sfa" "fq_fp1_clmp_fp2_fqscrn_repaired"
```

Check your queue!

```sh
squeue -u <your_user_ID>
```

Jellyfish will create a histogram file (`.histo`) with kmer frequencies. 

### **1c. Download this file to your local computer and upload it in [GenomeScope v1.0](http://qb.cshl.edu/genomescope/) and [Genomescope v2.0](http://qb.cshl.edu/genomescope/genomescope2.0/) (few minutes)**

To download, `sftp` into Wahab in a new Terminal window and download the histogram file.

```sh
sftp your_user_ID@wahab.hpc.odu.edu

cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

lpwd  #this is your local working directory
get fq_fp1_clmp_fp2_fqscrn_repaired/<histofile.histo>
```

Then:

1. Open `GenomeScope v1-2` and upload the histogram file.
2. Add a proper description to both of your GenomeScope runs. Example: "Sfa_fq_fp1_clmp_fp2_fqscrn_repaired_jfsh_v1" and  "Sfa_fq_fp1_clmp_fp2_fqscrn_repaired_jfsh_v2".
3. For version 1 ONLY, Adjust the read length to that of the length of the Fastp2 trimming --> 140 (unless you had to modify this during the Fastp2).
4. Leave all other parameters with default settings for both versions. 
5. Submit (takes only a few minutes to run),
 
### **1d. Complete the following table in your Species README. You can copy and paste this table straight into your README (no need to enclose it with quotes, i.e. a code block) and just substitute your table values.**

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

Provide a link to both GenomeScope reports in your README. See other species READMEs for examples. 

### **1e. Inspect your table and reports for red flags and choose a GenomeScope version.**

In your table, check that the heterozygosity estimates are reasonable (values ~1% or less are common) and check for a good model fit in the max values (>90%). Sometimes, the min value might have a low fit for V2 but this is okay.

  * In your reports, check for a tight relationship between the "observed", "full model" and "unique sequences" lines in the first graph.

If the values in your table are relatively similar for V1 and V2 and you found no red flags in reports, then use the V2 estimates.

Most of the time V1 & V2 perform similarly. However, sometimes the two reports give contrasting values, such as very different genome sizes or unrealistic estimates of heterozygosity.

For example:

  * For Sob (*Sphyraena obtusata*), the [Sob_GenScp_v1 report](http://qb.cshl.edu/genomescope/analysis.php?code=zQRfOkSqbDYAGYJrs7Ee) estimates a genome of 532 Mbp and 0.965 for H. However, the [Sob_GenScp_v2 report](http://qb.cshl.edu/genomescope/genomescope2.0/analysis.php?code=5vZKBtdSgiAyFvzIusxT) estimates a genome size of 259 Mbp (which is small for a fish) and actually fails to estimate heterozygosity. Thus, V1 was used for Sob. 
  * For Hte (*Hypoatherina temminckii*), the [Hte_GenScp_v1 report](http://qb.cshl.edu/genomescope/analysis.php?code=tHzBW2RjBK00gQMUSfl4) appears to have no red flags with a genome size of 846 Mbp and 0.49 for H. However, upon inspecting the first graph, you can see that the "unique sequence" line behaves diffently from the others. In contrast, the [Hte_GenScp_v2 report](http://qb.cshl.edu/genomescope/genomescope2.0/analysis.php?code=8eVzhAQ8zSenObScLMGC) restores a tight relationship between all lines with no red flags in any estimates either (H=2.1, GenSize= 457 Mbp). Thus, V2 was used for Hte.

***Note the best GenomeScope version and rounded genome size estimate in your species README. Please use the "Genome Haploid Length" max value rounded up or down to the nearest million. You will use this info later.***

---

## **2. Assemble the Genome with SPAdes**

Congrats! You are now ready to assemble the genome of your species!

After a comparisons of multiple assemblers with the PIRE shotgun data, we decided to use **SPAdes**. 

For the most part, we obtained better assemblies using single libraries (a library consists of one forward *r1.fq.gz and reverse file *r2.fq.gz pair), but in a few instances using all the libraries was better.

### **2a. Check resource availability on Turing**

You need to be in `turing.hpc.odu.edu` for this step. SPAdes requires high memory nodes (only available on Turing). The username/password you use to log onto Wahab will work for Turing as well.

```bash
#from wahab.hpc.odu.edu
exit

ssh userID@turing.hpc.odu.edu
```

Check how many high memory nodes ("himem") are available on Turing.

```sh
sinfo
```

You will see a list something like this below. Look at the state of himem nodes (partition = himem) below to identify how many are available for genome assembly.

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

### **2b. Get the genome size of your species in bp from step 1e**
 
Typically, we produce 3 libraries (from the same individual) for each species with SSL data. 

Sfa example:

```bash
ls /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/shotgun_raw_fq/*gz

Sfa-CBas_028-Ex1-1G_L4_1.fq.gz #library 1
Sfa-CBas_028-Ex1-1G_L4_2.fq.gz
Sfa-CBas_028-Ex1-1H_L4_1.fq.gz #library 2
Sfa-CBas_028-Ex1-1H_L4_2.fq.gz
Sfa-CBas_028-Ex1-2A_L4_1.fq.gz #library 3
Sfa-CBas_028-Ex1-2A_L4_2.fq.gz
``` 

We produce duplicate libraries because every now and then, one library can fail, and you may only end up with 2 sets of files. Thus, the following SPAdes script can be modified to run each of the 3 libraries independently as well as all 3 libraries together (for the "all" assembly).
 
**NOTE:** If your species has 4 or more libraries, you will need to modify the script to run the 4th library, 5th library etc. (You'll only need to add the necessary libraries to the SPAdes command.)

  * No changes are necessary for running the 1st, 2nd, 3rd, or all the libraries together (i.e. if you have 2 or 3 libraries only).  

### **2c. Run SPAdes and QUAST (multiple days)**

Use the decontaminated files (final fq.gz files created during pre-processing) to run one assembly for each of your libraries independently and then one combining all of your libraries together.

Execute [runSPADEShimem_R1R2_noisolate.sbatch](https://github.com/philippinespire/pire_ssl_data_processing/blob/main/scripts/runSPADEShimem_R1R2_noisolate.sbatch). 

Example for the 1st library:

```bash
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

#runSPADEShimem_R1R2_noisolate.sbatch <your user ID> <3-letter species ID> <library: all_2libs | all_3libs | 1 | 2 | 3> <contam | decontam> <genome size in bp> <species dir> <fq data dir>
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runSPADEShimem_R1R2_noisolate.sbatch "your_user_ID" "Sfa" "1" "decontam" "?" "~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name" "fq_fp1_clmp_fp2_fqscrn_repaired"
```

Run 2 more assemblies for the second and third libraries. Replace the "1", with "2" and "3" respectively.
 
Then, run a job combining all libraries together by choosing the appropiate "all_2libs" or "all_3libs" from the library options.

---

## **3. Review SPAdes and QUAST Output**

`runSPADEShimem_R1R2_noisolate.sbatch` names the output directories with the suffix A for the first library, B for the second, and C for the third (if there is one). Thus, for Sfa:

Assembly  |  Library
--- | --- 
A | 1G
B | 1H
C | 2A

For the `SPAdes` output, check that you have:
1. k22-99 directories
2. `contigs.fasta` and `scaffolds.fasta` files
3. Open the `params.txt` files and check the settings ran in SPAdes. Make sure these are as you expect (match your input settings).

`QUAST` is automatically run by the SPAdes script as well. `QUAST` creates statistics to help us evaluate genome assembly quality and composition. Look for the `quast-reports` directory, and for each of your assemblies open up the associated tsv files (both the contigs & scaffolds ones) and check the: 

1. Number of contigs in the assembly (this is the last contig column in the quast report with the name "# contigs"
2. the size of the largest contig
3. the total length of assembly
4. N50
5. L50 

**Tip:** you can align the columns of any `.tsv` for easy viewing with the command `column` in bash.

```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

bash
cat quast-reports/quast-report_contigs_Sfa_spades_Sfa-CBas-A_decontam_R1R2_21-99_isolateoff-covoff.tsv | column -ts $'\t' | less -S
```

---

## **4. Run BUSCO (multiple hours)**

QUAST gives us many of the basic assembly statistics, however we still need to run BUSCO to know how many expected (i.e. highly conserved) genes were recovered by the assembly. This gives us another sense of how "complete" the genomes we just assembled are.

Execute [runBUCSO.sh](https://github.com/philippinespire/pire_ssl_data_processing/blob/main/scripts/runBUSCO.sh) on the `contigs` and `scaffolds` files for each assembly.

```bash
cd ~/shotgun_PIRE/2022_PIRE_Omics_workshop/your_name

#runBUSCO.sh <species dir> <SPAdes dir> <contigs | scaffolds>
#do not use trailing / in paths. Example using contigs:
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runBUSCO.sh "~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name" "SPAdes_decontam_R1R2_noIsolate" "contigs"
```

Repeat the command using the contigs and scaffolds files for each SPAdes assembly.

`runBUSCO.sh` will generate a new directory every time it is run. In those directories, look for the `short_summary.txt` file and note the percentage of `Complete and single-copy BUSCOs (S)` genes. (This file will have a much longer name than just "short_summary," but it begins with that phrase.)

---

## **5. Record QUAST and BUSCO Values**

Fill in this table with your QUAST and BUSCO values in your species README.

A few notes:

  * Library names can be obtained from file names
  * The number of contigs is the last contig column in quast report with the name "# contigs".
  * % Genome size completeness = "Total length"/genome size (or rounded genome max value) * 100
  * **For QUAST, only report the row for the actual assembly (i.e. report "scaffolds" not "scaffolds_broken"**
  * **For BUSCO, only report the "Complete and single-copy BUSCOs (S)"**

```sh
Species    |Assembly    |Data Type    |SCAFIG    |covcutoff    |GenomeScope v.    |No. of contigs    |Largest contig    |Total length    |% Genome size completeness    |N50    |L50    |Ns per 100 kbp    |BUSCO single copy
------  |------  |------ |------ |------ |------  |------ |------ |------ |------ |------  |------ |------ |------ 
Sfa  |A  |decontam       |contgs       |off       |2       |  ?  |  ?  |   ?  |   ? % |  ?  |  ?  |  ?  |  ? % 
Sfa  |A  |decontam       |scaffolds       |off       |2    |  ?  |  ?  |   ?  |   ? % |  ?  |  ?  |  ?  |  ? % 
Sfa  |B  |decontam       |contgs       |off       |2       |  ?  |  ?  |   ?  |   ? % |  ?  |  ?  |  ?  |  ? % 
Sfa  |B  |decontam       |scaffolds       |off       |2    |  ?  |  ?  |   ?  |   ? % |  ?  |  ?  |  ?  |  ? % 
Sfa  |C  |decontam       |contgs       |off       |2       |  ?  |  ?  |   ?  |   ? % |  ?  |  ?  |  ?  |  ? % 
Sfa  |C  |decontam       |scaffolds       |off       |2    |  ?  |  ?  |   ?  |   ? % |  ?  |  ?  |  ?  |  ? % 
Sfa  |allLibs  |decontam       |contigs       |off       |2    |  ?  |  ?  |   ?  |   ? % |  ?  |  ?  |  ?  |  ? %
Sfa  |allLibs  |decontam       |scaffolds       |off       |2   |  ?  |  ?  |   ?  |   ? % |  ?  |  ?  |  ?  |  ? %
```

---

## **6. Determine the Best Assembly**

We assess quality across multiple metrics since we don't use a golden rule/metric for determining the best assembly. Often, it is clear that one of the libraries is better than the others, as it has better results across multiple metrics. However, sometimes this is not quite as clear as we would like, as different assemblies might fare better in some metrics and worse in others. Use the following table to help you decide which assembly is best:

Importance    |Metric    |Direction    |Description
------  |------  |------ |------ 
1st  |BUSCO  | Bigger is better  | % of expected genes observed in your assembly
2nd  |N50  |Bigger is better  | Length of the shortest contig from the set of contigs that (together) represent 50% of your assembly size
3rd  |Genome size completeness  |Bigger is better  |Length of the assembly divided by the estimated genome length
4th  |L50  | Smaller is better  | Number of contigs that make up the set of contigs that (together) represent 50% of your assembly size
5th  |Largest contig  |Bigger is better  | Length of the largest contig
 
If you are still undecided on which is the best assembly, raise your hand or talk to those around you in the workshop. Outside of the workshop, we would normally post the top candidates on the species slack channel and ask for opinions.

**Note your best assembly in your species README.**

---

## **7. Assemble Contaminated Data From the Best Library** 

```bash
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

#MAKE SURE YOU ARE ON TURING

#runSPADEShimem_R1R2_noisolate.sbatch <your user ID> <3-letter species ID> <library: all_2libs | all_3libs | 1 | 2 | 3> <contam | decontam> <genome size in bp> <species dir>
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runSPADEShimem_R1R2_noisolate.sbatch "your_user_ID" "Sfa" "2" "contam" "635000000" "~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name" "fq_fp1_clmp_fp2"
```

Compare the QUAST contigs and scaffolds values of your contaminated assembly to your decontaminated assembly.

---

## **8. Update the Main Assembly Stats Table With Your Species**

**You will not do this for the workshop. You should compare your results to this table, however, to see how your species stacks up.**

Add a new record for your species/assembly to the [best_ssl_assembly_per_sp.tsv](https://github.com/philippinespire/pire_ssl_data_processing/blob/main/best_ssl_assembly_per_sp.tsv) file.

Please note that you cannot paste a tab in `nano` as it interprets tabs as spaces. This means that you will have to manually enter each column one by one, or copy and paste multiple columns but then change the spaces between columns back to tabs to restore the tsv format.

Once done, push your changes to GitHub and confirm the that tsv format is correct by opening the [best_ssl_assembly_per_sp.tsv](https://github.com/philippinespire/pire_ssl_data_processing/blob/main/best_ssl_assembly_per_sp.tsv). Your browser should not be displaying code but instead a nice-looking table (aligned columns, etc). 

--- 

## **9. Evaluate Results**

Assuming you have completed Step 9, you now know what library(ies) produced the best assembly. Compare your BUSCO values with those of the other species (for example, you can check the ["best assembly table"](https://github.com/philippinespire/pire_ssl_data_processing/blob/main/best_ssl_assembly_per_sp.tsv).

If your BUSCO values are much lower than most other species, it might be worth changing the `covcutoff auto` flag (by changing the datatype variable from "decontam" to "decontam_covAUTO").

Example:

```bash
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runSPADEShimem_R1R2_noisolate.sbatch "your user ID" "Sfa" "2" "decontam_covAUTO" "635000000" "~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name" "fq_fp1_clmp_fp2_fqscrn_repaired"
```

Finally, run one more assembly using the decontaminated data from the same library (or all together) that produced the best assembly (with or without the covcutoff flag).

Example:

```bash
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/runSPADEShimem_R1R2_noisolate.sbatch "your user ID" "Sfa" "3" "decontam" "635000000" "~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name"
```

---

## **10. Clean Up**

Move your `*out` files into the `logs` directory.

```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

mv *out logs
```

---

## C. PROBE DESIGN

In this sectio,n you will identify contigs and regions within contigs to be used as candidate regions to develop the probes for capture sequencing.

You will create the following 4 files (among others):
1. `*.fasta.masked`: The masked fasta file 
2. `*.fasta.out.gff`: The gff file created from repeat masking (identifies regions of genome that were masked)
3. `*_augustus.gff`: The gff file created from gene prediction (identifies putative coding regions)
4. `*_per10000_all.bed`: The bed file with target regions for probe development (1 set of 2 probes per target region)

These instructions have been modified from Rene's [de novo assembly probe repo](https://github.com/philippinespire/denovo_genome_assembly/tree/main/WGprobe_creation).

---

## **11. Identify Regions for Probe Development** 

From your species directory, make a new directory for the probe design process.

```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

mkdir probe_design
```

Copy the necessary scripts and the best assembly (i.e. `scaffolds.fasta` from the best assembly made with the DECONTAMINATED fq.gz files) into the `probe_design` directory.

```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

cp /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/WGprobe_annotation.sb probe_design
cp /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/WGprobe_bedcreation.sb probe_design
cp best_assembly_dir/scaffolds.fasta probe_design
```

Rename the assembly to reflect the species and parameters used. Format to follow:

`<3-letter species code>_scaffolds_<library>_<cotam|decontam>_R1R2_noIsolate_<other treatments, if any>.fasta`

To get this information, you can copy and paste the parameter information from the appropriate BUSCO directory:

```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

#list the busco directories
ls -d busco_*

#identify the busco dir of the best assembly, copy the treatments (starting with the library)
#example,the busco dir for the best assembly for Sfa is `busco_scaffolds_results-SPAdes_allLibs_decontam_R1R2_noIsolate`

#then provide the species 3-letter code, scaffolds, and copy and paste the parameters from the busco dir after "SPAdes_" 
cd probe_design
mv scaffolds.fasta Sfa_scaffolds_alLibs_decontam_R1R2_noIsolate.fasta
```

Execute the first probe annotation script.

This script will create: 
1. a repeat-masked fasta and gff file (`.fasta.masked` & `.fasta.out.gff`)
2. a gff file with predicted gene regions (`augustus.gff`), and 
3. a sorted fasta index file that will act as a template for the `.bed` file (`.fasta.masked.fai`)

```sh
cd ~/shotgun_PIRE/202_PIRE_omics_workshop/your_name/probe_design

#WGprobe_annotation.sb <assembly name> 
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/WGprobe_annotation.sb "Sfa_scaffolds_allLibs_contam_R1R2_noIsolate.fasta"
```

Execute the second script.

This will create a `.bed` file that will be sent for probe creation. The bed file identifies 5,000 bp regions (spaced every 10,000 bp apart) in scaffolds > 10,000 bp long. These regions are the regions that probes will potentially be developed from.

```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name/probe_design

#WGprobe_bedcreation.sb <assembly name> 
sbatch /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/scripts/ WGprobe_bedcreation.sb "Sfa_scaffolds_allLibs_contam_R1R2_noIsolate.fasta"
```

**Check Upper Limit**

Open the `BEDprobes-*.out` file created from the second probe design script (`WGprobe_bedcreation.sb`) and check that the upper limit was set correctly. Record the longest contig, uppper limit used in the loop, and the number of identified regions and scaffolds in your species README. 

The upper limit should be XX7500 (just under the longest scaffold length). Ex: if longest scaffold is 88,888, then the upper limit should be 87,500; if longest scaffold is 87,499, then the upper limit should be 77,500.  

Example:
```sh
cat BEDprobes-415039.out

#the longest scaffold is 105644
#the uppper limit used in loop is 97500
#a total of 13063 regions have been identified from 10259 scaffolds
```

Move out files into your `logs` directory

```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name/probe_design

mv *out ../logs
```

---

## **12. Closest Relatives with Available Genomes**

The last thing we need to do is create a text file with links to available genomes from the 5 most closely-related species.

Most likely, there won't be genomes available for your targeted species (or even its genus). The easiest way to search for any is to start with the family.

Go to the [NCBI Genome repository](https://www.ncbi.nlm.nih.gov/genome/) and search for the family of your species. If you get more than 5 genomes in the family, narrow the search by looking for the genus. If you don't find any genomes at the family level, search higher classifications until you find some genome assemblies (i.e. order, class, etc).

Once you get at least 5 genomes, you'll need to figure out their phylogenetic relationships in order to list the genomes from most to least closely related. 

Seach for phylogenies specific to your species. For your convenience, you can use the phylogenies from Betancur et al. *BMC Evolutionary Biology* (2017) 17:162 for [fish phyla](https://github.com/philippinespire/pire_ssl_data_processing/blob/main/scripts/Betancur2017_phyla.pdf)
 and [fish families](https://github.com/philippinespire/pire_ssl_data_processing/blob/main/scripts/Betancur2017_families.pdf). These are an excellent resource for higher-order taxonomic groups, but only a few species per family are represented. If you need higher resolution (to distinguish relationships between species within families, for example), you will need to search specifically for your species.

Once your list is ready, create a file in your `probe_design` dirctory.

```sh
#example for Spratelloides gracilis
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/probe_design

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

---

## Files to Send

**You do not need to do this for the workshop.**

Share the following files with Arbor Bio to aid in probe creation:

1. The repeat-masked fasta file (`.fasta.masked`)
2. The gff file with repeat-masked regions (`.fasta.out.gff`)
3. The gff file with predicted gene regions (`.augustus.gff`)
4. The bed file (`.bed`)
5. The text file with links to available genomes from the 5 most closely-related species (`closest_relative_genomes.txt`.

Make a directory named `files_for_ArborSci` inside your `probe_design` directory and move these files there:

```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name/probe_design

mkdir files_for_ArborSci
mv *.fasta.masked *.fasta.out.gff *.augustus.gff *bed closest* files_for_ArborSci
```

Finally, notify Eric by email (e1garcia@odu.edu) saying that your files are ready and post a message in the slack species channel with the probe region and scaffold info (from your `BEDprobe*out` file), and the full path to your files.

Example of Slack post:

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

#### **Congrats! You have finished the SSL processing pipeline. Go ahead, give yourself a pat on the back!**

---

## **13. Cleaning Up**

The SSL pipeline creates multiple copies of your data in the form of intermediate files. Assuming that you have finished the pipeline (have checked your files and send probe info to Arbor Bio), it is now time to do some cleaning-up.

Document the size of your directories and files before cleaning-up and save this information to a file named:

`<your species 3-letter ID>_ssl_beforeDeleting_IntermFiles` 

From your species directory:
```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

du -h | sort -rh > <yourspecies>_ssl_beforeDeleting_IntermFiles
#Sgr example Sgr_ssl_beforeDeleting_IntermFiles
```

### **13a. Make a copy of important files** 

**You do not need to do this for the workshop. Only members of the Carpenter group (on Wahab) can read/write to the RC.**

Before deleting files, make a copy of any important files in the RC (only available when on the log-in node):

1. raw sequence files (this should had been done already but double check)
2. "contaminated" files (`fq_fp1_clmp_fp2`)
3. "decontaminated" files (`fq_fp1_clmp_fp2_fqscrn_repaired`)
4. best assembly (just the `contigs.fasta` and `scaffolds.fasta` for contam and decontam best assemblies)

```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

#check for a copy of raw files
ls /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_ssl_data_processing/your_species/shotgun_raw_fq

#make copy of contaminated and decontaminated files
cp -R fq_fp1_clmp_fp2 /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_ssl_data_processing/your species/
cp -R fq_fp1_clmp_fp2_fqscrn_repaired /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_ssl_data_processing/your species/               

#make a copy of fasta files for best assembly (Sgr example)
mkdir /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_ssl_data_processing/your species/SPAdes_SgC0072C_contam_R1R2_noIsolate
mkdir /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_ssl_data_processing/your species/SPAdes_SgC0072C_decontam_R1R2_noIsolate
cp SPAdes_SgC0072C_contam_R1R2_noIsolate/[cs]*.fasta /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_ssl_data_processing/<your species>/SPAdes_SgC0072C_contam_R1R2_noIsolate
cp SPAdes_SgC0072C_decontam_R1R2_noIsolate/[cs]*.fasta /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_ssl_data_processing/<your species>/SPAdes_SgC0072C_decontam_R1R2_noIsolate
```

### **13b. Delete unneeded files**

Delete the raw sequence files and other sequence files (`fq.gz` | `fastq.gz`) from the intermediate steps (Fastp1, Clumpify, and Fastqscreen; steps 0, 2, and 5). Keep the files from `fq_fp1_clmp_fp2` and `fq_fp1_clmp_fp2_fqscrn_repaired`. 

It is a good idea to keep track of the files you are deleting. An easy way to do this is to list the files to be deleted, copy their information and paste it into a log file tracking the files you are deleting.

```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

ls -l fq/*fq.gz

#copy what is printed to the commandline and paste into the log file

nano deleted_files_log
#paste (example)
/home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/spratelloides_gracilis/fq/
-rwxr-x--- 1 e1garcia carpenter  15G Aug  2 12:12 SgC0072B_CKDL210013395-1a-5UDI294-AK7096_HF33GDSX2_L4_1.fq.gz
-rwxr-x--- 1 e1garcia carpenter  16G Aug  2 12:30 SgC0072B_CKDL210013395-1a-5UDI294-AK7096_HF33GDSX2_L4_2.fq.gz
-rwxr-x--- 1 e1garcia carpenter  13G Aug  2 12:45 SgC0072C_CKDL210013395-1a-AK9146-7UDI286_HF33GDSX2_L4_1.fq.gz
-rwxr-x--- 1 e1garcia carpenter  14G Aug  2 13:01 SgC0072C_CKDL210013395-1a-AK9146-7UDI286_HF33GDSX2_L4_2.fq.gz
-rwxr-x--- 1 e1garcia carpenter  16G Aug  2 13:19 SgC0072D_CKDL210013395-1a-AK5577-AK7533_HF33GDSX2_L4_1.fq.gz
-rwxr-x--- 1 e1garcia carpenter  17G Aug  2 13:36 SgC0072D_CKDL210013395-1a-AK5577-AK7533_HF33GDSX2_L4_2.fq.gz
```

Append the information from the rest of files to be deleted into the same file.

Finally, document the new size of your directories.

```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

du -h | sort -rh > <yourspecies>_ssl_afterDeleting_IntermFiles
```

For *Spratelloides gracisilis* for example, about 1Tb of data was deleted! You will likely delete less than that but still a substantial amount.

Move the cleaning files into the `logs` directory

```sh
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name

mv Sfa_ssl* logs
mv deleted_files_log logs
```

---

## D. PSMC

Now that we have a reference genome, what can we do with it? Follow the [PSMC](https://github.com/philippinespire/2022_PIRE_omics_workshop/tree/main/salarias_fasciatus/PSMC) link to learn how we can use genomic data from a single individual to infer demographic history! 

