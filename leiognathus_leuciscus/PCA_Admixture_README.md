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
