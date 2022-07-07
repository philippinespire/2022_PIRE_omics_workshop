# Population Structure

We are now going to look at the population structure of our *Leiognathus leuciscus* dataset using two different methods (PCA & ADMIXTURE). Once we have the results from both analyses, we can combine their information to determine whether our *L. leuciscus* individuals came from one population or multiple populations.

---

## Principal Component Analysis (PCA)

Principal component analysis, or PCA, considers all the variation at all the loci among all the individuals (which is a lot of information!) and simplifies it down to a much smaller number of variables (two is often particularly convenient). It then gives us coordinates (or "eigenvectors") that we can use to plot our individuals on a graph and see how they cluster together in space. Individuals that cluster close to each other in a PCA are similar genetically, while those far apart are quite divergent. PCA is used in many branches of science and statistics other than population genetics.

While there are many different programs that can run a PCA using genetic data, today we will be using a program called **plink**. It is a multi-functional population genetics program that can run a wide range of basic analyses.

Before we can run plink, we need to install it using Conda, which is an open-source package/environment management system. Basically, Conda streamlines and simplifies the process of installing, updating, and running programs and packages. We will use it to install our population structure programs for this workshop, but you can use it to install and manage a variety of other things as well (including R, Python, and many bioinformatics programs). If you want more information on Conda, look [here](https://docs.conda.io/en/latest/).

## Installing plink

First, we need to create a Conda environment that will contain our population genetics/structure programs.

```bash
salloc #this will put you on an interactive node

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
conda activate popgen

conda install -c bioconda plink

conda deactivate
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

conda activate popgen

plink --vcf /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/leiognathus_leuciscus/pop_structure/lle.B.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr07.14.vcf --allow-extra-chr --make-bed --out PIRE.Lle.Ham

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

We still have a bit more work to do before we can analyze the results of our PCA. What you have just created are the "loadings", or coordinates that help you plot individuals on a graph. Now, we need to do the actual plotting. Normally, we do this with an R-script designed specifically to take data created by our CSSL (capture) pipeline and turn it into beautiful figures. However, to save time during the workshop, we won't actually run that R-script today. Instead, we will download and look at some plots already created with the data you are working with.

We have to download these plots to your local computer before we can open them up and look at them:

```
#open a new terminal window

#if using a mac:
sftp user_name@wahab.hpc.odu.edu:/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/leiognathus_leuciscus/pop_structure/PC*png PATH_TO_YOUR_LOCAL_DIRECTORY

#if using a PC:
r-sync user_name@wahab.hpc.odu.edu:/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/leiognathus_leuciscus/pop_structure/PC*png PATH_TO_YOUR_LOCAL_DIRECTORY
```

You can also view them on GitHub as well. Just go to this [link](https://github.com/philippinespire/2022_PIRE_omics_workshop/tree/main/leiognathus_leuciscus/pop_structure) and open up any of the `PC*png` files (`PC1PC2.png`, `PC1PC2.png` & `PC2PC3.png`).

**Once you have downloaded/opened the THREE png files, go to this [link](https://forms.gle/f6aycWGBNLCBEJ3P8) and answer the questions.**

---

## ADMIXTURE

Now, we are going to run another program that visualizes population structure in a slightly different way. In the previous exercise, PCA worked by clustering "like" individuals with "like" (or those that had similar genetic information with one another). PCA can form as many groups (or populations) as there appears to be in the dataset. With ADMIXTURE, the program we are about to run, we will actually assign individuals, or really, portions of our individuals' genomes, to a pre-determined number of populations.

For more information on ADMIXTURE, you can read the tutorial [here](https://dalexander.github.io/admixture/admixture-manual.pdf).

## Installing ADMIXTURE

We are once again going to install ADMIXTURE using Conda:

```bash
salloc

module load anaconda
conda activate popgen

conda install -c bioconda admixture

conda deactivate
```

## Running ADMIXTURE

Now that we have installed ADMIXTURE with Conda, we need to make some input files. We can just modify some of the files made when we ran plink to do PCA.

```bash
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name/pop_structure

#using bed and bim files made during PCA
awk '{$1=0;print $0}' PIRE.Lle.Ham.bim > PIRE.Lle.Ham.bim.tmp
mv PIRE.Lle.Ham.bim.tmp PIRE.Lle.Ham.bim
```

Now we can run ADMIXTURE!

We will run ADMIXTURE 5 times. Each time we run ADMIXTURE, we need to specify the number of populations, or genetic clusters, we think there are in our dataset. ADMIXTURE will then assign individuals to those respective populations. Because we don't know how many populations there really are, we are going to run ADMIXTURE a few times, specifying a different number of populations each time.

Later on, we will use all the data to determine the "true" number of populations.

***NOTE:** In ADMIXTURE (and many population-clustering softwares) K = the number of populations. For example, K = 2 means we assigned individuals to 2 possible populations.*

Let's run ADMIXTURE:

```bash
cd ~/shotgun_PIRE/2022_PIRE_omics_workshop/your_name/pop_structure

salloc #if you are no longer on an interactive node

conda activate popgen
admixture PIRE.Lle.Ham.bed 1 --cv > PIRE.Lle.Ham.log1.out
admixture PIRE.Lle.Ham.bed 2 --cv > PIRE.Lle.Ham.log2.out
admixture PIRE.Lle.Ham.bed 3 --cv > PIRE.Lle.Ham.log3.out
admixture PIRE.Lle.Ham.bed 4 --cv > PIRE.Lle.Ham.log4.out
admixture PIRE.Lle.Ham.bed 5 --cv > PIRE.Lle.Ham.log5.out

conda deactivate
exit
```

All done! 

Argument we used:
  * **--cv:** tells admixture we want to calculate the cross-validation error (we will use this to pick the best K later on)

ADMIXTURE creates a lot of output files. The one we are mainly interested in is the one with the extension `*.Q`. This file tells us which population an individual is assigned to (or, what proportion of an individual's genome is assigned to each of the possible populations).

We are also interested in the `*log.out` file as this file contains the cv (cross-validation) error that we will use to determine the true number of populations in our dataset. Ideally, the lower the error the better. Thus, the ADMIXTURE run with the lowest cv will be the best one.

As with PCA before, we still have a bit more work to do before we can analyze our results. Mainly, we need to visualize them so that they are easier to interpret. Normally, we do this with an R-script designed specifically to take data created by our CSSL (capture) pipeline and turn it into beautiful figures. However, to save time during the workshop, we won't actually run that R-script today. Instead, we will download and look at some plots already created with the data you are working with.

We have to download these plots to your local computer before we can open them up and look at them:

```
#open a new terminal window

#if using a mac:
sftp user_name@wahab.hpc.odu.edu:/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/leiognathus_leuciscus/pop_structure/ADMIXTURE*png PATH_TO_YOUR_LOCAL_DIRECTORY
sftp user_name@wahab.hpc.odu.edu:/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/leiognathus_leuciscus/pop_structure/CV*png PATH_TO_YOUR_LOCAL_DIRECTORY

#if using a PC:
r-sync user_name@wahab.hpc.odu.edu:.home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/leiognathus_leuciscus/pop_structure/ADMIXTURE*png PATH_TO_YOUR_LOCAL_DIRECTORY
r-sync user_name@wahab.hpc.odu.edu:/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/leiognathus_leuciscus/pop_structure/CV*png PATH_TO_YOUR_LOCAL_DIRECTORY
```

You can also view them on GitHub as well. Just go to this [link](https://github.com/philippinespire/2022_PIRE_omics_workshop/tree/main/leiognathus_leuciscus/pop_structure) and open up any of the `ADMIXTURE*png` files (`ADMIXTURE_K2.png`, `ADMIXTURE_K3.png`, `ADMIXTURE_K4.png` & `ADMIXTURE_K5.png`). You will also need to open up the CV file as well (`CV_admixture_plot.png`).

**Once you have downloaded/opened the FIVE png files, go to this [link](https://forms.gle/RAMgAycNP7mkMdAK8) and answer the questions.**
