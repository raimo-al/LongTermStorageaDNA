#!/usr/bin/env bash
# ------------------------------------------------------------
# Contact: alexandra.raimo@protonmail.com
# Project name: aDNAPrePro
# Version: 1.1
# Date: Mar 2026
# Step33.sh this is the seventh of nine scripts to preprocess ancient DNA samples.
#
## The computational results of this work have been achieved using the University of Vienna`s Life Science Compute Cluster (LiSC).
## This script has been written to work on the LiSC cluster. Using this Pipeline in a different environment, you would possibly need to install some programs. 

# Step33 sorts the *"_sorted.bam" files into *"_rmdup.bam" files
# Software SAMtools (https://github.com/samtools/samtools; https://doi.org/10.1093/gigascience/giab008)
##
# Usage:
# First time using the script
# chmod 754 Step33.sh

# Requirements: 
# 	Input:       *_sorted.bam
#       Parameters: -s <>, -M <> indexing
#	Output:  *rmdup.bam

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

# Load SAMtools on your cluster enviorment
module load SAMtools/1.23-GCC-14.2.0

cd "$ScratchDir"

for filename in ./Step3d/*q30_sorted.bam; do
    sample="${filename:9:6}"
    base="${filename##*/}"                 # remove ./Step3d/
    base="${base%.bam}"                    # remove .bam extension

    samtools rmdup -s "$filename" "$ScratchDir/Step3d/${base}_rmdup.bam" 
    echo "$sample"
done

# Index all rmdup BAM files in Step3d
samtools index -M "$ScratchDir"/Step3d/*q30_sorted_rmdup.bam
echo "All *_q30_sorted_rmdup.bam files have been indexed successfully."

echo "End:   $(date '+%H:%M')"
