# LongTermStorageaDNA pipeline
A bioinformatics pipeline for the analysis of human ancient DNA (aDNA) samples.

This pipeline contains a set of scripts and customized code, which were originally developed for the analysis of ancient human genomic data generated for the project "The effect of long-term storage on ancient DNA samples" project (Master' thesis). 

Thesis available here: https://utheses.univie.ac.at/detail/74668

## Citation

**Please cite https://utheses.univie.ac.at/detail/74668 if you use this pipeline.**

LongTermStorageaDNA-Scripts is available under the terms of the MIT license.


# Installation and pipeline

## Requirements :
For the pipeline to need to download your preferred reference genome in the directory "$ScratchDir" (ScratchDir="/path/to/your/scratchdirectory/").

## aDNAPrePro

The first part of the pipeline, **aDNAPrePro** (**v1.0**), is now available. It contains scripts and customised code developed for the analysis of ancient human genomic data generated  the project **“The effect of long-term storage on ancient DNA samples”** (Master’s thesis).

## Pipeline workflow:

Please make sure that all shell scripts have permissions and are executable. Please launch the scripts in the following order: 

- **Step1.sh**: Step 1 consists of Adapter trimming with Cutadapt

Cutadapt: https://github.com/marcelm/cutadapt; DOI:10.14806/ej.17.1.200

- **Step2.sh**: Step 2 consists of aligning your samples to the reference genome with bwa

bwa: (https://github.com/lh3/bwa; arXiv:1303.3997)

- **Step31.sh - Step34.sh**: All Step31.sh, Step32.sh, Step31.sh and Step34.sh use SAMtools.

SAMtools (https://github.com/samtools/samtools; https://doi.org/10.1093/gigascience/giab008)

**Step31.sh**: Step31 consists of converting *.sam to *.bam (binary) files with the program SAMtools and keep only reads with mapping quality (MAPQ) = 30

**Step32.sh**: Step32 consists of sorting the *.bam" files into *"_sorted.bam" files.

**Step33.sh**: Step33 consists of sorting the *"_sorted.bam" files into *"_rmdup.bam" files

**Step34.sh**: Step34 consists of generating summary statistics using samtools flagstat

- **Step4CreateReport.sh** creates a report (txt file) summarising the total, trimmed, unique/aligned and/or endogenous reads of all your samples.

# Additional references include:

Martin, M. (2011). Cutadapt removes adapter sequences from high-throughput sequencing reads. EMBnet. journal, 17(1), 10-12.

bwa Li, H., & Durbin, R. (2009). Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics , 25(14), 1754–1760. https://doi.org/10.1093/bioinformatics/btp324. Download: http://bio-bwa.sourceforge.net/bwa.shtml

SAMtools Li, H., Handsaker, B., Wysoker, A., Fennell, T., Ruan, J., Homer, N., … 1000 Genome Project Data Processing Subgroup. (2009). The Sequence Alignment/Map format and SAMtools. Bioinformatics , 25(16), 2078–2079. https://doi.org/10.1093/bioinformatics/btp352. Download: http://www.htslib.org/

Fernandes, DM, Cheronet, O, Gelabert, P, Pinhasi, R. TKGWV2: an ancient DNA relatedness pipeline for ultra-low coverage whole genome shotgun data. Sci Rep 11, 21262 (2021). https://doi.org/10.1038/s41598-021-00581-3
