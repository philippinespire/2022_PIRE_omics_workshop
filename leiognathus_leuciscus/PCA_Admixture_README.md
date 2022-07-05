# Population Structure

We are now going to look at the population structure of our *Leiognathus leuciscus* dataset using two different methods (PCA & ADMIXTURE). Once we have the results from both analyses, we can combine their information to determine whether our *L. leuciscus* individuals came from one population or multiple populations.

---

## Principal Component Analysis (PCA)

Principal component analysis, or PCA, considers all the variation at all the loci among all the individuals (which is a lot of information!) and simplifies it down to a much smaller number of variables (two is often particularly convenient). Individuals close to each other in a PCA are similar genetically, while those far apart are quite divergent. PCA is used in many branches of science and statistics other than population genetics.

While there are many different programs that can run a PCA using genetic data, today we will be using a program called **plink**. It is a multi-functional population genetics program that can run a wide range of basic analyses.

Before we can run plink, we need to install it using Conda, which is an open-source package/environment management system. Basically, Conda streamlines and simplifies the process of installing, updating, and running programs and packages. We will use it to install our population structure programs for this workshop, but you can use it to install and manage a variety of other things as well (including R, Python, and many bioinformatics programs). If you want more information on Conda, look [here](https://docs.conda.io/en/latest/).

## Installing plink

First, we need to create a Conda environment that will contain our population genetics/structure programs.

```bash
module load container_env/0.1
module load conda/3
module load anaconda

conda create -n popgen #this creates our environment and names it
conda activate popgen #this "loads" our popgen environment
conda config --add channels conda-forge

conda deactivate #this exits the conda environment
```

Next, we will install plink within the Conda environment you just created.

```bash
conda activate popgen -- if you didn't do this previously or accidentally exited out

conda install -c bioconda plink
```

## Running plink (and PCA)

Now that we have installed plink with Conda, we can use it to run a PCA and look at some population structure!

Before we run anything, we need to first set up the directory that we will write our output to.

```bash
cd ~/shotgun_pire/2022_pire_omics_workshop/your_name

mkdir pop_structure
```

Now, we can run our PCA. The code to do this is below:

```bash
cd ~/shotgun_pire/2022_pire_omics_workshop/your_name/pop_structure

salloc #this will put you on an interactive node

module load anaconda
conda activate popgen

plink --vcf /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/leiognathus_leuciscus/pop_structure/
lle.B.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr07.14.vcf --allow-extra-chr --make-bed --out PIRE.Lle.Ham

plink --pca --allow-extra-chr --bfile PIRE.Lle.Ham --out PIRE.Lle.Ham

conda deactivate
```

That was it! It probably didn't even take that long.

Arguments we used:
  * **--vcf:** the VCF file we read in data from
  * **--allow-extra-chr:** allows chromosomes that aren't human (1-23)
  * **--pca:** tells plink that we want to run a PCA
  * **--out:** the prefix plink should give any out files it makes

You may notice that plink wrote a few things to the screen. One line says how many variants (SNPs) and samples passed filters and QC. This tells you the amount of data that went into the PCA.

The output file that we are especially interested in is the one with the extension `*eigenvec`. This file contains each individual's "loadings" (coordinates) on each of the principal components. It is these loadings that we will use to visualize the data.

We still have a bit more work to do before we can analyze the results of our PCA. What you have just created are the "loadings", or coordinates that help you plot individuals on a graph. Now, we need to do the actual plotting. Normally we do this with an R-script designed specifically to take data created by our CSSL (capture) pipeline and turn it into beautiful figures. However, to save time during the workshop, we won't actually run that R-script today. Instead, we will download and look at some plots already created with the data you are working with.

We have to download these plots to your local computer before we can open them up and look at them:

```
#open a new terminal window

#if using a mac:
sftp user_name@wahab.hpc.odu.edu:~/shotgun_PIRE/2022_PIRE_omics_workshop/leiognathus_leuciscus/pop_structure/PC*png PATH_TO_YOUR_LOCAL_DIRECTORY

#if using a PC:
r-sync user_name@wahab.hpc.odu.edu:~/shotgun_PIRE/2022_PIRE_omics_workshop/leiognathus_leuciscus/pop_structure/PC*png PATH_TO_YOUR_LOCAL_DIRECTORY
```

You can also download them off GitHub as well. Just go to this link....

**Once you have downloaded and opened the THREE png files, go to this link and answer the questions.**

---

## Installing ADMIXTURE

Necessary to run ADMIXTURE to visualize population structure (best supported # of population clusters).

```
#assumes popgen conda environment has already been created
module load anaconda
conda activate popgen

#install admixture
conda install -c bioconda admixture

conda deactivate
```


PCA
================

Code for calculating eigenvalues & eigenvectors with the program PLINK. Instructions for installing PLINK can be found in `/popgen_analyses/README.md`.

```bash
#NOTE: probably best to grab an interactive node for this (don't run on log-in node).

module load anaconda

conda activate popgen

plink --vcf <VCF_FILE> --allow-extra-chr --pca --out <PIRE.SPECIES.LOC>

conda deactivate
```

Copy `*.eigenvec` & `*.eigenval` files to local computer and read into R for downstream analysis/visualization (`popgen_analyses/pop_structure.R`).

ADMIXTURE
================

Code for running ADMIXTURE to assess population structure. Requires input (bim & bed files) created with PLINK. Instructions for installing PLINK & ADMIXTURE can be found in `/popgen_analyses/README.md`.

```bash
#NOTE: probably best to grab an interactive node for this (don't run on log-in node).

module load anaconda

conda activate popgen

plink --vcf <VCF_FILE> --allow-extra-chr --make-bed --out <PIRE.SPECIES.LOC>

awk '{$1=0;print $0}' PIRE.SPECIES.LOC.bim > PIRE.SPECIES.LOC.bim.tmp
mv PIRE.SPECIES.LOC.bim.tmp PIRE.SPECIES.LOC.bim

admixture PIRE.SPECIES.LOC.bed 1 --cv > PIRE.SPECIES.LOC.log1.out #run from 1-5
conda deactivate
```

Copy `*.Q` files to local computer. Read into R for visualization (`popgen_analyses/pop_structure.R`).

```
#install stuff to run r script
conda install -c r r-tidyverse
conda install -c bioconda r-pophelper
