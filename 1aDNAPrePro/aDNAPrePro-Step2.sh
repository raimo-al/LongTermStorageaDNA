#!/usr/bin/env bash
# ------------------------------------------------------------
# Contact: alexandra.raimo@protonmail.com
# Project name: aDNAPrePro
# Version: 1.1
# Date: Mar 2026
# Step2.sh this is the fourth of nine scripts to preprocess ancient DNA.
#
## The computational results of this work have been achieved using the University of Vienna`s Life Science Compute Cluster (LiSC).
## This script has been written to work on the LiSC cluster. Using this Pipeline in a different environment, you would possibly need to install some programs. 

# Step2: Aligning the samples to the reference genome with bwa
# Software bwa (https://github.com/lh3/bwa; arXiv:1303.3997) 
##
# Usage:
# First time launching:
# chmod 754 Step2.sh
##
# Requirements: 
#	Input: *.fastq and indexed ReferenceGenome.fasta
#	Parameters:  -t 8 <NumberOfCPUThreads> ;  change "MyProject" with your project name: -R  '@RG\tID:MyProject\tSM:'${filename:9:6}'\tPL:ILLUMINA' <ReadGroupHeader>
#                    tSM <biological sample>; tLB: <sequencingLibrary>
#	Outputs: *.sam: alignments; *.sam.log: bwa log per sample

# Note: ${filename:9:6} extracts the sample identifier from the full file path.
# It removes the first 9 char (e.g. "./Step1d/") and then reads the next 6 char.
# This works ONLY if the files are located in a subdirectory with a 6 char name like "Step1d" (the path prefix has a total length of 9 char), 
# and the sample identifier consists of exactly 6 char (e.g. 123456).
#
# Example: ./Step1d/123456yyyyyyyyyyyyyyy.fastq
# the first 9 char ("./Step1d/") are ignored; the next 6 char ("123456") are extracted as the sample name.
# ------------------------------------------------------------

echo "Start: $(date '+%H:%M')"

#Set the path for your reference genome: ref="/path/to/your/ReferenceGenome.fasta" ; in this script following Reference Genome was used: hg37: human_g1k_v37.fasta
ref="/lisc/data/scratch/anthropology/Pinhasi_group/raimo/human_g1k_v37.fasta"
# ref ="???"

#$HOME is always the /path/to/your/homedirectory/
#ScratchDir="/path/to/your/scratchdirectory/"
TestHOME="$HOME/TestGithub"
ScratchDir="/lisc/data/scratch/anthropology/Pinhasi_group/raimo"  # assuming there is a Scratch Directory in an ad hoc Filesystem: adapt to your individual path

# Load bwa on your HPC enviorment
#This is how to load bwa on the LiSC Server
module load BWA/0.7.19-GCCcore-13.3.0

cd "$ScratchDir"
##Step2d: the output directory hosting your alignment results: *sam and *.sam.log
mkdir -p Step2d ## create Step2d if it doesn´t exists

for filename in ./Step1d/*.fastq; do
   sample="${filename:9:6}"
   base="${filename##*/}"     # remove ./Step1d/
   base="${base%.fastq}"      # remove .fastq extension

   bwa mem -t 8 -R "@RG\tID:MyProject\tSM:${sample}\tLB:${sample}\tPL:ILLUMINA" "$ref" "$filename" > "$ScratchDir/Step2d/${base}.sam" 2> "$ScratchDir/Step2d/${base}.sam.log"
   echo "$(date '+%H:%M')  Finished alignment for sample ${sample}"
done

echo "End:   $(date '+%H:%M')"