#!/usr/bin/env bash
# ------------------------------------------------------------
# Contact: alexandra.raimo@protonmail.com
# Project name: aDNAPrePro
# Version: 1.1
# Date: Mar 2026
# Step32.sh this is the sixth of nine scripts to preprocess ancient DNA samples.
#
## The computational results of this work have been achieved using the University of Vienna`s Life Science Compute Cluster (LiSC).
## This script has been written to work on the LiSC cluster. Using this Pipeline in a different environment, you would possibly need to install some programs. 

## Step32 sorts the "*.bam" files into *"_sorted.bam" files
# By using the Software Samtools (https://github.com/samtools/samtools; https://doi.org/10.1093/gigascience/giab008)
# Usage:
# First time launching:
# chmod 754 Step32.sh

# Requirements: 
# 	Input:*q30.bam
#       Parameters: -m 4G <MemoryPerThread> -@ 8 <NumberOfThreads> -o <OutputFileName>
#	Output:  *sorted.bam files

# Note: ${filename:9:6} extracts the sample identifier from the full file path.
# It removes the first 9 char (e.g. "./Step1d/") and then reads the next 6 char.
# This works ONLY if the files are located in a subdirectory with a 6 char name like "Step1d" (the path prefix has a total length of 9 char), 
# and the sample identifier consists of exactly 6 char (e.g. 123456).
#
# Example: ./Step1d/123456yyyyyyyyyyyyyyy.fastq
# the first 9 char ("./Step1d/") are ignored; the next 6 char ("123456") are extracted as the sample name.
# ------------------------------------------------------------

echo "Start: $(date '+%H:%M')"

#$HOME is always the /path/to/your/homedirectory/
#ScratchDir="/path/to/your/scratchdirectory/"
TestHOME="$HOME/TestGithub"
ScratchDir="/lisc/data/scratch/anthropology/Pinhasi_group/raimo"  # assuming there is a Scratch Directory in an ad hoc Filesystem: adapt to your individual path

# Load SAMtools on your cluster environment
module load SAMtools/1.23-GCC-14.2.0

cd "$ScratchDir"

for filename in ./Step3d/*q30.bam; do
    sample="${filename:9:6}"
    base="${filename##*/}"        # remove ./Step3d/
    base="${base%.bam}"           # remove .bam extension

    samtools sort "$filename" -m 4G -@ 8 -o "$ScratchDir/Step3d/${base}_sorted.bam"
    echo "$(date '+%H:%M') Finished converting *q30.bam to *q30_sorted.bam for sample ${sample}"
done

echo "End:   $(date '+%H:%M')"