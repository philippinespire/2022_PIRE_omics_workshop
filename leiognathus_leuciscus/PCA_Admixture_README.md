# Population Structure

We are now going to look at the population structure of our *Leiognathus leuciscus* dataset using two different methods (PCA & ADMIXTURE). Once we have the results from both analyses, we can combine their information to determine whether our *L. leuciscus* individuals came from one population or multiple populations.

---

## Principal Component Analysis (PCA)

Principal component analysis, or PCA, considers all the variation at all the loci among all the individuals (which is a lot of information!) and simplifies it down to a much smaller number of variables (two is often particularly convenient). Individuals close to each other in a PCA are similar genetically, while those far apart are quite divergent. PCA is used in many branches of science and statistics other than population genetics.

While there are many different programs that can run a PCA using genetic data, today we will be using a program called **plink**. It is a multi-functional population genetics program that can run a wide range of basic analyses.


Before we can run plink, we need to install it using Conda, which is an open-source package/environment management system. Basically, Conda streamlines and simplifies the process of installing, updating, and running programs and packages. We will use it to install our population structure programs for this workshop, but you can use it to install and manage a variety of other things as well (including R, Python, and many bioinformatics programs). If you want more information on Conda, look [here](https://docs.conda.io/en/latest/).

## Installing plink

First, we need to create a Conda environment that will contain our population genetics/structure programs.

```
module load container_env/0.1
module load conda/3
module load anaconda

conda create -n popgen #this creates our environment and names it
conda activate popgen #this "loads" our popgen environment
conda config --add channels conda-forge

conda deactivate #this exits the conda environment
```

Next, we will install plink within the Conda environment you just created.

```
conda activate popgen -- if you didn't do this previously or accidentally exited out

conda install -c bioconda plink
---




## Installing PLINK

Necessary to run PCA (with PLINK). Also useful for easily filtering VCFs and creating bed/bim files.

```
#to create conda environment that will contain popgen programs --> only need to do this ONCE
module load container_env/0.1
module load conda/3
module load anaconda

conda create -n popgen
conda activate popgen
conda config --add channels conda-forge

#install plink
conda install -c bioconda plink

conda deactivate
```

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
