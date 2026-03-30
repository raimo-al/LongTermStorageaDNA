#!/usr/bin/env bash
set -e

# ------------------------------------------------------------
# Contact: alexandra.raimo@protonmail.com
# Project name: aDNAPrePro
# Version: 1.1
# Date: Mar 2026
# aDNAPrePro-Step31.sh this is the fourth of eight scripts to preprocess ancient DNA samples.
#
## The computational results of this work have been achieved using the University of Vienna`s Life Science Compute Cluster (LiSC).
## This script has been written to work on the LiSC cluster. Using this Pipeline in a different environment, you would possibly need to install some programs. 

## aDNAPrePro-Step31: Convert *.sam to *.bam (binary) files with the program samtools and keep only reads with mapping quality (MAPQ) = 30
##
# Usage:
# If you did not download the scripts using wget, first make the script executable:
# chmod 754 aDNAPrePro-Step31.sh

# Requirements: 
# 	Input: *.sam
#       Parameters: -b -q30 <MappingQuality> : set to 30
#	Output: *_q30.bam

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
WorkDir="$HOME/aDNAPrePro"

#ScratchDir="/path/to/your/scratchdirectory/" # assuming there is a Scratch Directory in an ad hoc Filesystem: adapt to your individual path 

ScratchDir=""

#Check for path in "$ScratchDir"
if [[ -z "$ScratchDir" ]]; then
    echo 'ScratchDir="" is not defined. Please insert your path in aDNAPrePro-Step31.sh'
    exit 1
fi

# Load SAMtools on your HPC enviorment; this is how to load SAMtools on the LiSC Server
# check if your SAMtools system current version is correct.
module load SAMtools/1.23-GCC-14.2.0 

cd "$ScratchDir"

##Step3d: the output directory hosting your *.bam files
mkdir -p "$ScratchDir/Step3d" ## create Step3d if it doesn´t exist

for filename in ./Step2d/*.sam; do
   sample="${filename:9:6}"
   base="${filename##*/}"        # remove ./Step2d/
   base="${base%.sam}"           # remove .sam extension

   samtools view -b -q30 "$filename" > "$ScratchDir/Step3d/${base}_q30.bam"
   echo "$sample"
done

echo "End:   $(date '+%H:%M')"

