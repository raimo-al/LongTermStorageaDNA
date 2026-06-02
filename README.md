# LongTermStorageaDNA pipeline
A bioinformatics pipeline for the analysis of ancient DNA (aDNA) samples.

This pipeline contains a set of scripts and customized code, which were originally developed for the analysis of ancient human genomic data generated for the project **"The effect of long-term storage on ancient DNA samples" (Master's thesis)**. 

Thesis available here: https://utheses.univie.ac.at/detail/74668
# Pipeline workflow:
The pipeline is composed of modules, for which **two** are already available:

## 1. aDNAPrePro (v1.1) 
The first part of the pipeline, **aDNAPrePro** (**v1.1**), is now available. The pipeline aDNAPrePro (V1.1) preprocesses aDNA samples.

## 2. RunAmberFrag (v1.0) 
The second module runs the python programe **AMBER** and fragmentation analysis (mean fragment length). 

## 3. RunDeam (v1.0)
The third modules runs the program **mapDamage** and calculates deamination values

# aDNAPrePro
## Installation and pipeline

First, run the following command in your shell:

```bash
wget -O aDNAPrePro-Installation.sh https://raw.githubusercontent.com/raimo-al/LongTermStorageaDNA/main/modules/aDNAPrePro_preprocessing/aDNAPrePro-Installation.sh && bash aDNAPrePro-Installation.sh
```

## `aDNAPrePro-Installation.sh`:

This is the installation script and is executed automatically by the `wget` command above. If you use this command, all shell scripts will automatically receive the correct permissions and be made executable.

## Requirements :
Before running the pipeline, please download your preferred **reference genome** into your scratch directory:

```bash
ScratchDir="/path/to/your/scratchdirectory/"
```

Please also insert the correct path to the reference genome in `$ref`. Otherwise, the following message will appear:

```text
ref="" is not defined. Please insert your path in aDNAPrePro-Step*.sh
```

Please also make sure that all shell scripts have permissions and are executable.

## `aDNAPrePro core pipeline scripts` :

## Important Note:

In each script, you need to insert the path to your scratch directory (`$ScratchDir`). If you installed the pipeline using `aDNAPrePro-Installation.sh`, please use the same path that you entered in the installation script.

**Example message**:

```text
$ScratchDir="" is not defined. Please insert your path in aDNAPrePro-Step*.sh
```

**Please launch the scripts in the following order:**

- `Step1.sh`: Step 1 consists of Adapter trimming with Cutadapt

Cutadapt (https://github.com/marcelm/cutadapt; DOI:10.14806/ej.17.1.200)

- `Step2.sh`: Step 2 consists of aligning your samples to the reference genome with bwa

bwa: (https://github.com/lh3/bwa; arXiv:1303.3997)

- `Step31.sh - Step34.sh`: All Step31.sh, Step32.sh, Step31.sh and Step34.sh use SAMtools.

SAMtools (https://github.com/samtools/samtools; https://doi.org/10.1093/gigascience/giab008)

`Step31.sh`: Step31 consists of converting *.sam to *.bam (binary) files with the program SAMtools and keep only reads with mapping quality (MAPQ) = 30

`Step32.sh`: Step32 consists of sorting the *.bam" files into *"_sorted.bam" files.

`Step33.sh`: Step33 consists of sorting the *"_sorted.bam" files into *"_rmdup.bam" files

`Step34.sh`: Step34 consists of generating summary statistics using samtools flagstat

- `Step4CreateReport.sh`: creates a report (txt file) summarising the total, trimmed, unique/aligned and/or endogenous reads of all your samples.

# RunAmberFrag module:
## Installation and pipeline

First, run the following command in your shell:

```bash
wget -O RunAmber-Installation.sh https://raw.githubusercontent.com/raimo-al/LongTermStorageaDNA/main/modules/RunAmber/RunAmber-Installation.sh && bash RunAmber-Installation.sh
```

## `RunAmberFrag-Installation.sh`:

This is the installation script and is executed automatically by the `wget` command above. If you use this command, all shell scripts will automatically receive the correct permissions and be made executable.

## `RunAmberFrag core pipeline scripts` :

- `RunAmber.sh`: specifically is a customized script, which was employed to run AMBER with multiple BAM files automatically and sequentially,
if they are located in the same directory, using the Python software AMBER.
This means the script automatically updates the list “BamList.tsv” with each new sample name, BAM file, and path,
representing a minor improvement that simplifies running multiple samples.
NOTE: Through the automatic updating of BamList.tsv, the script enables the analysis of more than 6 samples at a time.

AMBER: (https://doi.org/10.1093/bioinformatics/btae436)

- `MeanFrag.sh`: calculates mean fragment length for each from AMBER output and summarises it into a *.txt file (e.g. mean_fragment_length.txt).

**Usage:**

**Single dataset:**
```bash
./MeanFrag.sh -i1 <Path/to/InputDir1> -c1 {st|N} -o <Path/to/OutputFile>
```

**Two datasets:**
```bash
./MeanFrag.sh -i1 <Path/to/InputDir1> -c1 {st|N} -i2 <Path/to/InputDir2> -c2 {st|N} -o <Path/to/OutputFile>
```

-o <Path/to/OutputFile> means for example ./Results/mean_fragment_length.txt

**Parameters:**

- -i1   Input directory for dataset 1 (AMBER output)
- -i2   Input directory for dataset 2 (optional)
- -c1   Cutoff value for dataset 1 (standard or numeric) 
- -c2   Cutoff for dataset 2 (optional)
- -o    Output file (e.g.: mean_fragment_length.txt)

**Cutoff options:**

- st    standard: computes mean fragment length using all reads
- N     numeric cutoff (e.g. 75): includes only reads = N bp: e.g. "-c1 90" truncates reads to 90bp

NOTE: The mean fragment lenghth can be computed for max 2 datasets at a time: i1, i2


# RunDeam module:
## Installation and pipeline

First, run the following command in your shell:

```bash
wget -O RunDeam-Installation.sh https://raw.githubusercontent.com/raimo-al/LongTermStorageaDNA/main/modules/RunDeam/RunDeam-Installation.sh && bash RunDeam-Installation.sh
```

## `RunDeam-Installation.sh`:

This is the installation script and is executed automatically by the `wget` command above. If you use this command, all shell scripts will automatically receive the correct permissions and be made executable.

## `RunDeam core pipeline scripts` :
- `RunDeam.sh`: specifically is a customized script, which was employed to run mapDamage with multiple BAM files automatically and sequentially,
if they are located in the same directory, using the software mapDamage.

mapDamage (https://doi.org/10.1093/bioinformatics/btt193 ; https://doi.org/10.1093/bioinformatics/btr347 )

SAMtools (https://github.com/samtools/samtools; https://doi.org/10.1093/gigascience/giab008)

**Usage:**

RunDeam.sh can be executed with or without command-line options; default:
```bash
./RunDeam.sh
```

Alternatively, RunDeam.sh can be run with these options:
```bash
./RunDeam.sh -st
```

```bash
RunDeam.sh -fscb
```
- -st     standard or default option: Runs the standard main analysis with mapDamage (without additional filtering).
- -fscb   fscb = (additional) filtering for soft-clipped bases: performs an extra filtering step to further reduce the extent of soft-clipped bases.

## Requirements :
Before running the pipeline, please download your preferred **reference genome** into your scratch directory:

```bash
ScratchDir="/path/to/your/scratchdirectory/"
```

Please also insert the correct path to the reference genome in `$ref`. Otherwise, the following message will appear:

```text
ref="" is not defined. Please insert your path in aDNAPrePro-Step*.sh
```

NOTE: The ref genome used for mapDamage has to be identical to the ref genome used for your BAM alignment, if not the script will fail.

Please also make sure that all shell scripts have permissions and are executable.

# Citation:

**Please cite https://doi.org/10.25365/thesis.77783 if you use this pipeline.** 

LongTermStorageaDNA-Scripts is available under the terms of the MIT license.

The computational results of this work have been achieved using the University of Vienna`s Life Science Compute Cluster (LiSC).

# Additional references include:

Aurelien Ginolhac, Morten Rasmussen, M. Thomas P. Gilbert, Eske Willerslev, Ludovic Orlando, mapDamage: testing for damage patterns in ancient DNA sequences, Bioinformatics, Volume 27, Issue 15, August 2011, Pages 2153–2155

bwa Li, H., & Durbin, R. (2009). Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics , 25(14), 1754–1760. https://doi.org/10.1093/bioinformatics/btp324. Download: http://bio-bwa.sourceforge.net/bwa.shtml

Dolenz, S., van der Valk, T., Jin, C., Oppenheimer, J., Sharif, M. B., Orlando, L., ... & Heintzman, P. D. (2024). Unravelling reference bias in ancient DNA datasets. Bioinformatics, 40(7), btae436.

Fernandes, DM, Cheronet, O, Gelabert, P, Pinhasi, R. TKGWV2: an ancient DNA relatedness pipeline for ultra-low coverage whole genome shotgun data. Sci Rep 11, 21262 (2021). https://doi.org/10.1038/s41598-021-00581-3

Hákon Jónsson, Aurélien Ginolhac, Mikkel Schubert, Philip L. F. Johnson, Ludovic Orlando, mapDamage2.0: fast approximate Bayesian estimates of ancient DNA damage parameters, Bioinformatics, Volume 29, Issue 13, July 2013, Pages 1682–1684,

Martin, M. (2011). Cutadapt removes adapter sequences from high-throughput sequencing reads. EMBnet. journal, 17(1), 10-12.

SAMtools Li, H., Handsaker, B., Wysoker, A., Fennell, T., Ruan, J., Homer, N., … 1000 Genome Project Data Processing Subgroup. (2009). The Sequence Alignment/Map format and SAMtools. Bioinformatics , 25(16), 2078–2079. https://doi.org/10.1093/bioinformatics/btp352. Download: http://www.htslib.org/


