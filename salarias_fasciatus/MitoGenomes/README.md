# Finding mitochondrial genomes and searching genetic databases

## Background

Ah the mitochondria - the powerhouse of the cell! These organelles are inherited maternally and possess their own small (usually <20,000 base pairs) genome. Although mitochondrial DNA (mtDNA) carries less information on evolutionary history compared to whole genomes / nuclear DNA, mtDNA is still useful to us for many reasons. Since mtDNA is abundant, single-copy, and non-recombining, it is easy to sequence and has been used for many years in wildlife forensics as a means to identify species.

In this exercise, we will use two different methods to extract mitochondrial DNA from genomic data. We will then compare the mitochondrial sequences we recover to existing databases to confirm species identity.

## Method 1: MitoFinder

When we ran SPAdes to assemble our shotgun genome, it's very likely that we recovered the mitochondrial genome with very high depth of coverage as well as the nuclear genome since there are many more copies of the mitochondrial genome than the nuclear genome in each cell. MitoFinder will search for any scaffolds that look like mitochondrial genomes in our assembly, extract these scaffolds, and annotate them (identifying the locations of mitochondrial genes).

We have a pair of scripts set up for running MitoFinder (`mitofinder_p2_sfa.bash` and `run_mitofinder_sfa.sbatch`). Make a folder called `MitoGenomes`, and inside this folder make a folder called `MitoFinder` and copy these scripts over to that folder. 

`cp /home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/MitoGenomes/MitoFinder/*sfa* .'

To run these scripts, first edit the config file (see `mitofinder_example.config`). You will have to provide the location of the assembly, the code for your species, the assembler you used to create the reference genome, and the family to which the species belongs. Make sure the OUT_DIR path is correct in the sbatch file as well. You can then run MitoFinder with the bash script:

```
bash mitofinder_p2_sfa.bash mitofinder_sfa.config
```

It should take a few minutes to run.


## Method 2: MitoZ

MitoZ uses a different approach - instead of trying to find the mitochondrial genome within an assembly, it uses the read data to do a denovo genome assembly. This is a bit more versatile as we could run this on short-read data even if we don't have an assembly.

For this exercise we will use one of the reduced "test" datasets that we used for PSMC. We should still be able to find the mitochondrial genome here. Make a directory called MitoZ and copy the example script there. Use the `MitoZ_assemble_example.sb` script to run MitoZ. You will have to add the species prefix (Sfa) and the locations of the forward and reverse read files.

This will take a little while to run.

## Outputs

Check the output for MitoFinder once it has run. You can find the full sequences for the mitochondrial genome(s) recovered, as well as sequences for the individual genes found in each genome.

How many "mitochondrial" scaffolds did MitoFinder recover? How many genes did MitoFinder recover? You can find this information in the .out file.

Which scaffolds in the reference genome correspond to "mitochondrial" scaffolds? You will have to dig a little deeper into the results (the .infos files in the Final_Results folder) to find this.

Note that MitoFinder actually found >1 scaffold that it identified as mtDNA! There could be a few explanations for this, including (1) the mitochondrial genome was assembled in several fragments; (2) there are regions of the nuclear genome that resemble the mitochondrial genome (these are often called "nuclear mitochondrial insertions", or NUMTS); (3) we have contamination from another species. 

Recall how we evaluated coverage using samtools for PSMC yesterday. If you have time, you can check the coverage of the MitoFinder scaffolds and compare to what we found for the whole genome. True mitochondrial genomes should have depth of coverage >> the nuclear genome, NUMTS should have coverage roughly equal to the nuclear genome, and contaminants should have coverage << the nuclear genome. 

Start an interactive node and load samtools. You will need to use a .bam file aligned to the full Sfa denovo reference genome - you can find these in `/home/e1garcia/shotgun_PIRE/2022_PIRE_omics_workshop/salarias_fasciatus/PSMC/data/mkBAM/shotgun_full/`

The basic syntax for evaluating the coverage for a specific scaffold is similar to what we used yesterday but with an -r flag added to identify which region we are interested in:

`
samtools depth -r <scaffold name> <.bam file> | awk '{sum+=$3} END { print "Average (covered sites) = ",sum/NR}'
`

Use this template to check coverage. Which scaffolds look like they represent the true mitochondrial genome?

Check the output of MitoZ when it is finished. Is it similar to MitoFinder?

## Species identification and searching genetic databases

The National Center for Biotechnology Information (NCBI) curates an extremely useful databse of genetic sequence data. You can search a query sequence against this database through the [BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi) web portal.

Go to the BLAST website and click on "Nucleotide BLAST". Enter a query sequence (could be the whole mitochondrial genome sequence or one of the individual gene sequences)  in the box and then click on the blue BLAST button at the bottom.

YOu should have results in a matter of seconds. The best "hits" are at the top. Which species does our sequence match? How similar is our sequence to the sequences in the NCBI database?

The NCBI database has data from all sorts of genes. We can also search another database, the Barcode of Life Database ([BOLD](https://boldsystems.org/)) that is much more focused. BOLD is specifically designed for species identifcation and contains mainly mitochondrial cytochrome oxidase I (COI or COX1) gene sequences.

Go to the BOLD website and click on the "Identification" link at the top of the page. Copy and paste a COI sequence into this box and search. What species does this sequence most resemble?

BOLD also creates a tree of results so you can visualize how similar your query sequence is to sequences in the database. Examine the tree. Do you feel confident that your sequence belongs to the species to which it was assigned?
