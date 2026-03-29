#!/usr/bin/env bash
set -e

# ------------------------------------------------------------
# Contact: alexandra.raimo@protonmail.com
# Project name: aDNAPrePro
# Version: 1.1
# Date: Mar 2026
# aDNAPrePro-Step1.sh this is the second of eight scripts to preprocess ancient DNA samples.
#
## The computational results of this work have been achieved using the University of Vienna`s Life Science Compute Cluster (LiSC).
## This script has been written to work on the LiSC cluster. Using this Pipeline in a different environment, you would possibly need to install some programs. 

# aDNAPrePro-Step 1: Adapter trimming with Cutadapt
# Software Cutadapt (https://github.com/marcelm/cutadapt; DOI:10.14806/ej.17.1.200) 
##
# Usage: 
##
# If you did not download the scripts using wget, first make the script executable:
# chmod 754 aDNAPrePro-Step1.sh
##
# Requirements: 
# 	Input *fastq.gz files
#       Parameters -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC <AdapterSequence> -m 30 <MinimumReadLength> 
#	Output: trimmed *.fastq files and *.log files

# Note: ${filename:9:6} extracts the sample identifier from the full file path.
# It removes the first 9 char (e.g. "./Step1d/") and then reads the next 6 char.
# This works ONLY if the files are located in a subdirectory with a 6 char name like "Step1d" (the path prefix has a total length of 9 char), 
# and the sample identifier consists of exactly 6 char (e.g. 123456).
#
# Example: ./Step1d/123456yyyyyyyyyyyyyyy.fastq
# the first 9 char ("./Step1d/") are ignored; the next 6 char ("123456") are extracted as the sample name.
# ------------------------------------------------------------

echo "Start: $(date '+%H:%M')"

# $HOME is always the /path/to/your/homedirectory/
WorkDir="$HOME/aDNAPrePro"
# ScratchDir="/path/to/your/scratchdirectory/" # assuming there is a Scratch Directory in an ad hoc Filesystem: adapt to your individual path

ScratchDir=""

#Check for path in "$ScratchDir"
if [[ -z "$ScratchDir" ]]; then
    echo 'ScratchDir="" is not defined. Please insert your path in aDNAPrePro-Step1.sh'
    exit 1
fi

#Cutadaptlogs: the directory hosting cutadapt log files: Ensure Cutadaptlogs exist
mkdir -p "$WorkDir/Cutadaptlogs" ## create Cutadaptlogs if it doesn´t exist

cd "$ScratchDir"

## Step0d: the directory hosting your fastq.gz files
mkdir -p "$ScratchDir/Step0d" ## create Step0d if it doesn´t exist
mkdir -p "$ScratchDir/Step1d" ## create Step1d if it doesn´t exist

# Load cutadapt on your HPC enviorment
module load cutadapt

#reads trimmed to 30bp: -m 30

for filename in ./Step0d/*.fastq.gz
do
  sample="${filename:9:6}"
  base="${filename##*/}"            # remove ./Step0d/
  base="${base%.fastq.gz}"          # remove .fastq.gz extension
  cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -m 30 "$filename" > "$ScratchDir/Step1d/${base}.fastq" 2> "$WorkDir/Cutadaptlogs/${base}.log"

  echo "$sample"
done

echo "End:   $(date '+%H:%M')"