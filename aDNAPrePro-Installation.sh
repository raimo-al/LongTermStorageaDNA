#!/usr/bin/env bash
set -e

# ------------------------------------------------------------
# Contact: alexandra.raimo@protonmail.com
# Project name:  aDNAPrePro
# Version: 1.1
# Date: Mar 2026
# aDNAPrePro-Install.sh this is the first of nine scripts to preprocess ancient DNA samples.
# This script is optional; it sets up the environment required for the remaining seven scripts. 
#
## The computational results of this work have been achieved using the University of Vienna`s Life Science Compute Cluster (LiSC).
## This script has been written to work on the LiSC cluster. Using this Pipeline in a different environment, you would possibly need to install some programs. 

# aDNAPrePro-Install.sh: Installation script to run the aDNAPrePro pipeline.
##
# Usage:
# Two possibilities to make the installation script executable:
#1: After downloading the repository from GitHub, run the installation script with:
#     bash aDNAPrePro-Install.sh
#####2: Alternatively, after downloading the repository from GitHub, make the script executable and run it directly:
# chmod 754 aDNAPrePro-Install.sh
# ------------------------------------------------------------

echo "Installing aDNAPrePro..."
echo "Start: $(date '+%H:%M')"

# $HOME is always the /path/to/your/homedirectory/
# Creating the working directory
WorkDir="$HOME/aDNAPrePro"
mkdir -p "$WorkDir"

# Create Scripts directory
mkdir -p "$WorkDir/Scripts"

# Check if wget exists
if ! command -v wget &> /dev/null; then
    echo "Error: wget not found. Please install wget."
    exit 1
fi

# Define GitHub repository URL 
RepoURL="https://github.com/raimo-al/LongTermStorageaDNA/archive/refs/heads/main.zip"
echo "Downloading aDNAPrePro from GitHub..."
wget -q -O "$WorkDir/aDNAPrePro.zip" "$RepoURL"
echo "Download complete."

# Extract repository
unzip -q "$WorkDir/aDNAPrePro.zip" -d "$WorkDir"

# Detect extracted folder
//ExtractedDir=$(find "$WorkDir" -maxdepth 1 -type d -name "aDNAPrePro-*")
ExtractedDir=$(find "$WorkDir" -maxdepth 1 -type d -name "LongTermStorageaDNA-*" | head -n 1)

# Copy scripts into Scripts directory
ScriptDir=$(find "$ExtractedDir" -type d -name "*aDNAPrePro*" | head -n 1)
cp "$ScriptDir"/aDNAPrePro*.sh "$WorkDir/Scripts/"
echo "Scripts installed in $WorkDir/Scripts."

# Cleanup
rm "$WorkDir/aDNAPrePro.zip"
rm -rf "$ExtractedDir"

cd "$WorkDir/Scripts"

# Remove prefix from Step scripts
shopt -s nullglob
for f in aDNAPrePro-Step*.sh; do
    mv -n "$f" "${f#aDNAPrePro-}"
done

# Make scripts executable
chmod 754 *.sh

# Create working directories
mkdir -p "$WorkDir/Cutadaptlogs"
mkdir -p "$WorkDir/Summaries"
mkdir -p "$WorkDir/DATAnew"
echo "Working directories created in $WorkDir."

# Customising scratch directory 
read -p "Do you want to use a scratch directory? (y/n): " use_scratch

if [[ "$use_scratch" =~ ^[Yy]$ ]]; then
    while true; do
        read -p "Enter scratch directory path: " ScratchDir
        
        if [ ! -d "$ScratchDir" ]; then
            echo "Path does not exist."
            read -p "Try again? (y/n): " retry
            [[ "$retry" =~ ^[Nn]$ ]] && ScratchDir="$WorkDir" && break
            continue
        fi
        
        if [ ! -w "$ScratchDir" ]; then
            echo "No write permission for this directory."
            read -p "Try another path? (y/n): " retry
            [[ "$retry" =~ ^[Nn]$ ]] && ScratchDir="$WorkDir" && break
            continue
        fi
        
        echo "Using scratch directory: $ScratchDir"
        break
    done
else
    ScratchDir="$WorkDir"
    echo "Using working directory as scratch: $ScratchDir"
fi
 
# Create scratch subdirectories
mkdir -p "$ScratchDir/Step0d" ## Step0d: the directory hosting your *.fastq.gz files
mkdir -p "$ScratchDir/Step1d" ## Step1d: the directory hosting your *.fastq files
mkdir -p "$ScratchDir/Step2d" ## Step2d: the directory hosting your alignment results (*.sam and *.sam.log)
mkdir -p "$ScratchDir/Step3d" ## Step3d: the output directory hosting your *.bam files
echo "Scratch directories created in $ScratchDir."

echo ""
echo "Installation of aDNAPrePro is complete."
echo "Scripts location: $WorkDir/Scripts"
echo "Working directory: $WorkDir"
echo "You can now run the aDNAPrePro pipeline scripts from the aDNAPrePro directory: cd $WorkDir."

echo "You can run the scripts from the aDNAPrePro directories, but need to add the following lines to your ~/.bashrc:"
echo ""
export PATH="$HOME/aDNAPrePro:$HOME/aDNAPrePro/Scripts:$PATH"

echo "End: $(date '+%H:%M')"